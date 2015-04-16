% MAP classification for a binary image
function classification = classify(classData,class,img,descriptors,FV_SIZE)
    % Load the image and calculate its feature vector
    imgPath = strcat('Images/',classData(class).name,'/');          
    im = imread([imgPath classData(class).testSet(img).name]); 	
    fv = featureVec(descriptors,logical(im),FV_SIZE);
    % Choose the class with the highest posterior probability 
    maxClass = struct('idx',0,'probability',0);
    for idx = 1:length(classData)
        cdx = classData(idx);
        % Use the pseudoinverse because c is singular or close to singular
        p = exp(-1/2 * (fv-cdx.xbar)' * inv(cdx.c) * (fv-cdx.xbar)) / ...
        ((sqrt(det(cdx.c)))*2*pi^(FV_SIZE/2));
        % Taking logs allows us work with bigger numbers
        prob = log(p) + log(cdx.prior);
        if idx == 1
            maxClass.probability = prob;
            maxClass.idx = 1;
        elseif prob > maxClass.probability
            maxClass.probability = prob;
            maxClass.idx = idx;
        end
    end
    % This is the index of the predicted class in classData (in main)
    classification = maxClass.idx;
end

