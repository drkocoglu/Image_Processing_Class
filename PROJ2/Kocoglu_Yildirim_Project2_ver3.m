% Project 2
% Image Processing
% Name: Yildirim Kocoglu

%% IMPORT IMAGES

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

% Initialize a cell array to store all "rotated and cropped" images
rotated_cropped_images = cell(1,nfiles);

%% KERNELS

% Sobel kernel in x-direction shown in class;
hx= [-1,-2,-1;0,0,0;1,2,1];
% Sobel kernel in y-direction shown in class;
hy = [-1,0,1;-2,0,2;-1,0,1];

% Sobel kernel in y-direction (hy) found in literature --> https://en.wikipedia.org/wiki/Sobel_operator (NOT USED!);
hx_literature = [1,0,-1;2,0,-2;1,0,-1];
% Sobel kernel in y-direction (hy) found in literature --> https://en.wikipedia.org/wiki/Sobel_operator (NOT USED!);
hy_literature = [1,2,1;0,0,0;-1,-2,-1];

% A Random Kernel for blurring (smoothing the image) --> Used to remove noise
Blur_kernel = [1/10,1/10;1/10,1/10];

% Laplace operator for taking the 2nd derivative of the image (shown in class)
Laplace_operator = [0,1,0;1,-4,1;0,1,0];

%% ROTATE AND CROP ALL CARD IMAGES


% Rotate the images to their original orientation automatically and crop rotated images to save as a new image

for ii=1:nfiles 
    
    % Get current image
    currentfilename = imageFiles(ii).name;
    Image_path = fullfile(Input_Path, currentfilename);
    currentimage = imread(Image_path);
    
    % Display 'Command' to warn the user to press a key if it is desired to continue the script
    disp('Press any key on the "Command Window" to continue...');
    
    % Binarized Image
    binarized_image = imbinarize(currentimage);
    
    % Change the current image from uint8 type to a double type for convolution operations
    thisimage = double(currentimage);
    
    % Pause for user to observe the rotated card images
    pause;
    
    % Blur Current Image multiple times using the same Blurring Kernel
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
    
    % Save the Blurred current image as a new variable to apply Sobel Kernel in x and y directions
    New_blurred_image = Blurred_image;

    

    % Apply Sobel Kernel in x direction
    Diffx = conv2(New_blurred_image,hx,'same');
    
    % Apply Sobel Kernel in y direction
    Diffy = conv2(New_blurred_image,hy,'same');
    
    % Calculate Magnitude using Sobel Kernel applied images (in both x and y directions)
    Mag_x_y = abs(Diffx) + abs(Diffy);
    
    % Binarize (Threshold) the Magnitude image for edges to show up
    Mag_x_y = imbinarize(Mag_x_y);
    
    % Calculate the Second Derivative of the original image (NOT GOOD RESULTS!)
    Sec_deriv = conv2(currentimage,Laplace_operator,'same');
    
    % LOCALIZE EDGE --> Go down from the middle of the image (:,512) and Find index where = 1 (count number of times 1 is seen downwards before it becomes 0 --> and choose the number in between).
    % OR USE Second derivative code from previous script to localize the edge (Easier)
    % IF POSITIVE ANGLE --> 180-angle+90 = rotation_angle
    % IF NEGATIVE ANGLE --> angle + 90 = abs(resultant_angle) = rotation_angle
    
    % Calculate the orientation image
    orientation_edge = atan2d(Diffy,Diffx);  
    
    %% Find angle to rotate
    % Find the approximate center of the image in the y-direction (according to class lectures --> NOT MATLAB!)
