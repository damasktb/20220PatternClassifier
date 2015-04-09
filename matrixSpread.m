% Calculate the percentage of elements which lie on a matrix diagonal 
% For confusion matrices, this is the accuracy of classification
function spread = matrixSpread(cMatrix,count)
    sum = 0;
    for col = 1:size(cMatrix,2)
        for row = 1:size(cMatrix,1)
            if row ~= col
                sum = sum + cMatrix(row,col);
            end
        end
    end
    spread = 100*(1 - (sum/count));
end

