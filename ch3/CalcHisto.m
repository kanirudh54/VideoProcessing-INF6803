%Calcul d'un histogramme

image=[1 4 5 4 5 6 4;4 5 5 10 4 5 3;6 6 7 8 5 9 4;10 4 6 9 7 6 4]
imshow(uint8(image/10)*255);

histogramme=zeros(1,10)
for i=1:size(image,1)
    for j=1:size(image,2)
        histogramme(image(i,j))=histogramme(image(i,j))+1;
    end
end
figure
bar(histogramme)