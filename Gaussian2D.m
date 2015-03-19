clear all;
close all;

%%
L = 10; % limits of a square around the origin
X = -L:L; % x locations
Y = -L:L; % y locations
mu = [3;-2.4]; % the mean
theta = 30*pi/180; % roation angle
R = [cos(theta) -sin(theta); sin(theta) cos(theta)]; % rotation, orthonormal
S = [3 0; 0 1]; % scale, a diagonal matrix
C = R*S*R'; % the covariance, the product of three
px_g = zeros( 2*L+1, 2*L+1 ); % an array to hold the Gaussian
K = 1/(2*pi*sqrt(det(C))); % a constant
iC = inv(C);
for j = 1:length(Y)
  for i = 1:length(X)
     x = X(i) - mu(1);
     y = Y(j) -  mu(2);
     px_g(j,i) = exp( -0.5* [x y] * iC * [x; y] ); % /K;
  end
end

figure
surf( px_g );

%% The same, but faster - no loops


L = 10;
[x,y] = meshgrid( -L:L );
mu = [3; -2.4]; % the mean
theta = 30*pi/180;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)]; % rotation, orthonormal
S = [3 0; 0 1]; % scale, a diagonal matrix
C = R*S*R'; % the covariance, the product of three matrices
iC = inv(C);
z = [x(:) - mu(1) , y(:)-mu(2)]'; % string all locations out into an array, with mean subtracted
pz_g = exp( -0.5*sum( z .* (iC *z), 1 ) ) / (2*pi*sqrt(det(C)));
pz_g = reshape( pz_g, size(x) );

figure
surf(x,y,pz_g);



