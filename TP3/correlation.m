%Gait Recognition -- Getting the corelation 
%As described in lecture
%Author: Sai Anirudh Kondaveeti

%Using the gait.m as a script to get required values which are used in
%finding correlation

%%Give the file names

file1 = 'v2.avi';
file2 = 'v6.avi';

%Correlation initialized to zero
correl = 0;

video1 = VideoReader(file1);                                      %input video to be read
videoread1 = read(video1);

video2 = VideoReader(file2);                                      %input video to be read
videoread2 = read(video2);


%Calling the script on the 1st video and getting the required values
filename = file1;
gait;
initial_frame_1 = locs1(1);                                       %gives the frame with the minimum
step_1 = floor(Ngait);
count1= 1;
frames_1 = zeros(25,25,(step_1+1));
for st = initial_frame_1:(initial_frame_1+step_1)
    frame_1 = videoread1(:,:,:,st);
    frame_1 = rgb2gray(frame_1);
    box = regionprops(bwconncomp(frame_1),'Image');
    
    [ltemp,~] = size(box);
    tempo = zeros(1,ltemp);
    for hg= 1:ltemp
        [temph,tempw]  = size(box(hg).Image);
        tempo(hg) = temph*tempw;
    end
    [~, In] = max(tempo);
    box = struct2array(box(In));
    img = imresize(box, [25 25]);
    frames_1(:,:,count1) = img;
    count1 = count1+1;
end    

%Calling the script on the 2nd video and getting the required values
filename= file2;
gait;
initial_frame_2 = locs1(1); 
step_2 = floor(Ngait);
count2= 1;
frames_2 = zeros(25,25,(step_2+1));
for st = initial_frame_2:(initial_frame_2+step_2)
    frame_1 = videoread2(:,:,:,st);
    frame_1 = rgb2gray(frame_1);
    box = regionprops(bwconncomp(frame_1),'Image');
    
    [ltemp,~] = size(box);
    tempo = zeros(1,ltemp);
    for hg= 1:ltemp
        [temph,tempw]  = size(box(hg).Image);
        tempo(hg) = temph*tempw;
    end
    [~, In] = max(tempo);    
    box = struct2array(box(In));
    img = imresize(box, [25 25]);
    frames_2(:,:,count2) = img;
    count2 = count2+1;
end


%Here count is nothing but (Ngait+2) , so we take the least count and find
%the sum of frame similarity.

%frame similarity is found by just multyplying every value in matrix by it
%corresponding value in another. It will onlbe one if both are one and
%hence their intersection. Union is nothing but the number of white pixels
%common + seperately


if (count2>=count1)
    for fg= 1:(count1-2)
        correl = correl + sum(sum(frames_1(:,:,fg).*frames_2(:,:,fg)))/(sum(sum((frames_1(:,:,fg)+frames_2(:,:,fg))>0))) ;
    end
end

if (count2<count1)
    for fg= 1:(count2-2)
        correl = correl + sum(sum(frames_1(:,:,fg).*frames_2(:,:,fg)))/(sum(sum((frames_1(:,:,fg)+frames_2(:,:,fg))>0))) ;
    end
end
