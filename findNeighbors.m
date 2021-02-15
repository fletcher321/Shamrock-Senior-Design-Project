function [updatedConnectivity, updatedPixels] = findNeighbors(image, connectivityMat, index, numPixels)

updatedConnectivity = connectivityMat;
updatedPixels = numPixels;
mark = connectivityMat(index(1), index(2));
[row, col] = size(image);

%list indices all possible neighbors
n1 = [index(1), index(2) + 1]; %directly right
n2 = [index(1) + 1, index(2)]; %directly below
n3 = [index(1) + 1, index(2)+1]; %corner right & below
n4 = [index(1), index(2)-1]; %directly left
n5 = [index(1) - 1, index(2)]; %directly above
n6 = [index(1) - 1, index(2)-1]; %corner left & above
n7 = [index(1) + 1, index(2)-1]; %corner right & above 
n8 = [index(1) - 1, index(2)+1]; %corner left & below
neighbors = [n1; n2; n3; n4; n5; n6; n7; n8];

for i = 1:length(neighbors)
    %check that index is within bounds
    if neighbors(i,1) <= row && neighbors(i,1) >= 1 && neighbors(i,2) <= col && neighbors(i,2) >= 1
        %check if neighbor is black
        if(image(neighbors(i,1), neighbors(i,2)) == 0 && updatedConnectivity(neighbors(i,1), neighbors(i,2)) ~= mark)
            %update connectivityMat
            updatedConnectivity(neighbors(i,1), neighbors(i,2)) = mark;
            updatedPixels = numPixels + 1;

            %recurse over this pixel's neighbors
            [updatedConnectivity, updatedPixels] = findNeighbors(image, updatedConnectivity, neighbors(i,:), updatedPixels);
        end
    end
end

end