%     Center_point = round(size(currentimage,2)/2);
%     Center_coordinate = [Center_point;1];
%     
%     % Find the pixel coordinates where the first edge is seen when moving in x-direction (according to class lectures --> NOT MATLAB!)
%     Required_points_1 = Mag_x_y(:,Center_point);
%     Five_points_to_right = Center_point + 40;
%     Required_points_2 = Mag_x_y(:,Five_points_to_right);
%     [row1,column1] = find(Required_points_1~=0);
%     [row2,column2] = find(Required_points_2~=0);
%     row1 = row1(row1 > 5);
%     row2 = row2(row2 > 5);
%     row1 = row1(1,1);
%     row2 = row2(1,1);
%     Center_point_edge = [Center_point;row1];
%     Five_pixels_to_the_right_of_center = [Five_points_to_right;row2];
%     
%     %disp(Center_coordinate);
%     %disp(Center_point_edge);
%     %disp(Five_pixels_to_the_right_of_center);
%     
%     % Find angle in radians
%     x0 = Center_point_edge(1,1);
%     y0 = Center_point_edge(2,1);
%     x1 = Center_coordinate(1,1);
%     y1 = Center_coordinate(2,1);
%     x2 = Five_pixels_to_the_right_of_center(1,1);
%     y2 = Five_pixels_to_the_right_of_center(2,1);
%     
%     x10 = x1-x0;
%     y10 = y1-y0;
%     x20 = x2-x0;
%     y20 = y2-y0; 
%     rad_ang = atan2d(x10*y20-x20*y10,x10*x20+y10*y20);
%     %angle = rad2deg(rad_ang);
%     disp(rad_ang);
    
    % Remove Artifacts in the Magnitude picture (possible only by 10 pixels)
    %Mag_x_y = Mag_x_y(10:end-10,10:end-10); % DO NOT Cut edges by 10 pixels to remove artifacts from applying Kernels (instead turn them to 0 values)
    Mag_x_y(1:10,:) = 0;
    Mag_x_y(end-10:end,:) = 0;
    Mag_x_y(:,1:10) = 0;
    Mag_x_y(:,end-10:end) = 0;
    
    % Find minimum and maximum edges (4 corner points) in the x and y directions
    [all_rows,all_columns] = find(Mag_x_y == 1);
    
    min_column_index = find(all_columns == min(all_columns));
    max_column_index = find(all_columns == max(all_columns));
    coordinate1 = [min(all_columns), all_rows(min_column_index(1))];
    miny = coordinate1;
    coordinate2 = [max(all_columns), all_rows(max_column_index(1))];
    maxy = coordinate2;
    
    %disp(miny) % Needed
    %disp(maxy) % Needed
    
    min_row_index = find(all_rows == min(all_rows));
    max_row_index = find(all_rows == max(all_rows));
    coordinate3 = [all_columns(min_row_index(1)),min(all_rows)];
    minx = coordinate3;
    coordinate4 = [all_columns(max_row_index(1)),max(all_rows)];
    max_x = coordinate4;
    
    %disp(minx) % Needed
    %disp(max_x) 
    
    % Flip columns
    miny1 = fliplr(miny);
    minx1 = fliplr(minx);
    maxy1 = fliplr(maxy);
    
    % Calculate miny-minx
    Distance1 = [miny1;minx1];
    d1 = pdist(Distance1,'euclidean');
    % Calculate minx-maxy
    Distance2 = [minx1;maxy1];
    d2 = pdist(Distance2,'euclidean');
    
    disp(d1);
    disp(d2);
    
    
    % Condition for finding the center point
    if d1 > d2
        % Use miny1, minx1
        Center_point1 = round(miny1(1,2) + abs(miny1(1,2)-minx1(1,2))/2);
        Second_point1 = round(Center_point1 + 0.9.*round(abs(Center_point1 - minx1(1,2))));
    elseif d1 < d2
        % Use minx1, maxy1
        Center_point1 = round(minx1(1,2) + abs(minx1(1,2)-maxy1(1,2))/2);
        Second_point1 = round(Center_point1 + 0.9.*round(abs(Center_point1 - maxy1(1,2))));
    end
    
    % Find how many points to the right you can move before the card corner points end...
    
    % Find the approximate center of the image in the y-direction (according to class lectures --> NOT MATLAB!)
    Center_point = round(size(currentimage,2)/2);
    Center_coordinate = [Center_point1;1];
    
    % Find the pixel coordinates where the first edge is seen when moving in x-direction (according to class lectures --> NOT MATLAB!)
    Required_points_1 = Mag_x_y(:,Center_point1);
    Five_points_to_right = Second_point1;
    Required_points_2 = Mag_x_y(:,Five_points_to_right);
    [row1,column1] = find(Required_points_1~=0);
    [row2,column2] = find(Required_points_2~=0);
    row1 = row1(row1 > 5);
    row2 = row2(row2 > 5);
    row1 = row1(1,1);
    row2 = row2(1,1);
    Center_point_edge = [Center_point1;row1];
    Five_pixels_to_the_right_of_center = [Five_points_to_right;row2];
    
    %disp(Center_coordinate);
    %disp(Center_point_edge);
    %disp(Five_pixels_to_the_right_of_center);
    
    % Find angle in radians
    x0 = Center_point_edge(1,1);
    y0 = Center_point_edge(2,1);
    x1 = Center_coordinate(1,1);
    y1 = Center_coordinate(2,1);
    x2 = Five_pixels_to_the_right_of_center(1,1);
    y2 = Five_pixels_to_the_right_of_center(2,1);
    
    x10 = x1-x0;
    y10 = y1-y0;
    x20 = x2-x0;
    y20 = y2-y0; 
    rad_ang = atan2d(x10*y20-x20*y10,x10*x20+y10*y20);
    %angle = rad2deg(rad_ang);
    disp(rad_ang);
    
    disp(Center_point1);
    disp(Second_point1);
