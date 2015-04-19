%Exemple PCA:

A=zeros(20,20)
A(5:15,5:10)=1
A(5:10,5:15)=1
%A(5:10,11:12)=1
imshow(A)
hold
[x,y]=find(A==1) 
x=x-mean(x);
y=y-mean(y);
C=cov(x,y)
[V,D] = eig(C)
[d,m]=find(D==max(max(D)))
%line([0 V(2,2)*3]+10,[0 V(1,2)*3]+10,'Color','b');
%line([0 V(2,1)*3]+10,[0 V(1,1)*3]+10,'Color','r');
vec=V(d,:)
line([0 vec(2)*3]+10,[0 vec(1)*3]+10,'Color','r');