function TextonLibrary = getTextonLibrary_onebyone(index)
NumberofClusters = 8;

%% Set the path to random folder
dirname = '../random';
d = dir(dirname);


%% Read the image of number 'index'
fname = sprintf('%s\\%s',dirname,d(index+2).name);
Image = imread(fname);

%% Extract feature matrix and implement kmeans clustering
GiantFeatureMatrix = extractResponseVectors(Image);
[clusterresult, clustercenters] = kmeans(GiantFeatureMatrix, NumberofClusters);
TextonLibrary = clustercenters;

end