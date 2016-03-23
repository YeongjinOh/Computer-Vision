% This script creates histogram of all sample classes.
% Since it uses a get_histogram function, it should be located in
% 'YOURCODE' folder or somewhere proper.

%% Initialization
% Set the number of clusters.
NumberofClusters = 16;

%% Load a TextonLibrary.
load TextureLibrary.mat;

%% Create histograms of every class.
Canvas_histogram = get_histogram('Canvas', TextonLibrary, NumberofClusters);
Chips_histogram = get_histogram('Chips', TextonLibrary, NumberofClusters);
Grass_histogram = get_histogram('Grass', TextonLibrary, NumberofClusters);
Seeds_histogram = get_histogram('Seeds', TextonLibrary, NumberofClusters);
Straw_histogram = get_histogram('Straw', TextonLibrary, NumberofClusters);

