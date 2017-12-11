function fitChargeStability
%FITCHARGESTABILITY Summary of this function goes here
%   Detailed explanation goes here

    % Load the charge stability data file
    DIR = cd;     
    cd([DIR,'\Data']);    
    [fname,path] = uigetfile('*.csv', 'Choose a file');
    data = csvread([path,fname],1,0); % Skip the first row of labels
    
    % See if the file has more than one bias voltage and if so, prompt user
    % for which one to work with
    biases = unique(data(:,2));
    if length(biases) == 1
        biasIndex = 1;
    else
        fprintf(1,'Type the number for which bias Voltage you wish to use?\n');
        for ii = 1:length(biases)
            fprintf(1,'%d: %.3f V\n',ii,biases(ii));
        end
        biasIndex = input('Which bias index?: ');
    end
    bias = biases(biasIndex);
    
    % Extract into meshgrids
    [rows, ~] = size(data);
    Vx = [];
    Vy = [];
    Cz = [];
    jj = 1;
    for ii = 1:rows
        if data(ii,2) == bias
            Vxtemp(jj) = data(ii,3);
            Vytemp(jj) = data(ii,4);
            Cztemp(jj) = abs(data(ii,5));
            jj = jj + 1;
        end
    end
    
    switch Vxtemp(1)
        case Vxtemp(2)
            Vx = sort(unique(Vxtemp),'descend');
            Vy = sort(unique(Vytemp),'descend');
%                 Vx = reshape(Vx,length(unique(Vy)),length(unique(Vx)));
%                 Vy = reshape(Vy,length(unique(Vy)),length(unique(Vx)));
            CZ = reshape(Cztemp,length(unique(Vytemp)),length(unique(Vxtemp)));
%                 figure(299);
%                 surf(Vx,Vy,CZ,'EdgeAlpha',0);
%                 view([0 0 90])
        otherwise
            Vx = unique(Vx);
            Vy = unique(Vy);
            CZ = reshape(Cz,length(Vytemp),length(Vxtemp));
%             figure(300);
%                 surf(Vy,Vx,CZ,'EdgeAlpha',0);
%                 view([0 0 90])
    end
    
    [outer, inner] = promptUserForDataRanges(Vx, Vy, CZ);
    
    outerX = outer(1,:);
    outerY = outer(2,:);
    innerX = inner(1,:);
    innerY = inner(2,:);
    
    % Now fix the and remove the rest of the values outside of the range
    % set by outerX and outerY
%     Vx = unique(Vxtemp);
%     Vy = unique(Vytemp);
%     CZ = zeros(length(Vy),length(Vx));
%     kk = 1;
%     for ii = 1:length(Vx)
%         for jj = 1:length(Vy)
%             CZ(jj,ii) = Cztemp(kk);
%             kk = kk + 1;
%         end
%     end
    xOuterInd = find((Vx >= outerX(1)) & (Vx <= outerX(2)));
    yOuterInd = find((Vy >= outerY(1)) & (Vy <= outerY(2)));
    
%     figure(100);
%     surf(Vx(xOuterInd),Vy(yOuterInd),CZ(yOuterInd,xOuterInd),'EdgeAlpha',0);
%     view(2);
%     pause;
    
    % Now send the subset for the bias triangle to the function that fits
    % it.
    xFinerInd = find((Vx >= innerX(1)) & (Vx <= innerX(2)));
    yFinerInd = find((Vy >= innerY(1)) & (Vy <= innerY(2)));
    % fitBiasTrianglesMain takes meshgrids as inputs for all arguments
    [vxtemp, vytemp] = meshgrid(Vx(xFinerInd),Vy(yFinerInd));
    [ dVgs, triPts ] = fitBiasTriangleMain(vxtemp,vytemp,CZ(yFinerInd,xFinerInd),0);
    triPts
    
    Vx = Vx(xOuterInd);
    Vy = Vy(yOuterInd);
    CZ = CZ(yOuterInd,xOuterInd);
    
    figure;
    plotData(Vx,Vy,CZ);
    fprintf(1,'How many triangles are there in each row and column?\n');
    numTri = input('[numTrianglesX numTrianglesY]: ');
    close;
    numTriX = numTri(1);
    numTriY = numTri(2);
    
    vxtemp = [];
    vytemp = [];
    thresh = 0.15*max(max(abs(CZ)));
    kk = 1;
    for ii = 1:length(Vy)
        for jj = 1:length(Vx)
            if abs(CZ(ii,jj)) >= thresh
                vxtemp(kk,1) = Vx(jj);
                vytemp(kk,1) = Vy(ii);
                kk = kk + 1;
            end
        end
    end
    
    figure;
    hold on;
    
    indX = kmeans(vxtemp,numTriX);

    triangleClusterCenter = zeros(numTriX*numTriY,2);
    allTriPts = zeros(numTriX*numTriY,7);
    kk = 1;
    for ii = 1:numTriX
        bigClusterX = vxtemp(indX==ii);
        bigClusterY = vytemp(indX==ii);
        indY = kmeans(bigClusterY,numTriY);
        for jj = 1:numTriY
            triangleClusterCenter(kk,:) = [mean(bigClusterX(indY==jj)) mean(bigClusterY(indY==jj))];
            
            allTriPts(kk,:) = getBiasTrianglePoints(triangleClusterCenter(kk,:), triPts);
            
            plot3(triangleClusterCenter(kk,1),triangleClusterCenter(kk,2),max(max(CZ))+1,'k*');
            
            plotBiasTrianglePoints(allTriPts(kk,:), CZ);
            
            kk = kk + 1;
        end
    end
    % Show all the fitted triangles overlaid on the data
    plotData(Vx,Vy,CZ);
    
    capacitances = findCapacitances(allTriPts, dVgs, bias, numTri,CZ)
