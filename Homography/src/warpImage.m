% This function takes two images, which are reference image(Iref) and 
% another image (Iin) compared with Iref. It warps the input image Iin 
% according to 3 by 3 homography matrix H and return the result as Iwarp.
% And then, merge Iwarp with Iref into a single mosaic image as Imerge.

function [Iwarp, Imerge] = warpImage (Iin, Iref, H)

%% Initialization

% get size of each image
Iin_row = size(Iin, 1);
Iin_col = size(Iin, 2);
Iref_row = size(Iref, 1);
Iref_col = size(Iref, 2);

% 4 corner of Iin
corners = [1    1     Iin_col   Iin_col;
    1    Iin_row   1     Iin_row;
    1    1     1     1  ;];
H = H / H(3,3);
transformedCorners = H * corners;

% calculate the range of output image size
for i=1:4
    transformedCorners(:,i) = transformedCorners(:,i)/transformedCorners(3,i);
end
Iwarp_maxRow = ceil(max(transformedCorners(2,:)));
Iwarp_maxCol = ceil(max(transformedCorners(1,:)));
Iwarp_minRow = floor(min(transformedCorners(2,:)));
Iwarp_minCol = floor(min(transformedCorners(1,:)));

Imerge_maxRow = max(Iwarp_maxRow, Iref_row);
Imerge_maxCol = max(Iwarp_maxCol, Iref_col);
Imerge_minRow = min(Iwarp_minRow, 0);
Imerge_minCol = min(Iwarp_minCol, 0);

% Initialize Iwarp and Imerge
Iwarp = uint8(zeros(Iwarp_maxRow-Iwarp_minRow, Iwarp_maxCol-Iwarp_minCol, 3));
Imerge = uint8(zeros(Imerge_maxRow-Imerge_minRow, Imerge_maxCol-Imerge_minCol, 3));


%% transform Iin using H.
% Bilinear interpolation
for k = 1:3
    for i = Iwarp_minCol:Iwarp_maxCol
        for j = Iwarp_minRow:Iwarp_maxRow
            p = (H\[i;j;1])';
            p = p/p(3);
            x = p(1); y = p(2);
            x_floor = ceil(x)-1; y_floor = ceil(y)-1;
            a = x-x_floor; b = y-y_floor;
            sum = 0;
            if x_floor > 0 && y_floor > 0 && x_floor < Iin_col && y_floor < Iin_row
                sum = sum + (1-a)*(1-b)*Iin(y_floor, x_floor, k);
                sum = sum + (1-a)*b*Iin(y_floor+1, x_floor, k);
                sum = sum + (1-b)*a*Iin(y_floor, x_floor+1, k);
                sum = sum + a*b*Iin(y_floor+1, x_floor+1, k);
            end
            Iwarp(j-Iwarp_minRow+1,i-Iwarp_minCol+1,k) = uint8(sum);
            Imerge(j-Imerge_minRow+1,i-Imerge_minCol+1,k) = uint8(sum);
        end
    end
end

% merge Iref with Iwarp.
Imerge(1-Imerge_minRow:(Iref_row-Imerge_minRow), 1-Imerge_minCol:(Iref_col-Imerge_minCol), :) = Iref;

% draw result images
imshow(Iwarp, 'XData', [Iwarp_minCol Iwarp_maxCol], 'YData', [Iwarp_minRow Iwarp_maxRow]);
axis on;
figure;
imshow(Imerge, 'XData', [Imerge_minCol Imerge_maxCol], 'YData', [Imerge_minRow Imerge_maxRow]);
axis on;

end