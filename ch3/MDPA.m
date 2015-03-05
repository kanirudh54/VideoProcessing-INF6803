HA=[4 1 1 0 0 0 3 1]
HB=[1 4 1 0 0 0 3 1]
HC=[2 1 1 0 0 0 3 3]

Dist=0;
for i=1:8
    dint=0;
    for j=1:i
        dint=dint+HC(j)-HA(j)
        pause
    end
    Dist=Dist+abs(dint)
    pause
end
        