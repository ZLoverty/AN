"""
director_field.py
=================
Compute director field from a 8-bit image stack [M x N x F]. Save the resulting director field [M x N x F x 2] as angle field [M x N x F]. The mapping between angles to 8-bit values is (-pi/2, pi/2] to (0, 255]. 

Syntax
------
python director_field.py imgDir --sigma1 1 --sigma2 8

imgDir: the input image stack tiff.
--sigma1: sigma for the raw image, default to 1.
--sigma2: sigma for the gradient fields, default to 8.

Edit
----
Jan 19, 2025 -- Initial commit.
Feb 02, 2025 -- Restore from the trash ...
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
    director_field -- the structure tensor orientation, [M x N x 2].
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

    return director

def director_to_angle(director):
    """
    Convert a director field to an angle field.

    Args:
    director -- the input director field, [M x N x 2].

    Returns:
    angle_field -- the angle field, [M x N].
    """
    angle_field = np.arctan(director[:, :, 1] / director[:, :, 0]) + np.pi/2
    angle_field_8bit = (angle_field / np.pi * 255).astype(np.uint8)
    return angle_field_8bit

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
    savefolder = os.path.join(mainfolder, "director_field")
    if not os.path.exists(savefolder):
        os.makedirs(savefolder)
    saveDir = os.path.join(savefolder, name+".npy")

    stack = io.imread(imgDir)
    angle_list = []
    for num, img in enumerate(stack):
        if num % 10 == 0:
            print("processing frame {:04d}".format(num))
        if num % 100 == 0:
            print("================ {} =================".format(name))
        d = fndstruct(sigma1, sigma2, img)
        angle = director_to_angle(d)
        angle_list.append(angle)
    
    angles = np.stack(angle_list)
    np.save(saveDir, angles)