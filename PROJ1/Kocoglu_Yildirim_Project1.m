% Assignment #1 
% Name: Yildirim Kocoglu
% Image Processing

clear;
clc;
close all;

% Specify the path to images (User input)
Path = input('Please enter the path for the images: ','s'); % C:\Users\ykocoglu\Desktop\Image Processing\HW1\ImageSet1;
fprintf('\n');

% Specify the image type (default = .JPG --> Change if needed)
Image_type = ('*.JPG');

% Get the names of the images within the given path
filePattern = fullfile(Path, Image_type);
imageFiles = dir(filePattern);

% Get the number of image files in the folder
nfiles = length(imageFiles);

% Initialize a cell array to store all images
images = cell(1,nfiles);

a = []; % initialize annotation array

% Go through each image within the given path and plot/caption each image with 'DAY' or 'NIGHT' based on a specific condition
for ii=1:nfiles %nfiles
    currentfilename = imageFiles(ii).name;
    new_path = fullfile(Path, currentfilename);
    currentimage = imread(new_path);
    disp('Press any key on the "Command Window" to continue...');
    
    % Convert RGB image to HSV image and split the channels into Hue (H), Saturation (S), and Value (V)
    HSV_image = rgb2hsv(currentimage);
    HSV_image = 255.*HSV_image; % Scale HSV (values between 0-1) to RGB by multiplying with 255 (good for plotting the images in HSV and observing the difference in between H,S,V channels statistics)
    HSV_uint8 = uint8(HSV_image);
    [H,S,V] = imsplit(HSV_uint8);
    
    % Calculate mean of Hue and Saturation channels to determine 'DAY' vs 'NIGHT' 
    Combine_H_S = H+S;
    Mean_H_S_channels = mean(mean(Combine_H_S));
    
    % Choose a Threshold value for 'DAY' vs 'NIGHT' images
    Threshold = 5; 
    
    % Condition to decide if the image is 'DAY' or 'NIGHT' image
    if Mean_H_S_channels < Threshold
        caption = 'NIGHT';
    elseif Mean_H_S_channels >= Threshold
        caption = 'DAY';
    end
    
    
    % Pause before plotting the image and the caption
    pause;
    
    % Plot both RGB and HSV images with the caption 'DAY' or 'NIGHT'
    figure(1)
    
    subplot(1,2,1) 
    imshow(currentimage);
    title('RGB IMAGE')
    
    subplot(1,2,2) 
    imshow(HSV_uint8);
    title('HSV IMAGE')
    
    
    dim = [0.365 0.35 .3 .3]; % Position of Caption ('DAY' or 'NIGHT')
    delete(a);
    a = annotation('textbox',dim,'String',caption,'FitBoxToText','on','Color','r','FontSize',25, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle','LineWidth',3,'BackgroundColor','y');
    fprintf('Mean of Hue and Saturation Channels is: %5.3f \n\n', Mean_H_S_channels);
    
    % Store images
    images{ii} = currentimage;
end

fprintf('\n\nEnd of Script!\n');