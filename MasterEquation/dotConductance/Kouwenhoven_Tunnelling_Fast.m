function [ current, debug1, debug2, debug3, debug4 ] = Kouwenhoven_Tunnelling_Fast( vL, vR, vG1, vG2, T, c1L, c1R, c1G, c2L, c2R, c2G, cM, g1L, g1R, g2L, g2R, gM )
%KOUWENHOVEN Determines when transport is allowed through a arbitrarily
%connected double dot with one gate
% Based on Rev. Mod. Phys. Vol. 75, No. 1

DEBUG = 0; % Turns on debug features such as tic,toc

if DEBUG
    tic;
end

% Calculator settings
N = 120;

% Electron charge
ee = 1.60217657e-19;
% Boltzmann constant
kb = 1.3806488e-23;

% Cumulative capacitance
cSum1 = c1L + c1R + c1G + cM;
cSum2 = c2L + c2R + c2G + cM;

% Charging energies
eC1 = ee^2 * cSum2 / (cSum1*cSum2 - cM^2);
eC2 = ee^2 * cSum1 / (cSum1*cSum2 - cM^2);
% Coupling energy
eM = ee^2 * cM / (cSum1*cSum2 - cM^2);

% c*v coefficients
coeff1 = c1L*vL+c1R*vR+c1G*vG1;
coeff2 = c2L*vL+c2R*vR+c2G*vG2;

% lead energies
muL = -ee * vL;
muR = -ee * vR;

% Determine chemical potentials for all needed electron configurations
for n1 = 0:N
    for n2 = 0:N
        % Chemical potentials
        mu1(n1+1,n2+1) = eC1*(n1-1/2) + eM*n2 - (1/ee)*(eC1*coeff1+eM*coeff2);
        mu2(n1+1,n2+1) = eC2*(n2-1/2) + eM*n1 - (1/ee)*(eC2*coeff2+eM*coeff1);
    end
end

% Build a "best guess" starting point by just grabbing n1 and n2 values
% which put the mu1 and mu2 inside the bias window
if muR > muL
    [ n1Start, n2Start ] = find(mu1>muL & mu2 > muL,1);
else
    [ n1Start, n2Start ] = find(mu1>muR & mu2 > muR,1);
end
n1Start = n1Start - 1;
n2Start = n2Start - 1;

if nargout > 2
	debug2 = zeros(4,(N+1)^2);
	debug2(1,1) = muL;
	debug2(4,1) = muR;
	for k = 1:N+1
		for j = 1:N+1
			debug2(2,(k-1)*(N+1)+j) = mu1(k,j);
			debug2(3,(k-1)*(N+1)+j) = mu2(k,j);
		end
	end
end

% Determine energy decreases for all transitions
% kML(n1,n2) means energy decrease when electron tunnels from M to L with 
% initial electron configuration of (n1,n2)
blockVal = -999999999; % Used to block a tunneling path (eg, to n1=-1)

