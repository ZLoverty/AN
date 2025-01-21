import pandas as pd
import os
from myimagelib.myImageLib import readdata

folder = r"C:\Users\liuzy\Documents\AN\08 jun 2023"
l = readdata(os.path.join(folder, "director_field"), "npy")
for num, i in l.iterrows():
    n, c = i.Name.split("_")
    maskDir = os.path.join(folder, "mask", f"{c}{n}.tif")
    os.system("python bending_energy.py \"{0}\" \"{1}\"".format(i.Dir, maskDir))