end

function [outer, inner] =  promptUserForDataRanges(Vx, Vy, CZ)
    % Inputted data sets are in column format

    % Show the whole data set and let user pick a narrower range for
    % fitting
    satisfied = 0;

%     switch Vx(1)
%         case Vx(2)
%             Vx = unique(Vx);
%             Vy = sort(unique(Vy),'descend');
% %             Vx = reshape(Vx,length(unique(Vy)),length(unique(Vx)));
% %             Vy = reshape(Vy,length(unique(Vy)),length(unique(Vx)));
%             CZ = reshape(Cz,length(unique(Vy)),length(unique(Vx)));
% %             figure(299);
% %             surf(Vx,Vy,CZ,'EdgeAlpha',0);
% %             view([0 0 90])
%         otherwise
%             Vx = unique(Vx);
%             Vy = unique(Vy);
%             CZ = reshape(Cz,length(Vx),length(Vy));
%             figure(300);
% %             surf(Vy,Vx,CZ,'EdgeAlpha',0);
% %             view([0 0 90])
%     end

    while ~satisfied
        close;

        figure;
        title('Full Data Set');
        plotData(Vx, Vy, CZ);
        fprintf(1,'Select a narrower range of a few bias triangles to fit the stability diagram to.\n');
        outer = input('Input the range as [xmin xmax; ymin ymax]: ');
        close;
        
        % Show the zoomed data set and make sure they are happy with the
        % range they selected
        xOuterInd = find((Vx >= outer(1,1)) & (Vx <= outer(1,2)));
        yOuterInd = find((Vy >= outer(2,1)) & (Vy <= outer(2,2)));
        figure;
        title('Zoomed Data Set');
        plotData(Vx(xOuterInd),Vy(yOuterInd),CZ(yOuterInd,xOuterInd));
        fprintf(1,'Are you happy using this range?\n');
        satisfied = input('(0==N/1==Y): ');
    end

    % Show the now zoomed in data set and prompt user to select which bias
    % triangle they want to fit to.  They will need to give an initial
    % guess for the points defining the trianlge
    satisfied = 0;
    while ~satisfied
        close;
        figure;
        title('Zoomed Data Set');
        plotData(Vx(xOuterInd),Vy(yOuterInd),CZ(yOuterInd,xOuterInd));
        fprintf(1,'Select the range of which bias triangle you wish to fit to determine capacitances.\n');
        inner = input('Input the x range as [xmin xmax; ymin ymax]: ');
        close;
        
        % Show the bias triangle they selected and confirm they are happy
        xFinerInd = find((Vx >= inner(1,1)) & (Vx <= inner(1,2)));
        yFinerInd = find((Vy >= inner(2,1)) & (Vy <= inner(2,2)));
        figure;
        title('Bias Triangle Selected');
        plotData(Vx(xFinerInd),Vy(yFinerInd),CZ(yFinerInd,xFinerInd));
        fprintf(1,'Are you happy using this range and triangle?\n');
        satisfied = input('(0==N/1==Y): ');
    end
    close;
end

function [capacitances] = findCapacitances(allTriPts, dVgs, bias, numTri,CZ)
    ee = 1.602E-19; % electron charge
    
    % TODO: Program a way to do this automatically.  It's tedious to do
    % every time...
    triplePoints = zeros(numTri(1)*numTri(2),2);
    % Use the upper left triangle as the reference triangle for finding
    % DeltaVgx and DeltaVgy
    for ii = 1:(numTri(1)*numTri(2))
        index = findTriplePoint(allTriPts(ii,:));
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
    
    % Plot to show we are picking the right triple points
    plot3(leftmostTriplePoints(1,1),...
        leftmostTriplePoints(1,2),max(max(CZ))+3,'g*');
    plot3(leftmostTriplePoints(2,1),...
        leftmostTriplePoints(2,2),max(max(CZ))+3,'r*');
    plot3(rightOfLeftmostTriplePoints(1,1),...
        rightOfLeftmostTriplePoints(1,2),max(max(CZ))+3,'b*');
    
%     triplePoints
%     refTriangle = input('Pick Reference Triangle');
%     vgxTriangle = input('Pick triangle to find Vgx');
%     vgyTriangle = input('Pick triangle to find Vgy');
    
    DeltaVgx = abs(leftmostTriplePoints(1,1)-rightOfLeftmostTriplePoints(1,1))
    DeltaVgy = abs(leftmostTriplePoints(1,2)-leftmostTriplePoints(2,2))
    
