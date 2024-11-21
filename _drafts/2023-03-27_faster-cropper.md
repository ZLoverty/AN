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

##### A problem: crop region exceeds image bounds

We used to rotate the image before cropping the channel region. This sometimes lead to a loss of information, see the rotation animation below:

![picture 2](/assets/images/2023/03/rotate-image.gif)

In the rotated image, I set the cropping region to the upper edge, but that cropping region does not cover all the useful image information. A more reasonable choice of cropping region is indicated by the red dashed line.

![picture 3](/assets/images/2023/03/missing-information-rotation.png)  

One solution to this is to skip the rotation step. But why we want to rotate the image in the first place? It is because rectangular cropping is easier to implement if the region is upstraight. In such a case, the cropping is simply to slice a subset of the original image as an 2D array. For example, in the 4x4 image below, if we want to crop the 2x2 pixels in the center, we can simply write:

```python
crop = image[1:3, 1:3]
```

However, when the cropping region is not upstraight, we cannot simply map an entire pixel in the original image to one pixel in the cropped image, because the cropped image pixel in principle should contain information from mutiple pixels in the original image. For example, in the right panel of the figure below, the red pixel is made of parts of (0,1), (0,2), (1,1), (1,2) pixels of the original image. At this point, we have two options:

- rotate the original image in such a way to make the cropping region, so that the one-to-one mapping of pixels can be established. 
- alternatively, we can get the pixels in the cropped image by interpolating from the 4 involved pixels in the original image. 

![picture 4](/assets/images/2023/03/tilted-cropping-region.png)  

We have always been using the first approach. Here, let's test the second one. There is a readily implemented method in `scipy` I can use: `scipy.ndimage.map_coordinates()`. According to the documentation, it "maps the input array to new coordinates by interpolation", which is exactly what we want. 

`order` needs to be specified for the interpolation. I tried both `order=1` and `order=3`. The speed of order 1 interpolation is 5 times faster than the order 3, while the resulting cropped image qualities are quite similar (see a comparison below). The order 0 interpolation (take one pixel?) is 6-7 times faster than order 3. 

![picture 6](/assets/images/2023/03/compare-interpolation-orders.png)  

We also want to compare the speed of this interpolation approach to the rotate-slice method. The time required for doing one cropping is summarized for rotate-slice method and the order 0,1,3 interpolation method. 

| method  | time (ms) |
|---------|-----------|
| rotate  | 3         |
| order 0 | 7         |
| order 1 | 10        |
| order 3 | 50        |

The rotate method is apparently more efficient. However, the order 0 interpolation is only about twice slower than the rotate method, and is considered acceptable trade-off for retaining more information. In the meantime, the cropped images of interpolation orders 0,1,3 are barely different from each other, suggesting that higher order interpolation is not necessary. 

##### Conclusion

We implement a fast cropper (mini GUI app) to create channel ROIs for bifurcation images. It has the following advantages compared to the  traditional rotate-slice method:

- it saves a lot of manual cropping time
- it automatically ensures identical crop size for all channels
- a map-coordinates method is used to retain image information close to corners, which is usually lost by the traditional method