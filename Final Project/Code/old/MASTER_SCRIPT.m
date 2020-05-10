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
% addpath(genpath(pwd));
% homeDir = pwd;
% [trainImagesDir,trainLabelsDir,valImagesDir,valLabelsDir,testDir] = setupEnvironment(homeDir);


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

%% Make Training/Validation/Testing Data

% % Size all images to [8192 8192];
% cd(trainImagesDir); resizeData;
% cd(valImagesDir); resizeData;
% cd(testDir); resizeData;
% cd(homeDir);

%% Train Network

%%%%%%%%%%%%%%%%%% REMOVE THIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
homeDir = 'D:\BMI567\PIL_3dayLBCR-training';
trainImagesDir = 'D:\BMI567\PIL_3dayLBCR-training\Training_Data\images';
trainLabelsDir = 'D:\BMI567\PIL_3dayLBCR-training\Training_Data\labels';
valImagesDir = 'D:\BMI567\PIL_3dayLBCR-training\Validation_Data\images';
valLabelsDir = 'D:\BMI567\PIL_3dayLBCR-training\Validation_Data\labels';
testDir = 'D:\BMI567\PIL_3dayLBCR-training\Test_Data';

% Create training image and ground-truth label datastores
imds = imageDatastore(trainImagesDir); 
pxds = pixelLabelDatastore(trainLabelsDir,["bg" "biofilm"],[0 255]);

% Create validation image and ground-truth label datastores
imdsVal = imageDatastore(valImagesDir);
pxdsVal = pixelLabelDatastore(valLabelsDir,["bg" "biofilm"],[0 255]);

patchSize = [256 256];
patchPerImage = 32;
miniBatchSize = 8;
patchds = randomPatchExtractionDatastore(imds,pxds,patchSize,'PatchesPerImage',patchPerImage);
patchds.MiniBatchSize = miniBatchSize;

patchdsVal = randomPatchExtractionDatastore(imdsVal,pxdsVal,patchSize,'PatchesPerImage',patchPerImage);
patchdsVal.MiniBatchSize = miniBatchSize;

options = trainingOptions('adam', ...
    'MaxEpochs',50, ...
    'InitialLearnRate',5e-4, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',5, ...
    'LearnRateDropFactor',0.95, ...
    'ValidationData',patchdsVal, ...
    'ValidationFrequency',400, ...
    'Plots','training-progress', ...
    'Verbose',true, ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch');

numClasses = 2;
inputPatchSize = [256 256 3];
encoderDepth = 3;
lgraph = unetLayers(inputPatchSize,numClasses,'EncoderDepth',encoderDepth);

% outputLayer = dicePixelClassificationLayer('Name','Output');
% lgraph = replaceLayer(lgraph,'Segmentation-Layer',outputLayer);

modelDateTime = datestr(now,'dd-mmm-yyyy-HH-MM-SS');
[UnetSegmentationV3,info] = trainNetwork(patchds,lgraph,options);
cd(fullfile(homeDir,'Code_GrantRoberts'));
save(['trainedUNetValid-' modelDateTime '-Epoch-' num2str(options.MaxEpochs) '.mat'],'UnetSegmentationV3');
cd(homeDir);

% load('UnetSegmentationV3.mat')
%% Testing
% cd(testDir);
% testData = imread('PIL-94_3dayLBCR-2.jpg');
% showImageFlag = 1;
% segImage = MLsegmentation(testData,UnetSegmentationV2,showImageFlag);

%% Write ML Segmentations
% cd(fullfile(homeDir,'PremadeSegmentations'));
% mkdir('ML_Segmentation');
% cd(trainImagesDir);
% segList = dir('*.jpg');
% for i=1:length(segList)
%     name = segList(i).name;
%     img = imread(name);
%     showImageFlag = 0;
%     segImage = MLsegmentation(img,UnetSegmentationV2,showImageFlag);
%     newName = [name(1:end-4) '_MLseg.tif'];
%     imwrite(segImage,newName);
%     movefile(newName,'../../PremadeSegmentations/ML_Segmentation');
% end
% 
% cd(valImagesDir);
% segList = dir('*.jpg');
% for i=1:length(segList)
%     name = segList(i).name;
%     img = imread(name);
%     showImageFlag = 0;
%     segImage = MLsegmentation(img,UnetSegmentationV2,showImageFlag);
%     newName = [name(1:end-4) '_MLseg.tif'];
%     imwrite(segImage,newName);
%     movefile(newName,'../../PremadeSegmentations/ML_Segmentation');
% end

%% Segmentation Performances


%% Repeatability Analysis

% repeatabilityAnalysis