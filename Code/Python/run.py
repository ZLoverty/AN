import os
from myimagelib.myImageLib import readdata

folder = r"C:\Users\liuzy\Documents\AN\08 jun 2023\crop_channel"
l = readdata(folder, "tif")

for num, i in l.iterrows():
    os.system("python director_field.py \"{}\"".format(i.Dir))