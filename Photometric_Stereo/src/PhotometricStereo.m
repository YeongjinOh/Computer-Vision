function PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere)
% This function draw the shape of target object using photometric stereo.
% It is supposed to located in the same directory with input images.

%% Initialization

% The constant to distinguish between object and background in the
% reference mask image
ObjThreshold = 1;

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

%% Implement closest-match between target object vectors and reference object vectors using kd-tree search.

% IDX is a list of indices which specifies the index of the reference
% object vector that corresponds to the appropriate target object vector.
IDX = kdtreeidx2(RefObjVec, TargetObjVec);



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

%% Extract the normal vectors of the pixels representing the objects in the reference image.

IndexedRefNormal = [(reshape(RefNormal(:,:,1),1,[])); reshape(RefNormal(:,:,2),1,[]); reshape(RefNormal(:,:,3),1,[])];
[row, col] = size(IndexedRefNormal);
% Count the number of erased columns
cnt=0;
for i = 1:col
    if RefMaskVec(i) == 0
        IndexedRefNormal(:,i-cnt)=[];
        cnt = cnt+1;
    end
end

%% Match the normal vector of the target object with that of the reference object using the indexed reference normal vectors and IDX.

[row, col] = size(TargetMask);
Normal = zeros(row,col,3);
cnt=0;
for j = 1:col
    for i= 1:row
        if TargetMask(i,j) ~= 0
            cnt = cnt + 1;
            Normal(i,j,:)=IndexedRefNormal(:,IDX(cnt));
        end
    end
end

%% Calculate Z and draw it.

nrows = 2^10;
ncols = 2^10;
% Caclulate Z
[Ni,Z] = integrability2(Normal,[], nrows,ncols);

% Draw Z
subplot(1,2,1);
surf(Z);
subplot(1,2,2);
surf(Z);
for i = 1:180
    subplot(1,2,1);
    view(30+i,30);
    axis image;
    subplot(1,2,2);
    view(30+i,30);
    axis image;
    light('Position',[0 0 100],'Style','local')
    pause(0.03);
end
end