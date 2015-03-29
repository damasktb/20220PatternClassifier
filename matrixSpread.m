function spread = matrixSpread(cMatrix)
    sum = 0;
    for col = 1:size(cMatrix,2)
        for row = 1:size(cMatrix,1);
            sum = sum + (cMatrix(row,col)*(row-col)^2);
        end
    end
    spread = sum;
end

