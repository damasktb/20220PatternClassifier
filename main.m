clear; close all; format short;

FV_SIZE = 13;

% Load all class directories from the Images folder
classDirectory = dir('Images/');
allClasses = {classDirectory([classDirectory.isdir]).name};
% Remove directories we don't care about
allClasses(ismember(allClasses,{'.','..','.DS_Store','Ignore'})) = [];
classNum = length(allClasses);

disp(strcat(num2str(classNum), ' classes found.'));

% Temporary cell arrays to store the class parameters and test sets
allNames = cell(classNum);
allXbar = cell(classNum);
allCov = cell(classNum);
allTSet = cell(classNum);

confusionMat = zeros(classNum);
allPriors = cell(classNum);
trainingImgCount = 0;

maxTrainingSet = 0;
for idx = 1:classNum
    directory = dir(strcat('Images/',allClasses{idx},'/'));
    trainingSetSize = ceil(3*length(directory)/4);
    if trainingSetSize > maxTrainingSet
        maxTrainingSet = trainingSetSize;
    end
end

results = zeros(10,1);

for idxx = 1:10
    for idx = 1:classNum
        dirName = allClasses{idx};
        allNames{idx} = dirName;
        if exist(strcat('Images/',dirName,'/'),'dir') == 0
           disp('Error: Individual image directory set incorrectly.');
        else
           p = parameters(dirName,FV_SIZE,maxTrainingSet);
           allXbar{idx} = p.xbar;
           allCov{idx} = p.c;
           allTSet{idx} = p.testSet;
           allPriors{idx} = p.count;
           trainingImgCount = trainingImgCount+length(p.testSet);
        end
    end

    classData = struct('name',allNames,...
                       'xbar',allXbar,...
                       'c',allCov,...
                       'testSet',allTSet,...
                       'prior', allPriors);

    for idx = 1:classNum
        classData(idx).prior = classData(idx).prior/trainingImgCount;
    end

    for idx = 1:classNum
        for idx2 = 1:length(classData(idx).testSet)
            predicted = classify(classData,idx,idx2,FV_SIZE);
            confusionMat(idx,predicted) = confusionMat(idx,predicted) + 1;
        end
    end
    results(idxx,1) = matrixSpread(confusionMat,trainingImgCount);
end
mean(results)

% Populate classData (via allNames, allXbar etc.) with
% name/mean/covariances for each class' training data
% as well as the names of the randomly chosen test data
for idx = 1:classNum
    dirName = allClasses{idx};
    allNames{idx} = dirName;
    if exist(strcat('Images/',dirName,'/'),'dir') == 0
       disp('Error: Individual image directory set incorrectly.');
    else
       p = parameters(dirName,FV_SIZE,maxTrainingSet);
       allXbar{idx} = p.xbar;
       allCov{idx} = p.c;
       allTSet{idx} = p.testSet;
       allPriors{idx} = p.count;
       trainingImgCount = trainingImgCount+length(p.testSet);
    end
end
    
classData = struct('name',allNames,...
                   'xbar',allXbar,...
                   'c',allCov,...
                   'testSet',allTSet,...
                   'prior', allPriors);
               
for idx = 1:classNum
    classData(idx).prior = classData(idx).prior/trainingImgCount;
end

for idx = 1:classNum
    for idx2 = 1:length(classData(idx).testSet)
        predicted = classify(classData,idx,idx2,FV_SIZE);
        confusionMat(idx,predicted) = confusionMat(idx,predicted) + 1;
    end
end



disp(confusionMat);
disp(matrixSpread(confusionMat,trainingImgCount));
