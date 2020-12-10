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
%bennuMed = imread('Osprey-Recon-C-Mosaic-300x179.png');
bennuMed = imread('buried_boulder.png');
numRows = size(bennuMed, 1);
numCols = size(bennuMed, 2);

% randomly generate the local map, pick a piece of the global map
% made the local image 41x41 - can change this in the future
% (n,m) top left corner
n = randi(numRows-40);
m = randi(numCols-40);
local = bennuMed(n:n+40,m:m+40);

% show local map over global map
figure
imshow(bennuMed)
rectangle('position',[m n 40 40],'edgecolor','r','LineWidth',2)
hold on
title('Global Map Showing Randomly Selected Local Map in Red')
hold off
% figure 
% imshow(local)

for i = 1:numRows-40
    for j = 1:numCols - 40
        globalSect = bennuMed(i:i+40,j:j+40);
        tempDiff = globalSect - local;
        locationDiff(i,j) = sum(tempDiff, 'all');
        clear globalSect
    end
end
[bestN, bestM] = find(locationDiff == 0);

figure
imshow(bennuMed)
title('Global Map with Gray Scale Image Selection In Yellow')
hold on
for dim = 1:length(bestM)
    rectangle('position',[bestM(dim) bestN(dim) 40 40],'edgecolor','y','LineWidth',2)
    hold on
end
hold off

for i = 1:length(bestN)
    for j = 1:length(bestM)
        globalSSIM = bennuMed(bestN(i):bestN(i)+40,bestM(j):bestM(j)+40);
        [ssimval(i,j),~] = ssim(local,globalSSIM);
    end
end
[ssimN, ssimM] = find(ssimval == 1);

figure
imshow(bennuMed)
title('Global Map with SSIM Selection In Green')
hold on
for dim = 1:length(ssimN)
    rectangle('position',[bestM(ssimM(dim)) bestN(ssimN(dim)) 40 40],'edgecolor','g','LineWidth',2)
    hold on
end
hold off

% % take the fourier transform of both the local map and the global map
% local_f = fftshift(fft2(local,numRows,numCols));
% global_f = fftshift(fft2(bennuMed,numRows,numCols));
% 
% % correlate the images by multiplying element by element of the FFT of the
% % global map by the complex conjugate of the FFT of the local map 
% for i = 1:numRows-40
%     for j = 1:numCols-40
%         % FIX THIS - want to try correlating each point and somehow saving
%         % the best correlation at every point
%         imgCorr(i,j) = sum(sum(ifft2(global_f(i:i+40,j:j+40) .* conj(local_f(i:i+40,j:j+40)))));
%     end
% end
% 
% % determine the best match by finding the maximum correlation 
% bestMatch = max(imgCorr,[],'all');
% [maxN,maxM] = find(imgCorr == bestMatch);

% plot using a yellow rectangle the position determined by the correlation

