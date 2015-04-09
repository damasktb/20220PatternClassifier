% Return the sample mean & covariance, class size and random testing set
function params = parameters(dirName,FV_SIZE,maxTrainingSet)

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
% split the training and testing data in a 75:25 ratio
testSet = images(ceil(3*length(images)/4)+1:length(images));
images = images(1:ceil(3*length(images)/4));
% Uncomment this line to stop oversampling occuring
% maxTrainingSet = length(images);

allFeatureVecs = zeros(FV_SIZE,maxTrainingSet);

% Get the feature vectors for the directory and store them in allFeatureVecs
for idx = 1:maxTrainingSet
    if idx > length(images) % Oversample
        % Use standard oversampling
        im = imread([imgPath images(randi([1, length(images)])).name]);
        allFeatureVecs(:,idx) = featureVec(logical(im),FV_SIZE);
        % Use basic synthetic oversampling instead
%         im1 = imread([imgPath images(randi([1, length(images)])).name]);
%         im2 = imread([imgPath images(randi([1, length(images)])).name]);
%         fv1 = featureVec(logical(im1),FEATURE_VEC_SIZE);
%         fv2 = featureVec(logical(im2),FEATURE_VEC_SIZE);
%         allFeatureVecs(:,idx) = (fv1+fv2)/2;
    else
        im = imread([imgPath images(idx).name]);
        allFeatureVecs(:,idx) = featureVec(logical(im),FV_SIZE);
    end
end

% Compute the sample mean
mu = allFeatureVecs * ones(maxTrainingSet,1) / maxTrainingSet;

C = zeros(FV_SIZE);
for idx = 1:maxTrainingSet
   C = C + (allFeatureVecs(:,idx) - mu) * (allFeatureVecs(:,idx) - mu)';
end

% This is the sample covariance matrix (with Bessel's correction applied)
% Change length(images)-1 to length(images) to use the biased estimator
C = C / (maxTrainingSet-1);

params = struct('xbar',mu,'c',C,'count',maxTrainingSet,'testSet',testSet);
