"""
qTensor.py
=================
Compute Q-tensor from a 8-bit image stack.

Syntax
------
python qTensor.py imgDir --sigma1 1 --sigma2 8

imgDir: the input image stack tiff.
--sigma1: sigma for the raw image, default to 1.
--sigma2: sigma for the gradient fields, default to 8.

Edit
----
Jan 19, 2025 -- Initial commit.
Jan 22, 2025 -- Compute Q-tensor instead of the director field.
"""

import numpy as np
from scipy.ndimage import gaussian_filter
from skimage import io
import argparse
import os

def fndstruct(sigma1, sigma2, im):
    """
    Returns the structure tensor orientation of an image.

    Args:
    sigma1 -- gaussian filter sigma for the raw image.
    sigma2 -- gaussian filter sigma for the gradient fields.
    im -- the input image, [M x N].

    Returns:
    director -- the director field of the nematic system, [M x N x 2].
    S -- the magnitude of the Q-tensor, [M x N].
    """
    imgf = gaussian_filter(im, sigma1)

    gx, gy = np.gradient(imgf)

    gxgx = gx * gx
    gxgy = gx * gy
    gygy = gy * gy

    gxgx = gaussian_filter(gxgx, sigma2)
    gxgy = gaussian_filter(gxgy, sigma2)
    gygy = gaussian_filter(gygy, sigma2)

    aa = np.array([[gxgx, gxgy], [gxgy, gygy]])
    eigenvalues, eigenvectors = np.linalg.eig(aa.transpose(2, 3, 0, 1).reshape(-1, 2, 2))
    eigenvalues = eigenvalues.reshape(aa.shape[2], aa.shape[3], 2)
    eigenvectors = eigenvectors.reshape(aa.shape[2], aa.shape[3], 2, 2)

    # Find the indices of the smaller eigenvalues
    indices = np.argmax(eigenvalues, axis=2)

    # Extract the corresponding eigenvectors
    director = np.array([eigenvectors[i, j, :, indices[i, j]] for i in range(eigenvectors.shape[0]) for j in range(eigenvectors.shape[1])])
    director = director.reshape(eigenvectors.shape[0], eigenvectors.shape[1], 2)

    # require the y component director to be positive, otherwise flip the director
    director[director[:,:,1]<=0] *= -1

    return director, np.max(eigenvalues, axis=2)

def qTensor(director, S):
    """
    Compute the Q-tensor from the director field.
    """
    Q = np.zeros((director.shape[0], director.shape[1], 2, 2))
    Q[:, :, 0, 0] = director[:, :, 0] * director[:, :, 0] - 0.5
    Q[:, :, 0, 1] = director[:, :, 0] * director[:, :, 1]
    Q[:, :, 1, 0] = director[:, :, 1] * director[:, :, 0]
    Q[:, :, 1, 1] = director[:, :, 1] * director[:, :, 1] - 0.5

    return Q * S[:, :, None, None]

if __name__ == "__main__":
    args = argparse.ArgumentParser()
    args.add_argument("imgDir", help="input image stack tiff")
    args.add_argument("--sigma1", default=1, help="sigma for the raw image", type=float)
    args.add_argument("--sigma2", default=8, help="sigma for the gradient fields", type=float)
    args = args.parse_args()

    imgDir = args.imgDir
    sigma1 = args.sigma1
    sigma2 = args.sigma2
    imgfolder, filename = os.path.split(imgDir)
    name, ext = os.path.splitext(filename)
    mainfolder = os.path.split(imgfolder)[0]
    savefolder = os.path.join(mainfolder, "qTensor")
    if not os.path.exists(savefolder):
        os.makedirs(savefolder)
    saveDir = os.path.join(savefolder, name+".npy")

    stack = io.imread(imgDir)
    Q_list = []
    for num, img in enumerate(stack):
        if num % 10 == 0:
            print("processing frame {:04d}".format(num))
        if num % 100 == 0:
            print("================ {} =================".format(name))
        d, s = fndstruct(sigma1, sigma2, img)
        Q = qTensor(d, s)
        Q_list.append(Q)

    Qs = np.stack(Q_list)
    np.save(saveDir, Qs)