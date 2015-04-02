function classification = classify(classData,class,img,FEATURE_VEC_SIZE)
    imgPath = strcat('Images/',classData(class).name,'/');
                 
    im = imread([imgPath classData(class).testSet(img).name]); 	
    fv = featureVec(logical(im),FEATURE_VEC_SIZE);
    
    maxClass = struct('idx',0,'probability',0);
    
    for idx = 1:length(classData)
        cdx = classData(idx);
        frac1 = 1/(2*pi^(FEATURE_VEC_SIZE/2));
        frac2 = 1/(sqrt(det(cdx.c)));
        m = exp(-1/2 * (fv-cdx.xbar)' * pinv(cdx.c) * (fv-cdx.xbar));
        prob = cdx.prior*real(frac1*frac2*m);
        prob = log(prob);
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

