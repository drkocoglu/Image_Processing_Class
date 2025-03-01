%Project three for image processing by Peter Wharton and Farshad Bolouri
%Program that opens a webcam and takes a picture of a playing card,
%processes it and then displays the rank and suite of the card.
clear; close all; clc;

%finds and opens the webcam to take the pictures
% endCase = 1;
% cams = webcamlist;
% cam = webcam(cams{1});

%loads the pretrained classifiers
load categoryClassifierRanks4
%load categoryClassifierSuits3

%% Import images (REPLACE WITH THE WEBCAM INPUT LATER)

% Specify the path to images (User input)
Path = input('Please enter the path for the images: ','s'); % C:\Users\ykocoglu\Desktop\Image Processing\HW3\CardImages C:\Users\ykocoglu\Desktop\Image Processing\HW3\Multi_CardImages
fprintf('\n');

% Specify the image type (default = .JPG --> Change if needed)
Image_type = ('*.tif');

% Get the names of the images within the given path
filePattern = fullfile(Path, Image_type);
imageFiles = dir(filePattern);

% Get the number of image files in the folder
nfiles = length(imageFiles);

% Initialize a cell array to store all images
images = cell(1,nfiles);


%while endCase ~= 0
for i=1:nfiles
    %     disp('Press space to take the picture of the card. ')
    %     preview(cam);
    %     pause()
    %     imOrig = rgb2gray(snapshot(cam));
    
    currentfilename = imageFiles(i).name;
    new_path = fullfile(Path, currentfilename);
    imOrig = imread(new_path);
    
    %% Multi card boundaries (detects all the card boundaries)
    %binarize and smooths the image
    imBin = double(imbinarize(imOrig));
    imSmooth = imgaussfilt(imBin, 10); % not used
    imBinfill = imfill(imBin, 'holes');
    boundaries = bwboundaries(imBinfill);

    for k = 1:length(boundaries)
        
        %% Multi Card Masking (Preprocessing)
        % Detect each card as a separate object and use a mask to leave a single card for further processing
        card_detected = poly2mask(boundaries{k}(:,2),boundaries{k}(:,1),size(imOrig,1),size(imOrig,2));
        imnew = imOrig.*uint8(card_detected); % mask applied new image with single card
        
        % Process and rotate the new card image
        binarizedimg = imbinarize(imnew);
        filledimg = imfill(binarizedimg,'holes');
        Crd = regionprops(filledimg,'Area','Orientation');
        rotation_angle = 90-Crd.Orientation;
        imRot = imrotate(imnew, rotation_angle, 'crop');
        
        %% Apply cropping and classification
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
            figure; imshow(imOrig);
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
                    if thisBB(2) > (size(segImg,1) / 3)
                        suit = imcrop(regionOfInterest, thisBB);
                    else
                        rank = imcrop(regionOfInterest, thisBB);
                    end
                    count = count + 1;
                elseif count == 0
                    if thisBB(2) > (size(segImg,1) / 3)
                        suit = imcrop(regionOfInterest, thisBB);
                    else
                        rank = imcrop(regionOfInterest, thisBB);
                    end
                    count = count + 1;
                end
            end
        end
        
        %Classifying Rank and Suit
        [RankIdx, ~] = predict(categoryClassifier, rank);
        predictedRank = categoryClassifier.Labels(RankIdx);
        
        img = imgaussfilt(suit);
        img = imbinarize(img);
        img = edge(img);
        img_half = imcrop(img, [0 0 size(img,1) size(img,2)/2]);
        featureVector_half = extractHOGFeatures(img_half , 'CellSize', [1 1]);
        featureVector = extractHOGFeatures(img , 'CellSize', [1 1]);
        middle_half = length(featureVector_half(featureVector_half >0.5 & featureVector_half <0.6));
        middle = length(featureVector(featureVector >0.5 & featureVector <0.6));
        %top_half = length(featureVector_half(featureVector_half > 0.9));
        top = length(featureVector(featureVector > 0.9));
        
        if middle_half <= 15
            if top <= 8
                predictedSuit = 'Diamonds';
            else
                predictedSuit = 'Spades';
            end
        else
            if middle <= 63
                predictedSuit = 'Hearts';
            else
                predictedSuit = 'Clubs';
            end
        end
        
        fig = figure(k);
%         fig.WindowState = 'fullscreen';
        subplot(211)
        imshow(imnew)
        subplot(212)
        
        %To show the suit and rank
        myFigure = figure(k);
        set(myFigure,'color',[1 1 1])
        axis off
        text(0.5, 0.5, ['Suit: ' predictedSuit 'Rank: ' predictedRank ], ...
            'FontSize',24, 'horizontalAlignment','center', ...
            'VerticalAlignment', 'middle')
        %     if input('Enter 1 to take another picture, or 0 to exit the program. ') == 1
        %         close all;
        %         continue
        %     else
        % %         clear;
        %         close all;
        %         endCase = 0;
        %     end

        
        
        
    end
    disp('Press any key on the "Command Window" to continue...');
    waitforbuttonpress;
    close all;
end
    
    
    %%
    
    %uses the gradient direction to find the angle
