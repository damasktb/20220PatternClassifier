clear; close all; format short;

FEATURE_VEC_SIZE = 2;
% Change Arrow to any other directory name to switch classes
imgPath = 'Images/Toonface/';
if exist(imgPath, 'dir') == 0
    disp('Error: Image directory set incorrectly');
    return;
end
params = parameters(imgPath,FEATURE_VEC_SIZE);
mu1 = params(:,1);
C1 = params(:,2:length(params));

imgPath2 = 'Images/Arrow/';
params2 = parameters(imgPath2,FEATURE_VEC_SIZE);
mu2 = params2(:,1);
C2 = params2(:,2:length(params2));

mu = [0 0];
mu = mu2'
Sigma = [.25 .3; .3 1];
Sigma = C2 / C2; %%%%%%%%%%%%
x1 = -5:.2:5; x2 = -5:.2:5;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
surf(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([-5 5 -5 5 0 .5])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');