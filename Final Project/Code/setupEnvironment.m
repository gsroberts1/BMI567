function [trainImagesDir,trainLabelsDir,valImagesDir,valLabelsDir,testDir] = setupEnvironment(homeDir)
%SETUPENVIRONMENT: Sets up environment to run MASTER_SCRIPT
%   Adds subfolders to home directory and moves images 
    mkdir Training_Data\images %subdirectory for images
    mkdir Training_Data\labels %subdirectory for ground truth masks
    trainDir = fullfile(homeDir,'Training_Data');
    trainImagesDir = fullfile(trainDir,'images');
    trainLabelsDir = fullfile(trainDir,'labels');
    
    mkdir Validation_Data\images
    mkdir Validation_Data\labels
    valDir = fullfile(homeDir,'Validation_Data');
    valImagesDir = fullfile(valDir,'images');
    valLabelsDir = fullfile(valDir,'labels');
    
    mkdir Test_Data
    testDir = fullfile(homeDir,'Test_Data');
    
    %% Sort Images
    % Sort validation images
    movefile('PIL-1_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-2_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-3_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-5_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-9_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-14_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-15_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-23_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-25_3dayLBCR-4.jpg',valImagesDir);
    movefile('PIL-26_3dayLBCR-4.jpg',valImagesDir);
    
    % Sort training images
    movefile('PIL-1_*',trainImagesDir);
    movefile('PIL-2_*',trainImagesDir);
    movefile('PIL-3_*',trainImagesDir);
    movefile('PIL-5_*',trainImagesDir);
    movefile('PIL-9_*',trainImagesDir);
    movefile('PIL-13_*',trainImagesDir);
    movefile('PIL-14_*',trainImagesDir);
    movefile('PIL-15_*',trainImagesDir);
    movefile('PIL-23_*',trainImagesDir);
    movefile('PIL-25_*',trainImagesDir);
    movefile('PIL-26_*',trainImagesDir);
    movefile('PIL-29_*',trainImagesDir);
    movefile('PIL-32_*',trainImagesDir);
    movefile('PIL-33_*',trainImagesDir);
    movefile('PIL-38_*',trainImagesDir);
    movefile('PIL-41_*',trainImagesDir);
    movefile('PIL-45_*',trainImagesDir);
    movefile('PIL-47_*',trainImagesDir);
    
    % Put all other images in test data folder
    movefile('*.jpg',testDir); 
    
    %% Sort pre-labelled data
    % Sort manually segmented validation labels
    if exist('PremadeSegmentations','dir')
       cd('PremadeSegmentations/Manual_Segmentation')
    else
        disp('Please place the unzipped Manual_Segmentation folder provided in the home directory');
    end
    
    % Sort manually segmented training labels
    copyfile('*.tif',trainLabelsDir);
    
    cd(trainLabelsDir);
    % move validation labels that were copied over to valLabelsDir
    movefile('PIL-1_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-2_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-3_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-5_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-9_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-14_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-15_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-23_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-25_3dayLBCR-4.tif',valLabelsDir);
    movefile('PIL-26_3dayLBCR-4.tif',valLabelsDir);
    
    cd(homeDir); % lets go back home now
end 