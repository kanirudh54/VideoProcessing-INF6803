function [ NewBinImage ] = ConnectedComponentUF( BinImage )
%Connected component avec union-find
%recoit une matrice correspondant ? une image binaire (0 et 1)
% G-A Bilodeau, 27 septembre 2006

label=0;
Parent=zeros(1,100);

% First pass
BinImage(BinImage==1)=-1;
NewBinImage=BinImage;

for i=1:size(BinImage,1)
    for j=1:size(BinImage,2)
        if NewBinImage(i,j)<0
            label=label+1;
            NewBinImage(i,j)=label;
            if (i+1)<=size(BinImage,1) && NewBinImage(i+1,j)~=0
                if NewBinImage(i+1,j)>0 & NewBinImage(i+1,j)~=label
                    Parent=Union(label,NewBinImage(i+1,j),Parent)
                else
                    NewBinImage(i+1,j)=label;
                end
            end
            if (j+1)<=size(BinImage,2) && NewBinImage(i,j+1)~=0
                if NewBinImage(i,j+1)>0 & NewBinImage(i,j+1)~=label
                    Parent=Union(label,NewBinImage(i,j+1),Parent)
                else
                    NewBinImage(i,j+1)=label;
                end
            end
            if (i+1)<=size(BinImage,1) && (j+1)<=size(BinImage,2) && NewBinImage(i+1,j+1)~=0
                if NewBinImage(i+1,j+1)>0 & NewBinImage(i+1,j+1)~=label
                    Parent=Union(label,NewBinImage(i+1,j+1),Parent)
                else
                    NewBinImage(i+1,j+1)=label;
                end
            end
        elseif NewBinImage(i,j)>0
            if (i+1)<=size(BinImage,1) && NewBinImage(i+1,j)~=0
                if NewBinImage(i+1,j)>0 & NewBinImage(i+1,j)~=NewBinImage(i,j)
                    Parent=Union(NewBinImage(i,j),NewBinImage(i+1,j),Parent);
                else
                    NewBinImage(i+1,j)=NewBinImage(i,j);
                end
            end
            if (j+1)<=size(BinImage,2) && NewBinImage(i,j+1)~=0
                if NewBinImage(i,j+1)>0 & NewBinImage(i,j+1)~=NewBinImage(i,j)
                    Parent=Union(NewBinImage(i,j),NewBinImage(i,j+1),Parent);
                else
                    NewBinImage(i,j+1)=NewBinImage(i,j);
                end
            end
            if (i+1)<=size(BinImage,1) && (j+1)<=size(BinImage,2) && NewBinImage(i+1,j+1)~=0
                if NewBinImage(i+1,j+1)>0 & NewBinImage(i+1,j+1)~=NewBinImage(i,j)
                    Parent=Union(NewBinImage(i,j),NewBinImage(i+1,j+1),Parent);
                else
                    NewBinImage(i+1,j+1)=NewBinImage(i,j);
                end
            end
        end
    end
end
NewBinImage
Parent

% 2ieme passe
for i=1:size(BinImage,1)
    for j=1:size(BinImage,2)
        if NewBinImage(i,j)~=0
            parr=FindParent(NewBinImage(i,j),Parent);
            if parr~=0
                NewBinImage(i,j)=parr;            
            end
        end
    end
end

NewBinImage

function res=Union(libelle1, libelle2, Parent)

rt1=libelle1;
rt2=libelle2;
res=Parent;
res(max(rt1,rt2))=min(rt1,rt2);



function res=FindParent(libelle,Parent)

res=libelle;
while Parent(res)~=0
    res=Parent(res);
end
    


        