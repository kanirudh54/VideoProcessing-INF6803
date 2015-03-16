h= imread('RGB.jpg'); %image read and stored

%figure;
imshow(h); %image displayed

b=h(:,:,3); %accessing only blue component and storing

%figure;
imshow(b); %showing only blue component

gray = rgb2gray(h); %original image to grayscale

%figure;
imshow(gray); %grayscale image


