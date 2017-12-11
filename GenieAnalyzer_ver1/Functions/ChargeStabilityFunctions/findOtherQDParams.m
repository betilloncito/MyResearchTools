function [ Ec, radii ] = findOtherQDParams( caps )
%FINDOTHERQDPARAMS Finds charging energies and dot sizes

    % capacitances = [Ctotx Ctoty Cgx Cgy Cleadx Cleady Cm];
    Ctotx = caps(1);
    Ctoty = caps(2);
    Cm = caps(7);
    
    ee = 1.602E-19; % electron charge
    epsr = 11.68; % Silicon dieletric constant
%     epsr = 7.8; % silicon dieletric constant
    eps0 = 8.854E-12; % Permitivity of free space
    
    temp = Ctotx*Ctoty - Cm^2;
%     Ecx = ee*Ctoty/temp;
%     Ecy = ee*Ctotx/temp;
    Ecm = ee*Cm/temp;
    Ecx = ee/Ctotx;
    Ecy = ee/Ctoty;
%     temp = caps(7)^2/(caps(1)*caps(2));
%     temp = 1 - temp;
%     temp = 1/temp;
%     Ecx = ee/caps(1)*temp; % eV units
%     Ecy = ee/caps(2)*temp; % eV units
%     temp = caps(1)*caps(2)/(caps(7)^2);
%     temp = temp - 1;
%     temp = 1/temp;
%     Ecm = ee/caps(7)*temp; % eV units
    
    ax = Ctotx/(8*epsr*eps0)*1E9; % nm units
    ay = Ctoty/(8*epsr*eps0)*1E9; % nm units
    
    Ec = [Ecx, Ecy, Ecm];
    radii = [ax, ay];
    
    % Print out in a more readible form
    fprintf(1,'****************\n');
    fprintf(1,'*Dot Parameters*\n');
    fprintf(1,'****************\n');
    fprintf(1,'Dot x Ec:     %0.2e eV\n',Ecx);
    fprintf(1,'Dot y Ec:     %0.2e eV\n',Ecy);
    fprintf(1,'Ecm:          %0.2e eV\n',Ecm);
    fprintf(1,'Dot x Radius: %0.1f nm\n',ax);
    fprintf(1,'Dot y radius: %0.1f nm\n',ay);
end



