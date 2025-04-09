"""
fill_images.py
==============

This script fills the black corners of images with a texture-awared method. 

Syntax
------

python fill_images.py input_dir

input_dir : directory of a tif image.

Edit
----
* Apr 08, 2025: Initial commit.
"""

import cv2
import os
import numpy as np
import argparse
from skimage import io
import time

def texture_aware_inpaint(image, mask, method=cv2.INPAINT_TELEA):
    """
    Inpaint with noise characteristics sampled from surrounding areas
    """
    # Standard inpainting
    result = cv2.inpaint(image, mask, inpaintRadius=3, flags=method)
    
    # Create a dilated mask to sample from surrounding pixels
    kernel = np.ones((15,15), np.uint8)
    sampling_region = cv2.dilate(mask, kernel) - mask
    
    # Get noise characteristics from surrounding area
    if len(image.shape) == 2:  # Grayscale
        surrounding_pixels = image[sampling_region > 0]
        noise_std = np.std(surrounding_pixels) * 0.7  # Scale factor
    else:  # Color
        noise_std = 0
        for c in range(image.shape[2]):
            surrounding_pixels = image[:,:,c][sampling_region > 0]
            noise_std += np.std(surrounding_pixels)
        noise_std = (noise_std / image.shape[2]) * 0.7
    
    return noisy_inpaint(image, mask, noise_level=noise_std, method=method)

def noisy_inpaint(image, mask, noise_level=10, method=cv2.INPAINT_TELEA):
    """
    Inpaint an image region and add controlled noise to the inpainted area
    
    Parameters:
    image: Input image (grayscale or color)
    mask: Binary mask where 255 indicates pixels to be inpainted
    noise_level: Standard deviation of Gaussian noise (higher = noisier)
    method: cv2.INPAINT_TELEA or cv2.INPAINT_NS
    
    Returns:
    Inpainted image with noise added to the inpainted region only
    """
    # Ensure mask is uint8
    if mask.dtype != np.uint8:
        mask = mask.astype(np.uint8)
    
    # Standard inpainting
    result = cv2.inpaint(image, mask, inpaintRadius=3, flags=method)
    
    # Create noise only in the inpainted area
    noise = np.zeros_like(image, dtype=np.float32)
    
    # Generate appropriate noise based on image dimensions
    if len(image.shape) == 2:  # Grayscale
        noise_img = np.random.normal(0, noise_level, image.shape).astype(np.float32)
    else:  # Color image
        noise_img = np.random.normal(0, noise_level, image.shape).astype(np.float32)
    
    # Apply noise only to the inpainted region
    binary_mask = mask > 0
    
    # Add noise to result
    result_float = result.astype(np.float32)
    
    if len(image.shape) == 2:  # Grayscale
        result_float[binary_mask] += noise_img[binary_mask]
    else:  # Color image
        for c in range(image.shape[2]):
            result_float[:,:,c][binary_mask] += noise_img[:,:,c][binary_mask]
    
    # Clip to valid range and convert back to original dtype
    result_float = np.clip(result_float, 0, 255)
    noisy_result = result_float.astype(image.dtype)
    
    return noisy_result


if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description="Fill black corners of images with texture-aware inpainting.")
    argparser.add_argument("input_dir", type=str, help="Directory of input images.")
    args = argparser.parse_args()

    print(args.input_dir)

    method = cv2.INPAINT_NS  # or cv2.INPAINT_TELEA
    img_stack = io.imread(args.input_dir)

    new_stack = []
    img = img_stack[0]  # Use the first image to create the mask
    mask = np.zeros_like(img, dtype=np.uint8)
    mask[img==0] = 255  # Create a mask where pixel value is 0
    for num, img in enumerate(img_stack):
        img_new = texture_aware_inpaint(img, mask)
        new_stack.append(img_new)
        if num % 100 == 0:
            print(time.asctime() + f" -> {num:04d}")
    # save the new stack
    new_stack = np.stack(new_stack)
    # save the new stack to a .tif file
    io.imsave(args.input_dir, new_stack)