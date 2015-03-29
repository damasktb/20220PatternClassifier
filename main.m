clear; close all; format short;

FEATURE_VEC_SIZE = 3;

% Load all class directories from the Images folder
classDirectory = dir('Images/');
allClasses = {classDirectory([classDirectory.isdir]).name};
% Remove directories we don't care about
allClasses(ismember(allClasses,{'.','..','.DS_Store','InvarianceTests'})) = [];
classNum = length(allClasses);

disp(strcat(num2str(classNum), ' classes found.'));
disp(allClasses);

% Temporary cell arrays to store the class parameters and test sets
allNames = cell(classNum);
allXbar = cell(classNum);
allCov = cell(classNum);
allTSet = cell(classNum);

% Populate classData (via allNames, allXbar etc.) with
% name/mean/covariances for each class' training data
% as well as the names of the randomly chosen test data
for idx = 1:classNum
    dirName = allClasses{idx};
    allNames{idx} = dirName;
    if exist(strcat('Images/',dirName,'/'),'dir') == 0
       disp('Error: Individual image directory set incorrectly.');
    else
       p = parameters(dirName,FEATURE_VEC_SIZE);
       allXbar{idx} = p.xbar;
       allCov{idx} = p.c;
       allTSet{idx} = p.testSet;
    end
end

classData = struct('name',allNames,'xbar',allXbar,'c',allCov,'testSet', allTSet);
classify(classData,5,3,FEATURE_VEC_SIZE)
                 