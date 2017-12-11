function tri_pts = fitBiasTriangle( VX, VY, CZ, userOptions, init_pts, thresh )
%fitBiasTriangle takes in a small window of charge stability data with
%one bias triangle in it and fits it.  The code should find the main axis
%of the triangles for the shifting, and it extracts the deltaVgs
%accordingly.

    fprintf(1,'Currently fitting a single bias triangle...\n');    

    if userOptions.fitTriangle
        tri_pts = optimizeTriangles(VX,VY,CZ,init_pts,thresh,userOptions.verbose);
    else
        tri_pts = init_pts;
    end
    
    if userOptions.verbose
        figure;
        hold on;
        drawChargeStabilityData(VX,VY,CZ);
        drawBiasTriangle(tri_pts,CZ);
        
        figure;
        hold on;
        drawChargeStabilityData(VX,VY,getCurrentAsThresholdData(CZ,thresh));
        drawBiasTriangle(tri_pts,CZ);
    end
    
    fprintf(1,'Done fitting a single bias triangle!\n');
end

function pts = optimizeTriangles(VX,VY,CZ,tri_pts,thresh,verbose)
    % To do the fitting we reduce the current to be simply a 0 or 1.  0
    % current falls below the threshold set by thresh and 1 lies above the
    % current.
    % The fitting works by minimizing both the number of 0s
    % inside the triangle window and the number of 1s outside of the
    % triangle window.
    
    % First, we want to set a bound for the range that the triangle points
    % can vary, we define this radius as 1/4 of the shortest triangle
    % length from the guess.
    side_lengths = [sqrt((tri_pts(1)-tri_pts(3))^2 + (tri_pts(2)-tri_pts(4))^2) ...
        sqrt((tri_pts(5)-tri_pts(3))^2 + (tri_pts(6)-tri_pts(4))^2) ...
        sqrt((tri_pts(1)-tri_pts(5))^2 + (tri_pts(2)-tri_pts(6))^2)];
    range_bnd = min(side_lengths)/4;
    init_guess = tri_pts; % Used for checking range
    init_area = getTriArea(tri_pts);
    mainSlopePts = [1,2];
    
    if verbose
        options = optimset('Display','iter','MaxIter',200);
    else
        options = optimset('MaxIter',200);
    end
    
    scaleFactor = 1000;
    tri_pts(7) = tri_pts(7)*scaleFactor;
    pts = fminsearch(@fun, tri_pts, options);
    pts(7) = pts(7)/scaleFactor;

    % Use a nested function to allow us to used other parameters like
    % thresh that is not actually being fitted
    function [quality_factor] = fun(tri_pts)
        
        tri_pts(7) = tri_pts(7)/scaleFactor;

        % First check if the new points to check are outside of the
        % parameter search window given by range_bnd
        if (sqrt((tri_pts(1)-init_guess(1))^2 + (tri_pts(2)-init_guess(2))^2) > range_bnd) ||...
                (sqrt((tri_pts(3)-init_guess(3))^2 + (tri_pts(4)-init_guess(4))^2) > range_bnd) ||...
                (sqrt((tri_pts(5)-init_guess(5))^2 + (tri_pts(6)-init_guess(6))^2) > range_bnd)
            quality_factor = 1e10;
            return;
        end

        % Then make sure that the current guess for the triangle point is
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
        if getTriArea(tri_pts) <= init_area*0.80 ||...
                getTriArea(tri_pts) >= init_area*1.20
            quality_factor = 1e10;
            return;
        end
        
        % Get the current slope to shift the triangles
        [dx, dy] = getTriDxDy(tri_pts, mainSlopePts);
        
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
                % Check with bias triangle case we are in
                if ((tri_pts(4)-tri_pts(2))/(tri_pts(3)-tri_pts(1))*(tri_pts(5) - tri_pts(1)) + tri_pts(2)) <= tri_pts(6)
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
                        inTriangle = 1;
                    else
                        inTriangle = 0; 
                    end
                else
                    % Check if point is above or below each line to characterize if
                    % in the triangles
                    % The point is in the triangle
                    if ((((tri_pts(4) - tri_pts(2))/(tri_pts(3)-tri_pts(1))*(VX(ii,jj)-tri_pts(1)) + tri_pts(2)) > VY(ii,jj))...
                            && (((tri_pts(4) - tri_pts(6))/(tri_pts(3)-tri_pts(5))*(VX(ii,jj)-tri_pts(5)) + tri_pts(6)) > VY(ii,jj))...
                            && (((tri_pts(6) - tri_pts(2))/(tri_pts(5)-tri_pts(1))*(VX(ii,jj)-tri_pts(5)) + tri_pts(6)) < VY(ii,jj)))...
                            ||...
                            ((((tri_pts(4) - tri_pts(2))/(tri_pts(3)-tri_pts(1))*(VX(ii,jj)-tri_pts(1)-dx) + tri_pts(2)+dy) > VY(ii,jj))...
                            && (((tri_pts(4) - tri_pts(6))/(tri_pts(3)-tri_pts(5))*(VX(ii,jj)-tri_pts(5)-dx) + tri_pts(6)+dy) > VY(ii,jj))...
                            && (((tri_pts(6) - tri_pts(2))/(tri_pts(5)-tri_pts(1))*(VX(ii,jj)-tri_pts(5)-dx) + tri_pts(6)+dy) < VY(ii,jj)))
                        inTriangle = 1;
                    else
                        inTriangle = 0; 
                    end
                end
                % So now we know if we are in the bias triangles..
                % Is there current or no current at the data point?
                if inTriangle
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