function MasterEqn_SingleDot
global e;
global kB;
global Ec;
global T;
global NumChannels;

%Constants:
e = 1.602e-19;
kB = 1.38064e-23;
C = 0;
%System properties [K]:
T = 1;
NumChannels = 4;

%Device properties:
%lever-arm of plunger gate (alpha.g), source (alpha.R), drain (alpha.L)
alpha.g = 0.2;
alpha.L = 0.5;
alpha.R = 0.2;
%charging energy [eV]
Ec = 5e-3;
%Tunnel Barriers [Hz]
Gamma.L = 1e3;
Gamma.R = 1e3;

%Applied voltages
Vbias = linspace(-30,30,100)*1e-3;
Vg = linspace(-30,65,100)*1e-3;

%Calculate Current
for i=1:length(Vg)
    for ii=1:length(Vbias)
        I(i,ii) = Calc_I(Vg(i),Vbias(ii),alpha,Gamma);
%         pause(.1);
    end
end

figure(100);
surf(Vbias/1e-3,Vg/1e-3,I,'EdgeAlpha',0);
xlabel('Vbias [mV]');ylabel('Vg [mV]');
view(2);
colormap('jet');


set(gca,'ZLim',[min(min(I)),max(max(I))]);
set(gca,'CLim',[min(min(I)),max(max(I))])

colorbar;

end

function I = Calc_I(Vg,Vbias,alpha,Gamma)
global e;
global Ec;
global NumChannels;

%Vbias: Assume the positive lead is connected to source(Right) and the negative
%lead is connected to the drain(Left)
mu_L = e*Vbias/2;
mu_R = -e*Vbias/2;

I = 0;
for N=0:NumChannels
    %Chemical potential of dot
    mu = e*(alpha.R-alpha.L)*Vbias/2 - e*alpha.g*Vg + e*Ec*N;
    
    %Occupation probabilities:
    %rho_1: probability of having 1e in the dot
    %rho_0: probability of having 0e in the dot
    
    %Transfer Rates:
    %W01: rate at which the dot goes from 0e to 1e
    %W10: rate at which the dot goes from 1e to 0e
    %W01_L: rate at which 1e tunnels into the dot from the left
    %W01_R: rate at which 1e tunnels into the dot from the right
    %W10_L: rate at which 1e tunnels out of the dot from the left
    %W10_R: rate at which 1e tunnels out of the dot from the right
    W01_L = Gamma.L*Fermi(mu,mu_L);
    W01_R = Gamma.R*Fermi(mu,mu_R);
    W10_L = Gamma.L*(1-Fermi(mu,mu_L));
    W10_R = Gamma.R*(1-Fermi(mu,mu_R));
    
    W01 = W01_L + W01_R;
    W10 = W10_L + W10_R;
    
    rho_1 = W01/(W01+W10);
    rho_0 = W10/(W01+W10);
    
    I = e*(rho_1*W10_R - rho_0*W01_R) + I;
end

end

function out = Fermi(mu, mu_lead)
global T;
global kB;

out = 1./(exp((mu-mu_lead)/(kB*T)) + 1);

end