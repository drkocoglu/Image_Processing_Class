% Project 2
% Image Processing
% Name: Yildirim Kocoglu

clear;
clc;
close all;

% Specify the path to images (User input)
Input_Path = input('Please enter the path for the images: ','s'); % C:\Users\ykocoglu\Desktop\Image Processing\HW2;
fprintf('\n');

% Specify the image type (default = .JPG --> Change if needed)
Image_type = ('*.tif');

% Get the names of the images within the given path
filePattern = fullfile(Input_Path, Image_type);
imageFiles = dir(filePattern);

% Get the number of image files in the folder
nfiles = length(imageFiles);

% Initialize a cell array to store all images
images = cell(1,nfiles);

% Sobel operator
% Sy = [-1,0,1;-2,0,2;-1,0,1];
% Sx = [-1,-2,-1;0,0,0;1,2,1];
hx= [-1,-2,-1;0,0,0;1,2,1];
hy = [-1,0,1;-2,0,2;-1,0,1];
%Blur_image = [1/25,1/25,1/25,1/25,1/25,1/25;1/25,1/25,1/25,1/25,1/25,1/25;1/25,1/25,1/25,1/25,1/25,1/25];
%Blur_image = [2,2,2,2,2,2;2,2,2,2,2,2;2,2,2,2,2,2];
Blur_kernel = [1/10,1/10;1/10,1/10];
Laplace_operator = [0,1,0;1,-4,1;0,1,0]; % For 2nd derivative

for ii=1:nfiles  % Rotate the images to their original orientation automatically. 
    
    currentfilename = imageFiles(ii).name;
    new_path = fullfile(Input_Path, currentfilename);
    currentimage = imread(new_path);
    %currentimage = imbinarize(currentimage);
    disp('Press any key on the "Command Window" to continue...');
    
    %currentimage(currentimage < 140) = 0;
    binarized_image = imbinarize(currentimage);
    
    thisimage = double(currentimage);
    pause;
    
    % Blurred Image
    Blurred_image = thisimage;
    Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
    Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
    Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
    Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
    
    figure(11)
    imagesc(Blurred_image);
    colormap gray
    
    New_blurred_image = Blurred_image;
    %New_blurred_image (New_blurred_image == 2)  = 255;
    %New_blurred_image (New_blurred_image == 1)  = 128;
    

    
    Diffx = conv2(New_blurred_image,hx,'same');
%     Diffx = abs(Diffx);
%     Diffx(Diffx < 0.001) = 0;
%     Diffx = double(imbinarize(Diffx));
    %Diffx(Diffx >= 0) = 255;
    
%     Diffx = uint8(conv2(Diffx,hx,'same'));
%     Diffx = uint8(conv2(Diffx,hx,'same'));
%     Diffx = uint8(conv2(Diffx,hx,'same'));
    %Diffx = double(Diffx);
    
    figure(12)
    imagesc(Diffx);
    colormap gray
    
    Diffy = conv2(New_blurred_image,hy,'same');
%     Diffy = abs(Diffy);
%     Diffy(Diffy < 0.009) = 0;
%     Diffy(Diffy > 0.009) = 255;
%     Diffy = double(imbinarize(Diffy));
    %Diffy(Diffy >= 0) = 255;
    figure(13)
    imagesc(Diffy);
    colormap gray
%     Diffy = uint8(conv2(Diffy,hx,'same'));
%     Diffy = uint8(conv2(Diffy,hx,'same'));
%     Diffy = uint8(conv2(Diffy,hx,'same'));
    %Diffy = double(Diffy);
    
    Mag_x_y = abs(Diffx) + abs(Diffy);
    Mag_x_y = imbinarize(Mag_x_y);
    Sec_deriv = conv2(currentimage,Laplace_operator,'same');
    
    % LOCALIZE EDGE --> Go down from the middle of the image (:,512) and Find index where = 1 (count number of times 1 is seen downwards before it becomes 0 --> and choose the number in between).
    % OR USE Second derivative code from previous script to localize the edge (Easier)
    % IF POSITIVE ANGLE --> 180-angle+90 = rotation_angle
    % IF NEGATIVE ANGLE --> angle + 90 = abs(resultant_angle) = rotation_angle
    
    %Sec_deriv = double(Sec_deriv);
    
%     New_image = 255.*ones(size(Diffx,1),size(Diffx,2));
%     New_image(1:590,1:512) = 0;
%     New_image_x = zeros(size(Diffx,1),size(Diffx,2));
%     New_image_x(384,:) = 255;
%     figure(10)
%     imshow(New_image)
    
    
    orientation_edge = atan2d(Diffy,Diffx);
    %orientation_edge = orientation_edge.*(180/pi);
    orientation_angle = orientation_edge;
    orientation_angle = orientation_angle(:);
%     orientation_angle(orientation_angle ==90) = [];
%     orientation_angle(orientation_angle ==0) = [];
%     
    
    % Find angle to rotate
    Maximum_angle = max(max(orientation_edge));
    Most_Frequent_angle = mode(orientation_angle,'all');
    
    % Rotate image
    
    
    figure(1)
    subplot(1,2,1) 
    imshow(currentimage);
    title('Original image');
    subplot(1,2,2) 
    rotated_image = imrotate(currentimage,97,'bilinear','loose'); % 'crop' --> crops to input size (not a good option) or 'loose'--> changes size of image
    imshow(rotated_image);
    title('Rotated image');
    
    figure(2)
    subplot(1,2,1)
    imshow(Diffx);
    title('DIFF X');
    subplot(1,2,2)
    imshow(Diffy);
    title('DIFF Y');
    
    figure(3)
    subplot(1,2,1)
    imshow(orientation_edge);
    title('ORIENTATION ANGLE');
    subplot(1,2,2)
    imshow(Mag_x_y);
    title('MAGNITUDE');
    
    
    figure(4)
    subplot(1,2,1)
    imshow(Sec_deriv);
    title('SECOND DERIVATIVE');
%     subplot(1,2,2)
%     imhist(uint8(orientation_edge));
%     title('Histogram of Orientation')
end
