function PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere)

RefObjVecRed = createObjectVectors(RefImageName, NumberOfImages, 1);
TargetObjVecRed = createObjectVectors(TargetImageName, NumberOfImages, 1);

%% Segment the object vectors of reference image into the pixels representing the objects
TargetMask = reshape(imread([RefImageName,'mask.png'), 1, []);
[row, col] = size(TargetMask);
for i = 1 : col
    if TargetMask(i) == 0
        RefObjVecRed(:,i)=[];
    end
end

%% Segment the object vectors of target image into the pixels representing the objects
TargetMask = reshape(imread([TargetImageName,'mask.png'), 1, []);
[row, col] = size(TargetMask);
for i = 1 : col
    if TargetMask(i) == 0
        TargetObjVecRed(:,i)=[];
    end
end


    
