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
Sy= [-1,0,1;-2,0,2;-1,0,1];
Sx = [-1,-2,-1;0,0,0;1,2,1];
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
    
    pause;
    
    % Blurred Image
    Blurred_image = currentimage;
    Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
%   Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
% 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
% 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
% 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
    
    New_blurred_image = Blurred_image;
%     This_blurred_image = Blurred_image;
%     This_blurred_image(This_blurred_image ==2) = 255;
%     This_blurred_image(This_blurred_image ==1) = 0;
%     New_blurred_image (New_blurred_image == 2)  = 255;
%     New_blurred_image (New_blurred_image == 1)  = 0;
    %New_blurred_image = 255.*imbinarize(New_blurred_image);
    % Added later
    %New_blurred_image = double(New_blurred_image);
    
    % Edge detection (convolution - differencing)
    Diffx = conv2(New_blurred_image,Sx,'same');
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%         Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
%     Diffx = uint8(conv2(Diffx,Blurring_kernel,'same'));
%     Diffx = uint8(conv2(Diffx,Blurring_kernel,'same'));
%     Diffx = uint8(conv2(Diffx,Blurring_kernel,'same'));
%     Diffx = uint8(conv2(Diffx,Blurring_kernel,'same'));
%     Diffx = uint8(conv2(Diffx,Blurring_kernel,'same'));
%     Diffx = uint8(conv2(Diffx,Sx,'same'));
    %Diffx = Blur_Sobel(Blurred_image, Sx, 20);
    %Diffx = double(Diffx);
    
    Diffy = conv2(New_blurred_image,Sy,'same');
    %Diffy = double(Diffy);
    
    Mag_x_y = abs(Diffx) + abs(Diffy);
    Mag_x_y = imbinarize(Mag_x_y);
    
    New_Blurry_image = currentimage;
    New_Blurry_image = uint8(conv2(New_Blurry_image,Blur_kernel,'same'));
    New_Blurry_image = uint8(conv2(New_Blurry_image,Blur_kernel,'same'));
    New_Blurry_image = uint8(conv2(New_Blurry_image,Blur_kernel,'same'));
    New_Blurry_image = uint8(conv2(New_Blurry_image,Blur_kernel,'same'));
    New_Blurry_image = uint8(conv2(New_Blurry_image,Blur_kernel,'same'));
%     New_Blurry_image(New_Blurry_image ==2) = 255;
%     New_Blurry_image(New_Blurry_image ==1) = 0;
%   Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
% 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
% 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
% 	Blurred_image = conv2(Blurred_image,Blur_kernel,'same');
    
    New_blurred_image = Blurred_image;
    
    Sec_deriv = uint8(conv2(New_Blurry_image,Laplace_operator,'same'));
    Sec_deriv = double(Sec_deriv);
    Sec_deriv(Sec_deriv > 0) = 1;
    %Sec_deriv(Sec_deriv < 0) = 0;
    [rows,columns] = find(Sec_deriv < 0);
    disp([rows,columns]);
    
    orientation_edge = atan2d(Diffy,Diffx);
%     orientation_edge = orientation_edge.*(180/pi);
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
    imshow(New_blurred_image);
    title('Original image');
    subplot(1,2,2) 
    rotated_image = imrotate(currentimage,45,'bilinear','loose'); % 'crop' --> crops to input size (not a good option) or 'loose'--> changes size of image
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
    subplot(1,2,2)
    imhist(uint8(orientation_edge));
    title('Histogram of Orientation')
   
    
    %disp(size(rotated_image));
end

function Output_image = Blur_Sobel(Input_image, Sobel_kernel, iterations)

% Output_image = conv2(Input_image,Blur_kernel,'same');
% Output_image = conv2(Output_image,Sobel_kernel,'same');

Output_image = Input_image;

for i = 1:iterations
    %Output_image = conv2(Output_image,Blur_kernel,'same');
    Output_image = conv2(Output_image,Sobel_kernel,'same');
end

end