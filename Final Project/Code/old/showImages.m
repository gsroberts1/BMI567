function showImages(strainSetName)
%SHOWIMAGES: Shows all images and masks contained within data structure

if contains(strainSetName,'.mat')
    load(strainSetName); % load data structure containing images/masks
else
    load([strainSetName '.mat']);
end 
fieldNames = fieldnames(images); % Get names of all images
numImages = length(fieldNames); % Get total number of images

figure; sgtitle(strainSetName);
for i=1:numImages
    subplot(1,numImages,i); 
    imshow(images.(fieldNames{i})); title(fieldNames{i});
end 

end

