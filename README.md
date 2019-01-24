# Image-Stitching
Computer Vision Project

Image stitching or mosaicing is a technique of image processing that helps blending together several overlapping images into one large image with making the boundaries of the original images unseen. Image stitching algorithms use the alignment measures estimated by image alignment algorithms to successfully blend the images in a seamless manner while dealing with problems such as ghosting and blurring caused by the movement, parallax and varying image exposures. 

## Problem Formulation and Solution Methods

The problem of image stitching of mosaicing requires detecting the keypoints in the images and matching them to determine which features come from corresponding locations in different images. The proposed method to do this is to use scale-invariant features since these features can be found and matched more reliably than traditional methods. SIFT algorithm works by constructing a scale-space and applying difference of Gaussian function to find the maxima/minima in the difference of Gaussian image, which are the feature points  

```MATLAB
%% Corner metric matrix (Harris Feautures)
cornersL = detectHarrisFeatures(imgL);
cornersR = detectHarrisFeatures(imgR);

```
After finding the Harris feature points, we have to match each image to a small number of neighbouring images. After identifying m images that have the greatest number of matches to an image, we use RANSAC to select a set of inliners and compute a homography. 


```MATLAB
%% Feature Descriptors
[featuresL, valid_cornersL] = extractFeatures(imgL, cornersL);
[featuresR, valid_cornersR] = extractFeatures(imgR, cornersR);

%match feautres
indexPairs = matchFeatures(featuresL,featuresR);

```

![harris](https://github.com/ProbisMis/Image-Stitching/blob/master/Screenshots/featurematch.png)


From these matched features, we compute a homography mapping the coordinates of the matched SIFT features from the first image to the coordinates of the matched SIFT features of the second image. To do this we select 4 matched SIFT features randomly and use these coordinates to compute a homography. We use RANSAC to select this set of inliers that are compatible with a homography between the images. To verify the accuracy of this homography and to decide if this is a successful match, we iteratively calculate the distance between the projected feature coordinates and the actual feature coordinates of the matched features, threshold it to calculate the number of inliers , and repeat the process by selecting another set of 4 SIFT features randomly and applying the same process. 

```MATLAB
%% RANSAC %%
pts1 = matchedPoints1.Location';
pts2 = matchedPoints2.Location';
[H , corrPtIdx] = findHomography(pts1,pts2);

```

After iterating for a fixed number of times we choose the homography with the largest number of inliers. This will be the homography that we will use for stitching the images together. 

```MATLAB

stitchedImage = stitch_cylinder(imgL, imgR, H); 
 figure(4);
 clf;
 imagesc(stitchedImage);
 axis image off ;
 title('Mosaic stitch cylinder') ;
 colormap gray;

```

![cylinder](https://github.com/ProbisMis/Image-Stitching/blob/master/Screenshots/cylinder.png)

## Results 

The success of the algorithm changes from image to image.  The percentage of overlapping between the images effects the result of stitching. 


## Special Thanks To

* Adina Stoica and  Derek Burrows for [image stitchig code](EE417Final/Image_mosaicing).


* Ke Yan for  [finding homography](EE417Final/ransac_homography) using RANSAC.


