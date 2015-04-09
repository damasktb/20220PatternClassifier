% MAP classification for a binary image
function classification = classify(classData,class,img,FEATURE_VEC_SIZE)
    % Load the image and calculate its feature vector
    imgPath = strcat('Images/',classData(class).name,'/');          
    im = imread([imgPath classData(class).testSet(img).name]); 	
    fv = featureVec(logical(im),FEATURE_VEC_SIZE);
    
    % Choose the class with the highest posterior probability 
    maxClass = struct('idx',0,'probability',0);
    for idx = 1:length(classData)
        cdx = classData(idx);
        % Use the pseudoinverse because c is singular or close to singular
        p = exp(-1/2 * (fv-cdx.xbar)' * pinv(cdx.c) * (fv-cdx.xbar)) / ...
            ((sqrt(det(cdx.c)))*2*pi^(FEATURE_VEC_SIZE/2));
        % Taking logs lets us work with bigger numbers
        prob = log(p) + log(classData(idx).prior);
        if idx == 1
            maxClass.probability = prob;
            maxClass.idx = 1;
        elseif prob > maxClass.probability
            maxClass.probability = prob;
            maxClass.idx = idx;
        end
    end
    classification = maxClass.idx;
end

