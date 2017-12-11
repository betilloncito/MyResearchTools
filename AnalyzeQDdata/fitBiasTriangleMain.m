function [deltaVgs, tri_pts ] = fitBiasTriangleMain( VX, VY, CZ, verbose )
%fitBiasTriangleMain takes in a small window of charge stability data with
%one bias triangle in it and fits it.  The user will be prompted for an
%initial guess for the fitting.
    
    satisfied = 0;
    while ~satisfied
        % Prompt the user for an initial guess of the bias triangle points 
        [init_pts,skipfit] = getTriangleInitialGuess(VX,VY,CZ);
        
        if ~skipfit
            tri_pts = optimizeTriangles(VX,VY,CZ,init_pts,abs(0.15*max(max(CZ))),verbose);
        else
            tri_pts = init_pts;
        end
     
        % Display the fit
        plotFitOnThreshData(VX,VY,CZ,tri_pts,abs(0.15*max(max(CZ))),1);
        plotFit(VX,VY,CZ,tri_pts,1);
        
        % See if user is happy with the bias triangle fitting
        fprintf(1,'Are you happy with the fitting results?\n');
        fprintf(1,'If not, we can try again with a different guess.\n');
        satisfied = input('(0==N/1==Y): ');
        
        close all;
    end
    deltaVgs = getdeltaVgs(tri_pts);
    
    % For output, we need to return the dy as well
    tri_pts = [ tri_pts ];
end

function [ pts, skipfit ] = getTriangleInitialGuess(VX, VY, CZ)
    
    satisfied = 0;
    while ~satisfied
        plotFit(VX,VY,CZ,[],0);
        prompt = 'Please enter the coordinates for the lower left triangle \nin standard MATLAB format [x1 y1; x2 y2; x3 y3]: ';
        pts = input(prompt);
        prompt = 'Please enter the estimated dx shift for the two triangles: ';
        dx = input(prompt);
        pts = [pts(1,1) pts(1,2) pts(2,1) pts(2,2) pts(3,1) pts(3,2) dx];
        
        close;
        plotFit(VX,VY,CZ,pts,1);
        title('Initial Guess for Triangle Fit');
        fprintf(1,'Are you happy with this guess?\n');
        satisfied = input('(0==N/1==Y): ');
    end
    if satisfied == 2
        skipfit = 1;
    else
        skipfit = 0;
    end
    close;
end

function [ dVgs ] = getdeltaVgs(tri_pts)
    % Calulate deltaVgx, deltaVgy, DeltaVgxm, DeltaVgym
    % Formulas taken from van der Wiel, et al.: Electron transport through
    % double quantum dots
        
    % Get slope of main line for shfiting triangle.  We will use the other
    % two lines to calculate deltaVgx and deltaVgy.
    mainSlopePts = getMainSlopePoints(tri_pts);  
    
    % Calculate deltaVgx
    vgxSlope = 0;
    for ii = 1:3
        for jj = ii:3
            % Obvious case to skip
            if ii == jj
                continue;
            end
            % Don't do the line that dictates the main slope
            if (any(ii == mainSlopePts) && any(jj == mainSlopePts))
                continue;
            end
            
            % Need to the steeper of the two remaining slopes (negative)
            [dx, dy] = getDxDy(tri_pts,[ii,jj]);
            if dy/dx < vgxSlope
                vgxSlope = dy/dx;
                vgxSlopePts = [ii jj];
%                 fprintf('%d,%d\n',ii,jj);
                % And record which is the third point
                for kk = 1:3
                    if any(kk == [ii jj])
                        continue;
                    else
                        otherpt = kk;
                    end
                end
            end      
        end
    end
    temp = (tri_pts(otherpt*2) - tri_pts(vgxSlopePts(1)*2) +...
        (vgxSlope*tri_pts(vgxSlopePts(1)*2-1)))/vgxSlope;
    deltaVgx = abs(tri_pts(otherpt*2-1) - temp);
    
    % Now calculate DeltaVgxm
    [dx, dy] = getDxDy(tri_pts,mainSlopePts);
    temp = (dy + vgxSlope*(tri_pts(vgxSlopePts(1)*2-1) + dx))/vgxSlope;
    DeltaVgxm = abs(tri_pts(otherpt*2-1) - temp);
    
    % Calculate deltaVgy
    vgySlope = -1E10;
    for ii = 1:3
        for jj = ii:3
            % Obvious case to skip
            if ii == jj
                continue;
            end
            % Don't do the line that dictates the main slope
            if (any(ii == mainSlopePts) && any(jj == mainSlopePts))
                continue;
            end
            
            % Need to the shallower of the two remaining slopes (negative)
            [dx, dy] = getDxDy(tri_pts,[ii,jj]);
            if dy/dx > vgySlope
                vgySlope = dy/dx;
                vgySlopePts = [ii jj];
