function drawManyBiasTriangles( allTriPts, numTri, CZ )
%DRAWMANYBIASTRIANGLES Takes an inputted set of bias triangle points and
%plots them as well as the lines connecting each bias triangle set

    % First calculate the distance between two triangles.  To do this...
    % Find the upper left triangle and the triangles to the right and below
    % of it
    % Store all the triangle centers in an array
    triCenters = zeros(numTri(1)*numTri(2),2);
    for ii = 1:(numTri(1)*numTri(2))
        triCenters(ii,:) = getBiasTriangleCenter(allTriPts(ii,:));
    end
    
    indX = kmeans(triCenters(:,1),numTri(1));
    min_mean = 1E10;
    clusterX = 0;
    for ii = 1:numTri(1)
        curr_mean = mean(triCenters(indX==ii,1));
        if curr_mean < min_mean
            min_mean = curr_mean;
            clusterX = ii;
        end
    end
    nextHighestMean = 1E10;
    nextClusterX = 0;
    for ii = 1:numTri(1)
        if ii == clusterX
            continue;
        end
        curr_mean = mean(triCenters(indX==ii,1));
        if curr_mean < nextHighestMean
            nextHighestMean = curr_mean;
            nextClusterX = ii;
        end
    end
    
    leftMostCenters = triCenters(indX==clusterX,:);
    rightOfLeftMostCenters = triCenters(indX==nextClusterX,:);
    [~,I] = sort(leftMostCenters(:,2),'descend');
    leftMostCenters = leftMostCenters(I,:);
    [~,I] = sort(rightOfLeftMostCenters(:,2),'descend');
    rightOfLeftMostCenters = rightOfLeftMostCenters(I,:);
    
    % tri1 => upper left triangle
    % tri2 => triangle directly underneath
    % tri3 => triangle directly to the right
    [rows,~] = size(triCenters);
    for ii = 1:rows
        if triCenters(ii,1) == leftMostCenters(1,1) &&...
                triCenters(ii,2) == leftMostCenters(1,2)
            tri1 = ii;
        end
    end
    for ii = 1:rows
        if triCenters(ii,1) == leftMostCenters(2,1) &&...
                triCenters(ii,2) == leftMostCenters(2,2)
            tri2 = ii;
        end
    end
    for ii = 1:rows
        if triCenters(ii,1) == rightOfLeftMostCenters(1,1) &&...
                triCenters(ii,2) == rightOfLeftMostCenters(1,2)
            tri3 = ii;
        end
    end
   
    % Draw the triangles and the lines connecting them
    % Check which bias triangle case we are in
    if ((allTriPts(tri1,4)-allTriPts(tri1,2))/(allTriPts(tri1,3)-allTriPts(tri1,1))*...
            (allTriPts(tri1,5) - allTriPts(tri1,1)) + allTriPts(tri1,2)) <= allTriPts(tri1,6)
        mxPoints = [2,3];
        myPoints = [1,3];
    else
        mxPoints = [1,3];
        myPoints = [2,3];
    end
    
    % Now find the lengths for the intermediate lines connecting triangles
    [dx,dy] = getTriDxDy(allTriPts(tri1,:),[1,2]);
    MXDX = abs((allTriPts(tri1,5)+dx) - allTriPts(tri3,mxPoints(1)*2-1));
    MYDX = abs((allTriPts(tri1,5)) - (allTriPts(tri2,myPoints(1)*2-1)+dx));

    % Get the slopes
    [mxdx,mxdy] = getTriDxDy(allTriPts(tri1,:),mxPoints);
    mx = mxdy/mxdx;
    [mydx,mydy] = getTriDxDy(allTriPts(tri1,:),myPoints);
    my = mydy/mydx;

    % So now.. For each triangle, loop through each one and draw lines
    % extending from each needed point with a length equal to D*Length at a
    % slope equal to m*
    color = 'white';
    lwidth = 1;
    CZmax = max(max(CZ));
    for ii = 1:rows
        drawBiasTriangle(allTriPts(ii,:),CZ,color);
        line([allTriPts(ii,mxPoints(1)*2-1),allTriPts(ii,mxPoints(1)*2-1)-MXDX],...
            [allTriPts(ii,mxPoints(1)*2),allTriPts(ii,mxPoints(1)*2)-MXDX*mx],...
            [CZmax,CZmax],'Color',color,'LineWidth',lwidth);
        line([allTriPts(ii,myPoints(1)*2-1)+dx,allTriPts(ii,myPoints(1)*2-1)-MYDX+dx],...
            [allTriPts(ii,myPoints(1)*2)+dy,allTriPts(ii,myPoints(1)*2)-MYDX*my+dy],...
            [CZmax,CZmax],'Color',color,'LineWidth',lwidth);
        line([allTriPts(ii,mxPoints(2)*2-1)+dx,allTriPts(ii,mxPoints(2)*2-1)+MXDX+dx],...
            [allTriPts(ii,mxPoints(2)*2)+dy,allTriPts(ii,mxPoints(2)*2)+MXDX*mx+dy],...
            [CZmax,CZmax],'Color',color,'LineWidth',lwidth);
        line([allTriPts(ii,myPoints(2)*2-1),allTriPts(ii,myPoints(2)*2-1)+MYDX],...
            [allTriPts(ii,myPoints(2)*2),allTriPts(ii,myPoints(2)*2)+MYDX*my],...
            [CZmax,CZmax],'Color',color,'LineWidth',lwidth);
    end
end





