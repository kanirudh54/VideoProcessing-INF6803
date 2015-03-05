%Filtre Gaussien.

a=imread('snapshot.bmp');
a=rgb2gray(a);
imshow(a)
pause
% Construction de Gaussienne
Gauss1=fspecial('gaussian',[5 5],1.6)

c=conv2(Gauss1,double(a));
figure(2);
imshow(uint8(round(c)));
pause


diff=abs(double(a)-round(c(3:end-2,3:end-2)));
imshow(diff);