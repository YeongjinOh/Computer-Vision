function g = extractResponseVectors(Image)

%% Initialization
% S = 10;
% K = 10;
S = 4;
K = 8;

Uh = 0.4;
Ul = 0.1;
a = (Uh/Ul)^(1/(S-1));
alpha = (a+1)/(a-1);
s_x = (1/(2*pi))*alpha*(sqrt(2*log(2))/Uh);
s_y = (1/(2*pi))/(tan(pi/(2*K))/(2*pi)*sqrt((alpha^2-1)/s_x^2));
W = 0.52;

%% Build mesh grid
% Get image size
sz = size(Image);
img_rows = sz(1);
img_cols = sz(2);

% Set filter size
filter_size = ceil(max(s_x,s_y))*2
[X Y] = meshgrid(-filter_size/2:filter_size/2,-filter_size/2:filter_size/2);

%% Extract Response Vectors
for n = 0 : K-1
    for m = 0 : S-1
    
        % Get filter
        theta = n*pi/K;
        X_ = a^(-m)*(X.*cos(theta)+Y.*sin(theta)) ;
        Y_ = a^(-m)*(-X.*sin(theta)+Y.*cos(theta)) ;
        g_mn= (1/(2*pi*s_x*s_y))*exp(complex(-1/2*(X_.^2/s_x^2+Y_.^2/s_y^2),2*pi*W.*X_));
                
        % Apply filter to the image
        I_complex = imfilter(double(Image), imag(g_mn), 'symmetric');
        I_real = imfilter(double(Image), real(g_mn), 'symmetric');
        I_mag = sqrt(I_complex.^2 + I_real.^2);

        % To check the filtered image
        % imshow(I_mag);
        % pause(0.1);
        
        g(:,S*n+m+1) = reshape(I_mag,img_rows*img_cols,[]);
    end
end

