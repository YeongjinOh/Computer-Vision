% This function computes the projective transformation matrix H,
% called homography, using the input arrays whose size of 2 by N.
% t2 is the list of points in reference image.
% t1 is the list of points in the other image corresponding to the point
% in t2.

function H = computeH (t1, t2)

%% Check the correctness of inputs t1, t2
if size(t1) ~= size(t2)
    error('t1 and t2 have differenet size');
end

if size(t2,2) < 4
    error('Input points does not have enought points');
end

if size(t2,1) ~= 2
    error('Input matrices must have two rows');
end

%% Initialization
N = size (t2, 2);
A = zeros (2*N, 8);
B = zeros(2*N,1);


%% Uniform scaling to avoid numerical issues.
scale_factor = 1/100;
t2 = t2 * scale_factor;
t1 = t1 * scale_factor;

% Scaling matrix C
C = zeros(3,3);
C(1,1) = scale_factor;
C(2,2) = scale_factor;
C(3,3) = 1;

%% Build A & B
for i = 1 : N
    % Build A
    p = [t1(1,i), t1(2,i), 1];
    o = zeros(1,3);
    A(2*i-1:2*i,:) = [p, o, -t2(1,i)*p(1:2); o, p, -t2(2,i)*p(1:2)];
    
    % Build B
    B(2*i-1:2*i) = t2(:,i);
end

%% Compute H
% Solve a least square problme || Ah-B ||
h = [A\B; 1];
H = (reshape(h, 3, 3)).';

% Rescale H back to the original scale.
H = inv(C)*H*C;
H = H / norm(H,'fro');

end
