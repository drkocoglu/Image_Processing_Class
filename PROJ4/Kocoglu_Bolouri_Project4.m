% Image Processing
% Project 4
% Group members: Yildirim Kocoglu, Farshad Bolouri

clear;
clc;
close all;

%% Problem 1

Img = imread('C:\Users\ykocoglu\Desktop\Image Processing\HW4\Proj4.tif');
Img = 1.*Img;
figure(3)
imshow(0.25.*Img);

FT_img = fft2(Img);
Visual_G = log(1+abs(fftshift(FT_img)));

figure(1)
imagesc(Visual_G);

figure(2)
[X,Y] = meshgrid(1:545,1:408);
surf(X,Y,Visual_G);


%% Design Butterworth filter (lowpass)

[M, N] = size(Img);
  
% Getting Fourier Transform of the input_image
% using MATLAB library function fft2 (2D fast fourier transform)
%FT_img = fft2(double(input_image));
  
% Assign the order value
n = 2; % one can change this value accordingly % n=0.3 0.1
  
% Assign Cut-off Frequency
D0 = 0.05; % one can change this value accordingly D0 = 7 0.05
  
% Designing filter
u = 0:(M-1);
v = 0:(N-1);
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;
  
% MATLAB library function meshgrid(v, u) returns 
% 2D grid which contains the coordinates of vectors 
% v and u. Matrix V with each row is a copy of v 
% and matrix U with each column is a copy of u 
[V, U] = meshgrid(v, u);
  
% Calculating Euclidean Distance
D = sqrt(U.^2 + V.^2);
  
% determining the filtering mask
H = 1./(1 + (D./D0).^(2*n));

% Designing filter
u1 = 0:(191*2-1); %191
v1 = 0:(266*2-1); % 266
idx1 = find(u1 > 191);
u1(idx1) = u1(idx1) -(191*2);
idy1 = find(v1 > 266);
v1(idy1) = v1(idy1) - (266*2);
  
% MATLAB library function meshgrid(v, u) returns 
% 2D grid which contains the coordinates of vectors 
% v and u. Matrix V with each row is a copy of v 
% and matrix U with each column is a copy of u 
[V1, U1] = meshgrid(v1, u1);
  
% Calculating Euclidean Distance
D1 = sqrt(U1.^2 + V1.^2);
  
% determining the filtering mask
H1 = 1./(1 + (D1./D0).^(2*n));

%H_final = H + H1;
%figure(3)


  
% Convolution between the Fourier Transformed 
% image and the mask
G = H.*FT_img;

% G(log(1+abs(G))<11) = 0.8.*G(log(1+abs(G))<11); % Patterns start showing up!
% G(log(1+abs(G)) > 11 & log(1+abs(G)) < 16) = 100.*G(log(1+abs(G)) > 11 & log(1+abs(G)) < 16);

G(log(1+abs(G))<7) = 0.01.*G(log(1+abs(G))<7); % Patterns start showing up!
%G(log(1+abs(G)) > 11 & log(1+abs(G)) < 16) = 100.*G(log(1+abs(G)) > 11 & log(1+abs(G)) < 16);

  
% Getting the resultant image by Inverse Fourier Transform 
% of the convoluted image using MATLAB library function  
% ifft2 (2D inverse fast fourier transform)   
output_image = real(ifft2(double(G))); 
% output_image = (output_image-double(Img));
% Displaying Input Image and Output Image
figure(2)
%[X,Y] = meshgrid(1:545,1:408);
subplot(2, 1, 1), imshow(output_image,[]); 
subplot(2, 1, 2), imagesc(log(1+abs(fftshift(G))));%surf(X,Y,log(1+abs(fftshift(G))));

figure(1)
[X,Y] = meshgrid(1:545,1:408);
surf(X,Y,log(1+abs(fftshift(H))));
%imagesc(log(1+abs(fftshift(H))))

% imagesc(H);





%% Design Butterworth filter (highpass)

% [M, N] = size(Img);
%   
% % Getting Fourier Transform of the input_image
% % using MATLAB library function fft2 (2D fast fourier transform)
% %FT_img = fft2(double(input_image));
%   
% % Assign the order value
% n = 2; % one can change this value accordingly % n=2
%   
% % Assign Cut-off Frequency
% D0 = 5; % one can change this value accordingly % D0 = 5-10
%   
% % Designing filter
% u = 0:(M-1);
% v = 0:(N-1);
% idx = find(u > M/2);
% u(idx) = u(idx) - M;
% idy = find(v > N/2);
% v(idy) = v(idy) - N;
%   
% % MATLAB library function meshgrid(v, u) returns 
% % 2D grid which contains the coordinates of vectors 
% % v and u. Matrix V with each row is a copy of v 
% % and matrix U with each column is a copy of u 
% [V, U] = meshgrid(v, u);
%   
% % Calculating Euclidean Distance
% D = sqrt(U.^2 + V.^2);
%   
% % determining the filtering mask
% H = 1./(1 + (D0./D).^(2*n));
%   
% % Convolution between the Fourier Transformed 
% % image and the mask
% G = H.*FT_img;
%   
% % Getting the resultant image by Inverse Fourier Transform 
% % of the convoluted image using MATLAB library function  
% % ifft2 (2D inverse fast fourier transform)   
% output_image = real(ifft2(double(G)));
% % output_image = abs(output_image);
% % output_image = uint8(255 * mat2gray(output_image));    
% % Displaying Input Image and Output Image 
% subplot(2, 1, 1), imshow(Img), 
% subplot(2, 1, 2), imshow(output_image, [ ]);
% 
% figure(3)
% [X,Y] = meshgrid(1:545,1:408);
% surf(X,Y,log(1+abs(fftshift(G))));
