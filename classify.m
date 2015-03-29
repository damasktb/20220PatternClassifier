function classification = classify(classData,class,img,FEATURE_VEC_SIZE)
 % maximise
    imgPath = strcat('Images/',classData(class).name,'/');
                 
    im = imread([imgPath classData(class).testSet(img).name]); 	
    fv = featureVec(logical(im),FEATURE_VEC_SIZE);
    
    maxClass = struct('name',0,'probability',0);
    
    for idx = 1:length(classData)
        cdx = classData(idx);
        frac = 1/((2*sqrt(pi))*(sqrt(det(cdx.c))));
        ex = exp(-1/2 * (fv-cdx.xbar)' * pinv(cdx.c) * (fv-cdx.xbar));
        prob = frac*ex;
        if prob > maxClass.probability
            maxClass.probability = prob;
            maxClass.name = cdx.name;
        end
    end
  
    classification = maxClass.name;
end

