function  [outputImg, meanColors] = quantizeRGB(origImg, k) 
%Input must be a 3d matrix, which means RGB image
%TODO too slow
    osize = size(origImg);
    numPixels = osize(1) * osize(2);
    colorMatrix = double(reshape(origImg, numPixels, 3));
    
    %generate k points as centers, until now we use random()

    meanColors = 255 * rand(k, 3);
    oldLabels = zeros(1, numPixels);
    
    c = 0;
    while 1
        colorSquare = repmat(sum((colorMatrix .* colorMatrix), 2)', k, 1);
        centerSquare = repmat(sum((meanColors .* meanColors), 2), 1, numPixels);
        dotProduct = -2 * meanColors * colorMatrix';
        distances =  colorSquare + dotProduct + centerSquare; 
       
        [maxValue, newLabels] = max(distances, [], 1); 
        
        if newLabels == oldLabels
            break;
        end
        c = c + 1
        
        oldLabels = newLabels;
        
        for i = 1:k
            points = colorMatrix(newLabels == i, :);
            if size(points, 1) ~= 0
                meanColors(i, :) = sum(points, 1) / size(points, 1);
            end
        end
    end
    
    for i = 1:k
        points = colorMatrix(newLabels == i, :);
        if size(points, 1) ~= 0
            meanColors(i, :) = sum(points, 1) / size(points, 1);
        end
    end 
    0
    %outputImg = origImg;
    %numPixels
    %size(oldLabels)
    outputImg = colorMatrix;
    
    for i = 1:k
       outputImg(oldLabels == i,:) = repmat(meanColors(i,:), sum(oldLabels == i), 1);
    end
    outputImg = uint8(reshape(outputImg, osize(1), osize(2), 3));
end

