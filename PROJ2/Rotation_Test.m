%% Rotation Test

% Test different angle images to see how they rotate

%% Import images to rotate
clear;
clc;
close all;

% Specify the path to images (User input)
Input_Path = input('Please enter the path for the images: ','s'); % C:\Users\ykocoglu\Desktop\Image Processing\HW2\Test_images;
fprintf('\n');

% Specify the image type (default = .JPG --> Change if needed)
Image_type = ('*.png');

% Get the names of the images within the given path
filePattern = fullfile(Input_Path, Image_type);
imageFiles = dir(filePattern);

% Get the number of image files in the folder
nfiles = length(imageFiles);

% rotated_card = zeros(768,1024);
% rotated_card(192:442,384:759) = 255;
% rotated_card(192+1:442-1,384+1:759-1) = 0;
% rotated_card = uint8(rotated_card);
% %img = drawrectangle(img, [120, 200], [120, 200]);
% figure(1)
% imshow(rotated_card);
%
% aligned_card = zeros(768,1024);
% aligned_card(192:567,384:634) = 255;
% aligned_card(192+1:567-1,384+1:634-1) = 0;
% aligned_card = uint8(aligned_card);
% % img(384+1:634+1,512+1:887+1) = 0;
% %img = drawrectangle(img, [120, 200], [120, 200]);
% figure(2)
% imshow(aligned_card);
%
% %Save images for further testing
% type = '.png';
% Image_name = 'Test_';
% Image_number = num2str(5);
% Full_image_name = strcat(Image_name,Image_number,type);
% imwrite(aligned_card,Full_image_name)


% rotated_card = rectangle('Position',[384 512 250 375],'Curvature',0.2);
% aligned_card = rectangle('Position',[384 512 375 250],'Curvature',0.2);


% figure
% axis equal
% subplot(1,2,1)
% aligned_card;
% % axis equal
% title('Aligned Card');
% subplot(1,2,2)
% rotated_card;
% title('Rotated Card');
% axis equal

%% Rotate

