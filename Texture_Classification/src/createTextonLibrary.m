% This script creates a TextonLibrary.
% Since it uses a buildGiantFeatureMatrix function, it should be located in
% 'YOURCODE' folder.

%% Initialization
S = 10;
K = 10;
NumberofFilters = S*K;

% Set the number of clusters.
NumberofClusters = 16;
TextonLibrary = zeros(NumberofClusters, NumberofFilters);

%% Build a Giant Feature Matrix
GiantFeatureMatrix = buildGiantFeatureMatrix();

%% Implement k-means clustering
[clusterresult, clustercenters] = kmeans(GiantFeatureMatrix, NumberofClusters, 'EmptyAction','drop');
TextonLibrary = clustercenters;