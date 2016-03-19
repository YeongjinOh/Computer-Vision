function GiantFeatureMatrix = buildGiantFeatureMatrix()

%% Set the path to 'random' folder.
dirname = '../random';
d = dir(dirname);

%% Initailization.
S = 10;
K = 10;
NumberofFilters = S * K;
NumberofSampledPixels = 50097;
GiantFeatureMatrix=zeros(NumberofSampledPixels,NumberofFilters);
current_row = 1;

for i = 3:length(d) % For each image in 'random' folder.
    %% Read an image and get the size of it.
    fname = sprintf('%s\\%s',dirname,d(i).name);
    im = imread(fname);
    [rows, cols] = size(im);
    totalNumOfPixcels = rows*cols;
    
    %% Extract reponse vectors from all pixels.
    responseVectorsMatrix = extractResponseVectors(im);
    
    %% Random samling (1/100 * size)-times.
    samplingNumOfPixcels = ceil(totalNumOfPixcels/100);
    samplingIndex = randsample(totalNumOfPixcels,samplingNumOfPixcels);
    for j = 1:samplingNumOfPixcels
        %% Extract a reponse vector from some pixel and concatenate it to GiantFeatureMatrix.
        responseVector = responseVectorsMatrix(samplingIndex(j),:);
        GiantFeatureMatrix(current_row,:) = responseVector;
        current_row = current_row + 1;
        %GiantFeatureMatrix = vertcat(GiantFeatureMatrix,responseVector);
    end
end

end