%Condensation Algorithm
%As described in lecture
%Sources and References : Lecture Notes, Wikipedia, Matlab Documentation
%Author: Sai Anirudh Kondaveeti

video = VideoReader('suivi_visage_visible.avi');            %input the video to be read
videoread = read(video);

%Some variable which can be modified
N = 1000;                                                      %Number of Samples or particles
regionofinterest = [273.00 100.00 50.00 70.00];              %The region of intrest we are interested in it of form [x-pos y-pos width height] and the x, y correspond to upper left corner of rectangle
wi = regionofinterest(3);
he = regionofinterest(4);
bins = 16;                                                   %Number of bins in histogram
[xpix,ypix,rgb,noframes] = size(videoread);                                      %Number of frames
%Bounding box and frame of reference
initframe = videoread(:,:,:,1);                              %Initial frame
cropofregionofinterest = imcrop(initframe,regionofinterest); % crop of region of interest

%Initializing sample set with the region of interest i.e we have 100% match
%here
sampleset = zeros(1,4,N);
for it=1:N
    sampleset(:,:,it) = regionofinterest;
end


%Processing each frame
for i= 1: noframes
    frame = videoread(:,:,:,i);
    simindex = zeros(1,N);                                       % Similarity index with respect to Bhattarcharrya Distance
    tempsampleset = sampleset;                                   % In the first loop same as the initialized one, but from next time onwards changes -- look at the last line of code
    %Calculate simililarity Index using Bhattacharya distance
    for j=1:N
        temp = tempsampleset(:,:,j);                             % Intermediate variables to extract out the histograms of Image. Here first we seperate the R, G, B parts of image as three images
        tempImage = imcrop(frame,temp);                          % then the respective histograms are found and then they are normalized. Here instead of concatenating the R, G, B as one vector , 
        tempImageR = tempImage(:,:,1);                           % I just found them out individually and added. The result would be same even if it was concatenated.(Everything is finally summed up)
        tempImageG = tempImage(:,:,2);
        tempImageB = tempImage(:,:,3);
        originalImageR = cropofregionofinterest(:,:,1);
        originalImageG = cropofregionofinterest(:,:,2);
        originalImageB = cropofregionofinterest(:,:,3);
        [tempHr,x] = imhist(tempImageR,bins);
        [tempHg,y] = imhist(tempImageG,bins);
        [tempHb,z] = imhist(tempImageB,bins);
        [origHr,q] = imhist(originalImageR,bins);
        [origHg,w] = imhist(originalImageG,bins);
        [origHb,e] = imhist(originalImageB,bins);
        normtempHr = (tempHr/sum(tempHr+tempHg+tempHb));
        normtempHg = (tempHg/sum(tempHr+tempHg+tempHb));
        normtempHb = (tempHb/sum(tempHr+tempHg+tempHb));
        normorigHr = (origHr/sum(origHr+origHg+origHb));
        normorigHg = (origHg/sum(origHr+origHg+origHb));
        normorigHb = (origHb/sum(origHr+origHg+origHb));
        simindex(:,j) =1 + log( sum(sqrt(normtempHr.*normorigHr)) + sum(sqrt(normtempHg.*normorigHg)) + sum(sqrt(normtempHb.*normorigHb)) ); %Calculation of similarity index using Bhattarcharrya Distance, if similar we get 1.
    end
    
    %take maximum value and show recangle
    [val,ind] = max(simindex);
    position = tempsampleset(:,:,ind);
    %code for bounding box % Done manually
    %figure;
    frame((position(2):position(2)+position(4)),(position(1):position(1)),:) = uint8(255*ones(he+1,1,3));
    frame((position(2):position(2)+position(4)),(position(1)+position(3):position(1)+position(3)),:) = uint8(255*ones(he+1,1,3));
    frame((position(2):position(2)),(position(1):position(1)+position(3)),:) = uint8(255*ones(1,wi+1,3));
    frame((position(2)+position(4):position(2)+position(4)),(position(1):position(1)+position(3)),:) = uint8(255*ones(1,wi+1,3));
    imshow(frame);
    
    %To make sure that simindex doesent have any negative weight --
    %requirement for randsample to work
    for v=1:N
        if simindex(v) < 0
            simindex(v) = 0;
        end    
    end    
    
    % randomly select from sample set based on weights
    newsamplesetindices = randsample(N,N,true,simindex);    %needs statistics toolbox , this function directly gives a set of indices from the tempsampleset, based on their weights. Same sample can come twice
    newsampleset = zeros(1,4,N);    
    
    % filling the new sample set from old one.(We are taking the best particles)
    for l=1:N
        index = newsamplesetindices(l);
        newsampleset(:,:,l) = tempsampleset(:,:,index);
    end
    
    %Updating the new sample set. We previously got the best partices. Now these particles are used as reference to create new particles
    for k = 1:N
        px = newsampleset(:,1,k);
        py = newsampleset(:,2,k);
        width = abs(newsampleset(:,3,k));
        height = abs(newsampleset(:,4,k));
        newpx = mod(px + round(5*width*(rand-0.5)),480);
        newpy = mod(py + round(5*height*(rand-0.5)),640);
        if ( ((newpx + width) > 640) || ((newpy + height) > 480) )   % To avoid the bounding box outside the frame
            newpx = px;
            newpy = py;
        end
        newsampleset(:,:,k) = [newpx newpy width height];            %Keeping the width and height of rectangle same as previous
    end    
    sampleset = newsampleset;                                        %Finally newsampleset is made the sampleset for next iteration.
end
