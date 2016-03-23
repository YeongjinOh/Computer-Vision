function class = classify(im)
% This function creates a histogram for the input image, and figures out
% which class this image belongs to, using the Texton Library. The output
% is the name of the class.
% This function should be located in the same directory with
% extractResponseVectors function.

%% Initialization.
NumberofClusters = 16;

%% Load TextonLibrary and class_histograms.
load TextureLibrary.mat
load Histograms.mat

%% Build class library
ClassLibrary = Canvas_histogram';
ClassLibrary = vertcat(ClassLibrary,Chips_histogram');
ClassLibrary = vertcat(ClassLibrary,Grass_histogram');
ClassLibrary = vertcat(ClassLibrary,Seeds_histogram');
ClassLibrary = vertcat(ClassLibrary,Straw_histogram');

%% Extract a feature matrix from given image and create a histogram.
featureMatrix = extractResponseVectors(im);
k = dsearchn(TextonLibrary,featureMatrix);
im_hist = hist(k,NumberofClusters);

% Normalize the histogram.
im_hist_sum = sum(im_hist);
im_hist = im_hist / im_hist_sum;

%% Find the closest class.
index = dsearchn(ClassLibrary,im_hist);

%% Return the name of class.
switch index
    case 1
        class = 'Canvas';
    case 2
        class = 'Chips';
    case 3
        class = 'Grass';
    case 4
        class = 'Seeds';
    case 5
        class = 'Straw';
    otherwise
        class = 'No match';
end


end

