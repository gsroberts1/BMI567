%% Environment Setup

% This script sorts training data for U-Net Segmentation. It runs from the
% downloaded DropBox directory entitled 'PIL_3dayLBCR-training' with
% unsorted color images and an excel file with biofilm metadata.

% To begin, move to this directory and place the unzipped
% 'Manual_Segmentation' and 'Code' folders that were provided in this
% directory.

% close all; clear all; clc; 
% dirList = dir('*.jpg');
% if length(dirList)<1 % if there aren't any jpegs
%     cd .. % youre likely in the Code folder. Move back to home
% end
% clear dirList
% 
% homeDir = pwd; % Make this 'PIL_3dayLBCR-training' folder my home folder
% [trainImagesDir,trainLabelsDir,valImagesDir,valLabelsDir,testDir] = setupEnvironment(homeDir);
clean
homeDir = 'D:\PIL_3dayLBCR-training_NEWEST';
trainImagesDir = 'D:\PIL_3dayLBCR-training_NEWEST\Training_Data\images';
trainLabelsDir = 'D:\PIL_3dayLBCR-training_NEWEST\Training_Data\labels';
valImagesDir = 'D:\PIL_3dayLBCR-training_NEWEST\Validation_Data\images';
valLabelsDir = 'D:\PIL_3dayLBCR-training_NEWEST\Validation_Data\labels';
testDir = 'D:\PIL_3dayLBCR-training_NEWEST\Test_Data';

%% Perform Simple Segmentation
% In this step, a simple multi-vertex polygon is drawn around the biofilm.
% NOTE: THIS STEP HAS ALREADY BEEN DONE. THE FOLLOWING PSUEDOCODE SHOWS HOW
% I PERFORMED THE POLYGON SEGMENTATION

% biofilmColor = imread('PIL-1_3dayLBCR-1.jpg');
% bw = rgb2gray(biofilmColor);

% % Open Image Segmentation Toolbox and save masks
% imageSegmenter
    % In the Image Segmenter Toolbox, select 'Load Image'
    % Load black-white image from workspace into toolbox
    % In the top 'ADD TO MASK' panel, click dropdown and select 'Draw ROIs'
    % Select 'Polygon' ROI at the top
    % Trace a semi-accurate polygon with ~50-150 vertices around biofilm
    % Click on biofilm image to add vertices
    % Connect the start point to the end point to close ROI
    % Click 'Apply' at the top
    % Click 'Close ROI' at the top
    % Select 'Export Images' at the top
    % Unselect 'Masked Image'
    % Write 'Final Segmentation' as a binary mask called 'SimpleSeg' 
    
% simpleSeg = imresize(simpleSeg,[8192 8192]);
% imwrite(double(simpleSeg),'PIL-1_3dayLBCR-1_simpleSeg.tif')
% NOTE: THIS STEP WAS REPEATED ON ALL FIRST SETS FOR REPEATABILITY ANALYSIS

%% Perform Manual Segmentation
% In this step, flood-filling, thresholding, hole-filling, and manual fine-
% trimming is used to perform ground-truth manual segmentation labels.
% NOTE: THIS STEP HAS ALREADY BEEN DONE. THE FOLLOWING PSUEDOCODE SHOWS HOW
% I PERFORMED THE MANUAL SEGMENTATION

% % Plot RGB channels
% load('Strain1_Set1.mat');
% figure; 
% subplot(1,3,1); imshow(images.biofilmColor(:,:,1),[]); title('Red');
% subplot(1,3,2); imshow(images.biofilmColor(:,:,2),[]); title('Green');
% subplot(1,3,3); imshow(images.biofilmColor(:,:,3),[]); title('Blue');

% % Visually determine weights based on contrast of specific images
% weightRed = 0.3;
% weightGreen = 0.3;
% weightBlue = 0.3;
% bw = weightRed*images.biofilmColor(:,:,1) ...
%     +weightGreen*images.biofilmColor(:,:,2) ... 
%     +weightBlue*images.biofilmColor(:,:,3); %convert rgb to grayscale
% bwHalf = imresize(bw,0.5); %downsample for faster preprocessing

% % Create gradients and edge images
% gradientMag = imgradient(bwHalf); %get gradient magnitude
% sobel = [0 2 2;-2 0 2;-2 -2 0]; %Sobel edge kernel
% gradientSobel = conv2(bw,sobel); %convolve sobel kernel to get edges
% gradientSobel = gradientSobel(2:end-1,2:end-1); %chop padding from conv2
% gradientSobel = imresize(gradientSobel,0.5);
% % Enhance the biofilm structure by taking the log of the sobel gradient
% bodyEnhanced = log(abs(gradientSobel)+1);
% bodyEnhanced = medfilt2(bodyEnhanced,[5 5]); %filter 'noise'

% figure; 
% subplot(2,2,1); imshow(bwHalf,[]); title('Downsampled black-white');
% subplot(2,2,2); imshow(gradientSobel,[]); title('Sobel');
% subplot(2,2,3); imshow(gradientMag,[]); title('Magnitude');
% subplot(2,2,4); imshow(bodyEnhanced,[]); title('Body Enhanced');

