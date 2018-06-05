% param.method = 'MOSSE';
% param.method = 'KCF';


switch param.method
case 'MOSSE',
    param.interp_factor = 0.075;  %linear interpolation factor for adaptation
    
    param.kernel.type = 'linear';
    param.kernel.sigma = 0.2;  %gaussian kernel bandwidth

    param.kernel.poly_a = 1;  %polynomial kernel additive term
    param.kernel.poly_b = 7;  %polynomial kernel exponent

    param.features.gray = true;
    param.features.hog = false;
    param.cell_size = 1;
    
    param.obs_thr = 0.45;                    % Threshold for local and global association
    param.type_thr = 0.57;                   % Threshold for changing a tracklet type


case 'KCF',
    param.interp_factor = 0.02;
    
    param.kernel.type = 'gaussian';
    param.kernel.sigma = 0.5;

    param.kernel.poly_a = 1;
    param.kernel.poly_b = 9;

    param.features.hog = true;
    param.features.gray = false;
    param.features.hog_orientations = 9;
    param.cell_size = 4;

    param.obs_thr = 0.28; % 0.4;     %0.28                % Threshold for local and global association 0.4
    param.type_thr = 0.35; % 0.5;    %0.35               % Threshold for changing a tracklet type  0.5

% case 'HCF',
%     param.~~~~~~    



otherwise
    error('Unknown method.')
end
param.padding = 3;  %extra area surrounding the target
param.lambda = 1e-4;  %regularization
param.output_sigma_factor = 0.1;

param.target_sz = [100,41];
param.window_sz = [120,60];

output_sigma = sqrt(prod(param.target_sz)) * param.output_sigma_factor / param.cell_size;
param.yf = fft2(gaussian_shaped_labels(output_sigma, floor(param.window_sz / param.cell_size)));

%store pre-computed cosine window
param.cos_window = hann(size(param.yf,1)) * hann(size(param.yf,2))';