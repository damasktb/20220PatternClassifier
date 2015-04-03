function params = parameters(dirName,FEATURE_VEC_SIZE,maxTrainingSet)

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
testSet = images(ceil(3*length(images)/4)+1:length(images));
images = images(1:ceil(3*length(images)/4));

% Uncomment this to stop oversampling
maxTrainingSet = length(images);

allFeatureVecs = zeros(FEATURE_VEC_SIZE,maxTrainingSet);

% To get the feature vec from the original chain codes (as opposed to the first
% order differences normalised) uncomment lines 39 and 40 in featureVec.m

% Get the feature vectors for the directory and store them in allFeatureVecs
for idx = 1:maxTrainingSet
    % Oversample!
    if idx > length(images)
        im = imread([imgPath images(randi([1, length(images)])).name]);
        allFeatureVecs(:,idx) = featureVec(logical(im),FEATURE_VEC_SIZE);
%         im1 = imread([imgPath images(randi([1, length(images)])).name]);
%         im2 = imread([imgPath images(randi([1, length(images)])).name]);
%         fv1 = featureVec(logical(im1),FEATURE_VEC_SIZE);
%         fv2 = featureVec(logical(im2),FEATURE_VEC_SIZE);
%         allFeatureVecs(:,idx) = (fv1+fv2)/2;
    else
        im = imread([imgPath images(idx).name]);
        allFeatureVecs(:,idx) = featureVec(logical(im),FEATURE_VEC_SIZE);
    end
end

% This is the mean vector
mu = allFeatureVecs * ones(maxTrainingSet,1) / maxTrainingSet;

% Iterate through the images, summing the products of each feature
% vector minus the mean by its transpose
C = zeros(FEATURE_VEC_SIZE);
for idx = 1:maxTrainingSet
   C = C + (allFeatureVecs(:,idx) - mu) * (allFeatureVecs(:,idx) - mu)';
end
% This is the sample covariance matrix (with Bessel's correction applied)
% Change length(images)-1 to length(images) to use the biased estimator
C = C / (maxTrainingSet-1);
params = struct('xbar', mu, 'c', C, 'count',maxTrainingSet,'testSet', testSet);
