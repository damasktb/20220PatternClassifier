% Calculate the percentage of elements which lie on a matrix diagonal 
% For confusion matrices, this is the accuracy of classification
function spread = matrixSpread(cMatrix)
    count = sum(sum(cMatrix));
    spread = 100*trace(cMatrix)/count;
end