for n1 = 0:N
    for n2 = 0:N
        if n1 > 0
            k1L(n1+1,n2+1) = mu1(n1+1,n2+1)-muL;
            k1R(n1+1,n2+1) = mu1(n1+1,n2+1)-muR;
        else
            k1L(n1+1,n2+1) = blockVal;
            k1R(n1+1,n2+1) = blockVal;
        end
        if n2 > 0
            k2L(n1+1,n2+1) = mu2(n1+1,n2+1)-muL;
            k2R(n1+1,n2+1) = mu2(n1+1,n2+1)-muR;
        else
            k2L(n1+1,n2+1) = blockVal;
            k2R(n1+1,n2+1) = blockVal;
        end
        if n2 > 0 && n1 < N
            k21(n1+1,n2+1) = mu2(n1+1,n2+1)-mu1(n1+2,n2);
        else
            k21(n1+1,n2+1) = blockVal;
        end
        if n1 < N
            kL1(n1+1,n2+1) = muL - mu1(n1+2,n2+1);
            kR1(n1+1,n2+1) = muR - mu1(n1+2,n2+1);
        else
            kL1(n1+1,n2+1)=blockVal;
            kR1(n1+1,n2+1)=blockVal;
        end
        if n2 < N
            kL2(n1+1,n2+1) = muL - mu2(n1+1,n2+2);
            kR2(n1+1,n2+1) = muR - mu2(n1+1,n2+2);
        else
            kL2(n1+1,n2+1)=blockVal;
            kR2(n1+1,n2+1)=blockVal;
        end
        if n1 > 0 && n2 < N
            k12(n1+1,n2+1) = mu1(n1+1,n2+1)-mu2(n1,n2+2);
        else
            k12(n1+1,n2+1) = blockVal;
        end
        % Determine tunneling rates
        tun1L(n1+1,n2+1) = g1L*k1L(n1+1,n2+1)/(ee^2*(1-exp(-k1L(n1+1,n2+1)/(kb*T))));
        tun1R(n1+1,n2+1) = g1R*k1R(n1+1,n2+1)/(ee^2*(1-exp(-k1R(n1+1,n2+1)/(kb*T))));
        tun2L(n1+1,n2+1) = g2L*k2L(n1+1,n2+1)/(ee^2*(1-exp(-k2L(n1+1,n2+1)/(kb*T))));
        tun2R(n1+1,n2+1) = g2R*k2R(n1+1,n2+1)/(ee^2*(1-exp(-k2R(n1+1,n2+1)/(kb*T))));
        tun21(n1+1,n2+1) = gM*k21(n1+1,n2+1)/(ee^2*(1-exp(-k21(n1+1,n2+1)/(kb*T))));
        tun12(n1+1,n2+1) = gM*k12(n1+1,n2+1)/(ee^2*(1-exp(-k12(n1+1,n2+1)/(kb*T))));
        tunL1(n1+1,n2+1) = g1L*kL1(n1+1,n2+1)/(ee^2*(1-exp(-kL1(n1+1,n2+1)/(kb*T))));
        tunL2(n1+1,n2+1) = g2L*kL2(n1+1,n2+1)/(ee^2*(1-exp(-kL2(n1+1,n2+1)/(kb*T))));
        tunR1(n1+1,n2+1) = g1R*kR1(n1+1,n2+1)/(ee^2*(1-exp(-kR1(n1+1,n2+1)/(kb*T))));
        tunR2(n1+1,n2+1) = g2R*kR2(n1+1,n2+1)/(ee^2*(1-exp(-kR2(n1+1,n2+1)/(kb*T))));
    end
end

% Build an index list of all n1,n2 pairs that are relevant for transport
% (ie, near levels where conduction happens)
index = zeros(N+3,N+3); % Use index(1,1) as a stop on n1=-1,n2=-1
count = 0;
mu1Step = 1.5*(mu1(1,2)-mu1(1,1));
mu2Step = 1.5*(mu2(1,2)-mu2(1,1));
debug3 = zeros((N+1)^2,1);
for n1=0:N
    for n2=0:N
        % Check if dot energy levels are near lead energy levels
        dot1 = mu1(n1+1,n2+1);
        dot2 = mu2(n1+1,n2+1);
        if (muL-mu1Step <= dot1 && dot1 <= muR+mu1Step) || (muR-mu1Step <= dot1 && dot1 <= muL+mu1Step) || (muL-mu2Step <= dot2 && dot2 <= muR+mu2Step) || (muR-mu2Step <= dot2 && dot2 <= muL+mu2Step)
            debug3(n1*(N+1)+n2+1) = 1;
            count = count+1;
            index(n1+2,n2+2) = count;
        end
    end
end
debug4 = index;

if count == 0
    % This case means no states are near the lead energy levels (eg, N=0)
    % In this case, no current will occur so we can just end the calc here
    debug1 = 1;
    current = 0;
    return % End the function
end

% If there are states near lead levels, continue
pVecSize = count;

if DEBUG
    fprintf('Done tunneling rate calculations: %f\n', toc);
end

% Now solve for p(n1,n2) which is stationary
% pVec format: element 1:N+1 is n1=0, n2 = 0:N, N+2:2*N+2 is n1=1,
% n2=0:N,...
% Coeff matrix is the coeffs from equation (4.3)
coeff = zeros(pVecSize,pVecSize);
for n1 = 0:N
    for n2 = 0:N
        currIndex = index(n1+2,n2+2);
        if currIndex ~= 0
            % All tunneling routes out of this state
            coeff(currIndex,currIndex) = -(tun1L(n1+1,n2+1)+tun1R(n1+1,n2+1)+tun2L(n1+1,n2+1)+tun2R(n1+1,n2+1)+tun21(n1+1,n2+1)+tun12(n1+1,n2+1)+tunL1(n1+1,n2+1)+tunL2(n1+1,n2+1)+tunR1(n1+1,n2+1)+tunR2(n1+1,n2+1));
            if index(n1+1,n2+2) ~= 0
                % Tunneling into n1
                coeff(currIndex, index(n1+1,n2+2)) = tunL1(n1,n2+1) + tunR1(n1,n2+1);
                if index(n1+1,n2+3) ~= 0
                    % tunneling from 2 to 1
                    coeff(currIndex,index(n1+1,n2+3)) = tun21(n1,n2+2);
                end
            end
            if index(n1+2,n2+1) ~= 0
                % Tunneling into n2
                coeff(currIndex, index(n1+2,n2+1)) = tunL2(n1+1,n2) + tunR2(n1+1,n2);
                if index(n1+3,n2+1) ~= 0
                    % tunneling from 1 to 2
                    coeff(currIndex, index(n1+3,n2+1)) = tun12(n1+2,n2);
                end
            end
            if index(n1+3,n2+2) ~= 0
                % Tunnel out of n1 to a lead
                coeff(currIndex, index(n1+3,n2+2)) = tun1L(n1+2,n2+1)+tun1R(n1+2,n2+1);
            end
            if index(n1+2,n2+3) ~= 0
                % Tunnel out of n2 to a lead
                coeff(currIndex, index(n1+2,n2+3)) = tun2L(n1+1,n2+2)+tun2R(n1+1,n2+2);
            end
        end
    end
