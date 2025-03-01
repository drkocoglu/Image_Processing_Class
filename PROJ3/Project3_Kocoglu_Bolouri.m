% Image Processing
% Project# 3
% Group members: Yildirim Kocoglu & Farshad Bolouri

%% Description of the script
% Step-by-step progress of this script: 
    % Take a snap shot image of standard playing card(s) using a webcam
    % Process the snap shot --> Rotate the card to upright position, detect & extract suit & rank features of the card
    % Classify the rank & suite of the playing card using the extracted features of the card

%% Clear and close all
clear;
clc;
% close all;

%% Import images (REPLACE WITH THE WEBCAM INPUT LATER)

% Specify the path to images (User input)
Path = input('Please enter the path for the images: ','s'); % C:\Users\ykocoglu\Desktop\Image Processing\HW3\CardImages
fprintf('\n');

% Specify the image type (default = .JPG --> Change if needed)
Image_type = ('*.tif');

% Get the names of the images within the given path
filePattern = fullfile(Path, Image_type);
imageFiles = dir(filePattern);
Cards_sorted = {imageFiles.name};
Cards_sorted = erase(Cards_sorted,'Card_')';
Cards_sorted = str2double(erase(Cards_sorted,'.tif'));
Cards_sorted = sort(Cards_sorted,'ascend');
Cards_sorted = strcat('Card_',string(Cards_sorted),'.tif');

% Get the number of image files in the folder
nfiles = length(imageFiles);

% Initialize a cell array to store all images
images = cell(1,nfiles);

a = []; % initialize annotation array

%loads the pretrained classifiers 
load categoryClassifierRanks4
load categoryClassifierSuits3

disp('Press any key on the "Command Window" to continue...');
%fprintf('\nSize of current image is: [%0.1f,%0.1f] \n',size(currentimage));
pause;

mytest = [4,5,6,7,8,9,10,11,12,2,13,1,14]; 

%myFigure = figure(1);
% mytext = 'Initial text';
% Go through each image within the given path and extract features 
for i=mytest %nfiles
    
%     clear mytext;
    

    tic;
    currentfilename = Cards_sorted(i);
    new_path = fullfile(Path, currentfilename);
    currentimage = imread(new_path);
    binarizedimage = double(imbinarize(currentimage));
    % Process the image
    Blurred_image = imgaussfilt(binarizedimage, 10);
    [Gmag, Gdir] = imgradient(Blurred_image,'sobel');
    
    % Apply a Laplacian Kernel (Second Derivative) to the image to find features
    Laplace_kernel = [0,1,0;1,-4,1;0,1,0];
    Second_der = edge(Gmag,'zerocross',Laplace_kernel); % Blurred_image
    
    % Rotate images
    Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;
    figure('Name','HIST');
    hist = histogram(Gdir, 'BinWidth', 2);
    hist.BinCounts(1) = 0;
    [~, ii] = max(hist.BinCounts);
    rot_ang = 180 - ((hist.BinEdges(ii + 1) + hist.BinEdges(ii)) / 2);
    toc;
    imRot = imrotate(currentimage, rot_ang, 'crop');
    close HIST
    
    %binarize and smooths the rotated image to process for cropping
    imBinOrig2 =  double(imbinarize(imRot, .4));
    imBinOrig2 = imgaussfilt(imBinOrig2, 3);
    stats = regionprops(imBinOrig2, 'BoundingBox', 'Area');
    areas = stats.Area;
    [val,ind] = max([stats.Area]);
    bboxes=stats(ind).BoundingBox;
    
    finalImage = imcrop(imRot, bboxes);
    
    %Makes sure the card is standing upright
    if size(finalImage, 1) < size(finalImage, 2)
        finalImage = imrotate(finalImage, 90);
    end
    
    %make sure that the card was cropped correctly and the image is usable
    if (size(finalImage, 1) / size(finalImage, 2)) > 1.3 && ...
            (size(finalImage, 1) / size(finalImage, 2)) < 1.5
        
        finalImageResized = imresize(finalImage, [400 300]);
        regionOfInterest = imcrop(finalImageResized, [0 0 50 120]);
    else
        disp('Picture is not usable, try taking a new picture in 5 seconds.');
        figure; imshow(currentimage);
        figure; imshow(finalImage);
