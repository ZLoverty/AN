"""
report.py
=========

This is an attempt to implement an idea I had in mind for a long time. The idea is to generate a report, which overviews the outcome of the data analysis. This is needed for all the projects, although the specific functions of these scripts are different. 

In this script, I will implement the following functions:
1. Director field overlayed on the original image;
2. Time-averaged elastic energy overlayed on the original image.

The script is designed to work in a data folder of a day. The generated report should be a image file (.jpg), in a folder named "report" in the data folder. The report is named as the video name, e.g. "00.jpg". 

Syntax
------

python report.py <data_folder>

Edit
----
* Apr 10, 2025 -- Initial commit.
"""

import argparse
import os
import matplotlib.pyplot as plt
import numpy as np
from myimagelib import readdata
from skimage import io
import matplotlib
matplotlib.rcParams["font.family"] = "STIXGeneral"
matplotlib.rcParams["mathtext.fontset"] = "stix"
matplotlib.rcParams["xtick.direction"] = "in"
matplotlib.rcParams["ytick.direction"] = "in"
plt.rcParams['xtick.major.size'] = 2  # Length of major ticks
plt.rcParams['ytick.major.size'] = 2  # Length of major ticks
plt.rcParams['xtick.minor.size'] = 1  # Length of minor ticks
plt.rcParams['ytick.minor.size'] = 1  # Length of minor ticks
import pandas as pd

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

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Generate a report for the data analysis.")
    parser.add_argument("folder", type=str, help="The data folder.")
    parser.add_argument("--step", type=int, default=15, help="The step size for the quiver plot. Default: 10.")
    args = parser.parse_args()
    folder = args.folder
    step = args.step
    report_folder = os.path.join(folder, "report")
    os.makedirs(report_folder, exist_ok=True)

    l = readdata(os.path.join(folder, "time_averaged_elastic_energy"), "npy")

    for num, i in l.iterrows():
        n, c = i.Name.split("_")

        img = io.imread(os.path.join(folder, "crop_channel", f"{n}_{c}.tif"))[0]
        mask = io.imread(os.path.join(folder, "mask", f"{c}{n}.tif"))
        angle = np.load(os.path.join(folder, "director_field", f"{n}_{c}.npy"))[0]
        abe = np.load(os.path.join(folder, "time_averaged_elastic_energy", f"{n}_{c}.npy"))
        # be = pd.read_csv(os.path.join(folder, "bending_energy", f"{n}_{c}.csv"))

        # setup grids for quiver plot
        xlim = [0, img.shape[1]]
        ylim = [0, img.shape[0]]
        Y, X = np.mgrid[ylim[0]:ylim[1]:step, xlim[0]:xlim[1]:step]

        d = angle_to_director(angle)
        d[~mask.astype(bool), :] = np.nan
        fig, ax = plt.subplots(1, 2, figsize=(4, 2), dpi=300, gridspec_kw={'wspace': .05})

        ax[0].imshow(img, cmap="gray")
        ax[0].quiver(X, Y, d[ylim[0]:ylim[1]:step, xlim[0]:xlim[1]:step, 0], d[ylim[0]:ylim[1]:step, xlim[0]:xlim[1]:step, 1], color='yellow', width=.008, scale=30,  headlength=0, headwidth=0, headaxislength=0, pivot="middle")
        ax[0].axis("off")

        ax[1].imshow(img, cmap="gray")
        ax[1].imshow(np.log(abe), cmap="jet", alpha=.7, vmin=-9, vmax=-5)
        ax[1].axis("off")

        # ax[2].plot(be["frame"], be["bending_energy"], color="blue", label="Bending energy")
        # ax[2].set_xlabel("Frame")
        # ax[2].set_ylabel("Bending energy")

        fig.savefig(os.path.join(report_folder, f"{n}_{c}.jpg"), bbox_inches="tight", dpi=300)
        
        