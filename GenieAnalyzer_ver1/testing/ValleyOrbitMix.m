%ValleyOrbitMix

%Reset Variables-----------------------------------------------------------
EE = [];
%--------------------------------------------------------------------------
h = 6.62607e-34;%J*s
me = 9.10938e-31;%kg
hbar = h/(2*pi);
ee = 1.60217e-19;%C
g = 2;
uB = 9.274e-24;%J/T
%--------------------------------------------------------------------------
%Identities
I2 = diag([1,1]);
    
%Sweep Parameters:
Sweep = 1;
d = 80e-9;
B = 0;
if(Sweep == 1)
    d = linspace(10,300)*1e-9;
    param = d;
else
    B = linspace(0,10,100);
    param = B;
end

for index=1:length(param)        
    H_Eorb=[];H_valley=[];H_Zeeman=[];H=[];HH=[];
    
    if(Sweep == 1)
        index1 = index;
        index2 = 1;
    else
        index1 = 1;
        index2 = index;
    end

    %Orbital States
    NumOrb = 2;
    me_star = 0.2*me;   AA = pi*(d(index1)/2)^2;
    Eorb = linspace(1,NumOrb,NumOrb).^2*(hbar*pi)^2/(2*me_star*AA)/ee;
    H_Eorb = diag(Eorb);
    
    %Valley States
    Delta_vs = 300.00e-6;%eV
    H_valley = [0 Delta_vs/2 ; Delta_vs/2 0];
    
    %Spin States
    H_Zeeman = g*uB*B(index2)/2*[-1 0; 0 1]/ee;
       
    %Hamiltonia
    H1 = kron(H_Eorb,I2) + kron(I2,H_valley);    
    HH = kron(I2,H1) + kron(H_Zeeman,kron(I2,I2));
    
    [eigenVec,lambda] = eig(HH);
    EE(:,index) = diag(lambda);    
    
end

CC = varycolor(size(EE,1));
figure(1);  child = get(gca,'Children');    delete(child);
for i=1:size(EE,1)
    
    line(param,EE(i,:),'Color',CC(i,:),'Marker','none');
    
end
set(gca,'XScale','linear');
set(gca,'YScale','log');
xlabel('Sweep Parameter (B-field or QD-Diameter');
ylabel('Eigen-energies [eV]');
grid on;