%     [Gmag, Gdir] = imgradient(imSmooth);
%     Gdir(Gdir < 0) = Gdir(Gdir < 0) + 180;
%     figure('Name','HIST');
%     hist = histogram(Gdir, 'BinWidth', 4);
%     hist.BinCounts(1) = 0;
%     [~, i] = max(hist.BinCounts);
%     rot_ang = 180 - ((hist.BinEdges(i + 1) + hist.BinEdges(i)) / 2);
%     close HIST
%     %rotates the image
%     imRot = imrotate(imOrig, rot_ang, 'crop');
%     
%     %binarize and smooths the rotated image to process for cropping
%     imBinOrig2 =  double(imbinarize(imRot, .4));
%     imBinOrig2 = imgaussfilt(imBinOrig2, 3);
%     stats = regionprops(imBinOrig2, 'BoundingBox', 'Area');
%     areas = stats.Area;
%     [val,ind] = max([stats.Area]);
%     bboxes=stats(ind).BoundingBox;
%     
%     finalImage = imcrop(imRot, bboxes);
%     
%     %Makes sure the card is standing upright
%     if size(finalImage, 1) < size(finalImage, 2)
%         finalImage = imrotate(finalImage, 90);
%     end
%     
%     %make sure that the card was cropped correctly and the image is usable
%     if (size(finalImage, 1) / size(finalImage, 2)) > 1.3 && ...
%             (size(finalImage, 1) / size(finalImage, 2)) < 1.5
%         
%         finalImageResized = imresize(finalImage, [400 300]);
%         regionOfInterest = imcrop(finalImageResized, [0 0 50 120]);
%     else
%         disp('Picture is not usable, try taking a new picture in 5 seconds.');
%         figure; imshow(imOrig);
%         figure; imshow(finalImage);
%         %         break
%         pause(5)
%         close all;
%         continue
%     end
%     
%     %processes the ROI to prepare for segmenting the suit and rank
%     segImg = imgaussfilt(regionOfInterest, 2);
%     segImg = imbinarize(segImg);
%     segImg = imcomplement(segImg);
%     
%     stats2 = regionprops(segImg, 'Area', 'BoundingBox');
%     
%     croppedImages = cell(size(stats2, 1), 2);
%     count = 0;
%     
%     %Segments the suit and rank out
%     for j = 1 : length(stats2)
%         thisBB = stats2(j).BoundingBox;
%         croppedImages{j,2} = thisBB(3) / thisBB(4);
%         if count >= 2
%             break
%         elseif stats2(j).Area > 150 && stats2(j).Area < 1000 && ...
%                 croppedImages{j,2} < 1.5 && croppedImages{j,2} > 0.5
%             if count == 1
%                 if thisBB(2) > (size(segImg,1) / 3)
%                     suit = imcrop(regionOfInterest, thisBB);
%                 else
%                     rank = imcrop(regionOfInterest, thisBB);
%                 end
%                 count = count + 1;
%             elseif count == 0
%                 if thisBB(2) > (size(segImg,1) / 3)
%                     suit = imcrop(regionOfInterest, thisBB);
%                 else
%                     rank = imcrop(regionOfInterest, thisBB);
%                 end
%                 count = count + 1;
%             end
%         end
%     end
%     
%     %Classifying Rank and Suit
%     [RankIdx, ~] = predict(categoryClassifier, rank);
%     predictedRank = categoryClassifier.Labels(RankIdx);
%     
%     img = imgaussfilt(suit);
%     img = imbinarize(img);
%     img = edge(img);
%     img_half = imcrop(img, [0 0 size(img,1) size(img,2)/2]);
%     featureVector_half = extractHOGFeatures(img_half , 'CellSize', [1 1]);
%     featureVector = extractHOGFeatures(img , 'CellSize', [1 1]);
%     middle_half = length(featureVector_half(featureVector_half >0.5 & featureVector_half <0.6));
%     middle = length(featureVector(featureVector >0.5 & featureVector <0.6));
%     %top_half = length(featureVector_half(featureVector_half > 0.9));
%     top = length(featureVector(featureVector > 0.9));
%     
%     if middle_half <= 15
%         if top <= 8
%             predictedSuit = 'Diamonds';
%         else
%             predictedSuit = 'Spades';
%         end
%     else
%         if middle <= 63
%             predictedSuit = 'Hearts';
%         else
%             predictedSuit = 'Clubs';
%         end
%     end
%     
%     fig = figure;
%     fig.WindowState = 'fullscreen';
%     subplot(211)
%     imshow(imOrig)
%     subplot(212)
%     %To show the suit and rank
%     %     myFigure = figure;
%     %     set(myFigure,'color',[1 1 1])
%     axis off
%     text(0.5, 0.5, ['Suit: ' predictedSuit 'Rank: ' predictedRank ], ...
%         'FontSize',24, 'horizontalAlignment','center', ...
%         'VerticalAlignment', 'middle')
%     %     if input('Enter 1 to take another picture, or 0 to exit the program. ') == 1
%     %         close all;
%     %         continue
%     %     else
%     % %         clear;
%     %         close all;
%     %         endCase = 0;
%     %     end
%     disp('Press any key on the "Command Window" to continue...');
%     waitforbuttonpress;
%     %close all;
% end

