function [ newTriPts ] = getBiasTrianglePointsFromCenter(currCenter, triPts)
    % Takes a fitted bias triangle set of points and returns a new bias
    % triangle shifted to have a center equal to currCenter
    
    center = getBiasTriangleCenter(triPts);
    xcenter = center(1);
    ycenter = center(2);

    newTriPts = zeros(1,7);
    
    % Find the dx and dy from the fitted triangle's center and the current
    % bias triangle
    dxcenter = xcenter - currCenter(1);
    dycenter = ycenter - currCenter(2);
    
    newTriPts(1) = triPts(1) - dxcenter;
    newTriPts(2) = triPts(2) - dycenter;
    newTriPts(3) = triPts(3) - dxcenter;
    newTriPts(4) = triPts(4) - dycenter;
    newTriPts(5) = triPts(5) - dxcenter;
    newTriPts(6) = triPts(6) - dycenter;
    
    newTriPts(7) = triPts(7);
end