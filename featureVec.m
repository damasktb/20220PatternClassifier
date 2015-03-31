function featureVector = featureVec(im, FEATURE_VEC_SIZE)

%% Calculate and draw the chain code
%% filter using the FT of the angles of the chaincode


% c = chainCode(im);
% s = size(c);
% s = s(:,2);
% c = mod((c(3,2:s) - c(3,1:s-1)),8);
% c = c ./ sum(c .^2);
% angles = c*(2*pi/8);

% Uncomment the next two lines to produce original chain code
angles = chainCode(im);
angles = (2*pi/8) * angles(3,:);

anglesFFT = fft(angles); %fast fourier transform

% Filter using a 'top hat' filter. The filter conists of the value one for 
%the lowest Nfrequencies and zero elsewhere.
N = FEATURE_VEC_SIZE; %number of lowest frequencies to keep
filter = zeros(size(angles)); 

%Both the positive and negative low frequencies must be kept
%filter(1) is the zero (DC) frequency, so there will be (N*2)-1 ones in
%total

filter(1:N) = 1; 
filter(end-N+2:end) = 1;

filteredFFT = anglesFFT .* filter;

% Apply the filter by scalar multipliacation


%Reconstructed the angles using the inverse FFT
%The FFT works with imaginary numbers. Since all the numbers in the chain
%code are real, the reconstruction should be real too.
%reconstructedAngles = real(ifft(filteredFFT));
% reconstructedAngles = real(ifft(abs(filteredFFT))); 

featureVector = (abs(filteredFFT(1:N)))';

end