function [ current ,gammaFwd, gammaBkwd, gamma , dkf, dkb, dk] = MultiDot_nonNegN(V, V_g, T, c11,c12,c21,c22,cg1,cg2,c,g11,g12,g21,g22,gM)
% Calculates the current as a function of bias and gate for a multi-dot system with arbitrary coupling and a single gate.
% This function uses Phys Rev B, 65, 125312

% To Do: All of it
%  - determine if n1,n2 < 0 are needed (not included right now)

% Fixed Parameters
ee = 1.60218e-19; % electron charge, Units = Coulomb
kB = 1.3806e-23; % Boltzmann constant, Units = m^2 kg s^-2 K^-1

% Calculation parameters
N = 10;

% Calculate intermediate sums for later use
cSum1 = c11+c12+cg1+c;
cSum2 = c22+c21+cg2+c;
cDeltaSq = cSum1*cSum2-c^2;

% Build the capacitance matrix which is passed around to sub-functions
% Format: c(i,j) = c_i,j for i < 3, i=3 => g, i=4 -> sum, c(5,1) = c, c(5,2) = cDeltaSq;
cArray = zeros(5,2);
cArray(1,1) = c11; cArray(1,2) = c12; cArray(2,1) = c21; cArray(2,2) = c22;
cArray(3,1) = cg1; cArray(3,2) = cg2; cArray(4,1) = cSum1; cArray(4,2) = cSum2;
cArray(5,1) = c;
cArray(5,2) = cDeltaSq;

% Build the transmission array
g(1,1) = g11; g(1,2) = g12; g(2,1) = g21; g(2,2) = g22;

% Build the lookup table of gamma values
numElem = N+1;
% gammaFwd(alpha,beta,n1,n2) is Gamma^->_{alpha,beta}(n1,n2)...
gammaFwd = -999*ones(2,2,numElem,numElem);
gammaBkwd = -9999*ones(2,2,numElem,numElem);
gamma = -99999*ones(2,2,numElem,numElem);
for alpha = 1:2
    for n1 = 0:N
        for n2 = 0:N
            for beta = 1:2
                dkf = deltaKForward(cArray,V,V_g,alpha,beta,n1,n2);
                gammaFwd(alpha,beta,n1+1,n2+1) = g(alpha,beta)*dkf / (ee^2*(1-exp(-dkf/(kB*T))));
                dkb = deltaKBackward(cArray,V,V_g,alpha,beta,n1,n2);
                gammaBkwd(alpha,beta,n1+1,n2+1) = g(alpha,beta)*dkb/ (ee^2*(1-exp(-dkb/(kB*T))));
            end
            dk = deltaK(cArray,V,V_g,alpha,n1,n2);
            gamma(alpha,1,n1+1,n2+1) = gM*dk / (ee^2 * (1-exp(-dk/(kB*T))));
        end
    end
end

% Now solve for p(n1,n2) which is stationary
% pVec format: element 1:N+1 is n1=0, n2 = 0:N, N+2:2*N+2 is n1=1,
% n2=0:N,...
% Coeff matrix is the coeffs from equation (4.3)
coeff = zeros((N+1)^2,(N+1)^2);
for n1 = 0:N
    for n2 = 0:N
        index = (n1)*(N+1) + n2 + 1;
        coeff(index,index) = -(gammaFwd(1,1,n1+1,n2+1)+gammaBkwd(1,1,n1+1,n2+1)+gammaFwd(1,2,n1+1,n2+1)+gammaBkwd(1,2,n1+1,n2+1)+gammaFwd(2,1,n1+1,n2+1)+gammaBkwd(2,1,n1+1,n2+1)+gammaFwd(2,2,n1+1,n2+1)+gammaBkwd(2,2,n1+1,n2+1)+gamma(1,1,n1+1,n2+1)+gamma(2,1,n1+1,n2+1));
        if n1 > 0
            coeff(index,index-(N+1)) = gammaFwd(1,1,n1,n2+1) + gammaBkwd(1,2,n1,n2+1);
            if n2 < N
                coeff(index,index-(N+1)+1) = gamma(2,1,n1,n2+2);
            end
        end
        if n2 > 0
            coeff(index,index-1) = gammaFwd(2,1,n1+1,n2)+gammaBkwd(2,2,n1+1,n2);
            if n1 < N
                coeff(index,index+(N+1)-1) = gamma(1,1,n1+2,n2);
            end
        end
        if n1 < N
            coeff(index,index+(N+1)) = gammaBkwd(1,1,n1+2,n2+1)+gammaFwd(1,2,n1+2,n2+1);
        end
        if n2 < N
            coeff(index,index+1) = gammaBkwd(2,1,n1+1,n2+2)+gammaFwd(2,2,n1+1,n2+2);
        end
    end
end

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%current = coeff;
%current = linsolve(coeff,zeros((2*N+1)^2,1));