% % Open Image Segmentation Toolbox and save masks
% imageSegmenter
    % Perform flood-fill on outside region (or threshold if appropriate).
    % Fill holes
    % Invert image and fill holes
    % Perform open operation to remove spurs
    % Perform manual trimming of edges
    % Write 'Final Segmentation' as a binary mask called 'manualSeg' 

% % manualSeg is mask from 'fine trimming' mask
% manualSeg = imresize(manualSeg,[8192 8192); %upsample to 8192^2
% imwrite(double(manualSeg),'PIL-1_3dayLBCR-1.tif')
% NOTE: THIS STEP WAS REPEATED ON SECOND SETS FOR REPEATABILITY ANALYSIS

%% Standardize Data Size, Add Dimensionality, Convert to .mat

%cd(trainImagesDir); convert2mat;
% cd(valImagesDir); convert2mat;
% cd(testDir); convert2mat;
% cd(homeDir);

%% Train Network

% Create training image and ground-truth label datastores

matReader = @(x) matRead(x);
imds = imageDatastore(trainImagesDir,'FileExtensions','.mat','ReadFcn',matReader); 
pxds = pixelLabelDatastore(trainLabelsDir,["bg" "biofilm"],[0 255],'FileExtensions','.tif');

% Create validation image and ground-truth label datastores
imdsVal = imageDatastore(valImagesDir,'FileExtensions','.mat','ReadFcn',matReader);
pxdsVal = pixelLabelDatastore(valLabelsDir,["bg" "biofilm"],[0 255],'FileExtensions','.tif');

patchSize = [256 256];
patchPerImage = 16384;
miniBatchSize = 4;
augmenter = imageDataAugmenter('RandRotation',[0 90], ...
    'RandScale',[0.5 2], ... 
    'RandYReflection',true, ... 
    'RandXReflection',true);

patchds = randomPatchExtractionDatastore(imds,pxds,patchSize,'PatchesPerImage',patchPerImage,'DataAugmentation',augmenter);
patchds.MiniBatchSize = miniBatchSize;

patchdsVal = randomPatchExtractionDatastore(imdsVal,pxdsVal,patchSize,'PatchesPerImage',patchPerImage,'DataAugmentation',augmenter);
patchdsVal.MiniBatchSize = miniBatchSize;

options = trainingOptions('adam', ...
    'MaxEpochs',20, ...
    'InitialLearnRate',1e-4, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',8, ...
    'LearnRateDropFactor',0.95, ...
    'ValidationData',patchdsVal, ...
    'ValidationFrequency',400, ...
    'Plots','training-progress', ...
    'Verbose',true, ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch');

numClasses = 2;
inputPatchSize = [256 256 6];
encoderDepth = 3;
lgraph = unetLayers(inputPatchSize,numClasses,'EncoderDepth',encoderDepth);

modelDateTime = datestr(now,'dd-mmm-yyyy-HH-MM-SS');
[net,info] = trainNetwork(patchds,lgraph,options);
cd(fullfile(homeDir,'Code_GrantRoberts'));
save(['trainedUNetValid-' modelDateTime '-Epoch-' num2str(options.MaxEpochs) '.mat'],'net');
cd(homeDir);

%% Testing

% cd(testDir);
% testData = imread('PIL-94_3dayLBCR-2.jpg');
% showImageFlag = 1;
% segImage = MLsegmentation(testData,net,showImageFlag);

%% Write ML Segmentations
% Uses ML weights to predict segmentation from the trained network.
% Writes the binary segmentation in 'PremadeSegmentations/ML_Segmentation'

cd(fullfile(homeDir,'PremadeSegmentations'));
mkdir('ML_Segmentation');
cd(trainImagesDir);
segList = dir('*.tif');
for i=1:length(segList)
    name = segList(i).name;
    img = imread(name);
    showImageFlag = 0;
    segImage = MLsegmentation(img,net,showImageFlag);
    newName = [name(1:end-4) '_MLseg.tif'];
    imwrite(segImage,newName);
    movefile(newName,'../../PremadeSegmentations/ML_Segmentation');
end

cd(valImagesDir);
segList = dir('*.tif');
for i=1:length(segList)
    name = segList(i).name;
    img = imread(name);
    showImageFlag = 0;
    segImage = MLsegmentation(img,net,showImageFlag);
    newName = [name(1:end-4) '_MLseg.tif'];
    imwrite(segImage,newName);
    movefile(newName,'../../PremadeSegmentations/ML_Segmentation');
end
cd(homeDir);

%% Segmentation Performances
% Assess performance of segmentations relative to ground-truth manual segs.
% Calculates dice coefficients, hausdorff distances, and total areas.

segmentationPerformance
cd(homeDir);

%% Repeatability Analysis
% Assess repeatability of manual and simple segmentations.
% Evaluates dice coefficients intraclass correlation coefficients of areas

repeatabilityAnalysis
cd(homeDir);


%% Ancillary Functions

function data = matRead(filename)
    inp = load(filename);
    f = fields(inp);
    data = inp.(f{1});
end
