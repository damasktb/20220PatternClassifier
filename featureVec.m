% Calculate the feature vector for a binary image
function featureVector = featureVec(descriptors, im, FV_SIZE)
% FV_SIZE is needed if you revert to fourier descriptors

if strcmp(descriptors,'ZERNIKE')
    % Use the absolute value of the Zernike Moments up to degree 6 as a feature vector
    % Uncomment lines 14-31 and comment 7-12 to switch back to standard feature
    % extraction using filtered fourier-transformed chain code
    imsize = 45;
    % The image needs to be centred on a unit square
    m = centersquare(im,imsize);
    % abs() gets rid of the phase component (the complex argument)
    % Calculate the Zernike moments up to degree 6
    fv = abs(zernike_mom(m,zernike_bf(imsize,6)));
    featureVector = fv / sum(fv);
else
    % Get the chain code for the image
    angles = chainCode(im);
    angles = (2*pi/8) * angles(3,:);
    % Take the fourier transform
    anglesFFT = fft(angles); 
    % Filter using a 'top hat' filter.
    filter = zeros(size(angles)); 
    % Both the positive and negative low frequencies must be kept
    filter(1:FV_SIZE) = 1; 
    filter(end-FV_SIZE+2:end) = 1;
    filteredFFT = anglesFFT .* filter;
    % abs() gets rid of the phase component (the complex argument)
    featureVector = (abs(filteredFFT(1:FV_SIZE)))';
end
end