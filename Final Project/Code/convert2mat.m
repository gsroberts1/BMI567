imList = dir('PIL*'); %get all strain folders
for im=1:length(imList) %for every strain folder
    temp_name = imList(im).name; %extract name
    imgFull = imread(temp_name); %load mat file containing imgs and segms
    bw = rgb2gray(imgFull);
    imgFull(:,:,4) = uint8(bw);
    gradMag = imgradient(bw);
    bodyEnhanced = log(abs(gradMag)+1);
    imgFull(:,:,5) = uint8(gradMag);
    imgFull(:,:,6) = uint8(bodyEnhanced);
    newName = [temp_name(1:end-4) '.mat'];
    save(newName,'imgFull'); 
end 

