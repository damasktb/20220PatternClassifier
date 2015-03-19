function featureVector = featureVec(im, FEATURE_VEC_SIZE)
% %Show the binary image
% figure;
% imshow(im);
% title('Raw binary image');

%% Calculate and draw the chain code
% figure;
% imshow(im);
% title('Binary image with boundary overlayed');
% hold on;
c = chainCode(im);

% The first and second rows of 'c' contain the x and y co-ordinates; the
% third row contains the chain code, from 0 meaning vertically right, 1  
% meaning diagonally down and right, clockwise to 7 meaning diagonally up
% and right

%Plot the chain code
%plot( c(1,:), c(2,:), 'r.' );

%Reconstruct the shape from the the chain code itself, ie c(3,:)
% coordinates = reconstructChainCode(c(3,:));
% figure;
% title('Image reconstructed from chain code');
% hold on;
% plot( coordinates(1,:), coordinates(2,:),'LineWidth',3 );
% axis equal;

s = size(c);
s = s(:,2);
c = mod((c(3,2:s) - c(3,1:s-1)),8);
c = c ./ sum(c .^ 2);


%% filter using the FT of the angles of the chaincode
angles = c*(2*pi/8);
% Uncomment the next two lines to produce original chain code
%angles = chainCode(im);
%angles = angles(3,:)*(2*pi/8);

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

filteredFFT = anglesFFT .* filter; % Apply the filter by scalar multipliacation

%Reconstructed the angles using the inverse FFT
%The FFT works with imaginary numbers. Since all the numbers in the chain
%code are real, the reconstruction should be real too.
%reconstructedAngles = real(ifft(filteredFFT));
% reconstructedAngles = real(ifft(abs(filteredFFT))); 
featureVector = (abs(filteredFFT(1:N)))';
end