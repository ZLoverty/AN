"""
time_averaged_energy.py
=======================

Compute the time-averaged elastic energy from director fields over time. 

Syntax
------
python time_averaged_energy.py directorDir maskDir [--size 10]

Edit
----
Apr 06, 2025 -- Initial commit.
"""

import argparse
import os
import numpy as np
from myimagelib.myImageLib import show_progress, readdata
from skimage import io
from scipy.ndimage import uniform_filter

def angle_to_director(angle_8_bit):
    """
    Convert an 8-bit angle image to a director field.

    Args:
    angle_8_bit -- the input 8-bit angle image, [M x N].

    Returns:
    director -- the output director field, [M x N x 2].
    """
    angle = angle_8_bit / 255 * np.pi - np.pi / 2
    director = np.array([np.cos(angle), np.sin(angle)]).transpose(1, 2, 0)

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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute the time-averaged elastic energy from director fields over time.")
    parser.add_argument("directorDir", help="The director field in angles (.npy), [M x N x F].")
    parser.add_argument("maskDir", help="The mask field (.tif), [M x N].")
    parser.add_argument("--size", type=int, default=10, help="The size of the spatial average filter size when computing Q-tensor. Default 10.")
    args = parser.parse_args()

    directorDir = args.directorDir
    maskDir = args.maskDir
    size = args.size

    folder, filename = os.path.split(directorDir)
    save_folder = os.path.join(folder, "time_averaged_elastic_energy")
    os.makedirs(save_folder, exist_ok=True)

    # Compute the time-averaged elastic energy    
    angle_stack = np.load(directorDir)
    mask = io.imread(maskDir)
    be_stack = []
    for num, angle in enumerate(angle_stack):
        show_progress(num / angle_stack.shape[0], label=filename)
        d = angle_to_director(angle)
        Q = qTensor(d, size)
        be_tmp = compute_bending_energy(Q)
        be_stack.append(be_tmp)
    be = np.stack(be_stack).mean(axis=0)
    be[~mask.astype("bool")] = np.nan

    np.save(os.path.join(save_folder, filename), be)