%                 fprintf('%d,%d\n',ii,jj);
                % And record which is the third point
                for kk = 1:3
                    if any(kk == [ii jj])
                        continue;
                    else
                        otherpt = kk;
                    end
                end
            end      
        end
    end
    temp = vgySlope*(tri_pts(otherpt*2-1) - tri_pts(vgySlopePts(1)*2-1)) + ...
        tri_pts(vgySlopePts(1)*2);
    deltaVgy = abs(tri_pts(otherpt*2) - temp);
    
    % Now calculate DeltaVgym 
    [dx, dy] = getDxDy(tri_pts,mainSlopePts);
    temp = -vgySlope*dx + tri_pts(otherpt*2) + dy;
    DeltaVgym = abs(tri_pts(otherpt*2) - temp);
    
    dVgs = [ deltaVgx deltaVgy DeltaVgxm DeltaVgym ];  
end

function pts = optimizeTriangles(VX,VY,CZ,tri_pts,thresh,verbose)
    % To do the fitting we reduce the current to be simply a 0 or 1.  0
    % current falls below the threshold set by thresh and 1 lies above the
    % current.
    % The fitting works by minimizing both the number of 0s
    % inside the triangle window and the number of 1s outside of the
    % triangle window.
    
    % First, we want to set a bound for the range that the triangle points
    % can vary, we define this radius as 1/5 of the shortest triangle
    % length from the guess.
    side_lengths = [sqrt((tri_pts(1)-tri_pts(3))^2 + (tri_pts(2)-tri_pts(4))^2) ...
        sqrt((tri_pts(5)-tri_pts(3))^2 + (tri_pts(6)-tri_pts(4))^2) ...
        sqrt((tri_pts(1)-tri_pts(5))^2 + (tri_pts(2)-tri_pts(6))^2)];
    range_bnd = min(side_lengths)/5;
    init_guess = tri_pts; % Used for checking range
    init_area = calcArea(tri_pts);
    
    if verbose
        options = optimset('Display','iter','MaxIter',200);
    else
        options = optimset('MaxIter',200);
    end
    
    pts = fminsearch(@fun, tri_pts, options);
%     pts = tri_pts;
    
    % Use a nested function to allow us to used other parameters like
    % thresh that is not actually being fitted
    function [quality_factor] = fun(tri_pts)
        % First check if the new points to check are outside of the
        % parameter search window given by range_bnd
        if (sqrt((tri_pts(1)-init_guess(1))^2 + (tri_pts(2)-init_guess(2))^2) > range_bnd) ||...
                (sqrt((tri_pts(3)-init_guess(3))^2 + (tri_pts(4)-init_guess(4))^2) > range_bnd) ||...
                (sqrt((tri_pts(5)-init_guess(5))^2 + (tri_pts(6)-init_guess(6))^2) > range_bnd)
            quality_factor = 1e10;
            return;
        end

        % Then make sure that the current guess for the trianlge point is
        % not outside of the fitted data range.
        if ((tri_pts(1) > max(max(VX)) || tri_pts(1) < min(min(VX))) ||...
                (tri_pts(3) > max(max(VX)) || tri_pts(3) < min(min(VX))) ||...
                (tri_pts(5) > max(max(VX)) || tri_pts(5) < min(min(VX))) ||...
                (tri_pts(2) > max(max(VY)) || tri_pts(2) < min(min(VY))) ||...
                (tri_pts(4) > max(max(VY)) || tri_pts(4) < min(min(VY))) ||...
                (tri_pts(6) > max(max(VY)) || tri_pts(6) < min(min(VY))))
            quality_factor = 1e10;
            return;
        end
        
        % Don't change the area of the triangle too much compared to the
        % initial guess.
        if calcArea(tri_pts) <= init_area*0.80
            quality_factor = 1e10;
            return;
        end
        
        % Get the current slope to shift the triangles
        slopepts = getMainSlopePoints(tri_pts);
        [dx, dy ] = getDxDy(tri_pts, slopepts);
        % If there was an error in finding the slope, then try again.
        if dy == -1e5 && dx == 1e-5
            quality_factor = 1e10;
            return;
        end
        
        % Loop through each data point and see if it's in or out of the
        % triangle
        onesInTri = 1;
        onesOutTri = 1;
        zerosInTri = 1;
        zerosOutTri = 1;
        intri = 0;
        outtri = 0;
        
        [rows, cols] = size(VX);
        for ii = 1:rows
            for jj = 1:cols
                % Check if point is above or below each line to characterize if
                % in the triangles
                % The point is in the triangle
                if ((((tri_pts(4) - tri_pts(2))/(tri_pts(3)-tri_pts(1))*(VX(ii,jj)-tri_pts(1)) + tri_pts(2)) < VY(ii,jj))...
                        && (((tri_pts(4) - tri_pts(6))/(tri_pts(3)-tri_pts(5))*(VX(ii,jj)-tri_pts(5)) + tri_pts(6)) > VY(ii,jj))...
                        && (((tri_pts(6) - tri_pts(2))/(tri_pts(5)-tri_pts(1))*(VX(ii,jj)-tri_pts(5)) + tri_pts(6)) < VY(ii,jj)))...
                        ||...
                        ((((tri_pts(4) - tri_pts(2))/(tri_pts(3)-tri_pts(1))*(VX(ii,jj)-tri_pts(1)-dx) + tri_pts(2)+dy) < VY(ii,jj))...
                        && (((tri_pts(4) - tri_pts(6))/(tri_pts(3)-tri_pts(5))*(VX(ii,jj)-tri_pts(5)-dx) + tri_pts(6)+dy) > VY(ii,jj))...
                        && (((tri_pts(6) - tri_pts(2))/(tri_pts(5)-tri_pts(1))*(VX(ii,jj)-tri_pts(5)-dx) + tri_pts(6)+dy) < VY(ii,jj)))

                    % So now we know that we are in the bias triangles..
                    % Is there current or no current at the data point?
                    if (abs(CZ(ii,jj)) >= thresh)
                        onesInTri = onesInTri + 1;
                    else
                        zerosInTri = zerosInTri + 1;
                    end
                    intri = intri + 1;

                % The point is out of the triangle    
                else
                    if (abs(CZ(ii,jj)) >= thresh)
                        onesOutTri = onesOutTri + 1;
                    else
                        zerosOutTri = zerosOutTri + 1;
                    end
                    outtri = outtri + 1;
                end
            end
        end
        
        % Calculate quality factor (ideal quality_factor = 1)
        quality_factor = zerosInTri*onesOutTri;
    end
    
