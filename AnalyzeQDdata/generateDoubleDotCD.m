function generateDoubleDotCD( triplePointE, capacitances )
%GENERATEDOUBLEDOTCD uses the triplePoints from a fitted triangle as well as
%the extracted capacitances to generate a double dot Coulomb diamond.  It
%works through reconstructing what the bias triangle looks like and seeing
%if the voltage point is in our outside of the triangle window.

    % triplePointE = triplePoint for electron transfer process
    % triplePointH = triplePoint for hole transfer process
    % capacitances = [Cleadx Cleady Cgx Cgy Cm]
    
    numBiasPoints = 1000;
    bias = linspace(-2,2,numBiasPoints);
    bias = bias*1E-3; % Put in millivolts
    
    numPlgPoints = 2000;
    plgVx = linspace(1.81,1.88,numPlgPoints);
    plgVy = linspace(1.68,1.5,numPlgPoints);
    
    current = zeros(numBiasPoints,numPlgPoints);
    isThereCurrent(bias(1000),plgVx(1),plgVy(1),triplePointE,capacitances);
%     for ii = 1:numBiasPoints
%         for jj = 1:numPlgPoints
%             if isThereCurrent(bias(ii),plgVx(jj),plgVy(jj),triplePointE,capacitances)
%                 current(ii,jj) = 1;
%             else
%                 current(ii,jj) = 0;
%             end
%         end
%     end
    
    
end

function [ current ] = isThereCurrent(bias,plgVx,plgVy,triplePointE,cap)
    % First step is to construct where the bias triangle is located with
    % the bias value.  This begins by calculating the deltaVgs from the
    % capacitances
    ee = 1.602E-19;
    
    Ctotx = cap(1) + cap(3) + cap(5);
    Ctoty = cap(2) + cap(4) + cap(5);
    DeltaVgx = ee/cap(3);
    DeltaVgy = ee/cap(4);
    DeltaVgxm = DeltaVgx*cap(5)/Ctotx;
    DeltaVgym = DeltaVgy*cap(5)/Ctoty;
    deltaVgx = abs(bias)*Ctotx/cap(3);
    deltaVgy = abs(bias)*Ctoty/cap(4);
    dVgs = [DeltaVgx, DeltaVgy, deltaVgx, deltaVgy, DeltaVgxm, DeltaVgym];
    
    allTrianglePoints = buildBiasTriangles(dVgs,[min(plgVx), max(plgVx)],[min(plgVy), max(plgVy)],triplePointE);
    
    current = 0;
end

function [ temp ] = buildBiasTriangles(dVgs, Vxrange, Vyrange, triplePointE)
    % What we want to do here.. Is to start at the initial triple point and
    % build up the bias triangle around that.  We will then shift the bias
    % triangles many times to fill up the alloted range given by Vxrange
    % and Vyrange and keeping track of those triangle points.  We will then
    % return all of the triangle points back to the calling funciton.
    
    DeltaVgx = dVgs(1);
    DeltaVgy = dVgs(2);
    DeltaVgxm = dVgs(5);
    DeltaVgym = dVgs(6);
    deltaVgx = dVgs(3);
    deltaVgy = dVgs(4);
    
    % Find triplePointH: refers to the triplePoint on the bias triangles
    % where hole transport is the effective transport mode
    del = [DeltaVgy, DeltaVgxm;DeltaVgym, DeltaVgx]\[DeltaVgxm*DeltaVgy;DeltaVgym*DeltaVgx];
    triplePointH = [(triplePointE(1)+del(1)), (triplePointE(2)+del(2))];
    
    % Find b: b refers to the point on the main slope of the triangle that 
    % is not a triplePoint for the upper triangle
    EHdist = sqrt((triplePointE(1)-triplePointH(1))^2 + (triplePointE(2) - triplePointH(2))^2);
    Hbdist = deltaVgx/DeltaVgxm*EHdist;
    mainSlope = (triplePointE(2) - triplePointH(2))/(triplePointE(1) - triplePointH(1));
    b2x = triplePointH(1) - (Hbdist/sqrt(1 + mainSlope^2));
    b2y = mainSlope*(b2x - triplePointH(1)) + triplePointH(2); 
    b2 = [b2x, b2y];
    
    % Find a: a refers to the "peak" on the rightmost triangle
    temp1 = triplePointH(2) + (DeltaVgym/DeltaVgx)*triplePointH(1);
    temp2 = b2(2) + (DeltaVgy/DeltaVgxm)*b2(1);
    a2 = [DeltaVgym/DeltaVgx, 1;DeltaVgy/DeltaVgxm, 1]\[temp1;temp2];
    
    a1 = [(triplePointE(1)-triplePointH(1)+a2(1)), (triplePointE(2)-triplePointH(2)+a2(2))];
    b1 = [(triplePointE(1)-triplePointH(1)+b2(1)), (triplePointE(2)-triplePointH(2)+b2(2))];
    
    figure;
    hold on;
%     line([triplePointE(1),triplePointE(3)],[triplePointE(2),triplePointE(4)],'Color','black');
%     line([triplePointE(5),triplePointE(3)],[triplePointE(6),triplePointE(4)],'Color','black');
%     line([triplePointE(1),triplePointE(5)],[triplePointE(2),triplePointE(6)],'Color','black');
    line([a1(1),b1(1)],[a1(2),b1(2)],'Color','black');
    line([a1(1),triplePointE(1)],[a1(2),triplePointE(2)],'Color','black');
    line([b1(1),triplePointE(1)],[b1(2),triplePointE(2)],'Color','black');
    line([a2(1),b2(1)],[a2(2),b2(2)],'Color','black');
    line([a2(1),triplePointH(1)],[a2(2),triplePointH(2)],'Color','black');
    line([b2(1),triplePointH(1)],[b2(2),triplePointH(2)],'Color','black');
    
    temp = 1;
end





