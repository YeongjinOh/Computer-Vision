function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize);

numCases = size(data, 2);

groundTruth = full(sparse(labels, 1:numCases, 1));                          
thetagrad = zeros(numClasses, inputSize);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.


% size(groundTruth) % 4 2000
% size(theta)       % 4 400*3*3
% size(labels)      % 2000 1
% size(data)        % 400*3*3 2000
% size (thetagrad)  % 4 400*3*3  
% h                 % 4 4


% note that if we subtract off after taking the exponent, as in the
% text, we get NaN

% ------------------------------------------------------------------
% Compute cost
prob = exp(theta*data);
sumCol = sum(prob,1);
% Normalize each column
for i=1:size(prob,1)
   prob(i,:) = prob(i,:)./sumCol; 
end
cost = -sum(sum(groundTruth.*log(prob))) / numCases  + lambda/2 * sum(sum(theta.^2));

% Unroll the gradient matrices into a vector for minFunc
thetagrad = (prob-groundTruth)*data'/numCases + lambda * theta;
grad = [thetagrad(:)];

end

