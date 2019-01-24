clear all
close all
clc


%% Image Loading
imgL = imread('imL.jpg');
imgL = rgb2gray(imgL);

imgR = imread('imR.jpg');
imgR = rgb2gray(imgR);


%% Corner metric matrix (Harris Feautures)
cornersL = detectHarrisFeatures(imgL);
cornersR = detectHarrisFeatures(imgR);

% pointwise locations
locationsL = cornersL.Location;
locationsR = cornersR.Location;

%% Feature Descriptors
[featuresL, valid_cornersL] = extractFeatures(imgL, cornersL);
[featuresR, valid_cornersR] = extractFeatures(imgR, cornersR);
%match feautres
indexPairs = matchFeatures(featuresL,featuresR);

%retrieve points
matchedPoints1 = valid_cornersL(indexPairs(:,1),:);
matchedPoints2 = valid_cornersR(indexPairs(:,2),:);

figure(1); showMatchedFeatures(imgL,imgR,matchedPoints1,matchedPoints2);

%% RANSAC %%
pts1 = matchedPoints1.Location';
pts2 = matchedPoints2.Location';
[H , corrPtIdx] = findHomography(pts1,pts2);


%% Image stitching 

 mosIm2 = stitch (imgL,imgR,H);
 
 figure(3);
 clf;
 imagesc(mosIm2);
 axis image off ;
 title('Mosaic stitch') ;
 colormap gray;
 
 stitchedImage = stitch_cylinder(imgL, imgR, H); 
 figure(4);
 clf;
 imagesc(stitchedImage);
 axis image off ;
 title('Mosaic stitch cylinder') ;
 colormap gray;