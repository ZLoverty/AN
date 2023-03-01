### Batch bifurcation data analysis workflow

In the bifurcation data analysis notebook, I describe the principles of the image analysis with small examples (typically one or two images). In practice, we have more videos with more frames, and it can be frustrating when trying to process them in a notebook, because a code box takes forever to finish. 

To make batch analysis more pleasant, I have written several scripts to automate the bifurcation image analysis workflow. I document the workflow here.

##### 0. Generate crop_data and mask with ImageJ

Images from bifurcation experiments typically involve 3 channels, in which we want to measure flow rates. To make simplify the downstream analysis, it is convenient to **rotate** the image, such that the channels are either horizontal or vertical in the image. In this case, we will only need to use one of the two components of PIV data to compute flow rate. 

Moreover, since the cropped images are usually larger than the channel, we want to generate masks that indicates where the channels are in the images. The masks are 8-bit images with large values indicating valid region and small values indicating invalid region. They will be used when computing flow rate.

In this section, I describe the procedure of using ImageJ to generate `crop_data.csv` file and `mask.tif` file. 



**crop_data.csv** is a comma separated values (csv) file guiding the python script to rotate and crop the raw images. The data looks like the following, where [BX, BY, Width, Height] specifies the crop bounding box and Angle specifies the rotation.

![picture 1](/assets/images/2023/02/crop-data.png)  

Two rows are used together to describe the rotating and cropping of one channel, i.e. row 1 and row 2 for channel A, row 3 and 4 for channel B, row 5 and row 6 for channel C. The Angle in the first row is the rotating angle, and the [BX, BY, Width, Height] in the second row specifies the bounding box in the rotated image. Here is the procedure to reproduce the `crop_data.csv` file from an .nd2 raw image. 

Below is a step-by-step walkthrough:

1. Load the .nd2 image in ImageJ (use virtual stack to make loading faster)

![picture 2](/assets/images/2023/02/load-image.png)  

2. Duplicate the first frame.

![picture 3](/assets/images/2023/02/dup-frame-1.png)  

3. Convert the image to 8-bit.

![picture 4](/assets/images/2023/02/to8bit.png)  

4. Change LUT to "Grays".

![picture 5](/assets/images/2023/02/grays.png)  

5. Analyze -> Set scale

![picture 6](/assets/images/2023/02/set-scale.png)  

6. Check "Global" and click "Click to remove scale"

![picture 7](/assets/images/2023/02/remove-scale.png)  

7. Analyze -> Set measurement, check only "Bounding rectangle"

![picture 11](/assets/images/2023/02/bounding-rect.png)  

8. Duplicate "first frame" twice (since there are 3 channels)

![picture 8](/assets/images/2023/02/dup-first-frame.png)  

9. Use rectangle selection tool to draw an *arbitrary* rectangle on a frame 

![picture 9](/assets/images/2023/02/arbitrary-rect.png)  

10. Analyze -> Measure 

![picture 12](/assets/images/2023/02/result-1.png)  

*NOTE: The purpose of steps 9 and 10 is only to set the [BX, BY, Width, Height] fields. The data is not useful.*

11. Use straight line tool to draw a line parallel to channel A. Note that to comply with the positive direction definition, you should draw the line starting from the center and ending at the channel opening.

![picture 13](/assets/images/2023/02/angle-A.png)  

12. Analyze -> Measure. The angle of channel A is measured and recorded. 

![picture 14](/assets/images/2023/02/angle-measure.png)  

13. Image -> Transform -> Rotate. Set the angle as (the measured angle - 90), and check preview, you should see channel A vertical, with exit at the top.

![picture 15](/assets/images/2023/02/rotate.png)  

![picture 16](/assets/images/2023/02/rotated-imag.png)  

14. Use rectangle selection tool to specify a crop region. It should be slightly larger than the channel region, and be as long as possible.

![picture 17](/assets/images/2023/02/crop-region.png)  

15. Analyze -> Measure. The cropping region is measured and recorded. 

![picture 18](/assets/images/2023/02/record-crop-region.png)  

16. Duplicate the region in the bounding box.

![picture 19](/assets/images/2023/02/dup-bounding-box.png)  

17. Save it as a separated file "preview/A.tif".

![picture 20](/assets/images/2023/02/save-as-file.png)  

18. Use polygon selection tool to draw the channel boundary (for straight channels, it is easier to use rectangle selection tool)

![picture 22](/assets/images/2023/02/polygon-selection.png)  
 
19. Fill the selected region with white color.

![picture 23](/assets/images/2023/02/fill-with-white.png)  

20. Threshold the image using Triangle preset and check "Dark background"

![picture 24](/assets/images/2023/02/thres.png)  

21. Save as a file "mask/A.tif".

![picture 25](/assets/images/2023/02/mask-A.png)  

22. Repeat steps 11-21 for the other two channels, and we get the following results:

![picture 26](/assets/images/2023/02/results.png)  

23. Remove the first row (because it is just a field holder), and save the results as "crop_data.csv".

##### 1. Crop channel
Generate tiffstacks of channels from raw videos. Note that this script has included background-removing already.

```
python crop_channel.py crop_data nd2Dir
```

##### 2. PIV
In order to make data treatment consistent, we decide that all the PIV should be done using the [ImageJ PIV Plugin](https://sites.google.com/site/qingzongtseng/piv/tuto#dataformat). For small scale analysis, it is convenient to use: just open a stack of two frames, and the plugin will give the results. However, for batch processing, this is not ideal since we have to convert the images to many many stacks of two frames, before the plugin takes over. 

Claire wrote [a ImageJ-macro](https://drive.google.com/file/d/1_3N5QFBLRBwhq626v-cDRyAmMFfGY5IN/view?usp=share_link) that automated the process of converting raw images to pairs and calling the plugin. This macro looks for all the .tif files in the given directory (/root/tif) and perform PIV analysis on them. The results are saved in another folder (/root/PIV).

For my own convenience (run one code for all the analysis), I use Python to call ImageJ PIV macro using the [headless mode](https://imagej.net/learn/headless):

```
python ij_piv.py img_folder
```

To avoid spamming the commandline output, I modify the PIV plugin to remove the logging info at each step. The modified the `PIV_.jar` file can be downloaded [here](https://drive.google.com/file/d/1ISZ734aDwkpSRf9e6gz2azPByfD8qlGl/view?usp=share_link). To install the modified version, you need to install the PIV plugin first according to the official site, then replace the `PIV_.jar` file in the plugins folder of ImageJ (in my case `C:\Fiji.app\plugins`) with the modified version. 

##### 3. Rename ImageJ PIV data files
ImageJ macro generates files like "_1.txt", which does not give correct order when sorting based on filename. We therefore rename the files, and also remove excess columns from the data. The remaining data are saved as "{:05d}.csv".
```
python rename_ij_piv.py piv_folder
```

##### 4. Apply mask
Add a "mask" column to .csv data, based on input mask image. In fact, mask can be applied to the compactPIV data, in which case the mask only needs to be computed once. The current implementation still has a lot of redundant computation, and can be optimized.
```
python apply_mask piv_folder mask_dir
```

##### 5. Wrap PIV data
Wrap a bunch of csv files into a .mat file.
```
python wrap_piv.py piv_folder
```

##### 6. Flow rate
Compute flow rate from PIV. 
```
python flowrate.py main_piv_folder flowrate_folder dt
```

