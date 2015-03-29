function params = parameters(dirName,FEATURE_VEC_SIZE)

% Load the images from the directory
imgType = '*.gif';
imgPath = strcat('Images/',dirName,'/');
images = dir([imgPath imgType]);

if length(images) == 0
    imgType = '*.jpg';
    images = dir([imgPath imgType]);
end

% Randomly shuffle them and divide in half, giving test and training sets
shuffled = randperm(numel(images));
images = reshape(images(shuffled), size(images));
testSet = images(ceil(length(images)/2)+1:length(images));
images = images(1:ceil(length(images)/2));

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