tSteps = 1000;
tStepSize = 100;
% % current = zeros((2*N+1)^2,tSteps);
% Start with empty dots
pVec = zeros((N+1)^2,1);
pVec((0+N)*(N+1) + 0 + 1) = 1;
unity = eye((N+1)^2);
StepScale = trace(coeff);
tJump = tStepSize/StepScale;
%%My basic attempt
% for count = 1:tSteps
% %     current(:,count) = pVec;
%     dpVec = coeff*pVec;
%     pVec = pVec + tStepSize*dpVec;
%     % renormalize
%     scale = sum(pVec.^2);
%     pVec = pVec / sqrt(scale);
% end
%%Based on paper
for count = 1:tSteps
% %     current(:,count) = pVec;
    pVec = (unity - tJump*coeff)*pVec;
    % renormalize
    scale = sum(pVec.^2);
    pVec = pVec / sqrt(scale);
end

% % % % Solve for p_n1,n2 which result in dp/dt = 0. Note the coeff matrix isn't
% % % % well conditioned, so this may need help (TODO)
% % % [ v, d] = eig(coeff);
% % % [ ~, i] = min(abs(diag(d)));
% % % pVec = v(:,i);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine the current
current = 0;
for n1 = 0:N
    for n2 = 0:N
        current = current + ee * ((gammaFwd(1,1,n1+1,n2+1) - gammaBkwd(1,1,n1+1,n2+1) + gammaFwd(2,1,n1+1,n2+1) - gammaBkwd(2,1,n1+1,n2+1))*pVec((n1)*(N+1) + n2 + 1));
    end
end

end

function result = deltaKForward(cArray,V,V_g,alpha,beta, n1, n2)
% Computes deltaK^->_alpha,beta

% Electron charge
ee = 1.60218e-19; % Units = Coulomb

alphaBar = 3-alpha;
betaBar = 3-beta;

if alpha == 1
	nAlpha = n1;
    nAlphaBar = n2;
else
	nAlpha = n2;
    nAlphaBar = n1;
end
% if beta == 1
% 	nBeta = n1;
%     nBetaBar = n2;
% else
% 	nBeta = n2;
%     nBetaBar = n1;
% end

% Calculate
numerator = ee^2 *(cArray(4,alphaBar)*((-1)^beta * nAlpha - 1/2)+cArray(5,1)*(-1)^beta*nAlphaBar);
numerator = numerator + ee * V * (cArray(4,alphaBar)*cArray(alpha,betaBar)+cArray(5,1)*cArray(alphaBar,betaBar));
numerator = numerator + ee*((-1)^beta*V_g+V/2)*(cArray(4,alphaBar)*cArray(3,alpha)+cArray(5,1)*cArray(3,alphaBar));
result = numerator/cArray(5,2);
end

function result = deltaKBackward(cArray,V,V_g,alpha,beta, n1, n2)
% Computes deltaK^<-_alpha,beta

% Electron charge
ee = 1.60218e-19; % Units = Coulomb

alphaBar = 3-alpha;
betaBar = 3-beta;

if alpha == 1
	nAlpha = n1;
    nAlphaBar = n2;
else
	nAlpha = n2;
    nAlphaBar = n1;
end
% if beta == 1
% 	nBeta = n1;
%     nBetaBar = n2;
% else
% 	nBeta = n2;
%     nBetaBar = n1;
% end

% Calculate
numerator = -ee^2 *(cArray(4,alphaBar)*((-1)^beta * nAlpha + 1/2)+cArray(5,1)*(-1)^beta*nAlphaBar);
numerator = numerator - ee * V * (cArray(4,alphaBar)*cArray(alpha,betaBar)+cArray(5,1)*cArray(alphaBar,betaBar));
numerator = numerator - ee*((-1)^beta*V_g+V/2)*(cArray(4,alphaBar)*cArray(3,alpha)+cArray(5,1)*cArray(3,alphaBar));
result = numerator/cArray(5,2);
end

function result = deltaK(cArray,V,V_g,alpha, n1, n2)
% Computes deltaK_alpha,alphaBar

% Electron charge
ee = 1.60218e-19; % Units = Coulomb

alphaBar = 3-alpha;

if alpha == 1
	nAlpha = n1;
	nAlphaBar = n2;
else
	nAlpha = n2;
	nAlphaBar = n1;
end

% Calculate
numerator = -ee^2 * ( -cArray(4,alphaBar)*(nAlpha-1/2)+cArray(4,alpha)*(nAlphaBar+1/2) + cArray(5,1)*(nAlpha-nAlphaBar-1));
numerator = numerator - ee *(-1)^alpha*V*(cArray(alpha,alpha)*cArray(alphaBar,alphaBar)-cArray(alpha,alphaBar)*cArray(alphaBar,alpha)+cArray(3,alpha)*(cArray(alphaBar,alphaBar)-cArray(alphaBar,alpha))/2 + cArray(3,alphaBar)*(cArray(alpha,alpha)-cArray(alpha,alphaBar)/2));
numerator = numerator + ee * V_g *(cArray(3,alpha)*(cArray(alphaBar,alphaBar)+cArray(alphaBar,alpha))-cArray(3,alphaBar)*(cArray(alpha,alpha)+cArray(alpha,alphaBar)));
result = numerator/cArray(5,2);
end