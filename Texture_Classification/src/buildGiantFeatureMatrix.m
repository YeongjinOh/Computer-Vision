function TextonLibraryArray = buildGiantFeatureMatrix(NumberofClusters, NumberofFilters)
k = NumberofClusters;
n = NumberofFilters;

dirname = '../random';
d = dir(dirname);

%TextonLibraryArray = zeros(NumberofClusters,NumberofFilters,length(d)-2);
TextonLibraryArray = zeros(NumberofClusters,NumberofFilters,5);
%total_size = 0;

%for i = 3:length(d)
for i = 3:7
    fname = sprintf('%s\\%s',dirname,d(i).name);
    im = imread(fname);
    g = extractResponseVectors(im);
    [clusterresult clustercenters] = kmeans(g, k);



%% Read the image of number 'index'
fname = sprintf('%s\\%s',dirname,d(index+2).name);
Image = imread(fname);

%% Extract feature matrix and implement kmeans clustering
GiantFeatureMatrix = extractResponseVectors(Image);
[clusterresult, clustercenters] = kmeans(GiantFeatureMatrix, NumberofClusters);
TextonLibrary = clustercenters;


end

end