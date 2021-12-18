clc;clear;close all;
img = imread('./ˮӡͼ.png');
% grayImg = rgb2gray(img);

img = im2bw(img,220/255);
imshow(img);
