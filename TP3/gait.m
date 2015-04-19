%Gait Recognition -- Getting Ngait
%As described in lecture
%Author: Sai Anirudh Kondaveeti


%filename = 'v1.avi';                                               %comment it out when using it as a part of correlation.m

video = VideoReader(filename);                                      %input video to be read
videoread = read(video);

%Terms useful throughout code
[length, width, ~ ,time] = size(videoread);							%Extracting the length, width adn time from the video sequence
%totalpixels = length*width;  
plotval = zeros(1,time);											%Stores the plot values
Ngait = 0;                                                          %Ngait initialized to zero  



for i = 1:time
    frame = videoread(:,:,:,i);
    temp = im2bw(frame,0.1);                                         %Though image is in black and white, it is in 4-D format, and hence the conversion
    tempresize = imresize(temp, [NaN 128]);                          %To get the images who height is 128 pixels. uniformity in comparison
    regionofinterest = tempresize(:,:);                              %Only pixels concering leg (Approximation) -- can be modified, but I prefered this as few videos weren't very good 
    pixels = regionofinterest  > 0 ;                                 %Gives bool satisfying the above condition
    numberofpixels = sum(sum(pixels));                               %Number of pixels greater than 0 i.e number of white pixels
    plotval(1,i) = numberofpixels;
end


%Smoothing the graph Savitzky-Golay Filter in Signal processing toolbox
temp1 = sgolayfilt(plotval,1,7);                                     %Can be varied to get the required plot, there values worked well for these values
[~, locs1] = findpeaks(-temp1);                                      %Gets the minimums in graph

[~,b] = size(locs1);                                            


%if number of minimums is even 
if mod(b,2) == 0                                                     % Getting the alternate minmums and then getting the repective median whose mean is the required Ngait.
    k = (b/2 -1)*2;
    tempmed = zeros(1,k);
    for j=1:(b-2)
        tempmed(j)= locs1(j+2) - locs1(j);
    end
    tempmed1 = zeros(1,k/2);
    tempmed2 = zeros(1,k/2);
    v=1;
    l=1;
    for d= 1:k
        if mod(d,2)==0
            tempmed1(v) = tempmed(d);
            v=v+1;
        end    
        if mod(d,2)==1
            tempmed2(l) = tempmed(d);
            l=l+1;
        end    
    end
    median1 = median(tempmed1);
    median2 = median(tempmed2);
    if isnan(median1)
        Ngait = median2;
    elseif isnan(median2)
        Ngait = median1;
    else
        Ngait = (median1 + median2)/2;
    end  
end

%if number of minimums is odd                                           % Getting the alternate minmums and then getting the repective median whose mean is the required Ngait.
if mod(b,2) == 1                                                        
    f = b-2;
    tempmed4 = zeros(1,f);
    for t=1:(b-2)
        tempmed4(t) = locs1(t+2) - locs1(t);
    end
    tempmed5 = zeros(1, (f/2 -0.5));
    tempmed6 = zeros(1, (f/2 -1.5));
    r=1;
    e=1;
    for s=1:(b-2)
        if mod(s,2)==1
            tempmed5(r)= tempmed4(s);
            r=r+1;
        end
        if mod(s,2)==0
            tempmed6(e) = tempmed4(s);
            e=e+1;
        end    
    end
    median3 = median(tempmed5);
    median4 = median(tempmed6);
    if isnan(median3)
        Ngait = median4;
    elseif isnan(median4)
        Ngait = median3;
    else
        Ngait = (median3 + median4)/2;
    end    
end


% figure;
% plot(temp1);               % this the smoothed graph

figure;
plot(plotval);               % this is the original graph