for ii = 1:nfiles
    % Find minimum and maximum edges (4 corner points) in the x and y directions
    
    % Get current image
    currentfilename = imageFiles(ii).name;
    Image_path = fullfile(Input_Path, currentfilename);
    Sec_deriv = imread(Image_path);
    Sec_deriv = double(Sec_deriv);
    
    % Display 'Command' to warn the user to press a key if it is desired to continue the script
    disp('Press any key on the "Command Window" to continue...');
    pause;
    
    [all_rows,all_columns] = find(Sec_deriv == 255);
    
    min_column_index = find(all_columns == min(all_columns));
    max_column_index = find(all_columns == max(all_columns));
    coordinate1 = [min(all_columns), all_rows(min_column_index(1))];
    miny = coordinate1;
    coordinate2 = [max(all_columns), all_rows(max_column_index(1))];
    maxy = coordinate2;
    
    %     disp(miny) % Needed
    %     disp(maxy) % Needed
    
    min_row_index = find(all_rows == min(all_rows));
    max_row_index = find(all_rows == max(all_rows));
    coordinate3 = [all_columns(min_row_index(1)),min(all_rows)];
    minx = coordinate3;
    coordinate4 = [all_columns(max_row_index(1)),max(all_rows)];
    max_x = coordinate4;
    %
    %     disp(minx) % Needed
    %     disp(max_x)
    %
    % If miny - minx (Condition for rotating or not)
    CONDITIONX = miny - minx;
    disp(CONDITIONX)
    
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
    
    %     disp(d1);
    %     disp(d2);
    
    %% Another if statement checking if miny minx is exactly aligned meaning 0 degress
    % Condition for finding the center point
    if d1 > d2
        % Use miny1, minx1
        Center_point1 = round(miny1(1,2) + abs(miny1(1,2)-minx1(1,2))/2);
        Second_point1 = round(Center_point1 + 0.9.*round(abs(Center_point1 - minx1(1,2))));
        
        Center_coordinate = [Center_point1;1];
        
        % Find the pixel coordinates where the first edge is seen when moving in x-direction (according to class lectures --> NOT MATLAB!)
        Required_points_1 = Sec_deriv(:,Center_point1);
        Five_points_to_right = Second_point1;
        Required_points_2 = Sec_deriv(:,Five_points_to_right);
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
        
    elseif d1 < d2
        % Use minx1, maxy1
        Center_point1 = round(minx1(1,2) + abs(minx1(1,2)-maxy1(1,2))/2);
        Second_point1 = round(Center_point1 + 0.9.*round(abs(Center_point1 - maxy1(1,2))));
        
        Center_coordinate = [Center_point1;1];
        
        % Find the pixel coordinates where the first edge is seen when moving in x-direction (according to class lectures --> NOT MATLAB!)
        Required_points_1 = Sec_deriv(:,Center_point1);
        Five_points_to_right = Second_point1;
        Required_points_2 = Sec_deriv(:,Five_points_to_right);
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
        
        %     elseif d1 == 0
        %         Center_point1 = round(miny1(1,2) + abs(miny1(1,2)-minx1(1,2))/2);
        %         Second_point1 = round(Center_point1 + 0.9.*round(abs(Center_point1 - minx1(1,2))));
        %
        %         Center_coordinate = [Center_point1;1];
        %
        %     % Find the pixel coordinates where the first edge is seen when moving in x-direction (according to class lectures --> NOT MATLAB!)
        %     Required_points_1 = Sec_deriv(:,Center_point1);
        %     Five_points_to_right = Second_point1;
        %     Required_points_2 = Sec_deriv(:,Five_points_to_right);
        %     [row1,column1] = find(Required_points_1~=0);
        %     [row2,column2] = find(Required_points_2~=0);
        %     row1 = row1(row1 > 5);
        %     row2 = row2(row2 > 5);
        %     row1 = row1(1,1);
        %     row2 = row2(1,1);
        %     Center_point_edge = [Center_point1;row1];
        %     Five_pixels_to_the_right_of_center = [Five_points_to_right;row2];
        %
        %     %disp(Center_coordinate);
        %     %disp(Center_point_edge);
        %     %disp(Five_pixels_to_the_right_of_center);
        %
        % % Find angle in radians
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
    end
    
    % Find how many points to the right you can move before the card corner points end...
    
    % Find the approximate center of the image in the y-direction (according to class lectures --> NOT MATLAB!)
    %Center_point = round(size(Sec_deriv,2)/2);
    %     Center_coordinate = [Center_point1;1];
    
    %     % Find the pixel coordinates where the first edge is seen when moving in x-direction (according to class lectures --> NOT MATLAB!)
    %     Required_points_1 = Sec_deriv(:,Center_point1);
    %     Five_points_to_right = Second_point1;
    %     Required_points_2 = Sec_deriv(:,Five_points_to_right);
    %     [row1,column1] = find(Required_points_1~=0);
    %     [row2,column2] = find(Required_points_2~=0);
    %     row1 = row1(row1 > 5);
    %     row2 = row2(row2 > 5);
    %     row1 = row1(1,1);
    %     row2 = row2(1,1);
    %     Center_point_edge = [Center_point1;row1];
    %     Five_pixels_to_the_right_of_center = [Five_points_to_right;row2];
    %
    %     %disp(Center_coordinate);
    %     %disp(Center_point_edge);
    %     %disp(Five_pixels_to_the_right_of_center);
    %
    % % Find angle in radians
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
    
    rotated_image = imrotate(Sec_deriv,rad_ang,'bilinear','loose');
    
    %% Crop image
    % Find minimum and maximum edges (4 corner points) in the x and y directions to start cropping
    
    new_rotated_image = 255.*imbinarize(rotated_image);
    %new_rotated_image = 255;
    [all_rows2,all_columns2] = find(new_rotated_image == 255);
    
    min_column_index2 = find(all_columns2 == min(all_columns2));
    max_column_index2 = find(all_columns2 == max(all_columns2));
    coordinate11 = [min(all_columns2), all_rows2(min_column_index2(1))];
    miny2 = coordinate11;
    coordinate22 = [max(all_columns2), all_rows2(max_column_index2(1))];
    maxy2 = coordinate22;
    min_row_index2 = find(all_rows2 == min(all_rows2));
    max_row_index2 = find(all_rows2 == max(all_rows2));
    coordinate33 = [all_columns2(min_row_index2(1)),min(all_rows2)];
    minx2 = coordinate33;
    coordinate44 = [all_columns2(max_row_index2(1)),max(all_rows2)];
    max_x2 = coordinate44;
    
    % Flip columns
    miny11 = miny2;
    minx11 = minx2;
    maxy11 = maxy2;
    max_x11 = max_x2;
    
    newx1 = miny11(1,1); % row of miny
    newy1 = max_x11(1,2); % column of max_x
    newx2 = maxy11(1,1); % row of maxy
    newy2 = minx11(1,2); % column of minx
    
    size_of_image_x_direction = size(new_rotated_image,1);
    
    newx1y1_coords = [newx1,size_of_image_x_direction-newy1];
    newx2y2_coords = [newx2,size_of_image_x_direction-newy2];
    
    width1 = newx2y2_coords(1,1) - newx1y1_coords(1,1);
    height1 = newx2y2_coords(1,2) - newx1y1_coords(1,2);
    
    % Condition for cropping (rotate before cropping if height < width --> applies in perfectly aligned images)
    if height1 > width1
        new_rotation_angle = 0;
        fprintf('\nNew rotation angle is: %0.3f\n\n', new_rotation_angle);
        new_position = [newx1y1_coords(1,1)-5, newy2-5, width1+10, height1+10];
    elseif height1 < width1
        new_rotation_angle = 90;
        fprintf('\nNew rotation angle is: %0.3f\n\n', new_rotation_angle);
        rotated_image = imrotate(rotated_image,new_rotation_angle,'bilinear','loose');
        %new_rotated_image = 255;
        new_rotated_image = 255.*imbinarize(rotated_image);
        [all_rows2,all_columns2] = find(new_rotated_image == 255);
        
        min_column_index2 = find(all_columns2 == min(all_columns2));
        max_column_index2 = find(all_columns2 == max(all_columns2));
        coordinate11 = [min(all_columns2), all_rows2(min_column_index2(1))];
        miny2 = coordinate11;
        coordinate22 = [max(all_columns2), all_rows2(max_column_index2(1))];
        maxy2 = coordinate22;
        min_row_index2 = find(all_rows2 == min(all_rows2));
        max_row_index2 = find(all_rows2 == max(all_rows2));
        coordinate33 = [all_columns2(min_row_index2(1)),min(all_rows2)];
        minx2 = coordinate33;
        coordinate44 = [all_columns2(max_row_index2(1)),max(all_rows2)];
        max_x2 = coordinate44;
        
        % Flip columns
        miny11 = miny2;
        minx11 = minx2;
        maxy11 = maxy2;
        max_x11 = max_x2;
        
        newx1 = miny11(1,1); % row of miny
        newy1 = max_x11(1,2); % column of max_x
        newx2 = maxy11(1,1); % row of maxy
        newy2 = minx11(1,2); % column of minx
        
        size_of_image_x_direction = size(new_rotated_image,1);
        
        newx1y1_coords = [newx1,size_of_image_x_direction-newy1];
        newx2y2_coords = [newx2,size_of_image_x_direction-newy2];
        
        width1 = newx2y2_coords(1,1) - newx1y1_coords(1,1);
        height1 = newx2y2_coords(1,2) - newx1y1_coords(1,2);
        new_position = [newx1y1_coords(1,1)-5, newy2-5, width1+10, height1+10];
    end
    
    %new_position = [newx1y1_coords(1,1)-5, newy2-5, width1+10, height1+10];
    Cropped_rotated_image = imcrop(rotated_image,new_position);
    %% Display rotated image
    figure(1)
    subplot(1,2,1)
    imshow(Sec_deriv);
    title('Original image');
    subplot(1,2,2)
    imshow(rotated_image);
    title('Rotated image');
    
    figure(2)
    subplot(1,2,1)
    imshow(Sec_deriv);
    title('Original image');
    subplot(1,2,2)
    imshow(Cropped_rotated_image);
    title('Cropped + Rotated image');
    
end