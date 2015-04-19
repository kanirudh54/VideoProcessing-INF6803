%Activity recognition
%As described in lecture
%Author: Sai Anirudh Kondaveeti


filename = 'v9.avi';

video = VideoReader(filename);                                      %input video to be read
videoread = read(video);

%Some parameters which could be changed and some initializations
[length,width,~,time] =size(videoread(:,:,1,:));                        
buffer = zeros(length,width);
accumulation = 200;                                                  %accumulation factor
decay =250;                                                          %decay factor
threshold=0.1;                                                       %Use??
counter = 0 ;
temsum =0;
val = 0;

for i=2:time
    presentframe = videoread(:,:,:,i);
    presentframe = im2bw(presentframe,0.1);
    for j= 1:length
        for k =1:width
          if(presentframe(j,k)==1)
              buffer(j,k) = min((buffer(j,k) + 255/accumulation),255);
          else
              buffer(j,k) = max((buffer(j,k) - 255/decay),0);
          end   
        end
    end
    figure(1);
    subplot(2,1,1),imshow(presentframe),title('Original');
    subplot(2,1,2),imshow(buffer/max(max(buffer))),title('Buffer');
end      

