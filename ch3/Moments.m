%Calcul de moment
clc

%Images (tr�s) synth�tiques tests!
%image1=[0 0 0 0 0 0 0;0 0 0 1 1 0 0; 0 0 0 0 1 0 0; 0 0 0 0 0 0 0];
%image2=[0 1 1 1 1 0 0;0 1 1 1 1 0 0; 0 0 0 1 1 0 0; 0 0 0 1 1 0 0];
%image2=[0 0 0 1 0 1 0;1 1 1 1 1 0 0; 0 0 0 0 1 1 1; 0 0 0 0 0 0 0];
image1=[0 0 0 0 0 0 0 0 0;0 0 0 0 1 1 0 0 0;0 0 0 0 1 1 1 0 0;0 0 0 0 1 1 0 0 0;0 0 0 0 0 0 0 0 0]
%image2=[0 0 0 0 1 0 0 0 0;0 0 0 0 1 1 0 0 0;0 0 1 1 1 1 1 1 0;0 0 0 0 1 1 0 0 0;0 0 0 0 0 0 0 0 0]
%image2=[0 0 0 0 0 0 0 0 0;0 0 0 0 1 1 0 0 0;0 0 0 1 1 1 0 0 0;0 0 0 0 1 1 0 0 0;0 0 0 0 0 0 0 0 0]
%image2=[0 0 0 0 0 0 0 0 0;0 0 0 0 0  1 1 0 0;0 0 0 0 0 1 1 1 0;0 0 0 0 0 1 1  0 0;0 0 0 0 0 0 0 0 0]
image2=[0 0 0 0 1 1 1 1 0;0 0 0 0 1  1 1 1 1;0 0 0 0 1 1 1 1 1;0 0 0 0 1 1 1 1 1;0 0 0 0 1 1 1 1 0]

%� changer selon la taille des images
%posx=[1:7;1:7;1:7;1:7];
%posy=[ones(1,7);2*ones(1,7);3*ones(1,7);4*ones(1,7);];
posx=[1:9;1:9;1:9;1:9;1:9];
posy=[ones(1,9);2*ones(1,9);3*ones(1,9);4*ones(1,9);5*ones(1,9)];


%Calcul de l'aire
m00_im1=sum(sum(image1))
m00_im2=sum(sum(image2))

%Calcul centroide
m10_im1=sum(sum(image1.*posx))/m00_im1
m10_im2=sum(sum(image2.*posx))/m00_im2
m01_im1=sum(sum(image1.*posy))/m00_im1
m01_im2=sum(sum(image2.*posy))/m00_im2

%Moment de Hu ordre 2 image 1
mu11_im1=sum(sum(((image1(image1>0).*posx(image1>0))-m10_im1).*((image1(image1>0).*posy(image1>0))-m01_im1)));
mu20_im1=sum(sum(((image1(image1>0).*posx(image1>0)-m10_im1).^2)));
mu02_im1=sum(sum(((image1(image1>0).*posy(image1>0)-m01_im1).^2)));

nu11_im1=mu11_im1/(m00_im1)^(1+(1+1)/2);
nu20_im1=mu20_im1/(m00_im1)^(1+(2+0)/2);
nu02_im1=mu02_im1/(m00_im1)^(1+(0+2)/2);

MomentHu_im1=(nu20_im1-nu02_im1).^2+4*(nu11_im1.^2)

%Moment de Hu ordre 2 image 2
mu11_im2=sum(sum(((image2(image2>0).*posx(image2>0))-m10_im2).*((image2(image2>0).*posy(image2>0))-m01_im2)));
mu20_im2=sum(sum(((image2(image2>0).*posx(image2>0)-m10_im2).^2)));
mu02_im2=sum(sum(((image2(image2>0).*posy(image2>0)-m01_im2).^2)));

nu11_im2=mu11_im2/(m00_im2)^(1+(1+1)/2);
nu20_im2=mu20_im2/(m00_im2)^(1+(2+0)/2);
nu02_im2=mu02_im2/(m00_im2)^(1+(0+2)/2);

MomentHu_im2=(nu20_im2-nu02_im2).^2+4*(nu11_im2.^2)