%         break
        pause(5)
        close all;
        continue
    end
    
    %processes the ROI to prepare for segmenting the suit and rank
    segImg = imgaussfilt(regionOfInterest, 2);
    segImg = imbinarize(segImg);
    segImg = imcomplement(segImg);
    
    stats2 = regionprops(segImg, 'Area', 'BoundingBox');
    
    croppedImages = cell(size(stats2, 1), 2);
    count = 0;
    
    %Segments the suit and rank out
    for j = 1 : length(stats2)
        thisBB = stats2(j).BoundingBox;
        croppedImages{j,2} = thisBB(3) / thisBB(4);
        if count >= 2
            break
        elseif stats2(j).Area > 150 && stats2(j).Area < 1000 && ...
                croppedImages{j,2} < 1.5 && croppedImages{j,2} > 0.5
            if count == 1
                rank = imcrop(regionOfInterest, thisBB);
                count = count + 1;
            elseif count == 0
                suit = imcrop(regionOfInterest, thisBB);
                count = count + 1;
            end
        end
    end
    
    %Classifying Rank and Suit
    [SuitIdx1, scores1] = predict(categoryClassifierSuits, rank);
    [SuitIdx2, scores2] = predict(categoryClassifierSuits, suit);
    
    if (var((scores1+1)*100) > var((scores2+1)*100))
        predictedSuit = categoryClassifierSuits.Labels(SuitIdx1);
        [RankIdx, ~] = predict(categoryClassifier, suit);
        predictedRank = categoryClassifier.Labels(RankIdx);
    else
        predictedSuit = categoryClassifierSuits.Labels(SuitIdx2);
        [RankIdx, ~] = predict(categoryClassifier, rank);
        predictedRank = categoryClassifier.Labels(RankIdx);
    end
    
%     mytext = 'random';
%     delete(mytext);
    
    %To show the suit and rank
    %close myFigure;
    myFigure = figure(1);
    subplot(1,2,1) 
    imshow(currentimage);
    title('ORIGINAL IMAGE')
    %myFigure = figure(1);
    subplot(1,2,2);
    set(myFigure,'color',[1 1 1])
    axis off
    mytext = text(0.5, 0.5, ['Suit: ' predictedSuit 'Rank: ' predictedRank ], ...
        'FontSize',24, 'horizontalAlignment','center', ...
        'VerticalAlignment', 'middle');
    title('PREDICTED SUIT & RANK');
    
    
%     if input('Enter 1 to continue to the next image: ') == 1
%         close all;
%         continue
%     else
% %       clear;
%         close all;
%         endCase = 0;
%     end

figure(5)
subplot(311)
imshow(imRot)
subplot(312)
imshow(rank)
subplot(313)
imshow(suit)

disp('Press any key on the "Command Window" to continue...');    
waitforbuttonpress;
% close all;



    % Plot results
%     figure(2)
% %     subplot(1,4,1) 
%     imshow(currentimage);
%     title('ORIGINAL IMAGE')
% %     subplot(1,4,2) 
% %     imshow(Blurred_image);
% %     title('BLURRED IMAGE')
% %     subplot(1,4,3) 
% %     imshow(Gmag);
% %     title('MAGNITUDE IMAGE')
% %     subplot(1,4,4) 
% %     imshow(Gdir);
% %     title('ORIENTATION IMAGE')
% %     figure(2) 
% %     imshow(Second_der);
% %     title('SECOND DERIVATIVE IMAGE')
%     figure(3)
%     imshow(regionOfInterest);
%     title('ROTATED IMAGE');
%     
%     figure(4)
%     imshow(rank);
%     title('RANK');
%     figure(5)
%     imshow(suit);
%     title('SUIT');
    
    
    
end