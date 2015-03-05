% Diff�rence de Gaussiennes
clc;
close all;
clear all;
imagea=imread('im2.jpg');
% Conversion en tons de gris (grayscale)
intensite=floor(double(imagea(:,:,1))*0.213+double(imagea(:,:,2))*0.715+double(imagea(:,:,3))*0.072);
colormap('gray');
image(intensite)
title('Grayscale');
% filtre gaussien
filtre1=gausswin(5,2)*gausswin(5,2)'
filtre2=gausswin(5,3)*gausswin(5,3)'
% Convolution avec premier filtre
res1=conv2(intensite,filtre1);
res1=floor((255/max(max(res1))).*res1); %normalisation
figure
colormap('gray');
image(res1)
title('Filtre gaussien 1');
% Convolution avec 2ieme filtre
res2=conv2(intensite,filtre2);
res2=floor((255/max(max(res2))).*res2);
figure
colormap('gray');
image(res2)
title('Filtre gaussien 2');
figure
% diff�rence des gaussiennes
colormap('gray');
res3=res1-res2;
%res3=255-res3;
res3=floor((255/max(max(res3))).*res3);
image(res3)
title('DoG');
