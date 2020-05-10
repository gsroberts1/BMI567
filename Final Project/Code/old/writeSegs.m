cd(imageDir)
strainLists = dir('Strain*'); %get all strain folders
for strain=1:length(strainLists) %for every strain folder
    cd(strainLists(strain).name) %go into folder
    setList = dir('Strain*'); %get all image sets
    for set=1:length(setList) %for every set
        temp_name = setList(set).name; %extract name
        load(temp_name); %load mat file containing images and segmentations
        
        simpleSeg_name = [temp_name(1:end-4) '_SimpleSeg.jpg']; 
        manualSeg_name = [temp_name(1:end-4) '_ManualSeg.jpg']; 
        
        imwrite(images.simpleSeg,simpleSeg_name); %rewrite image to jpg 
        imwrite(images.manualSeg,manualSeg_name); %write truth mask to jpg
        
        movefile(simpleSeg_name,'../../SimpleSeg') %move to training data
        movefile(manualSeg_name,'../../ManualSeg')
    end  
    cd .. %get out of directory
end 
cd(homeDir)