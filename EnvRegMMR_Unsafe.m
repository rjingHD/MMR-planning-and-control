function [centersMMRs, radiiMMRs, unsafeRegion]= EnvRegMMR_Unsafe(image_file_name, IsPlot)
% IMPORTANT: This function assumes one type of objects 
% Takes an image as an nput and returns the centers and radii of the objects (cells) in the images
% Inputs: image_file_name = string
%         IsPlot = true OR false
%

if nargin<2
    IsPlot = false;
end

%% Read image

image = imread(image_file_name);
dim1 = 512; dim2 = 512;
imgResized = imresize(image,[dim1, dim2]);

imgGray = rgb2gray(image);
imgGray = imresize(imgGray,[dim1, dim2]);
%% Adjust to use darker and brighter pixels
imgGray_adj = imadjust(imgGray);

%% MMRs 
maskedRGBImage = createMask_MMRs(imgResized);
% imshowpair(maskedRGBImage,imgGray_adj, "montage")

stats = regionprops('table',maskedRGBImage,'Centroid',...
    'MajorAxisLength','MinorAxisLength');

diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
centersMMRs = stats.Centroid;
radiiMMRs = 6+ diameters/2;


%% Segment image all bodies vs background
unsafeRegion = segmentImageUnsafe(imgGray_adj);
figure
if IsPlot 
    imshowpair(unsafeRegion,imgGray_adj, "montage")
    figure
    img_resized = imresize(image,[dim1, dim2]);
    imshowpair(maskedRGBImage,img_resized, "montage")

    title("segmented VS original")
    hold on
    viscircles(centersMMRs,radiiMMRs)
    hold off
end

% %% Find centers and radii of objects
% stats = regionprops('table',maskedImageAll,'Centroid',...
%     'MajorAxisLength','MinorAxisLength');
% 
% diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
% centers = stats.Centroid;
% radii = diameters/2;
% 
% figure
% img_resized = imresize(image,[dim1, dim2]);
% imshowpair(maskedImageAll,img_resized, "montage")
% title("segmented VS original")
% hold on
% viscircles(centers,radii)
% hold off

end 


