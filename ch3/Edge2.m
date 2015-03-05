%Detection of edges

a=imread('snapshot20060710115049.bmp');
imshow(a)
pause
a=rgb2gray(a);
sobel=[-1 0 1;-2 0 2;-1 0 1];
c=conv2(sobel,double(a));
mesh(c);
pause
c=abs(c);
c(c<30)=0;
imshow(c);