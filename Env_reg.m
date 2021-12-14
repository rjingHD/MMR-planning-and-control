% function obs= FindObs(image)
clear all 
clc
close all

%% 

image = imread('sample.PNG');
dim1 = 500; dim2 = 500;

imgGray = rgb2gray(image);

figure
imshowpair(image,imgGray,"montage");
title("color vs gray");
imgGray = imresize(imgGray,[dim1, dim2]); 

% adjust to use darker and brighter pixels


imgGray_adj = imadjust(imgGray);

figure
imshowpair(imgGray,imgGray_adj,"montage");
title("gray vs adjusted gray ");

imgSegmented = segmentImage(imgGray_adj);

figure
imshowpair(imgGray_adj,imgSegmented,"montage");
title(" adjusted gray vs segmented gray");
%%
figure
 hold on;
imshow(imgSegmented)
props = regionprops(imgSegmented, 'centroid');
radii = 20;
for k = 1 : length(props)
%     thisBB = props(k).BoundingBox
    hold on;
%     rectangle('Position', thisBB);
    viscircles(props(k).Centroid,radii)
end



% 
%      obs.x = ;
%      obs.y = ;
% obs.radius = ;

% end