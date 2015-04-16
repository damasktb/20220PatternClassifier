% Return the sample mean & covariance, class size and random testing set
function params = parameters(dirName,FV_SIZE,maxTrainingSet,descriptors)

% Load the images from the directory
imgType = '*.gif';
imgPath = strcat('Images/',dirName,'/');
images = dir([imgPath imgType]);
% Some of the additional classes use jpegs
if isempty(images)
    imgType = '*.jpg';
    images = dir([imgPath imgType]);
end

% Randomly shuffle image names
shuffled = randperm(numel(images));
images = reshape(images(shuffled), size(images));
% Split the training and testing data in a 75:25 ratio
testSet = images(ceil(3*length(images)/4)+1:end);
images = images(1:ceil(3*length(images)/4));

% Comment out the following line to use minority class oversampling
maxTrainingSet = length(images);

allFeatureVecs = zeros(FV_SIZE,maxTrainingSet);

% Get the feature vectors for the directory and store them in allFeatureVecs
for idx = 1:maxTrainingSet
    if idx > length(images) % Oversample
        % Use standard oversampling (sampling with replacement)
        im = imread([imgPath images(randi([1, length(images)])).name]);
        allFeatureVecs(:,idx) = featureVec(descriptors,logical(im),FV_SIZE);
        % Uncomment to use basic synthetic oversampling instead
%         im1 = imread([imgPath images(randi([1, length(images)])).name]);
%         im2 = imread([imgPath images(randi([1, length(images)])).name]);
%         fv1 = featureVec(descriptors,logical(im1),FEATURE_VEC_SIZE);
%         fv2 = featureVec(descriptors,logical(im2),FEATURE_VEC_SIZE);
%         allFeatureVecs(:,idx) = (fv1+fv2)/2;
    else
        im = imread([imgPath images(idx).name]);
        allFeatureVecs(:,idx) = featureVec(descriptors,logical(im),FV_SIZE);
    end
end

% Compute the sample mean
mu = allFeatureVecs * ones(maxTrainingSet,1) / maxTrainingSet;
C = zeros(FV_SIZE);
for idx = 1:maxTrainingSet
   C = C + (allFeatureVecs(:,idx) - mu) * (allFeatureVecs(:,idx) - mu)';
end

% This is the sample covariance matrix (with Bessel's correction applied)
% Change maxTrainingSet-1 to maxTrainingSet to use the biased estimator
C = C / (length(images)-1);

% C must be full rank, if not, use EVD to decompose it and add eigenvalues
if rank(C) < FV_SIZE
    [U,L] = eig(C);
    % U is the matrix of eigenvectors, L is the matrix of normalised eigenvalues
    L = diag(L); % Get the leading diagonal of E
    L(L < 0.0001) = 0.0001; % Replace tiny diagonal elements with a larger value
    L = diag(L); % Turn it back into a square matrix
    C = U * L * U';
end

params = struct('xbar',mu,'c',C,'count',maxTrainingSet,'testSet',testSet);
