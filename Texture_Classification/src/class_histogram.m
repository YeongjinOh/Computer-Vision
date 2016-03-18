function counts = class_histogram(class_name, TextonLibrary)
    
dirname = strcat('../train',class_name);
d = dir(dirname);
q = 63;
counts=zeros(1,q);

for i = 3:length(d)

%% Read the image
fname = sprintf('%s\\%s',dirname,d(i).name);
Image = imread(fname);

%% Extract feature matrix and implement kmeans clustering
GiantFeatureMatrix = extractResponseVectors(Image);
k = dsearchn(TextonLibrary,GiantFeatureMatrix);
counts = counts + hist(k,q);
end

end