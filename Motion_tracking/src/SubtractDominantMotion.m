% SubtractDominantMotion extracts Moving_image between image1 and image2
% by subtracting dominant motion. This function implement lucas-kanade
% algorithm iteratively, so would take time quite much. You can adjust some
% constants, NormThreshold, MaxIterations, in order to shorten time.
% Input     - image1 : Previous image. The entire part of image1 is used as
%                     template image T when implementing lucas-kanade.
%           - image2 : Next image on which the moving_image is based.
% output    - Moving_image : A binary image of the same size as the input
%                           images, in which the nonzero pixels correspond
%                           to locations of moving objects.
function [Moving_image] = SubtractDominantMotion(image1, image2)

%% Initialize
p = zeros(6,1);                     % warp parameters
dp = zeros(6,1);                    % delta p
[ROW, COL] = size(image1);
I = zeros(ROW, COL);
I_Subtracted = zeros(ROW, COL);
Gx = zeros(ROW, COL);
Gy = zeros(ROW, COL);

DiffThreshold = 20;                 % threshold of difference for strong edge
NormThreshold = 0.01;               % norm threshold of delta p
MaxIterations = 30;                 % maximal iteration for while loop

%% Build gradient of I
Gx(:,1:COL-1) = conv2(image2,[-1 1], 'valid');
Gy(1:ROW-1,:) = conv2(image2, [-1;1], 'valid');

%% Implement Lucas-Kanade algorithm

% Set dummy value for the first iteration.
dp(1) = NormThreshold+1;
cnt = 0;

% Iterate until dp converges or it reach to the maximal iteration.
while norm(dp) > NormThreshold && cnt < MaxIterations
    cnt = cnt + 1;
    
    % Reset the initail values
    T = [1 0 0; 0 1 0; 0 0 1] + [reshape(p,2,3); 0 0 0];
    H = zeros(6,6);                     % Hessian matrix
    Hdp = zeros(6,1);                   % H * delta p
    
    % Implement each step of lucas-kanade pixel by pixel.
    for i = 1 : ROW
        for j = 1 : COL
            
            % calculate warp W(x;p)
            % W transforms current point (j,i) into (x_warped, y_warped)
            t = (T\[j;i;1])';
            t = t/t(3);
            x = t(1); y = t(2);
            x_warped = ceil(x)-1; y_warped = ceil(y)-1;
            a = x-x_warped; b = y-y_warped;
            
            % Check if W(x;p) is inside of image domain, then implement
            % lucas-kanade algorithm if true.
            if x_warped > 0 && y_warped > 0 && x_warped < COL && y_warped < ROW
                
                % Step 1. Warp I with W(x;p) to I(W(x;p))
                I_warped = (1-a)*(1-b)*image2(y_warped, x_warped);
                I_warped = I_warped + (1-a)*b*image2(y_warped+1, x_warped);
                I_warped = I_warped + (1-b)*a*image2(y_warped, x_warped+1);
                I_warped = I_warped + a*b*image2(y_warped+1, x_warped+1);
                
                % Step 2. Compute error image T(x) - I(W(x;p)) at current
                % point x.
                E = image1(i,j)-I_warped;
                
                % Step 3. Warp gradient of I to compute gradient(I(W(x;p))).
                Gx_warped = (1-a)*(1-b)*Gx(y_warped, x_warped);
                Gx_warped = Gx_warped + (1-a)*b*Gx(y_warped+1, x_warped);
                Gx_warped = Gx_warped + (1-b)*a*Gx(y_warped, x_warped+1);
                Gx_warped = Gx_warped + a*b*Gx(y_warped+1, x_warped+1);
                
                Gy_warped = (1-a)*(1-b)*Gy(y_warped, x_warped);
                Gy_warped = Gy_warped + (1-a)*b*Gy(y_warped+1, x_warped);
                Gy_warped = Gy_warped + (1-b)*a*Gy(y_warped, x_warped+1);
                Gy_warped = Gy_warped + a*b*Gy(y_warped+1, x_warped+1);
                
                % Step 4. Evaluate Jacobian matrix.
                J = [x_warped 0 y_warped 0 1 0 ;
                    0 x_warped 0 y_warped 0 1];
                
                % Step 5. Compute Hessian matrix.
                G_warped = [Gx_warped, Gy_warped];
                subH = G_warped*J;
                H = H + subH'*subH;
                
                % Step 6. Compute (H * delta p)
                Hdp = Hdp + subH'*E;
            end
        end
    end
    
    % Get delta p from H*dp
    dp = H\Hdp;
    
    % Step 7. update parameters p
    p = p + dp;
end

%% Warp image1 into I
T = [1 0 0; 0 1 0; 0 0 1] + [reshape(p,2,3); 0 0 0];
for i = 1 : ROW
    for j = 1 : COL
        
        % Calculate warped point.
        t = (T*[j;i;1])';
        t = t/t(3);
        x = t(1); y = t(2);
        x_warped = ceil(x)-1; y_warped = ceil(y)-1;
        a = x-x_warped; b = y-y_warped;
        
        % Check if the warped point is inside of image domain.
        if x_warped > 0 && y_warped > 0 && x_warped < COL && y_warped < ROW
            
            % Warp using bilinear interpolation.
            I_warped = (1-a)*(1-b)*image1(y_warped, x_warped);
            I_warped = I_warped + (1-a)*b*image1(y_warped+1, x_warped);
            I_warped = I_warped + (1-b)*a*image1(y_warped, x_warped+1);
            I_warped = I_warped + a*b*image1(y_warped+1, x_warped+1);
            I(i,j) = I_warped;
            
            % Calculate subtracted image only in the valid domain.
            I_Subtracted(i,j) = image2(i,j) - I_warped;
        end
    end
end

%% Extract dominant motion
Moving_image = (I_Subtracted>DiffThreshold);
Moving_image = removeNoise(Moving_image);

end