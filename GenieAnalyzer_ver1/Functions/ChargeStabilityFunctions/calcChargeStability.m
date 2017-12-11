function allTriPts = calcChargeStability( Vx, Vy, numTri )
%CALCCHARGESTABILITY This program simply takes in some user inputs and
%simply draw the charge stability and calculate the capacitances.  This
%program does NO fitting.

    % This is for a negative bias case.. Not sure how well it will work to
    % swap
    % We will just use the guess from the gui
    DxLine = [1.682,1.597;1.701,1.592];
    DyLine = [1.682,1.597;1.689,1.573];
    triPtE = [1.678,1.593];
    Dx = 0.0135;
    Dy = 0.0185;
    
    numTriX = numTri(1);
    numTriY = numTri(2);

    mainSlope = (DyLine(1,2)-triPtE(2))/(DyLine(1,1)-triPtE(1));
    DySlope = (DyLine(1,2)-DyLine(2,2))/(DyLine(1,1)-DyLine(2,1));
    DxSlope = (DxLine(1,2)-DxLine(2,2))/(DxLine(1,1)-DxLine(2,1));
    
    solution = linsolve([DxSlope,-1;DySlope,-1],[DxSlope*triPtE(1)-triPtE(2);DySlope*DyLine(1,1)-DyLine(1,2)]);
    x1 = solution(1);
    y1 = solution(2);
    
    % Build the first bias triangle
    triPts = [triPtE(1),triPtE(2),DyLine(1,1),DyLine(1,2),x1,y1,abs(DxLine(1,1)-triPtE(1))];
    
    % Find the shifts to move the rest of the triangles
%     Dx = abs(x1-DxLine(2,1))
%     Dy = abs(y1-DyLine(2,2))
    shifts = [Dx, Dy];
    
    % Now build the rest of them..
    allTriPts = buildManyBiasTriangles(Vx,Vy,triPts,numTri,shifts);
end

