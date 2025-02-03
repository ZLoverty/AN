"""
bending_energy.py
=================
Compute bending energy from a director field.
1. Read angle field from a .npy file;
2. Convert the angle field to a director field;
3. Compute bending energy.

Syntax
------
python bending_energy.py qTensorDir maskDir

directorDir: the director field, [M x N x 2].
maskDir: the mask field, [M x N].

Edit
----
Jan 19, 2025 -- Initial commit.
Jan 20, 2025 -- Fix the computation of director field, by requiring positive y component. Add mask processing.
Jan 22, 2025 -- Compute Q-tensor instead of the director field, as the director field is sensitive to the + and - direction.
Jan 23, 2025 -- Use float64 for the energy calculation to avoid overflow.
Feb 02, 2025 -- Compute from director field instead of Q-tensor. This is to save the storage space of intermediate results. 
"""

import numpy as np
import pandas as pd
import os
import argparse
from myimagelib.myImageLib import show_progress
from skimage import io

def compute_gradient(field):
    """
    Compute the gradient, divergence andn curl of a 2D field.

    Args:
    field -- the input 2D field, [M x N x 2].

    Returns:
    gradient -- the gradient of the field, [M x N x 2 x 2].
    """
    grad_x = np.gradient(field[:, :, 0])
    grad_y = np.gradient(field[:, :, 1])
    grad = np.array([grad_x, grad_y]).transpose(1, 2, 0, 3)
    div = grad_x[0] + grad_y[1]
    curl = grad_y[0] - grad_x[1]

    return grad, div, curl

def compute_bending_energy_old(field):
    """
    Compute the bending energy of a 2D field using the director field.

    Args:
    field -- the input 2D field, [M x N x 2].

    Returns:
    bending_energy -- the bending energy of the field, [M x N].
    """
    grad, div, curl = compute_gradient(field)
    bending_energy = div**2 + curl**2

    return bending_energy

def compute_bending_energy(Q_tensor):
    """
    Compute the bending energy from a 2D Q-tensor.

    Args:
    Q_tensor: A 2D array of Q-tensor components with shape (Nx, Ny, 2, 2).

    Returns:
    bending_energy: The total bending energy.
    """

    Nx, Ny, _, _ = Q_tensor.shape

    # Compute spatial derivatives using finite differences
    dQxx_dx = np.gradient(Q_tensor[:, :, 0, 0], axis=0)
    dQxx_dy = np.gradient(Q_tensor[:, :, 0, 0], axis=1)
    dQxy_dx = np.gradient(Q_tensor[:, :, 0, 1], axis=0)
    dQxy_dy = np.gradient(Q_tensor[:, :, 0, 1], axis=1)
    dQyy_dx = np.gradient(Q_tensor[:, :, 1, 1], axis=0)
    dQyy_dy = np.gradient(Q_tensor[:, :, 1, 1], axis=1)

    # Compute the bending energy density
    bending_energy = (
        dQxx_dx**2 + dQxx_dy**2 +
        dQxy_dx**2 + dQxy_dy**2 +
        dQyy_dx**2 + dQyy_dy**2
    )

    return bending_energy

def angle_to_director(angle_8_bit):
    """
    Convert an 8-bit angle image to a director field.

    Args:
    angle_8_bit -- the input 8-bit angle image, [M x N].

    Returns:
    director -- the output director field, [M x N x 2].
    """
    angle = angle_8_bit * np.pi / 255 - np.pi / 2
    director = np.array([np.cos(angle), np.sin(angle)]).transpose(1, 2, 0)

    # require the y component director to be positive, otherwise flip the director
    director[director[:,:,1]<=0] *= -1

    return director

def qTensor(director, size=10):
    """
    Compute the Q-tensor from the director field.
    """
    Q = np.zeros((director.shape[0], director.shape[1], 2, 2))
    Q[:, :, 0, 0] = uniform_filter(director[:, :, 0] * director[:, :, 0], size=size) - 0.5
    Q[:, :, 0, 1] = uniform_filter(director[:, :, 0] * director[:, :, 1], size=size)
    Q[:, :, 1, 0] = uniform_filter(director[:, :, 1] * director[:, :, 0], size=size)
    Q[:, :, 1, 1] = uniform_filter(director[:, :, 1] * director[:, :, 1], size=size) - 0.5

    return Q

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute bending energy from a director field.")
    parser.add_argument("directorDir", help="the director field file dir.")
    parser.add_argument("maskDir", help="the mask field file dir.")
    parser.add_argument("--size", type=int, default=8, help="the kernel size of the uniform filter to smooth the Q-tensor.")
    args = parser.parse_args()

    # load director field
    angles = np.load(args.directorDir)
    

    # load mask
    mask = io.imread(args.maskDir)

    # process the filename
    folder, filename = os.path.split(args.directorDir)
    name, ext = os.path.splitext(filename)
    mainfolder = os.path.split(folder)[0]
    savefolder = os.path.join(mainfolder, "bending_energy")
    if not os.path.exists(savefolder):
        os.makedirs(savefolder)

    # compute bending energy
    energy_list = []
    nFrame = angles.shape[0]
    for num, angle in enumerate(angles):
        show_progress(num/nFrame, label=name)
        d = angle_to_director(angle)
        Q = qTensor(d, size=args.size)
        bending_energy = compute_bending_energy(Q)
        bending_energy[~mask.astype("bool")] = np.nan
        energy_list.append(np.nanmean(bending_energy))
    
    # save bending energy data
    df = pd.DataFrame({"frame": range(len(energy_list)), "bending_energy": energy_list})
    df.to_csv(os.path.join(savefolder, name+".csv"), index=False)