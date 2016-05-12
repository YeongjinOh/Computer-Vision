% removeNoise removes noise in input image and return cleared image.
% It regard the pixels which are not dense as noise. The dense pixel means
% the pixel which is  marked and which has more than 6 marked neighbors.
% Also, if there are too many noise pixels, regarding the result unuseful,
% it clear all marked pixels.
% Input     - NoiseImage : A binary image which might contain noise.
% output    - ClearImage : A binary image obtained by removing all noises
%                         in input image.
function ClearImage = removeNoise(NoiseImage)

%% Initialize
[ROW, COL] = size(NoiseImage);
ClearImage = zeros(ROW, COL);
row_off = [-1 -1 -1 0 1 1 1 0];
col_off = [-1 0 1 1 1 0 -1 -1];

MaximumNoiseRatio = 1/40;     % Set maximum noise ratio among entire image.

%% Find dense pixels
for r = 2 : ROW-1
    for c = 2 : COL-1
        
        % Only check marked pixels
        if (NoiseImage(r,c) == 0)
            continue;
        end
        
        % Check 8-directional neighbors of (r,c)
        rCheck = r+row_off;
        cCheck = c+col_off;
        cnt = 0;
        for i = 1:8
            if (NoiseImage(rCheck(i),cCheck(i)) > 0)
                cnt = cnt + 1;
            end
        end
        if (cnt > 6)
            ClearImage(r,c) = NoiseImage(r,c);
        end
   
    end
end

%% Reconstruct neighbors of dense pixels
for r = 2 : ROW-1
    for c = 2 : COL-1
        
        % Only check dense pixels
        if (ClearImage(r,c) == 0)
            continue;
        end
        
        % Set coordinates of neighbors
        rCheck = r+row_off;
        cCheck = c+col_off;
        
        % Reconstruct if the neighbor is marked
        for i = 1:8
            if (NoiseImage(rCheck(i),cCheck(i)) > 0)
                ClearImage(rCheck(i),cCheck(i)) = NoiseImage(rCheck(i),cCheck(i));
            end
        end   
    end
end

%% Clear all pixels if there are too many noise pixels.
if sum(sum(ClearImage)) > (ROW*COL)*MaximumNoiseRatio
    ClearImage = zeros(ROW, COL);
end

end