%     dVgs = [deltaVgx, deltaVgy, DeltaVgxm, DeltaVgym] 
    dVgs
    Cgx = ee/DeltaVgx;
    Cgy = ee/DeltaVgy;
    Ctotx = Cgx*dVgs(1)/abs(bias)*100; %100 used to adjust for voltage divider in experiment
    Ctoty = Cgy*dVgs(2)/abs(bias)*100; %100 used to adjust for voltage divider in experiment
    Cm = Ctoty*dVgs(3)/DeltaVgx;
    Cleadx = Ctotx - Cgx - Cm;
    Cleady = Ctoty - Cgy - Cm;
    
    capacitances = [Cleadx Cleady Cgx Cgy Cm];
    
end

function [ triplePointIndex ] = findTriplePoint(triPts)
    % Find the triple point by searching for the main
    % slope and finding the rightmost point along it
    
    slopePts = getMainSlopePoints(triPts);
    if triPts(slopePts(1)*2-1) > triPts(slopePts(2)*2-1)
        triplePointIndex = slopePts(1);
    else
        triplePointIndex = slopePts(2);
    end
end

function plotBiasTrianglePoints( tri_pts, CZ )
    slopepts = getMainSlopePoints(tri_pts);
    [dx, dy] = getDxDy(tri_pts, slopepts);
    maxCZ = max(max(CZ));
    line([tri_pts(1),tri_pts(3)],[tri_pts(2),tri_pts(4)],[maxCZ+1,maxCZ+1],'Color','black');
    line([tri_pts(5),tri_pts(3)],[tri_pts(6),tri_pts(4)],[maxCZ+1,maxCZ+1],'Color','black');
    line([tri_pts(1),tri_pts(5)],[tri_pts(2),tri_pts(6)],[maxCZ+1,maxCZ+1],'Color','black');
    line([tri_pts(1)+dx,tri_pts(3)+dx],[tri_pts(2)+dy,tri_pts(4)+dy],[maxCZ+1,maxCZ+1],'Color','black');
    line([tri_pts(5)+dx,tri_pts(3)+dx],[tri_pts(6)+dy,tri_pts(4)+dy],[maxCZ+1,maxCZ+1],'Color','black');
    line([tri_pts(1)+dx,tri_pts(5)+dx],[tri_pts(2)+dy,tri_pts(6)+dy],[maxCZ+1,maxCZ+1],'Color','black');
end

function [ currTriPts ] = getBiasTrianglePoints(currCenter, triPts)
    currTriPts = [];
    
    [dx, dy] = getDxDy(triPts,getMainSlopePoints(triPts));
    % Calculate the center of the fitted two bias triangles
    xcenter1 = (triPts(1) + triPts(3) + triPts(5))/3;
    ycenter1 = (triPts(2) + triPts(4) + triPts(6))/3;
    xcenter2 = (triPts(1)+dx + triPts(3)+dx + triPts(5)+dx)/3;
    ycenter2 = (triPts(2)+dy + triPts(4)+dy + triPts(6)+dy)/3;
    xcenter = (xcenter1 + xcenter2)/2;
    ycenter = (ycenter1 + ycenter2)/2;
    
    % Find the dx and dy from the fitted triangle's center and the current
    % 2 bias triangle's center
    dxcenter = xcenter - currCenter(1);
    dycenter = ycenter - currCenter(2);
    
    currTriPts(1) = triPts(1) - dxcenter;
    currTriPts(2) = triPts(2) - dycenter;
    currTriPts(3) = triPts(3) - dxcenter;
    currTriPts(4) = triPts(4) - dycenter;
    currTriPts(5) = triPts(5) - dxcenter;
    currTriPts(6) = triPts(6) - dycenter;
    
    currTriPts(7) = triPts(7);
end

function plotData(VX,VY,CZ)
    axis([min(min(VX)) max(max(VX)) min(min(VY)) max(max(VY))]);
    surf(VX,VY,CZ,'EdgeAlpha',0);
    view(2);
end

function [ slope ] = getMainSlopePoints(tri_pts)
    % Figure out which pair of points determine the dy/dx slope to shift
    % our triangle.  Do this by seeing which slope is closest to +1.
    min_dis = 1e10;
    for ii = 1:3
        for jj = 1:3
            if ii == jj 
                continue
            end
            curr_slope = (tri_pts(ii*2)-tri_pts(jj*2))/(tri_pts(ii*2-1)-tri_pts(jj*2-1));
            if curr_slope < 0
                continue
            end
            if abs(curr_slope - 1) < min_dis
                slope = [ii jj];
                min_dis = abs(curr_slope - 1);
            end
        end
    end

end

function [ dx, dy ] = getDxDy(tri_pts, linepts)
    dx = tri_pts(7);
    dy = (tri_pts(linepts(1)*2)-tri_pts(linepts(2)*2))/(tri_pts(linepts(1)*2-1)-tri_pts(linepts(2)*2-1))*dx;
end