function allTriPtsGuess = fitManyBiasTriangles(Vx, Vy, CZ, triPtsGuess, numTri, thresh, userOptions)
%FITMANYBIASTRIANGLES takes in a data set comprising a grid of a few bias
%triangles.  One of these triangles should have already been fitted by
%fitBiasTriangle and that fit is an input to this funciton.  The code will
%use the fitted bias triangle to fit the grid of several triangles. It
%should return the DeltaVgs.

    fprintf(1,'Currently fitting many bias triangles...\n');

    vxtemp = [];
    vytemp = [];
    
    % Find the Vx and Vy values for where the current is above threshold
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
    
    % Get initial guess for DX and DY shifts
    % Look at the clusters of Vx and VY indicating a bias triangle and
    % seperate them by cluster using kmeans.
    numTriX = numTri(1);
    numTriY = numTri(2);
    [~,Cx] = kmeans(vxtemp,numTriX);
    [~,Cy] = kmeans(vytemp,numTriY);
      
    % Find DX guess
    DX = 1E10;
    for ii = 1:numTriX
        for jj = (ii+1):numTriX
            currDXguess = abs(Cx(ii) - Cx(jj));
            if currDXguess < DX
                DX = currDXguess;
            end
        end
    end
    DY = 1E10;
    for ii = 1:numTriY
        for jj = (ii+1):numTriY
            currDYguess = abs(Cy(ii) - Cy(jj));
            if currDYguess < DY
                DY = currDYguess;
            end
        end
    end
    
    % We want to set a bound for the range that the triangle points
    % can vary, we define this radius as 1/12 of the shortest triangle
    % length from the guess.
    side_lengths = [sqrt((triPtsGuess(1)-triPtsGuess(3))^2 + (triPtsGuess(2)-triPtsGuess(4))^2) ...
        sqrt((triPtsGuess(5)-triPtsGuess(3))^2 + (triPtsGuess(6)-triPtsGuess(4))^2) ...
        sqrt((triPtsGuess(1)-triPtsGuess(5))^2 + (triPtsGuess(2)-triPtsGuess(6))^2)];
    range_bnd = min(side_lengths)/12;
    init_guess = triPtsGuess; % Used for checking range
    init_area = getTriArea(triPtsGuess);
    mainSlopePts = [1,2];
    
    % We want to do a similar fitting to that of fitting the bias triangle
    % where now we only have 2 parameters to vary.  DX, DY
    % corresponding to how to shift the triangles either along the X or Y
    % axis of the charge stability diagram.
    if userOptions.verbose
        options = optimset('Display','iter','MaxIter',300);
    else
        options = optimset('MaxIter',300);
    end
    
    DXinit = DX*0.85;
    DYinit = DY*0.85;
    initShifts = [DXinit, DYinit];
    allTriPtsGuess = zeros(numTriX*numTriY,7);
    initParams = [initShifts,triPtsGuess];

    params = fminsearch(@fun, initParams, options);
    
    function [qfactor] = fun(params)
        
        tri_pts = [params(3),params(4),params(5),params(6),params(7),params(8),params(9)];
        shifts = [params(1),params(2)];
        
        % First step is to check that the new bias triangle fit does not
        % violate some conditions.  If it does... Return a large quality
        % factor.
        % Check if the new points to check are outside of the
        % parameter search window given by range_bnd
        if (sqrt((tri_pts(1)-init_guess(1))^2 + (tri_pts(2)-init_guess(2))^2) > range_bnd) ||...
                (sqrt((tri_pts(3)-init_guess(3))^2 + (tri_pts(4)-init_guess(4))^2) > range_bnd) ||...
                (sqrt((tri_pts(5)-init_guess(5))^2 + (tri_pts(6)-init_guess(6))^2) > range_bnd)
            qfactor = 1E10;
            return;
        end

        % Then make sure that the current guess for the triangle point is
        % not outside of the fitted data range.
        if ((tri_pts(1) > max(Vx) || tri_pts(1) < min(Vx)) ||...
                (tri_pts(3) > max(Vx) || tri_pts(3) < min(Vx)) ||...
                (tri_pts(5) > max(Vx) || tri_pts(5) < min(Vx)) ||...
                (tri_pts(2) > max(Vy) || tri_pts(2) < min(Vy)) ||...
                (tri_pts(4) > max(Vy) || tri_pts(4) < min(Vy)) ||...
                (tri_pts(6) > max(Vy) || tri_pts(6) < min(Vy)))
            qfactor = 1E10;
            return;
        end
        
        % Don't change the area of the triangle too much compared to the
        % initial guess.
        if getTriArea(tri_pts) <= init_area*0.95 ||...
            getTriArea(tri_pts) >= init_area*1.05
            qfactor = 1E10;
            return;
        end
        
        % Dx and Dy shouldn't change too much to the initial guess
        if shifts(1) < DXinit*0.8 || shifts(1) > DXinit*1.2
            qfactor = 1E10;
        end
        if shifts(2) < DYinit*0.8 || shifts(2) > DYinit*1.2
            qfactor = 1E10;
        end
        
        % Build the rest of the honeycomb pattern
        allTriPtsGuess = buildManyBiasTriangles( Vx, Vy, tri_pts, numTri, shifts );
            
        % Now that we have built up the honeycomb structure.. Let's
        % calculate the quality factor
        % Do this by looping through each point and seeing if it lies in
        % any of the bias triangles or not.
        onesInTri = 1;
        onesOutTri = 1;
        zerosInTri = 1;
        zerosOutTri = 1;
        intri = 0;
        outtri = 0;
        [triNum,~] = size(allTriPtsGuess);
        [maindx,maindy] = getTriDxDy(tri_pts,[1,2]);
        for ll = 1:length(Vx)
            for nn = 1:length(Vy)
                % Go through every bias triangle and see if the current vx
                % and vy point lie within ANY bias triangle group.
                for mm = 1:triNum
                    currTriPts = allTriPtsGuess(mm,:);
                    % Check with bias triangle case we are in
                    if ((currTriPts(4)-currTriPts(2))/(currTriPts(3)-currTriPts(1))*(currTriPts(5) - currTriPts(1)) + currTriPts(2)) <= currTriPts(6)
                        % Check if point is above or below each line to characterize if
                        % in the triangles
                        % The point is in the triangle
                        if ((((currTriPts(4) - currTriPts(2))/(currTriPts(3)-currTriPts(1))*(Vx(ll)-currTriPts(1)) + currTriPts(2)) < Vy(nn))...
                                && (((currTriPts(4) - currTriPts(6))/(currTriPts(3)-currTriPts(5))*(Vx(ll)-currTriPts(5)) + currTriPts(6)) > Vy(nn))...
                                && (((currTriPts(6) - currTriPts(2))/(currTriPts(5)-currTriPts(1))*(Vx(ll)-currTriPts(5)) + currTriPts(6)) < Vy(nn)))...
                                ||...
                                ((((currTriPts(4) - currTriPts(2))/(currTriPts(3)-currTriPts(1))*(Vx(ll)-currTriPts(1)-maindx) + currTriPts(2)+maindy) < Vy(nn))...
                                && (((currTriPts(4) - currTriPts(6))/(currTriPts(3)-currTriPts(5))*(Vx(ll)-currTriPts(5)-maindx) + currTriPts(6)+maindy) > Vy(nn))...
                                && (((currTriPts(6) - currTriPts(2))/(currTriPts(5)-currTriPts(1))*(Vx(ll)-currTriPts(5)-maindx) + currTriPts(6)+maindy) < Vy(nn)))
                            % We know the point is in a bias triangle so we
                            % can break out of this inner loop.
                            inTriangle = 1;
                            break;
                        else
                            inTriangle = 0; 
                        end
                    else
                        % Check if point is above or below each line to characterize if
                        % in the triangles
                        % The point is in the triangle
                        if ((((currTriPts(4) - currTriPts(2))/(currTriPts(3)-currTriPts(1))*(Vx(ll)-currTriPts(1)) + currTriPts(2)) > Vy(nn))...
                                && (((currTriPts(4) - currTriPts(6))/(currTriPts(3)-currTriPts(5))*(Vx(ll)-currTriPts(5)) + currTriPts(6)) > Vy(nn))...
                                && (((currTriPts(6) - currTriPts(2))/(currTriPts(5)-currTriPts(1))*(Vx(ll)-currTriPts(5)) + currTriPts(6)) < Vy(nn)))...
                                ||...
                                ((((currTriPts(4) - currTriPts(2))/(currTriPts(3)-currTriPts(1))*(Vx(ll)-currTriPts(1)-maindx) + currTriPts(2)+maindy) > Vy(nn))...
                                && (((currTriPts(4) - currTriPts(6))/(currTriPts(3)-currTriPts(5))*(Vx(ll)-currTriPts(5)-maindx) + currTriPts(6)+maindy) > Vy(nn))...
                                && (((currTriPts(6) - currTriPts(2))/(currTriPts(5)-currTriPts(1))*(Vx(ll)-currTriPts(5)-maindx) + currTriPts(6)+maindy) < Vy(nn)))
                            % We know the point is in a bias triangle so we
                            % can break out of this inner loop.
                            inTriangle = 1;
                            break;
                        else
                            inTriangle = 0; 
                        end
                    end
                end
                % Now.. If the point is in a triangle.. We need to know if
                % the current at that point is above or below threshold.
                if inTriangle
                    if (abs(CZ(nn,ll)) >= thresh)
                        onesInTri = onesInTri + 1;
                    else
                        zerosInTri = zerosInTri + 1;
                    end
                    intri = intri + 1;
                % The point is out of the triangle    
                else
                    if (abs(CZ(nn,ll)) >= thresh)
                        onesOutTri = onesOutTri + 1;
                    else
                        zerosOutTri = zerosOutTri + 1;
                    end
                    outtri = outtri + 1;
                end
            end
        end
        % Calculate quality factor (ideal quality_factor = 1)
        qfactor = zerosInTri*onesOutTri;
    end
    
    % Plot centers of cluster as sanity checks if we choose verbose
    if userOptions.verbose
        for ii = 1:numTriX
            for jj = 1:numTriY
                plot3(Cx(ii),Cy(jj),max(max(CZ))+1,'k*');
            end
        end
    end
    
    fprintf(1,'Done fitting many bias triangles!\n');
end
