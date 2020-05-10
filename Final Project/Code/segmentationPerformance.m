%% Simple Segmentation Performance vs Manual
cd(fullfile(homeDir,'PremadeSegmentations/Manual_Segmentation'));
manDir = dir('*.tif');
names = {manDir.name}';
for i=1:length(manDir)
    imgName = manDir(i).name; % get name of repeat image
    manSeg = imread(imgName); % load 2nd (repeat) image
    manSeg = imbinarize(manSeg);
    manAreasTotal(i,1) = sum(manSeg(:))./numel(manSeg);
    manSegs(:,:,i) = manSeg;
end 

cd(fullfile(homeDir,'PremadeSegmentations/Simple_Segmentation'));
simpleDir = dir('*.tif');
for i=1:length(simpleDir)
    imgName = simpleDir(i).name; % get name of repeat image
    simpleSeg = imread(imgName); % load 2nd (repeat) image
    simpleSeg = imbinarize(simpleSeg);
    simpleAreasTotal(i,1) = sum(simpleSeg(:))./numel(simpleSeg);
    simpleSegs(:,:,i) = simpleSeg;
end 

cd(fullfile(homeDir,'PremadeSegmentations/ML_Segmentation'));
MLDir = dir('*.tif');
for i=1:length(MLDir)
    imgName = MLDir(i).name; % get name of repeat image
    MLSeg = imread(imgName); % load 2nd (repeat) image
    MLSeg = imbinarize(MLSeg);
    MLAreasTotal(i,1) = sum(MLSeg(:))./numel(MLSeg);
    MLSegs(:,:,i) = MLSeg;
end 

for i=1:length(MLDir)
    simpleVsManualDice(i,1) = dice(simpleSegs(:,:,i),manSegs(:,:,i)); 
    MLVsManualDice(i,1) = dice(MLSegs(:,:,i),manSegs(:,:,i));
end 

for i=1:length(MLDir)
    simpleVsManualMHD(i,1) = ModHausdorffDist(imresize(simpleSegs(:,:,i),0.2),imresize(manSegs(:,:,i),0.2)); 
    MLVsManualMHD(i,1) = ModHausdorffDist(imresize(MLSegs(:,:,i),0.2),imresize(manSegs(:,:,i),0.2)); 
end 

MLPerformance = table(names,manAreasTotal,MLAreasTotal,MLVsManualDice,MLVsManualMHD)
save MLPerformance MLPerformance

cd '../Simple_Segmentation'
SimplePerformance = table(names,manAreasTotal,simpleAreasTotal,simpleVsManualDice,simpleVsManualMHD)
save SimplePerformance SimplePerformance




%% Modified Hausdorff Distance Calculation
function [ mhd ] = ModHausdorffDist( A, B )

% Code Written by B S SasiKanth, Indian Institute of Technology Guwahati.
% Website: www.bsasikanth.com
% E-Mail:  bsasikanth@gmail.com
% 
% This function computes the Modified Hausdorff Distance (MHD) which is 
% proven to function better than the directed HD as per Dubuisson et al. 
% in the following work:
% 
% M. P. Dubuisson and A. K. Jain. A Modified Hausdorff distance for object 
% matching. In ICPR94, pages A:566-568, Jerusalem, Israel, 1994.
% http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=576361
% 
% The function computed the forward and reverse distances and outputs the 
% minimum of both.
% 
% Format for calling function:
% 
% MHD = ModHausdorffDist(A,B);
% 
% where
% MHD = Modified Hausdorff Distance.
% A -> Point set 1
% B -> Point set 2
% 
% No. of samples of each point set may be different but the dimension of
% the points must be the same.

% BEGINNING OF CODE

% Compute the sizes of the input point sets
Asize = size(A);
Bsize = size(B);

% Check if the points have the same dimensions
if Asize(2) ~= Bsize(2)
    error('The dimensions of points in the two sets are not equal');
end

% Calculating the forward HD

fhd = 0;                    % Initialize forward distance to 0
for a = 1:Asize(1)          % Travel the set A to find avg of d(A,B)
    mindist = Inf;          % Initialize minimum distance to Inf
    for b = 1:Bsize(1)      % Travel set B to find the min(d(a,B))
        tempdist = norm(A(a,:)-B(b,:));
        if tempdist < mindist
            mindist = tempdist;
        end
    end
    fhd = fhd + mindist;    % Sum the forward distances
end
fhd = fhd/Asize(1);         % Divide by the total no to get average

% Calculating the reverse HD

rhd = 0;                    % Initialize reverse distance to 0
for b = 1:Bsize(1)          % Travel the set B to find avg of d(B,A)
    mindist = Inf;          % Initialize minimum distance to Inf
    for a = 1:Asize(1)      % Travel set A to find the min(d(b,A))
        tempdist = norm(A(a,:)-B(b,:));
        if tempdist < mindist
            mindist = tempdist;
        end
    end
    rhd = rhd + mindist;    % Sum the reverse distances
end
rhd = rhd/Bsize(1);         % Divide by the total no. to get average

mhd = max(fhd,rhd);         % Find the minimum of fhd/rhd as 
                            % the mod hausdorff dist


end

