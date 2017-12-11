function drawChargeStabilityData( VX, VY, CZ )
%DRAWCHARGESTABILITYDATA Simply plots the charge stability data usually to
%be overlaid by the biad triangle fits
    axis([min(min(VX)) max(max(VX)) min(min(VY)) max(max(VY))]);
    surf(VX,VY,CZ,'EdgeAlpha',0);
    view(2);
    xlabel('$V_{\rm Rplg}$','Interpreter','latex','Fontsize',16);
    ylabel('$V_{\rm Lplg}$','Interpreter','latex','Fontsize',16);
end

