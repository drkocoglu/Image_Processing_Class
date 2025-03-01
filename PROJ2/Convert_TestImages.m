clear;
close all;
clc;

%% Convert Test images to grayscale and resize to 768X1024

%Test_image44
%Test_image55

currentimage = imread('Testimage_5.jpg');
I = rgb2gray(currentimage);
A = imresize(I,[768 1024]);
imwrite(A,'Testimage5.tif')