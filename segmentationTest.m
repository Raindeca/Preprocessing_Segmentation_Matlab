close all;clear all;clc;
%Segmentation Process

%Input the image
b=dicomread('crop_13S0RMLOanon1102.dcm');
%b=dicomread('crop_13S0RMLOanon1102.dcm');
Max=double(max(max(b)));
I=uint8(double(b(:,:))*255/Max);   % konversi nilai citra dicom 16 bit ke 8 bit


%Noise-Reduction
M1 = medfilt2(I);

%Thresholding
[T,EM] = graythresh(M1);
BW = imbinarize(M1,T);

%figure, imshow(BW);

%Operasi Morfologi
M = imfill(BW,'holes');
N = bwareaopen(M,100000);
%figure, imshow(N,[]);

[y,x] = find(N); %// Find row and column locations that are non-zero

%// Find top left corner
xmin = min(x(:));
ymin = min(y(:));

%// Find bottom right corner
xmax = max(x(:));
ymax = max(y(:));

%// Find width and height
width = xmax - xmin + 1;
height = ymax - ymin + 1;

out = imcrop(I, [xmin ymin width height]);

%figure, imshow(out);

%Do Thresholding[II]
K = uint8(out);
L = im2bw(K, 0.8);
%figure, imshow(L,[]);

%Noise-Reduction2
M2 = medfilt2(L);
%figure, imshow(M1);

%Operasi Morfologi2
M = imfill(M2,'holes');
N = bwareaopen(M,10000);
%figure, imshow(N,[]);


% Mengambil Bounding box masing2 objek Hasil segmentasi
[labeled, numObjects] = bwlabel(N,8);
stats = regionprops(labeled,'BoundingBox');
bbox = cat(1, stats.BoundingBox);

%Menampilkan citra rgb hasil segmentasi
%figure, imshow(I);
subplot(2,4,7), imshow(I), title('Bounding Box');
hold on;
for idx = 1 : numObjects
    h = rectangle('Position',bbox(idx,:), 'LineWidth',2);
    set(h,'EdgeColor',[.75 0 0]);
    hold on;
end

%Menampilkan Jumlah objek hasil segmentasi
title(['there are ', num2str(numObjects), ' objects in the image!']);

hold off;

[y,x] = find(N); %// Find row and column locations that are non-zero

%// Find top left corner
xmin = min(x(:));
ymin = min(y(:));

%// Find bottom right corner
xmax = max(x(:));
ymax = max(y(:));

%// Find width and height
width = xmax - xmin + 1;
height = ymax - ymin + 1;

out2 = imcrop(I, [xmin ymin width height]);

%figure, imshow(out2);

glcm = graycomatrix(out2,'Offset',[1 0]);
stats = graycoprops(glcm);
Contrast = stats.Contrast
Correlation = stats.Correlation
Energy = stats.Energy
Homogeneity = stats.Homogeneity
%feature = [stats.Contrast;stats.Correlation;stats.Energy;stats.Homogeneity]

subplot(2,4,1), imshow(I), title('origin');
subplot(2,4,2), imshow(BW), title('Thresholding[I]');
subplot(2,4,3), imshow(N,[]), title('Morphological Operations[I]');
subplot(2,4,4), imshow(out), title('Cropping[I]');
subplot(2,4,5), imshow(L,[]), title('Thresholding[II]');
subplot(2,4,6), imshow(N,[]), title('Morphological Operations[I]');
subplot(2,4,8), imshow(out2), title('ROI Final');