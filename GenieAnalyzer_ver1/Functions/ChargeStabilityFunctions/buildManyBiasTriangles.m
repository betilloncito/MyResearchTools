function [ allTriPoints ] = buildManyBiasTriangles( Vx, Vy, tri_pts, numTri, shifts )
%BUILDMANYBIASTRIANGLES Takes in a fitted bias triangle as well as the
%range of the charge stability being fitted and constructs the rest of the
%bias triangles based on an inputted DX and DY
    
    % Make an array that will store the full set of TriPoints
    numTriX = numTri(1);
    numTriY = numTri(2);
    allTriPoints = zeros(numTriX*numTriY,7);
    
    % Find the ranges for the Vx and Vy
    Vxrange = [min(min(Vx)), max(max(Vx))];
    Vyrange = [min(min(Vy)), max(max(Vy))];
    
    numTriFound = 1; % You have the initial guess
    numDXshifts = 0; % Start by going +0DX
    Dx = shifts(1);
    Dy = shifts(2);
    
    fitCenter = getBiasTriangleCenter(tri_pts);
    DXplus = 1;
    [maindx,maindy] = getTriDxDy(tri_pts,[1,2]);
    
    % Start at the triPts fit and increase by DX until out of
    % the range of Vx.  Then start at triPts fit and decrease
    % by DX until out of the range of Vx.  Do the same for DY
    % and checking range of Vy.
    for ll = 1:numTriX
        
        % Shift the triangle to the new column of triangles
        % Check with bias triangle case we are in
        if ((tri_pts(4)-tri_pts(2))/(tri_pts(3)-tri_pts(1))*(tri_pts(5) - tri_pts(1)) + tri_pts(2)) <= tri_pts(6)
            [dx,dy] = getTriDxDy(tri_pts,[2,3]);
        else
            [dx,dy] = getTriDxDy(tri_pts,[1,3]);
        end
        mprime = dy/dx; % Slope to shift triangle along the x axis
        newCenterX = [fitCenter(1)+(numDXshifts*maindx) + numDXshifts*Dx, fitCenter(2)+(numDXshifts*maindy) + mprime*numDXshifts*Dx];

        numDYshifts = 0; % Start by going +0DY
        DYplus = 1;

        tempTriangle = getBiasTrianglePointsFromCenter(newCenterX, tri_pts);
        % See if it's outside of the range and if so... Adjust
        if any(tempTriangle([1,3,5]) > Vxrange(2))
            DXplus = 0;
            numDXshifts = -1;

            newCenterX = [fitCenter(1)+(numDXshifts*maindx) + numDXshifts*Dx, fitCenter(2)+(numDXshifts*maindy) + mprime*numDXshifts*Dx];
            numDXshifts = numDXshifts - 1;
        else
            if DXplus
                numDXshifts = numDXshifts + 1;
            else
                numDXshifts = numDXshifts - 1;
            end
        end
        for nn = 1:numTriY
            % Shift the triangle center to the new row of bias
            % triangles
            % Check with bias triangle case we are in
            if ((tri_pts(4)-tri_pts(2))/(tri_pts(3)-tri_pts(1))*(tri_pts(5) - tri_pts(1)) + tri_pts(2)) <= tri_pts(6)
                [dx,dy] = getTriDxDy(tri_pts,[1,3]);
            else
                [dx,dy] = getTriDxDy(tri_pts,[2,3]);
            end
            mprime = dy/dx;
            newCenterY = [newCenterX(1) + numDYshifts*Dy/mprime + (numDYshifts*maindx),newCenterX(2) + numDYshifts*Dy + (numDYshifts*maindy)];

            % Get the bias triangle points now based off of the
            % newCenter
            allTriPoints(numTriFound,:) = getBiasTrianglePointsFromCenter(newCenterY, tri_pts);

            % Check if we're out of the range
            if any(allTriPoints(numTriFound,[2,4,6]) > Vyrange(2))
                numDYshifts = -1;
                DYplus = 0;

                % Recalculate the center
                newCenterY = [newCenterX(1) + numDYshifts*Dy/mprime + (numDYshifts*maindx),newCenterX(2) + numDYshifts*Dy + (numDYshifts*maindy)];

                numDYshifts = numDYshifts - 1;
                
                % Get the bias triangle points now based off of the
                % newCenter
                allTriPoints(numTriFound,:) = getBiasTrianglePointsFromCenter(newCenterY, tri_pts);
            else
                if DYplus
                    numDYshifts = numDYshifts + 1;
                else
                    numDYshifts = numDYshifts - 1;
                end
            end
            numTriFound = numTriFound + 1; % Increase our counter for storing data
        end
    end
end

