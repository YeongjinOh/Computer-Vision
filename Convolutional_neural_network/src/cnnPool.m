function pooledFeatures = cnnPool(poolDim, convolvedFeatures)
%cnnPool Pools the given convolved features
%
% Parameters:
%  poolDim - dimension of pooling region
%  convolvedFeatures - convolved features to pool (as given by cnnConvolve)
%                      convolvedFeatures(featureNum, imageNum, imageRow, imageCol)
%
% Returns:
%  pooledFeatures - matrix of pooled features in the form
%                   pooledFeatures(featureNum, imageNum, poolRow, poolCol)
%

numImages = size(convolvedFeatures, 2);
numFeatures = size(convolvedFeatures, 1);
convolvedDim = size(convolvedFeatures, 3);

pooledFeatures = zeros(numFeatures, numImages, floor(convolvedDim / poolDim), floor(convolvedDim / poolDim));

% -------------------- YOUR CODE HERE --------------------
% Instructions:
%   Now pool the convolved features in regions of poolDim x poolDim,
%   to obtain the
%   numFeatures x numImages x (convolvedDim/poolDim) x (convolvedDim/poolDim)
%   matrix pooledFeatures, such that
%   pooledFeatures(featureNum, imageNum, poolRow, poolCol) is the
%   value of the featureNum feature for the imageNum image pooled over the
%   corresponding (poolRow, poolCol) pooling region
%   (see http://ufldl/wiki/index.php/Pooling )
%
%   Use mean pooling here.
% -------------------- YOUR CODE HERE --------------------
poolRow = size(pooledFeatures,3);
poolCol = size(pooledFeatures,4);
startIdx = 1:poolDim:convolvedDim+1;
startIdx(poolRow+1) = convolvedDim+1;


for r = 1:poolRow
    for c = 1:poolCol
        pooledValues = convolvedFeatures(:,:,startIdx(r):startIdx(r+1)-1, startIdx(c):startIdx(c+1)-1);
        pooledFeatures(:,:, r,c) = mean(mean(pooledValues,4),3);
    end
end
