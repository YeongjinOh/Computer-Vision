function TextonLibrary = getTextonLibrary(NumberofClusters)

%% Initialization
S = 10;
K = 10;
NumberofFilters = S*K;
TextonLibrary = zeros(NumberofClusters, NumberofFilters);

%% Build a Giant Feature Matrix
disp('Build a Giant Matrix');
GiantFeatureMatrix = buildGiantFeatureMatrix();

%% Implement k-means clustering
disp('Implement k-means clustering');
[clusterresult, clustercenters] = kmeans(GiantFeatureMatrix, NumberofClusters, 'EmptyAction','drop');
TextonLibrary = clustercenters;

end