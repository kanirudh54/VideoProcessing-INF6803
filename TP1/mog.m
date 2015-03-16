%Implementing Mixture of Gaussian from "Adaptive background mixture models for real-time tracking" by Stauffer and Grimson
%Help also taken from other research papers like  "Practical mixtures of Gaussians with brightness monitoring"
%and "Parameter Analysis for Mixture of Gaussians Model"
%Author: Sai Anirudh Kondaveeti
%This code is buit from existing code at http://areshmatlab.blogspot.ca/2010/05/high-complexity-background-subtraction.html . Like the structure is same but the computation is different and adapted to paper by Stauffer

input = VideoReader('video1.avi');
inputVideo = read(input);


%frame related variabls 
frame = inputVideo(:,:,:,1);               % first frame read
frame_bg = rgb2gray(frame);                % getting greyscale image
frame_size = size(frame_bg);               % size of the frame
width = frame_size(2);                     % width of the frame
height = frame_size(1);                    % height of the frame
foreground = zeros(height, width);         % initialize variable to store foreground
background = zeros(height, width);         % initialize variable to store background

% Parameters
K = 3;                                     % number of gaussian components (can be upto 3-5)- I was getting good results with 3 components
B = K;                                     % number of background components considered when taking the argmin
D = 2.5;                                   % deviation threshold
alpha = 0.01;                              % learning rate (between 0 and 1) - also estimated from half-life formula 
foreThreshold = 0.25;                      % foreground threshold -- depends on the scenario.
sd_initial = 6;                            % initial standard deviation
weight = zeros(height,width,K);            % initializing weights array
mean = zeros(height,width,K);              % pixel means
stdDev = zeros(height,width,K);            % pixel standard deviations
diffMean = zeros(height,width,K);          % difference of each pixel from mean
rankComp = zeros(1,K);                     % rank of components (w/sd)


%Initializing Components
for i=1:height
    for j=1:width
        for k=1:K
            mean(i,j,k) = frame_bg(i,j);    % first frame value as the mean.Though the papers suggested differently.I was adviced by Pierre-Luc St-Charlesand on this initialization.
            weight(i,j,k) = 1/K;            % initializing with equal weights
            stdDev(i,j,k) = sd_initial;   
        end
    end
end

% Applying the algorithm frame by frame
for n = 1:length(inputVideo)
    % reading the frame
    frame = inputVideo(:,:,:,n);  
    % converting the frame to grayscale.
    frame_bg = rgb2gray(frame);      
    % calculating the difference from mean for each pixel.
    for m=1:K
        diffMean(:,:,m) = abs(double(frame_bg) - double(mean(:,:,m)));
    end
    % updating gaussian components for each pixel values.
    for i=1:height
        for j=1:width
            match = 0; % it is changed to 1 if the component matches
            for k=1:K  
                if (abs(diffMean(i,j,k)) <= D*stdDev(i,j,k))       %%%%%%%%%
                    match = 1;                                             
                    % updating weights, mean, standard deviation and
                    % learning factor as there is match
                    weight(i,j,k) = (1-alpha)*weight(i,j,k) + alpha;
                    p = normpdf(double(frame_bg(i,j)),mean(i,j,k),stdDev(i,j,k));
                    mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(frame_bg(i,j));
                    stdDev(i,j,k) =   sqrt((1-p)*(stdDev(i,j,k)^2) + p*diffMean(i,j,k));
                else                                               % if pixel ist matched 
                    weight(i,j,k) = (1-alpha)*weight(i,j,k);       % weight slighly decreased as suggested by paper
                end
            end
            weight(i,j,:) = weight(i,j,:)./sum(weight(i,j,:));            
            background(i,j)=0;
            for k=1:K
                background(i,j) = background(i,j)+ mean(i,j,k)*weight(i,j,k);
            end
            % if no components are matched
            if (match == 0)
                [min_w, min_w_index] = min(weight(i,j,:));  
                mean(i,j,min_w_index) = double(frame_bg(i,j));
                stdDev(i,j,min_w_index) = sd_initial;
            end
            %Ranking
            rankComp = weight(i,j,:)./stdDev(i,j,:);             
            rankIndex = [1:1:K];
            
            % sorting the rank values
            for k=2:K               
                for m=1:(k-1)
                    if (rankComp(:,:,k) > rankComp(:,:,m))                     
                        % swaping max values
                        rank_temp = rankComp(:,:,m);  
                        rankComp(:,:,m) = rankComp(:,:,k);
                        rankComp(:,:,k) = rank_temp;
                        % swaping max index values
                        rank_ind_temp = rankIndex(m);  
                        rankIndex(m) = rankIndex(k);
                        rankIndex(k) = rank_ind_temp;    
                    end
                end
            end
            % calculating foreground 
            match = 0;
            k=1;
            foreground(i,j) = 0;
            x=0;
            while ((match == 0)&&(k<=B))
                x=x+weight(i,j,rankIndex(k)); %%%%%%%
                if ( x>= foreThreshold)
                    if (abs(diffMean(i,j,rankIndex(k))) <= D*stdDev(i,j,rankIndex(k)))
                        foreground(i,j) = 0;
                        match = 1;
                    else
                        foreground(i,j) = 255;     %%%%%%%%%
                    end
                end
                k = k+1;
            end
        end
    end
    
    %filtering to get better output i.e reduce the salt and pepper noise
    foreground = medfilt2(foreground,[8 8]); %%%%%%%%%%%
    
    % Plotting the foreground and original video
    figure(1),
    subplot(1,2,1),imshow(frame), title('Original Video');
    subplot(1,2,2),imshow(uint8(foreground)) , title('Foreground( Moving Objects )');

    % foreground frames into a movie.
    Movie1(n)  = im2frame(uint8(foreground),gray);    
end

% saving foreground movie as avi. 
movie2avi(Movie1,'mixtureOfGaussiansOutput','fps',14);  
