function [objVectors] = createObjectVectors(ImageName, NumberOfImages, ColorIndex)
% This function create object vectors.
% The input ImageName corresponds to the seed name of the sequence 
% of images as a string.
% The corresponding images are assumed to be in the current directory.


for i=1:NumberOfImages
    img = imread([ImageName,num2str(i),'.png']);
    imgVector = reshape(img(:,:,ColorIndex),1,[]);
    
    % initialize objVectors matrix with the first image vector
    if i == 1
        objVectors = imgVector;
    % and keep concatenating the other object vectors
    else
        objVectors = [objVectors; imgVector];
    end
        
end
end