function [segImage] = MLsegmentation(image,net,showImageFlag)
    
%% Break up image into 256x256 patches
iter = 1;
for i=1:32
    topIdx = (256*(i-1))+1;
    botIdx = 256*i;
    for j=1:32
        leftIdx = (256*(j-1))+1;
        rightIdx = 256*j;
        patch = image(topIdx:botIdx,leftIdx:rightIdx,:);
        mySeg = semanticseg(patch,net); % Produce ML segmentation
        mySegBinary = grp2idx(mySeg(:)); % Turn categorical into double
        mySegBinary = reshape(mySegBinary,[256 256])-1;
        segImage(topIdx:botIdx,leftIdx:rightIdx) = mySegBinary;
        iter = iter+1;
    end 
end 

%% Post-process image

segImagePost = imfill(segImage); % Fill holes
segImagePost(4192,:) = 1; % Create artifical line to avoid filling biofilm
segImagePost = imcomplement(segImagePost); % Invert image
segImagePost = imfill(segImagePost); % Fill holes on other side
segImagePost = imcomplement(segImagePost); % Invert back to original
se = strel('disk',1); % Morphological open kernel
segImagePost = imopen(segImagePost,se); % Open image to remove artificial line

if showImageFlag % if we want to show images, turn on flag
    figure; subplot(1,3,1); imshow(image(:,:,1:3)); title('Image');
    subplot(1,3,2); imshow(segImage); title('Original Segmentation');
    subplot(1,3,3); imshow(segImagePost); title('Post-Processed Segmentation');
end

segImage = segImagePost;

end