close all;clear all;clc;
%Pretest GKPC
%Main Image


%I = imread('Breast_cancer4.jpg');
I = imread('mdb077fatt.pgm');

%Step 1
%Median Filtering
M1 = medfilt2(I);

%Step 2
%Histogram Equalization
HQ = histeq(M1);
AD = imadjust(HQ);

%Step 3
%Do Thresholding + Morphological Operations 
K = uint8(AD);
L = im2bw(K, .08);

%Morphological Operations
M = imfill(L,'holes');
N = bwareaopen(M,100000);
se = strel('disk', 25);
erodeBW = imerode(N,se);
dilaBW = imdilate(erodeBW,se);

%Step 4 Filtering + Finalization
M = medfilt2(dilaBW);
Mu = immultiply(I,M);


subplot(2,3,1), imshow(I), title('origin');
subplot(2,3,2), imshow(M1), title('STEP 1: Median Filter');
subplot(2,3,3), imshow(HQ), title('STEP 2: Histogram Equalization');
subplot(2,3,4), imshow(L), title('STEP 3.1: Thresholding');
subplot(2,3,5), imshow(dilaBW), title('STEP 3-2: After Morphological Operations');
subplot(2,3,6), imshow(Mu), title('STEP 4: Final');