function [ capacitances ] = extractCapacitances( dVgs, bias )
%EXTRACTCAPACITANCES takes in all the necessary deltaVs from the charge
%stability diagram and extracts the capacitances. 
    ee = 1.602E-19;

    % Convention used...
    % dVgs = deltaVgx, deltaVgy, DeltaVgmx, DeltaVgmy, DeltaVgx, DeltaVgy
    deltaVgs = [dVgs(1), dVgs(2)];
    DeltaVgms = [dVgs(3), dVgs(4)];
    DeltaVgs = [dVgs(5), dVgs(6)];
    
    % 1 == x, 2 == y
    Cgx = ee/DeltaVgs(1);
    Cgy = ee/DeltaVgs(2);
    Ctotx = Cgx*deltaVgs(1)/abs(bias)*100; %100 used to adjust for voltage divider in experiment
    Ctoty = Cgy*deltaVgs(2)/abs(bias)*100; %100 used to adjust for voltage divider in experiment
    Cmx = Ctoty*DeltaVgms(1)/DeltaVgs(1);
    Cmy = Ctotx*DeltaVgms(2)/DeltaVgs(2);
    Cm = (Cmx + Cmy)/2;
    Cleadx = Ctotx - Cgx - Cm;
    Cleady = Ctoty - Cgy - Cm;
    
    capacitances = [Ctotx Ctoty Cgx Cgy Cleadx Cleady Cm];
    
    % Print out in a more readible form
    fprintf(1,'**************\n');
    fprintf(1,'*Capacitances*\n');
    fprintf(1,'**************\n');
    fprintf(1,'Vbias:  %0.2e V\n',bias/100);
    fprintf(1,'Cx:     %0.2e F\n',Ctotx);
    fprintf(1,'Cy:     %0.2e F\n',Ctoty);
    fprintf(1,'Cgx:    %0.2e F\n',Cgx);
    fprintf(1,'Cgy:    %0.2e F\n',Cgy);
    fprintf(1,'Cleadx: %0.2e F\n',Cleadx);
    fprintf(1,'Cleady: %0.2e F\n',Cleady);
    fprintf(1,'Cm:     %0.2e F\n',Cm);
end