end

function [ area ] = calcArea(pts)
    x = [pts(1) pts(3) pts(5)];
    y = [pts(2) pts(4) pts(6)];

    area = polyarea(x,y);
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


function plotFit(VX,VY,CZ,tri_pts,showFit)
    % First plot out the charge stability diagram    
    figure;
    hold on;
    axis([min(min(VX)) max(max(VX)) min(min(VY)) max(max(VY))])
    surf(VX,VY,CZ,'EdgeAlpha',0);
    view(2);

    if showFit
        % Now plot the fitted bias triangle
        slopepts = getMainSlopePoints(tri_pts);
        [dx, dy ] = getDxDy(tri_pts, slopepts);
        maxCZ = max(max(CZ));
        line([tri_pts(1),tri_pts(3)],[tri_pts(2),tri_pts(4)],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(5),tri_pts(3)],[tri_pts(6),tri_pts(4)],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(1),tri_pts(5)],[tri_pts(2),tri_pts(6)],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(1)+dx,tri_pts(3)+dx],[tri_pts(2)+dy,tri_pts(4)+dy],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(5)+dx,tri_pts(3)+dx],[tri_pts(6)+dy,tri_pts(4)+dy],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(1)+dx,tri_pts(5)+dx],[tri_pts(2)+dy,tri_pts(6)+dy],[maxCZ+1,maxCZ+1],'Color','black');
    end

end

function plotFitOnThreshData(VX,VY,CZ,tri_pts,thresh,showFit)
    % Change CZ to be simply 0 or 1 based on threshold data
    [rows, cols] = size(CZ);
    for ii = 1:rows
        for jj = 1:cols
            if abs(CZ(ii,jj)) >= thresh
                CZ(ii,jj) = 1;
            else
                CZ(ii,jj) = 0;
            end
        end
    end

    % First plot out the charge stability diagram
    figure;
    hold on;
    axis([min(min(VX)) max(max(VX)) min(min(VY)) max(max(VY))])
    surf(VX,VY,CZ,'EdgeAlpha',0);
    view(2);
    
    if showFit
        % Now plot the fitted bias triangle
        slopepts = getMainSlopePoints(tri_pts);
        [dx, dy ] = getDxDy(tri_pts, slopepts);
        maxCZ = max(max(CZ));
        line([tri_pts(1),tri_pts(3)],[tri_pts(2),tri_pts(4)],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(5),tri_pts(3)],[tri_pts(6),tri_pts(4)],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(1),tri_pts(5)],[tri_pts(2),tri_pts(6)],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(1)+dx,tri_pts(3)+dx],[tri_pts(2)+dy,tri_pts(4)+dy],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(5)+dx,tri_pts(3)+dx],[tri_pts(6)+dy,tri_pts(4)+dy],[maxCZ+1,maxCZ+1],'Color','black');
        line([tri_pts(1)+dx,tri_pts(5)+dx],[tri_pts(2)+dy,tri_pts(6)+dy],[maxCZ+1,maxCZ+1],'Color','black');
    end

end