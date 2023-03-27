---
date: 2023-03-27
title: Faster cropper
---
### Faster cropper

Previously, we cropped the 3 channels manually in ImageJ. It worked fine, but is quite slow and some parts of the work are redundant. For example, most bifurcation grids have channels 120 degrees apart from each other. In principle, I have to specify the angle of only one of the three channels and the junction center (3 numbers: angle_1, xc, yc) and the other crops can be inferred. In rare cases, we have right angles instead of 120-degree channels, where we only have to specify 2 more numbers (angle_2 and angle_3). 

On top of being fast, this method also makes it easier to make crops of identical length. 

The video below illustrates the UI of the implemented cropper. The script is stored in the ZLoverty/script repo as `faster_cropping.py`.

![picture 1](/assets/images/2023/03/cropper-snapshot.gif)  

##### Settings

The cropper requires the following inputs:

- a sample image directory `imgDir`: str
- a folder to save outputs `save_folder`: str
- angles of channels from channel A `angles`: list of floats, in degree, measured in clockwise direction
- crop region width `w` and height `h`: int

faster_cropping.py
```python
### Required settings below

imgDir = r"test_images\faster_cropping\crop-test.tif"

save_folder = r"test_images\faster_cropping"

angles = [0, 120, 240]

w, h = 400, 500

### Settings above
```

##### Usage

After completing the required setting, run the script with 

```
$ python faster_cropping.py
```

The UI will be displayed with the image. Press left button at the center of the three channels and drag the mouse to channel "A". Once the crops are satisfactory, release the left button. If you want to redo the crop, repeat the press + release. To save the crop data, press <kbd>Enter</kbd>.

##### Data

This mini-app generates 3 types of data (output):

- raw image with overlayed crop indicators: 1 x .jpg
- cropped images: 3 x .tif
- crop data: 1 x .csv 

 which will all be put in `save_folder`. 

##### A problem

We used to rotate the image before cropping the channel region. This sometimes lead to a loss of information, see the rotation animation below:

![picture 2](/assets/images/2023/03/rotate-image.gif1)  

One solution to this is to skip the rotation step. We can try the `scipy.ndimage.map_coordinates()`.