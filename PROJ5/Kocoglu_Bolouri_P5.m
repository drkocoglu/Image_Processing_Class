% Project to read in a video of a C. elegan and then track and analyze its movement
% movement from the video
% By Farshad Bolouri & Yildirim Kocoglu
clear; close all;

videoPath = inputdlg("Enter the path to the video:" + newline + ...
    "For example: C:\Image-Processing-Projects\Video\worm.avi", 'Directory');

tic
if ~isempty(videoPath{1})
    
    % Write a video of the results
    writerObj = VideoWriter('Bolouri_Kocoglu_Proj5_Video.avi'); % create a video object to start saving the frames
    writerObj.FrameRate = 5; % framerate 
    open(writerObj); % Need to open the video object first before saving anyhting into it
    
    %% Calculate Mean Frame
    disp("Calculating the Mean Frame from the Video...")
    video = VideoReader(videoPath{1});
    
    frame1 = readFrame(video);
    
    meanFrame = imcomplement(imbinarize(readFrame(video)));
    
    % Finding the Mean of all Frames
    
    while(hasFrame(video))
        tempFrame = imcomplement(imbinarize(readFrame(video)));
        meanFrame = meanFrame + tempFrame;
    end
    
    meanFrame = meanFrame/video.NumFrames;
    
    meanFrame = im2uint8(meanFrame);
    %imshow(meanFrame);
    disp("---------------------------------------------")
    %% Processing the video
    disp("Processing the Video...")
    percentage = 0.1*video.NumFrames;
    se = strel('disk',5);
    se2 = strel('disk',25);
    se3 = strel('disk',12);
    scale=50;
    NUM_OF_VECS = 10;
    
    % Binarizing the mean-frame
    meanFrame = imbinarize(meanFrame, 0.85);
    figure
    
    for i = 1 : video.NumFrames
        worm = false(size(meanFrame));
        I = read(video, i);             % Reading the next frame
        frame = imcomplement(imbinarize(I));    % Binarizing the Frame
        
        % Subtracting the mean-frame from the current frame
        frameN = frame - meanFrame;     
        
        stats = regionprops(logical(frameN), 'Area', 'PixelIdxList');
        
        if max([stats.Area]) >= 23000   
            % This program would not continue tracking the worm if a large
            % part of the worm is inside a bubble or not in the frame (not
            % visible)
            
            if max([stats.Area]) >= 30000
                frameN = logical(imopen(frameN, se));
                stats = regionprops(frameN, 'Area', 'PixelIdxList');
            end
            
            % Separating the Worm in binarized image
            [~ , idx] = max([stats.Area]);
            worm(stats(idx).PixelIdxList) = 1;
            wormN = imclose(worm, se2);
            
            wormN_area = bwarea(wormN);
            if wormN_area > 32750
                wormN = imclose(worm, se3);
            end
            
            % Calculating the Skeleton of the Worm
            skel = bwskel(wormN, 'MinBranchLength',65);
            bbox = regionprops(wormN, 'BoundingBox');
            overlay = imdilate(skel, se);
            skel_L = length(find(skel));
            
            % Calculating the endpoints of the skeleton and its sorting the
            % pixels corresponding to the skeleton
            [endpointsX, endpointsY] = find( bwmorph(skel == 1, 'endpoints') );
            bwtrace = bwtraceboundary(skel, [endpointsX(1), endpointsY(1)],'N');
            y = bwtrace(1:skel_L,1);
            x = bwtrace(1:skel_L,2);
            
            % Calculating normal vectors of equidistant points on the worm
            % based on the length of the skeleton
            vecs = 4: floor(skel_L/NUM_OF_VECS) :skel_L-3;
            norms = zeros(length(vecs),2);
            
            if pdist([x(vecs(end)) y(vecs(end)); x(end) y(end)],'euclidean') > 25 
                vecs = [vecs skel_L];
                norms = zeros(length(vecs),2);
                
                pNorm = normCalc(x, y, skel_L, scale , 'End');
                norms(end,:) = pNorm;
            end
            
            j = 1;
            for k=4: floor(skel_L/NUM_OF_VECS) :skel_L-3
                pNorm = normCalc(x, y, k, scale , 'Middle');
                norms(j,:) = pNorm;
                j = j + 1;
            end
            
            % Overlaying the Segmented worm and its skeleton
            segmented = labeloverlay(I,wormN,'Transparency',0);
            imshow(labeloverlay(segmented,overlay,'Transparency',0, 'Colormap', 'spring'))
            hold on
            
            % Showing the normal vectors
            quiver(x(vecs),y(vecs), abs(x(vecs) - norms(:,1))*3,...
                abs(y(vecs) - norms(:,2))*1.75, 'r' , 'LineWidth', 1.75, 'MaxHeadSize', 1.25)
            quiver(x(vecs),y(vecs), -abs(x(vecs) - norms(:,1))*3,...
                -abs(y(vecs) - norms(:,2))*1.75, 'r' , 'LineWidth', 1.75, 'MaxHeadSize', 1.25)
            
            % plotting the equidistant points
            plot(x(vecs),y(vecs),'.y', 'MarkerSize', 15)
            
            % Putting a bounding box around the worm
            rectangle('Position', [bbox(1).BoundingBox(1)-40 ...
                bbox(1).BoundingBox(2)-40 bbox(1).BoundingBox(3)+80 ...
                bbox(1).BoundingBox(4)+80], 'EdgeColor', 'g', 'LineWidth', 1.5);
            
            % Putting a bounding box around the head and tail
            rectangle('Position', [endpointsY(1)-45, endpointsX(1)-45,...
                90, 90], 'EdgeColor', 	'#7E2F8E', 'LineWidth', 2.5);
            if length(endpointsX) == 2
                rectangle('Position', [endpointsY(2)-45, endpointsX(2)-45,...
                    90, 90], 'EdgeColor', 	'#7E2F8E', 'LineWidth', 2.5);
            end
            
            hold off
            
        else
            imshow(I)
        end
        
        writeVideo(writerObj, getframe(gcf));
        
        if ~mod(i, percentage)
            fprintf('\n\n%d%% of the video is processed...!', i/video.NumFrames*100);
        end
    
    end
    
    close(writerObj);
    disp("\n\nVideo Saved!")
    disp("---------------------")
