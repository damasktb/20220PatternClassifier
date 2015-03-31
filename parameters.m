function params = parameters(dirName,FEATURE_VEC_SIZE)

% Load the images from the directory
imgType = '*.gif';
imgPath = strcat('Images/',dirName,'/');
images = dir([imgPath imgType]);

% Some of the additional classes use jpegs
if isempty(images)
    imgType = '*.jpg';
    images = dir([imgPath imgType]);
end

% Randomly shuffle them and divide in half, giving test and training sets
shuffled = randperm(numel(images));
images = reshape(images(shuffled), size(images));

% 75:25
testSet = images(3*ceil(length(images)/4)+1:length(images));
images = images(1:3*ceil(length(images)/4));

allFeatureVecs = zeros(FEATURE_VEC_SIZE,length(images));

% To get the feature vec from the original chain codes (as opposed to the first
% order differences normalised) uncomment lines 39 and 40 in featureVec.m

% Get the feature vectors for the directory and store them in allFeatureVecs
for idx = 1:length(images)
    im = imread([imgPath images(idx).name]);
	allFeatureVecs(:,idx) = featureVec(logical(im),FEATURE_VEC_SIZE);
end

% This is the mean vector
mu = allFeatureVecs * ones(length(images),1) / length(images);

% Iterate through the images, summing the products of each feature
% vector minus the mean by its transpose
C = zeros(FEATURE_VEC_SIZE);
for idx = 1:length(images)
   C = C + (allFeatureVecs(:,idx) - mu) * (allFeatureVecs(:,idx) - mu)';
end
% This is the sample covariance matrix (with Bessel's correction applied)
% Change length(images)-1 to length(images) to use the biased estimator
C = C / (length(images)-1);
params = struct('xbar', mu, 'c', C, 'count',length(images),'testSet', testSet);
