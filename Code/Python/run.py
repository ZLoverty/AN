import pandas as pd
import os
from myimagelib.myImageLib import readdata

folder = r"G:\My Drive\NASync\Sample 1\nd2"
l = readdata(os.path.join(folder, "qTensor"), "npy")
for num, i in l.iterrows():
    # os.system("python qTensor.py \"{}\"".format(i.Dir))
    n, c = i.Name.split("_")
    maskDir = os.path.join(folder, "mask", f"{c}{n}.tif")
    os.system("python bending_energy.py \"{0}\" \"{1}\"".format(i.Dir, maskDir))
