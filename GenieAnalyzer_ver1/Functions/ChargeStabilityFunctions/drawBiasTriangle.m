function drawBiasTriangle( triPts, CZ, color )
%DRAWBIASTRIANGLE Simply plots the bias triangle and ensures it's visible
%by setting it's Z component to be above the max current value

    mainSlopePts = getTriMainSlopePoints(triPts);
    [dx, dy] = getTriDxDy(triPts, mainSlopePts);
    maxCZ = max(max(CZ));
    
    linewidth = 1;
    line([triPts(1),triPts(3)],[triPts(2),triPts(4)],[maxCZ+1,maxCZ+1],'Color',color,'LineWidth',linewidth);
    line([triPts(5),triPts(3)],[triPts(6),triPts(4)],[maxCZ+1,maxCZ+1],'Color',color,'LineWidth',linewidth);
    line([triPts(1),triPts(5)],[triPts(2),triPts(6)],[maxCZ+1,maxCZ+1],'Color',color,'LineWidth',linewidth);
    line([triPts(1)+dx,triPts(3)+dx],[triPts(2)+dy,triPts(4)+dy],[maxCZ+1,maxCZ+1],'Color',color,'LineWidth',linewidth);
    line([triPts(5)+dx,triPts(3)+dx],[triPts(6)+dy,triPts(4)+dy],[maxCZ+1,maxCZ+1],'Color',color,'LineWidth',linewidth);
    line([triPts(1)+dx,triPts(5)+dx],[triPts(2)+dy,triPts(6)+dy],[maxCZ+1,maxCZ+1],'Color',color,'LineWidth',linewidth);
end

