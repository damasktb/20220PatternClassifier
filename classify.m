function classification = classify(classData,class,img,FEATURE_VEC_SIZE)
    imgPath = strcat('Images/',classData(class).name,'/');
                 
    im = imread([imgPath classData(class).testSet(img).name]); 	
    fv = featureVec(logical(im),FEATURE_VEC_SIZE);
    
    maxClass = struct('idx',0,'probability',0);
    
    for idx = 1:length(classData)
        cdx = classData(idx);
        p = exp(-1/2 * (fv-cdx.xbar)' * pinv(cdx.c) * (fv-cdx.xbar)) / ...
            ((sqrt(det(cdx.c)))*2*pi^(FEATURE_VEC_SIZE/2));
        prob = log(p);
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

