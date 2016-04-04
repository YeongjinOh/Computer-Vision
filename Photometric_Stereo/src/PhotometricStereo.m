function PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere)
% This function draw the shape of target object using photometric stereo.
% It is supposed to located in the same directory where the target folders
% which are 'bottle', 'velvet',and 'wavy' exist.

% Create object vectors
RefObjVec = [createObjectVectors(RefImageName, NumberOfImages, 1); createObjectVectors(RefImageName, NumberOfImages, 2); createObjectVectors(RefImageName, NumberOfImages, 3)];
TargetObjVec = [createObjectVectors(TargetImageName, NumberOfImages, 1); createObjectVectors(TargetImageName, NumberOfImages, 2); createObjectVectors(TargetImageName, NumberOfImages, 3)];

%% Extract the object vectors of the pixels representing the objects using mask which specifies the pixels that belong to the object within the image.

RefMask = imread([RefImageName,'mask.png']);
RefMaskVec = reshape(RefMask,1,[]);
[row, col] = size(RefMaskVec);
% Count the number of erased columns
cnt=0;
for i = 1:col
    if RefMaskVec(i) == 0
        RefObjVec(:,i-cnt)=[];
        cnt = cnt+1;
    end
end

TargetMask = imread([TargetImageName,'mask.png']);
TargetMaskVec = reshape(TargetMask, 1, []);
[row, col] = size(TargetMaskVec);
cnt = 0;
for i = 1:col
    if TargetMaskVec(i) == 0
        TargetObjVec(:,i-cnt)=[];
        cnt = cnt + 1;
    end
end


%% Calculate the surface normal in the reference object

[row, col] = size(RefMask);

% If the reference object is a sphere
if isRefASphere
    
    % Find the center of the sphere
    maxSum = 0;
    for i = 1:row
        rowSum = sum(RefMask(i,:));
        if (maxSum < rowSum)
            maxSum = rowSum;
            center_y = i;
        end
    end
    
    maxSum = 0;
    for i = 1:col
        colSum = sum(RefMask(:,i));
        if (maxSum < colSum)
            maxSum = colSum;
            center_x = i;
        end
    end
    
    % Calculate the raidus of the sphere
    for i = 1:row
        if RefMask(i,center_y) > ObjThreshold
            radius = center_y - i;
            break;
        end
    end
    
    % Calculate the surface normal of the sphere
    RefNormal = zeros(row,col,3);
    for i=1:row
        for j=1:col
            if (i-center_y)^2 + (j-center_x)^2 <= radius^2
                NormalVec = [j-center_x, i-center_y, sqrt(radius^2 - (j-center_x)^2 - (i-center_y)^2)];
            else
                NormalVec = [0, 0, 0];
            end
            RefNormal(i,j,:) = NormalVec/radius;
        end
    end
    
    % If the reference object is cylinder.
else
    
    % Find the center of the cylinder
    for i = 1:row
        if max(RefMask(i,:)) > ObjThreshold
            top = i;
            break;
        end
    end
    for i = 1:row
        j = row+1-i;
        if max(RefMask(j,:)) > ObjThreshold
            bottom = j;
            break;
        end
    end
    for i = 1:col
        if max(RefMask(:,i)) > ObjThreshold
            left = i;
            break;
        end
    end
    for i = 1:col
        j = col+1-i;
        if max(RefMask(:,j)) > ObjThreshold
            right = j;
            break;
        end
    end
    center_x = (left+right)/2;
    radius = (right-left)/2;
    
    % Calculate the surface normal of the cylinder
    RefNormal = zeros(row,col,3);
    for i=1:row
        for j=1:col
            if top <= i && i <= bottom && left <= j && j <= right
                NormalVec = [j-center_x, 0, sqrt(radius^2 - (j-center_x)^2)];
            else
                NormalVec = [0, 0, 0];
            end
            RefNormal(i,j,:) = NormalVec/radius;
        end
    end
end


end