end

if DEBUG
    fprintf('Done coeff matrix building: %f\n', toc);
end

% Now build an initial pVec estimate and iterate it to a stationary
% solution
pVec = zeros(pVecSize,1);
try
    pVec(index(n1Start+2,n2Start+2)) = 1;
catch
    pVec(1) = 1;
end

% Scaling is done by multiplying previous solution by (I - t*C) where I is
% identiy, C is the coeff matrix, and t is some scaled timestep
unity = eye(pVecSize);

% The coeff matrix is pretty sparse, so it's faster to store it as such
coeff = sparse(coeff);
unity = sparse(unity);
pVec = sparse(pVec);

if DEBUG
    fprintf('Starting time loop: %f\n', toc);
end

% Calibrate tStep
tStepScale = 50000;
% From Danilov et. al., it's best if tStep is scaled by inverse of max eigenval, which
% is roughly approx by scaling by trace
tStep = tStepScale / -(trace(coeff));
notCalibrated = 1; % Calibrate the tStep to not explode the prob dist (NB: It's somewhat redundant to have this here as well as in the time step loop, but this keeps the counter abortion low in the time step case)
counter = 0;
while notCalibrated
    tempVec = (unity + tStep*coeff)*pVec;
    if max(tempVec < 0) > 0 % If any of the elements are less than zero
        tStep = tStep / 1.4;
    else
        notCalibrated = 0;
    end
    counter = counter + 1;
    if counter > 100
        notCalibrated =0;
    end
end

numTSteps = 50000;
debug1 = zeros(pVecSize,numTSteps);

% Need to catch if the stepping is "too fast" by watching for negative
% probabilities and restarting if this occurs
finished = 0;
restartCounter = 0;
while not(finished)
    finished = 1; % If nothing goes wrong then this we will be finished after the for loop
    for count = 1:numTSteps
        % Output pVec evolution (image(debug1) to see step evolution)
        debug1(:,count) = pVec;
        % For catch condition
        pVecDelta = +tStep*coeff*pVec;
        pVec = pVec + pVecDelta;
        % Check for negative pValue
        if max(pVec < 0) > 0
            tStep = tStep / 1.4;
            restartCounter = restartCounter + 1;
            finished = 0; % Mark not finished
            % Re-initialize pVec
            pVec = zeros(pVecSize,1);
            try
                pVec(index(n1Start+2,n2Start+2)) = 1;
            catch
                pVec(1) = 1;
            end
            pVec = sparse(pVec);
            % If restart is looping hard, abort
            if restartCounter > 50
                fprintf('Warning: exceeded restart counter. Aborting.\n');
                finished = 1;
            end
            break; % Restart for loop
        end
        % renormalize the pVec
        pVec = pVec / sum(pVec);
        % If convergence criteria is met, end loop
        if count > 20 && sum(abs(pVecDelta))/pVecSize < 1e-9
            break
        end
    end
end

debug1 = debug1(:,1:count);

if DEBUG
    fprintf('Done time stepping: %f\n', toc);
    [ ~, idx ] = max(pVec);
    for n1 = 0:N
        for n2 = 0:N
            if index(n1+2,n2+2) == idx
                fprintf('Max n1 = %d, max n2 = %d\n',n1,n2)
            end
        end
    end
end

% Once we have equilibrium distribution, determine current using tunneling
% rates. Note we only need to count current to/from on lead as it is by
% necessity matched on the other
current = 0;
for n1 = 0:N
    for n2 = 0:N
        % Tunnelling through left lead will give current through system
        if index(n1+2,n2+2)~=0
            current = current + ee * ( tunL1(n1+1,n2+1)- tun1L(n1+1,n2+1) + tunL2(n1+1,n2+1) - tun2L(n1+1,n2+1))*pVec(index(n1+2,n2+2));
        end
    end
end

if DEBUG
    fprintf('Done all: %f\n', toc);
end

end