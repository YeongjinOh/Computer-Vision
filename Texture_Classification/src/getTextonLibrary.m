function TextonLibrary = getTextonLibrary()

%% Initialization
NumberofClusters = 8;
TextonLibrary = [];

%% Set the path to random folder
dirname = '../random';
d = dir(dirname);


for i = 3:length(d)

%% Read the image of number 'index'
fname = sprintf('%s\\%s',dirname,d(i).name);
Image = imread(fname);

%% Extract feature matrix and implement kmeans clustering
GiantFeatureMatrix = extractResponseVectors(Image);
[clusterresult, clustercenters] = kmeans(GiantFeatureMatrix, NumberofClusters);
TextonLibrary = vertcat(TextonLibrary,clustercenters);

end

end