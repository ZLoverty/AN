import pandas as pd
import os
from myimagelib.myImageLib import readdata

folder = r"C:\Users\zl948\Documents\AN\aug08completed"
l = readdata(os.path.join(folder, "director_field"), "npy")
for num, i in l.iterrows():
    # os.system("python qTensor.py \"{}\"".format(i.Dir))
    n, c = i.Name.split("_")
    maskDir = os.path.join(folder, "mask", f"{c}{n}.tif")
    os.system("python bending_energy.py \"{0}\" \"{1}\" --size 10".format(i.Dir, maskDir))
