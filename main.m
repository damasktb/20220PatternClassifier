clear; close all; format short;

FEATURE_VEC_SIZE = 5;

classDirectory = dir('Images/');
class = [classDirectory(:).isdir];
classes = {classDirectory(class).name}';
classes(ismember(classes,{'.','..','.DS_Store'})) = [];
classNum = length(classes)

allNames = cell(classNum); allXbar = cell(classNum); allCov = cell(classNum); allTSet = {};

for idx = 1%1:length(classes)
    name = classes(idx);
    dirName = name{1};
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

classParams = struct('name',allNames, ...
                     'xbar',allXbar, ...
                     'c',allCov, ...
                     'testSet', allTSet);
                 
classParams(4).testSet.name

