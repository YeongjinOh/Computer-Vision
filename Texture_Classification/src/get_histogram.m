function class_histogram = get_histogram(class_name, TextonLibrary, NumberofClusters)

%% Set the path to 'train'class_name folder.
dirname = strcat('../train',class_name);
d = dir(dirname);
class_histogram=zeros(1,NumberofClusters);
disp(['Get a histogram of ', class_name]);

for i = 3:length(d)
    
    %% Read the image
    fname = sprintf('%s\\%s',dirname,d(i).name);
    im = imread(fname);
    
    %% Extract feature matrix and implement kmeans clustering
    featureMatrix = extractResponseVectors(im);
    k = dsearchn(TextonLibrary,featureMatrix);
    class_histogram = class_histogram + hist(k,NumberofClusters);
end
    sumofCounts = sum(class_histogram);
    class_histogram = class_histogram'/sumofCounts;
    
    
end