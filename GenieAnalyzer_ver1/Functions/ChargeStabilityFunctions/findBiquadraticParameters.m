function findBiquadraticParameters(Ec,radii,allTriPts)
    me = 9.11e-31; % e- mass [kg]
    m = 0.191*me; % e- effective mass [kg]
    ee = 1.602e-19; % e- charge [C]
    epsr = 11.68; % silicon dieletric constant
%     epsr = 7.8; % silicon dieletric constant
    eps0 = 8.854E-12; % permitivity of free space
    hbar = 6.626E-34/(2*pi); % reducec Plank's constant [J*s]

    % All formulas are taken from Das Sarma, et. al PRB 83.23 (2011): 235314.
    Ecx = Ec(1)*ee; % Convert eV to J's
    Ecy = Ec(2)*ee;
    Ecm = Ec(3)*ee;
    
%     Ecx = 9.8E-3*ee;
%     Ecy = 11.0E-3*ee;
%     Ecm = 2.91E-3*ee;
    
    k = 1/(4*pi*epsr*eps0);
    wx = 2*hbar/(pi*m)*(Ecx/(k*ee*ee))^2;
    wy = 2*hbar/(pi*m)*(Ecy/(k*ee*ee))^2;
    
    lx = sqrt(hbar/(m*wx));
    ly = sqrt(hbar/(m*wy));
%     radii = radii*1E-9;
%     wx = hbar/(m*radii(1)^2);
%     wy = hbar/(m*radii(2)^2);
%     
%     lx = radii(1);
%     ly = radii(2);
    
    amin = 0; % Obviously the dots can't be closer than 0 nm
    amax = 250; % Let's say the maximum they can be spread out in our geometry is 500 nm
    tol = 0.1; % Tolerance of 0.1 nm in our calculation
    initSign = sign(findaFunc(amin)); % Get the initial sign of the function
    aa = amin;
    for curraGuess = amin:tol:amax
%         fprintf(1,'%0.2f ==> %0.2e\n',curraGuess,findaFunc(curraGuess));
        if sign(findaFunc(curraGuess)) ~= initSign
            aa = curraGuess;
            break;
        end
    end
    
    function value = findaFunc(aGuess)
        aGuess = aGuess*1e-9; % Convert into natural units
        
        temp = k*ee*ee*sqrt(pi/(lx^2 + ly^2));
        temp = temp*exp(-2*aGuess^2/(lx^2 + ly^2));
        temp = temp*besseli(0,(2*aGuess^2)/(lx^2 + ly^2));
        
        value = Ecm - temp;
    end

    % Now extract the chemical potential (we assume a mapping to the
    % capacitance model is valid)
    [rows,~] = size(allTriPts);
    allTriplePoints = zeros(rows,2);
    for ii = 1:rows
        tripleInd = getTriTriplePointIndex(allTriPts(ii,:));
        allTriplePoints(ii,1) = allTriPts(ii,tripleInd*2 - 1);
        allTriplePoints(ii,2) = allTriPts(ii,tripleInd*2);
    end
    % now find the mean Vx and Vy for the charge stability region we fit
    vxmean = mean(allTriplePoints(:,1)) - 1.821; % Accounts for unknown turn on of device
    vymean = mean(allTriplePoints(:,2)) - 1.752; % Accounts for unknown turn on of device
    
    alphax = (Ecy - Ecm)*Ecx/(Ecx*Ecy - Ecm^2);
    alphay = (Ecx - Ecm)*Ecy/(Ecx*Ecy - Ecm^2);
    
    mux = (alphax*vxmean + (1-alphax)*vymean) - Ecx/2;
    muy = ((1-alphay)*vxmean + alphay*vymean) - Ecy/2;
    
    % Print out in a more readible form
    fprintf(1,'************************\n');
    fprintf(1,'*Biquadratic Parameters*\n');
    fprintf(1,'************************\n');
    fprintf(1,'Dot x omega:        %0.2e Hz\n',wx);
    fprintf(1,'Dot y omega:        %0.2e Hz\n',wy);
    fprintf(1,'Dot x eff Bohr Rad: %0.2e nm\n',lx/1e-9);
    fprintf(1,'Dot y eff Bohr Rad: %0.2e nm\n',ly/1e-9);
    fprintf(1,'Dot spacing 2a:     %0.2e nm\n',2*aa);
    fprintf(1,'Dot x mu:           %0.2e eV\n',mux);
    fprintf(1,'Dot y mu:           %0.2e eV\n',muy);
    fprintf(1,'Dot x alpha:        %0.2e   \n',alphax);
    fprintf(1,'Dot y alpha:        %0.2e   \n',alphay);
    fprintf(1,'Vx mean:            %0.3f V\n',vxmean);
    fprintf(1,'Vy mean:            %0.3f V\n',vymean);
end
