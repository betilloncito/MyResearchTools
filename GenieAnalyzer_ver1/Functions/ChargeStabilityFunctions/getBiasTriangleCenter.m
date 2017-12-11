function [ center ] = getBiasTriangleCenter(triPts)
    % Finds the center of the two bias triangles
    mainSlopePoints = [1,2];
    
    [dx,dy] = getTriDxDy(triPts,mainSlopePoints);
    xcenter1 = (triPts(1) + triPts(3) + triPts(5))/3;
    ycenter1 = (triPts(2) + triPts(4) + triPts(6))/3;
    xcenter2 = (triPts(1) + triPts(3) + triPts(5) + 3*dx)/3;
    ycenter2 = (triPts(2) + triPts(4) + triPts(6) + 3*dy)/3;
    xcenter = (xcenter1 + xcenter2)/2;
    ycenter = (ycenter1 + ycenter2)/2;
    
    center = [xcenter, ycenter];
end
