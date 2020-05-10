%% Creates inner/outer boundaries where bacteria edge exists
load('Strain38_Set4.mat');

%% Plot RGB channels
figure; 
subplot(1,3,1); imshow(images.biofilmColor(:,:,1),[]); title('Red');
subplot(1,3,2); imshow(images.biofilmColor(:,:,2),[]); title('Green');
subplot(1,3,3); imshow(images.biofilmColor(:,:,3),[]); title('Blue');

%visually determine weights based on contrast of specific images
weightRed = 0.3;
weightGreen = 0.3;
weightBlue = 0.3;
bw = weightRed*images.biofilmColor(:,:,1) ...
    +weightGreen*images.biofilmColor(:,:,2) ... 
    +weightBlue*images.biofilmColor(:,:,3); %convert rgb to grayscale
bwHalf = imresize(bw,0.5); %downsample for faster preprocessing

%% Create gradients and edge images
gradientMag = imgradient(bwHalf); %get gradient magnitude
sobel = [0 2 2;-2 0 2;-2 -2 0]; %Sobel edge kernel
gradientSobel = conv2(bw,sobel); %convolve sobel kernel to get edges
gradientSobel = gradientSobel(2:end-1,2:end-1); %chop padding from conv2
gradientSobel = imresize(gradientSobel,0.5);

%Enhance the biofilm structure by taking the log of the sobel gradient
bodyEnhanced = log(abs(gradientSobel)+1);
bodyEnhanced = medfilt2(bodyEnhanced,[5 5]); %filter 'noise'
%gradFilt = wiener2(gradFilt,[5 5]); %filter 'noise'

%Create an 'enhanced' edge image to suppress slowly-varying background
edgeEnhanced = (abs(double(gradientSobel))).^2;
edgeEnhanced = medfilt2(edgeEnhanced,[3 3]); %filter 'noise'


figure; 
subplot(2,2,1); imshow(gradientMag,[]); title('Magnitude');
subplot(2,2,2); imshow(gradientSobel,[]); title('Sobel');
subplot(2,2,3); imshow(edgeEnhanced,[]); title('Edge Enhanced');
subplot(2,2,4); imshow(bodyEnhanced,[]); title('Body Enhanced');


%% Open Image Segmentation Toolbox and save masks
%imageSegmenter;

%adaptSeg is mask created from initial flood fill, hole fill, and opening
    %images.adaptSeg = imresize(adaptSeg,2); %upsample to original size
%manualSeg is mask created from 'fine trimming' the adaptSeg mask
    %images.manualSeg = imresize(manualSeg,2); %upsample to original size