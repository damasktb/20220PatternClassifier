% Calculate the feature vector for a binary image
function featureVector = featureVec(im, FEATURE_VEC_SIZE)

% Use the absolute value of the Zernike Moments up to degree 6 as a feature vector
% Uncomment lines 14-31 and comment 7-12 to switch back to standard feature
% extraction using filtered fourier-transformed chain code
imsize = 40;
% The image needs to be square
m=centersquare(im,imsize);
% abs() gets rid of the phase component (the complex argument)
fv = abs(zernike_mom(m,zernike_bf(imsize,6)));
featureVector = fv ./ sum(fv);

% % Get the chain code for the image
% angles = chainCode(im);
% angles = (2*pi/8) * angles(3,:);
% % Take the fourier transform
% anglesFFT = fft(angles); 
% % Filter using a 'top hat' filter. The filter conists of the value one for 
% %the lowest N frequencies and zero elsewhere.
% N = FEATURE_VEC_SIZE; %number of lowest frequencies to keep
% filter = zeros(size(angles)); 
% 
% %Both the positive and negative low frequencies must be kept
% %filter(1) is the zero (DC) frequency, so there will be (N*2)-1 ones in
% %total
% filter(1:N) = 1; 
% filter(end-N+2:end) = 1;
% filteredFFT = anglesFFT .* filter;
% % Apply the filter by scalar multipliacation
% featureVector = (abs(filteredFFT(1:N)))';
end