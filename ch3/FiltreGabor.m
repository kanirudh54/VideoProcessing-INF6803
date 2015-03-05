%Filtre Gabor.

a=imread('snapshot.bmp');
a=rgb2gray(a);
figure(1)
imshow(a)
pause
% Construction du filtre Gabor

for i=-2:2
    for j=-2:2
        Gab(i+3,j+3)=exp(-(i^2+j^2)/(2*8))*cos(3*i+3*j);
    end
end
figure(2)
mesh(Gab)

c=conv2(Gab,double(a));
figure(3);
imshow(uint8(round(abs(c))));
