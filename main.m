% Classify a set of binary images stored inside directories in Images/
clear; close all; format short;

descriptors = 'ZERNIKE';
% TOGGLE
% descriptors = 'FOURIER';

if strcmp(descriptors,'FOURIER')
    FV_SIZE = 13;
else % ZERNIKE
    FV_SIZE = 16;
end


% Load all class directories from the Images folder
classDirectory = dir('Images/');
allClasses = {classDirectory([classDirectory.isdir]).name};
% Remove directories we don't care about
allClasses(ismember(allClasses,{'.','..','.DS_Store','Ignore'})) = [];
classNum = length(allClasses);

% Display the classes
disp(strcat(num2str(classNum), ' classes found:'));
disp(allClasses');

% Temporary cell arrays to store the class parameters, priors and test sets
allNames = cell(classNum);
allXbar = cell(classNum);
allCov = cell(classNum);
allTSet = cell(classNum);
confusionMat = zeros(classNum);
allPriors = cell(classNum);
trainingImgCount = 0;


% Find the largest class; all other classes will be oversampled to 
% match this size in the Parameters function (can be disabled). Calculate priors.
maxTrainingSet = 0;
for idx = 1:classNum
    directory = dir(strcat('Images/',allClasses{idx},'/'));
    trainingSetSize = ceil(3*length(directory)/4);
    allPriors{idx} = trainingSetSize;
    trainingImgCount = trainingImgCount + trainingSetSize;
    if trainingSetSize > maxTrainingSet
        maxTrainingSet = trainingSetSize;
    end
end
maxTrainingSet = maxTrainingSet-2;
disp(strcat(descriptors, ' descriptors.'));



% Populate classData (via allNames, allXbar etc.) with name/mean/covariances
% for each class' training data as well as the names of the randomly chosen test set
disp('Estimating parameters.');
for idx = 1:classNum
    dirName = allClasses{idx};
    allNames{idx} = dirName;
    if exist(strcat('Images/',dirName,'/'),'dir') == 0
       disp('Error: Individual image directory set incorrectly.');
    else
       p = parameters(dirName,FV_SIZE,maxTrainingSet,descriptors);
       allXbar{idx} = p.xbar;
       allCov{idx} = p.c;
       allTSet{idx} = p.testSet;
    end
end

classData = struct('name',allNames,...
                   'xbar',allXbar,...
                   'c',allCov,...
                   'testSet',allTSet,...
                   'prior', allPriors);

% Normalise the priors so they sum to 1
for idx = 1:classNum
    classData(idx).prior = classData(idx).prior/trainingImgCount;
end

% Classify each image and populate a confusion matrix
disp('Classifying testing images.');
for idx = 1:classNum
    for idx2 = 1:length(classData(idx).testSet)
        predicted = classify(classData,idx,idx2,descriptors,FV_SIZE);
        confusionMat(idx,predicted) = confusionMat(idx,predicted) + 1;
    end
end

% Display the confusion matrix and accuracy as a percentage
disp(confusionMat);
accuracy = matrixSpread(confusionMat,sum(sum(confusionMat)));
disp(strcat(num2str(accuracy), '% accurate.'));
