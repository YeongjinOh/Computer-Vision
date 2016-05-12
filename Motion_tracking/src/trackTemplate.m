% trackTemplate asks user to choose template region and track the template
% in the following consecuitve images. If the tracker lose the template,
% it terminate with error message.
% Input     - path_to_car_sequence : Path to the folder where input images
%                                   are contained
%           - sigma : Sigam value for gaussian smoothing
% output    - This function doesn't return anything, but it save the result
%            images in the output folder.
function trackTemplate(path_to_car_sequence, sigma)

%% Initialize
numimages = 700;
maxIterations = 3;          % maximum number of iterations
eps = 0.05;                 % accuracty desired in terms of pixel-width

% To check if tracker miss the template
maxConsecutiveOverDiff = 5;
countOverDiff = 0;
OverDiff = 20;

% Make output folder to save results.
mkdir('../result/output/');

% Load first input image
fname = sprintf('%s/%d.jpg',path_to_car_sequence,0);
F = double(imread(fname));
[ROW, COL] = size(F);
[X,Y] = meshgrid(1:COL, 1:ROW);     % meshgrid for translation

%% Select the region of interest
figure; imshow(uint8(F));
title('first input image');
disp('Click on the top-left and bottom-right corner of template region');
[tempX,tempY] = ginput(2);  % get two points from the user
close;

% Construct rectangle pointer (x1,y1), (x2,y2)
tempX = round(tempX);
tempY = round(tempY);
x1=tempX(1);x2=tempX(2);
y1=tempY(1);y2=tempY(2);

% Reorder the pointer so that (x1,y1) points to top-left and (x2, y2)
% points to bottom-right corner of region of interest.
if (x1>x2) tmp = x1;x1 = x2;x2 = tmp;clear tmp; end
if (y1>y2) tmp = y1;y1 = y2;y2 = tmp;clear tmp; end
row_roi = y2-y1+1;  col_roi = x2-x1+1;

% Initial template which has one more size of pixel to calculate more exact
% gradient
T = F(y1:y2+1,x1:x2+1);

% Gaussian smoothing only when input sigma is positive
if sigma > 0
    gaussianFilter = fspecial('gaussian',[3 3], sigma);
    T = imfilter(T, gaussianFilter, 'replicate');
end


%% Track the template in the following consecutive images.
for i=1:numimages
    sprintf('Image No. %d',i);
    
    % Load next image
    fname = sprintf('%s/%d.jpg',path_to_car_sequence,i);
    image_original = double(imread(fname));
    
    % Smooth the image using gaussian filter.
    if sigma > 0
        image_smooth = imfilter(image_original, gaussianFilter, 'replicate');
    else
        image_smooth = image_original;
    end
    image_warped = image_smooth;
    
    % Reset variables
    count=0;
    u=0;    v=0;
    du=1;   dv=1;  %initialize to dummy values
    
    % stopping criterion for the Newton-Raphson like iteration:
    % either the frame shift is less than 'eps' of pixel width
    % or maxIterations have been done
    while ((abs(du) > eps || abs(dv) > eps) && (count < maxIterations))
        
        count=count+1;
        SumOfIxIx = 0;        SumOfIxIy = 0;
        SumOfIyIy = 0;        SumOfIxIt = 0;
        SumOfIyIt = 0;
        
        % Calculate gradient
        Ix = (conv2(T,[1 -1; 1 -1], 'valid') + conv2(image_warped(y1:y2+1,x1:x2+1),[1 -1; 1 -1], 'valid'))/4;
        Iy = (conv2(T, [1 1; -1 -1], 'valid')  + conv2(image_warped(y1:y2+1,x1:x2+1), [1 1; -1 -1], 'valid'))/4;
        It = image_warped(y1:y2,x1:x2)-T(1:row_roi, 1:col_roi);
        Ix(isnan(Ix))=0; Iy(isnan(Iy))=0;  It(isnan(It))=0;  % NaN to zero
        
        % Calculate sum of gradient to implement area-based method
        for r = 1:row_roi
            for c = 1:col_roi
                SumOfIxIx = SumOfIxIx + Ix(r,c)*Ix(r,c);
                SumOfIxIy = SumOfIxIy + Ix(r,c)*Iy(r,c);
                SumOfIyIy = SumOfIyIy + Iy(r,c)*Iy(r,c);
                SumOfIxIt = SumOfIxIt + Ix(r,c)*It(r,c);
                SumOfIyIt = SumOfIyIt + Iy(r,c)*It(r,c);
            end
        end
        
        % Solve the least square to minimize optical flow constraint error:
        % E(u,v) = sum of (Ix*u + Iy*v + It)^2 in the region of interest.
        H = [SumOfIxIx SumOfIxIy; SumOfIxIy SumOfIyIy];
        b = -[SumOfIxIt; SumOfIyIt];
        p = H\b;
        du = p(1); dv = p(2);
        
        % Update u, v
        u = u+du;
        v = v+dv;
        
        % Translate and interpolate I using updated (u,v)
        [Xq,Yq] = meshgrid(1+u:COL+u, 1+v:ROW+v);
        image_warped = interp2(X,Y,image_smooth,Xq,Yq);
    end
    
    % Check if the object is inside of image domain
    if x1+u<1 || y1+v<1 || x2+u>COL || y2+v>ROW
        disp('The object is going out of the image domain');
        break;
    end
    
    % Calculate difference value to estimate if tracker lose the object
    Diff = abs(T(1:row_roi, 1:col_roi) - image_warped(y1:y2, x1:x2));
    Diff(Diff<20)=0;                            % ignore small differences
    Diff = sum(sum(Diff))/(row_roi*col_roi);    % calculate average.
    if (Diff > OverDiff)
        countOverDiff = countOverDiff + 1;
    else
        countOverDiff = 0;
    end
    
    % If tracker lose the object, display a message and exit.
    if (countOverDiff > maxConsecutiveOverDiff)
        disp('missed object');
        break;
    end
    
    % Draw image and rectangle, then save it in the output folder.
    close;
    fig = figure;
    imshow(uint8(image_original));
    title([num2str(i) '.jpg']);
    hold on;
    rectangle('Position', [x1+u y1+v x2-x1 y2-y1], 'Edgecolor','r', 'LineWidth', 2);
    print(fig,['../result/output/track' num2str(i)],'-djpeg');
    
    sprintf('No. of iterations: %d',count)
    
    % Update template area pointer and redundent of u, v
    x1 = ceil(x1 + u);    x2 = ceil(x2 + u);
    y1 = ceil(y1 + v);    y2 = ceil(y2 + v);
end

end


