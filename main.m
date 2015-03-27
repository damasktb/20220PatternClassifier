clear; close all; format short;

FEATURE_VEC_SIZE = 5;

classDirectory = 'Images/';
if exist(classDirectory,'dir') == 0
    disp('Error: Class directory set incorrectly.');
    return;
end

d = dir(classDirectory);
class = [d(:).isdir];
classes = {d(class).name}';
classes(ismember(classes,{'.','..','.DS_Store'})) = [];

allNames = {}; allXbar = {}; allCov =  {};

for idx = 1:length(classes)
    name = classes(idx);
    dirName = name{1};
    allNames{idx} = dirName;
    if exist(strcat(classDirectory,dirName,'/'),'dir') == 0
%       disp('Error: Individual image directory set incorrectly.');
    else
       p = parameters(dirName,FEATURE_VEC_SIZE);
       allXbar{idx} = p.xbar;
       allCov{idx} = p.c;
    end
end

classParams = struct('name',allNames,'xbar',allXbar,'c',allCov)

for idx = 1:length(classParams)
    disp(classParams(idx).name);
    disp(classParams(idx).xbar);
    disp(classParams(idx).c);
end

% dirName = 'Arrow';
% if exist(strcat(classDirectory,dirName,'/'),'dir') == 0
%     disp('Error: Individual image directory set incorrectly.');
%     return;
% end


