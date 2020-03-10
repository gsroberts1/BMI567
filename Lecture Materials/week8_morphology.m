% Illustration of basic Image Morphology
% Code by Daniel Pimentel
clear all; close all; clc;

%% Load Pacman image
im = imread('pacman.png') > 0;
figure(1); subplot(1,2,1); imshow(im);

%% Region Growing
ker = ones(3);
mask_old = zeros(size(im));
mask_new = mask_old;
mask_new(100,50) = 1;   %Seed
subplot(1,2,2); imagesc(mask_new);

mask_size_old = 0;
mask_size_new = 1;
while(mask_size_old ~= mask_size_new)
    mask_old = mask_new;
    mask_size_old = mask_size_new;
    for i=2:size(im,1)-1
        for j=2:size(im,2)-1
            if mask_old(i,j)==1
                mask_new(i-1:i+1,j-1:j+1) = im(i-1:i+1,j-1:j+1).* ker;
            end
        end
    end
    mask_size_new = sum(mask_new(:));
    pause(0.01); 
    imshow(mask_new);
end


%% Load lung image, and run initial analysis
im0 = double(imread('lung.jpg'));
figure(2); subplot(1,2,1); imagesc(im0); colormap(gray);
subplot(1,2,2); hist(im0(:));

% Thresholding
figure(3); subplot(1,3,1); imshow(im0/255);
im = im0 < 150;
subplot(1,3,2); imshow(im);

%% Region Growing
ker = ones(3);
mask_old = zeros(size(im));
mask_new = mask_old;
mask_new(300,150) = 1;   %Seed
subplot(1,3,3); imagesc(mask_new);

mask_size_old = 0;
mask_size_new = 1;
while(mask_size_old ~= mask_size_new)
    mask_old = mask_new;
    mask_size_old = mask_size_new;
    for i=2:size(im,1)-1
        for j=2:size(im,2)-1
            if mask_old(i,j)==1
                mask_new(i-1:i+1,j-1:j+1) = im(i-1:i+1,j-1:j+1).* ker;
            end
        end
    end
    mask_size_new = sum(mask_new(:));
    pause(0.01);
    figure(3); subplot(1,3,3); imshow(mask_new);
end


%% Dilate image
im_dilated = im;
for i=2:size(im,1)-1
    for j=2:size(im,2)-1
        bloc = im(i-1:i+1,j-1:j+1);
        if sum(bloc(:))>0
            im_dilated(i-1:i+1,j-1:j+1) = 1;
        end
    end
end

figure(4); subplot(1,5,1); imshow(im0/255);
subplot(1,5,2); imshow(im);
subplot(1,5,3); imshow(im_dilated);

%% Erode image
im_eroded = im_dilated;
for i=2:size(im,1)-1
    for j=2:size(im,2)-1
        bloc = im_dilated(i-1:i+1,j-1:j+1);
        if sum(bloc(:))<9
            im_eroded(i-1:i+1,j-1:j+1) = 0;
        end
    end
end

subplot(1,5,4); imshow(im_eroded);

%% Region Growing
ker = ones(3);
mask_old = zeros(size(im));
mask_new = mask_old;
mask_new(300,150) = 1;   %Seed
subplot(1,5,5);
imagesc(mask_new);
mask_size_old = 0;
mask_size_new = 1;
while(mask_size_old ~= mask_size_new)
    mask_old = mask_new;
    mask_size_old = mask_size_new;
    for i=2:size(im,1)-1
        for j=2:size(im,2)-1
            if mask_old(i,j)==1
                mask_new(i-1:i+1,j-1:j+1) = im_eroded(i-1:i+1,j-1:j+1).* ker;
            end
        end
    end
    mask_size_new = sum(mask_new(:));
    pause(0.01);
    figure(4); subplot(1,5,5); imshow(mask_new);
end

