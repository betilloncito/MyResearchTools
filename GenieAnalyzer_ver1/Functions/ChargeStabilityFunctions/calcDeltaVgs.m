function [ dVgs ] = calcDeltaVgs(allTriPts,numTri)
    % Calulate all deltaVg values from a fitted set of bias triangles  
    % Formulas taken from van der Wiel, et al.: Electron transport through
    % double quantum dots
        
    % Convention: 1st point in triPts is the lower left point, 2nd point
    % is the other point along the main slope of the triangle, 3rd point is
    % the "peak" point.
    
    % Get slope of main line for shfiting triangle.  We will use the other
    % two lines to calculate deltaVgx and deltaVgy.
    mainSlopePts = [1,2];
    
    % Use the first set of triangle points to find the deltaVgs and
    % DeltaVgms
    currTriPts = allTriPts(1,:);
    
    % Check which bias triangle case we are in
    if ((currTriPts(4)-currTriPts(2))/(currTriPts(3)-currTriPts(1))*(currTriPts(5) - currTriPts(1)) + currTriPts(2)) <= currTriPts(6)
        vgxSlopePts = [1,3];
        otherptvgx = 2;
        vgySlopePts = [2,3];
        otherptvgy = 1;
        
        % Calculate deltaVgx
        [dx,dy] = getTriDxDy(currTriPts,vgxSlopePts);
        vgxSlope = dy/dx;
        temp = (currTriPts(vgxSlopePts(1)*2) - currTriPts(otherptvgx*2))/vgxSlope;
        temp = temp + currTriPts(otherptvgx*2-1);
        deltaVgx = abs(currTriPts(vgxSlopePts(1)*2-1) - temp);

        % Now calculate DeltaVgxm
        [dx, dy] = getTriDxDy(currTriPts,mainSlopePts);
        temp = -dy/vgxSlope + currTriPts(otherptvgx*2-1) + dx;
        DeltaVgxm = abs(currTriPts(otherptvgx*2-1) - temp);

        % Calcualte deltaVgy
        [dx,dy] = getTriDxDy(currTriPts,vgySlopePts);
        vgySlope = dy/dx;
        temp = vgySlope*(currTriPts(vgySlopePts(2)*2-1) -...
            currTriPts(otherptvgy*2-1)) + currTriPts(otherptvgy*2);
        deltaVgy = abs(currTriPts(vgySlopePts(2)*2) - temp);    

        % Now calculate DeltaVgym 
        [dx, dy] = getTriDxDy(currTriPts,mainSlopePts);
        temp = -vgySlope*dx + dy;
        DeltaVgym = abs(temp);
    else
        vgxSlopePts = [2,3];
        otherptvgx = 1;
        vgySlopePts = [1,3];
        otherptvgy = 2;
        
        % Calculate deltaVgx
        [dx,dy] = getTriDxDy(currTriPts,vgxSlopePts);
        vgxSlope = dy/dx;
        temp = (currTriPts(vgxSlopePts(2)*2) - currTriPts(otherptvgx*2))/vgxSlope +...
            currTriPts(otherptvgx*2-1);
        deltaVgx = abs(currTriPts(vgxSlopePts(2)*2-1) - temp);

        % Now calculate DeltaVgxm
        [dx, dy] = getTriDxDy(currTriPts,mainSlopePts);
        temp = -dy/vgxSlope + dx;
        DeltaVgxm = abs(temp);

        % Calcualte deltaVgy
        [dx,dy] = getTriDxDy(currTriPts,vgySlopePts);
        vgySlope = dy/dx;
        temp = vgySlope*(currTriPts(vgySlopePts(2)*2-1) - currTriPts(otherptvgy*2-1)) +...
            currTriPts(otherptvgy*2);
        deltaVgy = abs(currTriPts(vgySlopePts(2)*2) - temp);    

        % Now calculate DeltaVgym 
        [dx, dy] = getTriDxDy(currTriPts,mainSlopePts);
        temp = -vgySlope*dx + dy;
        DeltaVgym = abs(temp);
    end
    
    % Now find the DeltaVgs
    
    % Store all the triple points in an array
    triplePoints = zeros(numTri(1)*numTri(2),2);
    % Use the upper left triangle as the reference triangle for finding
    % DeltaVgx and DeltaVgy
    for ii = 1:(numTri(1)*numTri(2))
        index = getTriTriplePointIndex(allTriPts(ii,:));
        triplePoints(ii,:) = [allTriPts(ii,index*2-1) allTriPts(ii,index*2)];
    end
    
    % Find the upper left triangle and the triangles to the right and below
    % of it to calculate DeltaVgs
    indX = kmeans(triplePoints(:,1),numTri(1));
    min_mean = 1E10;
    for ii = 1:numTri(1)
        curr_mean = mean(triplePoints(indX==ii,1));
        if curr_mean < min_mean
            min_mean = curr_mean;
            clusterX = ii;
        end
    end
    nextHighestMean = 1E10;
    for ii = 1:numTri(1)
        if ii == clusterX
            continue;
        end
        curr_mean = mean(triplePoints(indX==ii,1));
        if curr_mean < nextHighestMean
            nextHighestMean = curr_mean;
            nextClusterX = ii;
        end
    end
    
    leftmostTriplePoints = triplePoints(indX==clusterX,:);
    rightOfLeftmostTriplePoints = triplePoints(indX==nextClusterX,:);
    [~,I] = sort(leftmostTriplePoints(:,1));
    leftmostTriplePoints = leftmostTriplePoints(I,:);
    [~,I] = sort(rightOfLeftmostTriplePoints(:,1));
    rightOfLeftmostTriplePoints = rightOfLeftmostTriplePoints(I,:);
    
%     if userOptions.verbose
%         % Plot to show we are picking the right triple points
%         plot3(leftmostTriplePoints(1,1),...
%             leftmostTriplePoints(1,2),max(max(CZ))+3,'g*');
%         plot3(leftmostTriplePoints(2,1),...
%             leftmostTriplePoints(2,2),max(max(CZ))+3,'r*');
%         plot3(rightOfLeftmostTriplePoints(1,1),...
%             rightOfLeftmostTriplePoints(1,2),max(max(CZ))+3,'b*');
%     end
    
    DeltaVgx = abs(leftmostTriplePoints(1,1)-rightOfLeftmostTriplePoints(1,1));
    DeltaVgy = abs(leftmostTriplePoints(1,2)-leftmostTriplePoints(2,2));
    
    dVgs = [ deltaVgx, deltaVgy, DeltaVgxm, DeltaVgym, DeltaVgx, DeltaVgy ];
end