end
time = toc;
fprintf("Elapsed Time = %.2f Minutes\n" , time/60);


%% This one is more reliable to use to display percentage complete in my opinion in case number of frames is not equal to 300 (number of frames = 327 for example --> your code will not show any percentage progress)

clc;

num_frames = 300; % change this to see the effect

allnumbersdividible = alldivisors(num_frames);
percentage = allnumbersdividible(end-1);

for i = 1:num_frames
        
        % Copy below and replace yours (%d) can give numbers like "9.0005e + 1 %" (= 90.0005%) which is not comfortable to look at
        if ~mod(i, percentage)
            fprintf('\n\n%0.2f%% of the video is processed...!', i/num_frames*100);
        end
end

function divs = alldivisors(N)
  % compute the set of all integer divisors of the positive integer N
  
  % first, get the list of prime factors of N. 
  facs = factor(N);
  
  divs = [1,facs(1)];
  for fi = facs(2:end)
    % if N is prime, then facs had only one element,
    % and this loop will not execute at all, In that case
    % The set of all divisors is simply 1 and N.
    
    % this outer product will generate all combinations of
    % the divisors found so far, combined with the current
    % divisor fi.
    divs = [1;fi]*divs;
    
    % unique eliminates the replicate divisors, making
    % this an efficient code.
    divs = unique(divs(:)');
  end
  
end
%% Function for Calculating the Normal Vectors
function pNorm = normCalc(x, y, k, scale , position)

% step 1 dv/dt
if strcmp(position, 'Middle')
    dx = (mean(x(k+1:k+3))-mean(x(k-3:k-1)));
    dy =(mean(y(k+1:k+3))-mean(y(k-3:k-1)));
    
elseif strcmp(position, 'End')
    dx = x(k)-x(k-2);
    dy = y(k)-y(k-2);
end

% step2 rotate 90%
dvdtRot = [-dy ;dx];

% Step 3: Scale it to magnitude 1
% unit vector
dvdtRotNorm = dvdtRot/norm(dvdtRot);
pNorm = [x(k);y(k)]+scale*dvdtRotNorm;

end