%     width_and_height = abs(row_coordinate1 - row_coordinate2);
%     width = width_and_height(1,1);
%     height = width_and_height(1,2);
%     disp(width);
%     disp(height);
%     if height > width
%         disp('Card is in upright position');
%     end
    
    %% Rotate image
    rotated_image = imrotate(currentimage,rad_ang,'bilinear','loose'); % 'crop' --> crops to input size (not a good option --> will loose parts of image including the desired object) or 'loose'--> changes size of image

    
    %% Crop image using detected edges and a rectangle box
    
    rotated_Mag_x_y = imrotate(Mag_x_y,rad_ang,'bilinear','loose'); % Rotate detected edges with the same angle
    
        % Find minimum and maximum edges (4 corner points) in the x and y directions
    [all_rows2,all_columns2] = find(rotated_Mag_x_y == 1);
    
    min_column_index2 = find(all_columns2 == min(all_columns2));
    max_column_index2 = find(all_columns2 == max(all_columns2));
    coordinate11 = [min(all_columns2), all_rows2(min_column_index2(1))];
    miny2 = coordinate11;
    coordinate22 = [max(all_columns2), all_rows2(max_column_index2(1))];
    maxy2 = coordinate22;
    
    %disp(miny) % Needed
    %disp(maxy) % Needed
    
    min_row_index2 = find(all_rows2 == min(all_rows2));
    max_row_index2 = find(all_rows2 == max(all_rows2));
    coordinate33 = [all_columns2(min_row_index2(1)),min(all_rows2)];
    minx2 = coordinate33;
    coordinate44 = [all_columns2(max_row_index2(1)),max(all_rows2)];
    max_x2 = coordinate44;
    
    %disp(minx) % Needed
    %disp(max_x) 
    
    % Flip columns
    miny11 = miny2;
    minx11 = minx2;
    maxy11 = maxy2;
    max_x11 = max_x2;
    
    newx1 = miny11(1,1); % row of miny
    newy1 = max_x11(1,2); % column of max_x
    newx2 = maxy11(1,1); % row of maxy
    newy2 = minx11(1,2); % column of minx
    
    size_of_image_x_direction = size(rotated_Mag_x_y,1);
    
    newx1y1_coords = [newx1,size_of_image_x_direction-newy1];
    newx2y2_coords = [newx2,size_of_image_x_direction-newy2];
    
%     flipped_newx1 = fliplr(newx1);
%     flipped_newx1 = fliplr(newx1);
%     flipped_newx1 = fliplr(newx1);
%     flipped_newx1 = fliplr(newx1);
    
    disp([newx1,newy1]);
    disp([newx2,newy2]);
    
    width1 = newx2y2_coords(1,1) - newx1y1_coords(1,1);
    height1 = newx2y2_coords(1,2) - newx1y1_coords(1,2);
    new_position = [newx1y1_coords(1,1), newy2, width1, height1]; %[newx1y1_coords(1,1),%newy2
    %New_rectangle = rectangle('Position',new_position);
    Cropped_rotated_image = imcrop(rotated_image,new_position);
    %New_rectangle.EdgeColor = 'b';
%     this_rotated_image = double(rotated_image);
%     
%     % Blur Current Image multiple times using the same Blurring Kernel
% %     Blurred_image2 = this_rotated_image;
% %     Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %  	Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %  	Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %  	Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %  	Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %     Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %     Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %  	Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
% %     Blurred_image2 = conv2(Blurred_image2,Blur_kernel,'same');
%     binarized_rotated_image = imbinarize(this_rotated_image);
%     % Apply Sobel Kernel in x direction
%     Diffx2 = conv2(binarized_rotated_image,hx,'same');
%     
%     % Apply Sobel Kernel in y direction
%     Diffy2 = conv2(binarized_rotated_image,hy,'same');
%     
%     % Calculate Magnitude using Sobel Kernel applied images (in both x and y directions)
%     Mag_x_y2 = abs(Diffx2) + abs(Diffy2);
%     
%     % Binarize (Threshold) the Magnitude image for edges to show up
%     Mag_x_y2 = imbinarize(Mag_x_y2);
%     
%     Mag_x_y2(1:10,:) = 0;
%     Mag_x_y2(end-10:end,:) = 0;
%     Mag_x_y2(:,1:10) = 0;
%     Mag_x_y2(:,end-10:end) = 0;
    
    %% Display Original and Rotated Images
    
    figure(1)
    subplot(1,2,1) 
    imshow(currentimage);
    title('Original image');
    subplot(1,2,2)
    imshow(Cropped_rotated_image);
    title('Rotated + Cropped image');
%% Show Diffx and Diffy Images
    figure(2)
    subplot(1,2,1)
    imshow(Diffx);
    title('DIFF X');
    subplot(1,2,2)
    imshow(Diffy);
    title('DIFF Y');
    
    % Display Orientation and Magnitude Images
    figure(3)
    subplot(1,2,1)
    imshow(orientation_edge);
    title('ORIENTATION ANGLE');
    subplot(1,2,2)
    imshow(Mag_x_y);
    title('MAGNITUDE');
    
    % Display Second Derivative Image
    figure(4)
    subplot(1,2,1)
    imshow(Sec_deriv);
    title('SECOND DERIVATIVE');
    subplot(1,2,2)
    imshow(rotated_Mag_x_y);
    title('MAGNITUDE OF ROTATED IMAGE');

end
