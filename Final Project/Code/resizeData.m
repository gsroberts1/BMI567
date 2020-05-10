imList = dir('PIL*'); %get all strain folders
for im=1:length(imList) %for every strain folder
    temp_name = imList(im).name; %extract name
    imgFull = imread(temp_name); %load mat file containing imgs and segms
    imgDown = imresize(imgFull,[8192 8192]); %downsample
    imwrite(imgDown,temp_name); %rewrite image to jpg/tif file 
end 

