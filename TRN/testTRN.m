%{
Senior Design
Team Shamrock
Hannah Shafferman
11/19/20

testTRN.m - first Terrain Relative Navigation (TRN) implementation attempt

%}
clear all
close all

% read in medium Bennu surface map, serving as the global map
bennuMed = imread('Osprey-Recon-C-Mosaic-300x179.png');
%testimg = imread('grids_of_pictures_memory_game_colors.jpg',);
numRows = size(bennuMed, 1);
numCols = size(bennuMed, 2);

% randomly generate the local map, pick a piece of the global map
% made the local image 41x41 - can change this in the future
% (n,m) top left corner
n = randi(round(numRows/2));
m = randi(round(numCols/2));
local = bennuMed(n:n+40,m:m+40);

% show local map over global map
figure
imshow(bennuMed)
rectangle('position',[m n 40 40],'edgecolor','r','LineWidth',2)
hold on
% figure 
% imshow(local)

% take the fourier transform of both the local map and the global map
local_f = fftshift(fft2(local,numRows,numCols));
global_f = fftshift(fft2(bennuMed,numRows,numCols));

% correlate the images by multiplying element by element of the FFT of the
% global map by the complex conjugate of the FFT of the local map 

for i = 1:numRows
    for j = 1:numCols
        imgCorr(i,j) = ifft2(global_f(i,j) * conj(local_f(i,j)));
    end
end

% determine the best match by finding the maximum correlation 
bestMatch = max(imgCorr,[],'all');
[maxN,maxM] = find(imgCorr == bestMatch);

% plot using a yellow rectangle the position determined by the correlation
rectangle('position',[maxM maxN 40 40],'edgecolor','y','LineWidth',2)
