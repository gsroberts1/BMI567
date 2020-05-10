% man1 = images.manualSeg;
% man2 = images.manualSeg2;
% areas(10,1) = sum(man1(:))./numel(man1)
% areas(10,2) = sum(man2(:))./numel(man2)
% diceCo(10) = dice(man1,man2)


% sim1 = images.simpleSeg;
% sim2 = images.simpleSeg2;
% SimpleAreas(10,1) = sum(sim1(:))./numel(sim1)
% SimpleAreas(10,2) = sum(sim2(:))./numel(sim2)
% SimpleDiceCo(10) = dice(sim1,sim2)

iter = 1;
strainLists = dir('Strain*'); %get all strain folders
for strain=1:length(strainLists) %for every strain folder
    cd(strainLists(strain).name) %go into folder
    setList = dir('Strain*'); %get all image sets
    for set=1:length(setList) %for every set
        temp_name = setList(set).name; %extract name
        load(temp_name); %load mat file containing images and segmentations
        manual = images.manualSeg;
        simple = images.simpleSeg;
        simpleAreasTotal(iter) = sum(simple(:))./numel(simple);
        manualAreasTotal(iter) = sum(manual(:))./numel(manual);
%         simpleVsManualHD(iter) = ModHausdorffDist(imresize(manual,0.2),imresize(simple,0.2)); 
        iter = iter+1;
    end  
    cd .. %get out of directory
end 