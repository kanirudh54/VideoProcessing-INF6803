BW=zeros(200,300);
BW(80:160,100:200)=1;
BW(100:130,200:202)=1;
imshow(BW)
pause

BW3 = bwmorph(BW,'skel',Inf);
imshow(BW3)
pause

% image=imread('forskel.jpg');
% image=rgb2gray(image);
% 
% image(image<100)=0;
% image(image>=100)=1;
% BW=double(image);
% imshow(BW)
% pause;

%{p2,p3,p4,p5,p6,p7,p8,p9,p2}
Voisins={[-1 0],[-1 1],[0 1],[1 1],[1 0],[1 -1],[0 -1],[-1 -1],[-1 0]};
BW2=BW;
BWtemp=BW2;
nochange=1;
k=0;
while nochange~=0
    k=k+1
    nochange=0;
    for i=2:size(BW,1)-1
        for j=2:size(BW,2)-1
            if BW2(i,j)==1
                % �tape 1:

                %Condition 1:
                %Calcul du nombre de voisins.
                %Si 1 voisin, ne peut pas effacer.
                %Si 7 voisins, ferait un trou dans la r�gion. Contour=au moins un voisin �
                %0
                nbvoisins=0;
                for a=1:length(Voisins)-1;
                    nbvoisins=nbvoisins+BW2(i+Voisins{a}(1),j+Voisins{a}(2));
                end

                %Condition 2:
                %Empecher de d�connecter des points du squelette.
                %Calcul du nombre de transitions 0->1 sur la
                %s�quence p2,p3,...,p9,p2
                nbtransitions=0;
                for a=1:length(Voisins)-1
                    if BW2(i+Voisins{a}(1),j+Voisins{a}(2))==0 && BW2(i+Voisins{a+1}(1),j+Voisins{a+1}(2))==1
                        nbtransitions=nbtransitions+1;
                    end
                end 

                %Condition 3:
                Position1=BW2(i-1,j)*BW2(i,j+1)*BW2(i+1,j); %p2*p4*p6

                %Condition 4:
                Position2=BW2(i,j+1)*BW2(i+1,j)*BW2(i,j-1); %p4*p6*p8

                if nbvoisins>=2 && nbvoisins<=6 && nbtransitions==1 && Position1==0 && Position2==0
                    BWtemp(i,j)=0;
                    nochange=nochange+1;
                end
            end
        end
    end
    BW2=BWtemp;
    for i=2:size(BW,1)-1
        for j=2:size(BW,2)-1
            if BW2(i,j)==1
                % �tape 2:
                 %Condition 1:
                %Si 1 voisin, ne peut pas effacer.
                %Si 7 voisins, ferait un trou dans la r�gion. Contour=au moins un voisin �
                %0
                nbvoisins=0;
                for a=1:length(Voisins)-1;
                    nbvoisins=nbvoisins+BW2(i+Voisins{a}(1),j+Voisins{a}(2));
                end

                %Condition 2:
                %Empecher de d�connecter des points du squelette.
                nbtransitions=0;
                for a=1:length(Voisins)-1
                    if BW2(i+Voisins{a}(1),j+Voisins{a}(2))==0 && BW2(i+Voisins{a+1}(1),j+Voisins{a+1}(2))==1
                        nbtransitions=nbtransitions+1;
                    end
                end 


                %Condition 3:
                Position1=BW2(i-1,j)*BW2(i,j+1)*BW2(i,j-1);  %p2*p4*p8

                %Condition 4:
                Position2=BW2(i-1,j)*BW2(i+1,j)*BW2(i,j-1);   %p2*p6*p8

                if nbvoisins>=2 && nbvoisins<=6 && nbtransitions==1 && Position1==0 && Position2==0
                    BWtemp(i,j)=0;
                    nochange=nochange+1;
                end
            end
        end
    end
    BW2=BWtemp;
    imshow(BW2);
    nochange
    pause(0.2);
end
