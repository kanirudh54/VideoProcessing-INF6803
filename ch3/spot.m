%Filtre pour d�tecter les taches.

a=imread('snapshot.bmp');
imshow(a)
pause
a=rgb2gray(a);

% Construction de DOG2
Gauss1=fspecial('gaussian',[5 5],0.62)
Gauss2=fspecial('gaussian',[5 5],1)
Gauss3=fspecial('gaussian',[5 5],1.6)

Somme=Gauss1-2*Gauss2+Gauss3;
mesh(Somme);
pause

c=conv2(Somme,double(a));
mesh(c);
pause
c=abs(c);
imshow(c);