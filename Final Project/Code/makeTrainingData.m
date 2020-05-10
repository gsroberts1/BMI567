cd 'C:\Users\robertsgr\Documents\Graduate Schoolwork\BMI567\Final Project\PIL_3dayLBCR-training'

strainLists = dir('Strain*'); %get all strain folders
for strain=1:length(strainLists) %for every strain folder
    cd(strainLists(strain).name) %go into folder
    setList = dir('Strain*'); %get all image sets
    for set=1:length(setList) %for every set
        temp_name = setList(set).name; %extract name
        load(temp_name); %load mat file containing images and segmentations
        temp_train = imresize(images.biofilmColor,[8192 8192]); %downsample
        temp_truth = imresize(images.manualSeg,[8192 8192]); %downsample 
        train_name = [temp_name(1:end-4) '_train.jpg']; 
        truth_name = [temp_name(1:end-4) '_truth.jpg']; 
        imwrite(temp_train,train_name); %rewrite image to jpg file 
        imwrite(temp_truth,truth_name); %rewrite ground-truth mask to jpg
        movefile(train_name,'../Training_Data/images') %move to training data
        movefile(truth_name,'../Training_Data/labels')
    end  
    cd .. %get out of directory
end 

