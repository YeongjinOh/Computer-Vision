function class_histogram = get_histogram(class_name, TextonLibrary, NumberofClusters)
% This function creates a histogram of given class_name.
% It uses a relative folder, so it should be located in 'YOURCODE' folder,
% or somewhere proper.

%% Initialization
class_histogram=zeros(1,NumberofClusters);

%% Set the path to 'train'class_name folder.
dirname = strcat('../train',class_name);
d = dir(dirname);

%% Create a histogram.
for i = 3:length(d)
    % Read the image
    fname = sprintf('%s\\%s',dirname,d(i).name);
    im = imread(fname);
    
    % Extract feature matrix and create a histogram.
    featureMatrix = extractResponseVectors(im);
    k = dsearchn(TextonLibrary,featureMatrix);
    
    % Accumulate the result.
    class_histogram = class_histogram + hist(k,NumberofClusters);
end

% Normalize the histogram and transpose it to make it column vector.
sumofCounts = sum(class_histogram);
class_histogram = class_histogram'/sumofCounts;
end