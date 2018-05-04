clear all; clc;
format short;
fignum = 102;
figHandle = figure(fignum);
% child = get(figHandle,'Children');delete(child);

g = 2;
ee = 1.60217662e-19;%C
m = 9.109e-31;%kg
me = 0.19*m;
uB = 5.788e-5; %eV/T
eo = 8.85e-12;
er = 11.7;
h = 6.62607004e-34; %J*s
hbar = h/(2*pi);

U = 5e-3; %eV
Cap = ee/U;
r = Cap/(8*er*eo);
L = sqrt(pi*r^2);

%Number of electrons
N = 20;
e_pairs = round(N/2);

%Vslley splitting energy
E_VS = [0, 100, 230, 360]*1e-6; %eV
% E_orb = 1.3e-3; %eV

%In Tesla
B_start = 0;
B_end = 3;
B_steps = 100;
Bfield = linspace(B_start,B_end,B_steps);

%Orbital energy
Lx = L;
Ly = L;
e_orb_0 = hbar^2*pi^2/(2*me)*((1/Lx)^2 + (1/Ly)^2);
cnt = 1;
for nx = 1:e_pairs
    for ny = 1:e_pairs
        e_orb = hbar^2*pi^2/(2*me)*((nx/Lx)^2 + (ny/Ly)^2) - e_orb_0;
        E_orb(cnt) = e_orb/ee;
        cnt = cnt+1;
    end
end
E_orb = sort(E_orb,'ascend')

color = varycolor(e_pairs)
for index = 1:e_pairs
% % %     line([Bfield(1),Bfield(end)],E_orb(index)*ones(1,2),'Color',color(index,:),'LineStyle','--');hold on;

%     line([Bfield(1),Bfield(end)],E_orb(index)*ones(1,2),'Color','k','LineStyle',':');hold on;
end

%{
%}
for index_B = 1:length(Bfield)
    mu = [];
    for index_VS = 1:length(E_VS)
        II = [1,0; 0,1];
        
        %loops over all 
        for index = 1:e_pairs
            vec = zeros(1,e_pairs);
            vec(index) = 1;
            M = vec'*vec;
            H = 1/2*[g*uB, 0; 0, -g*uB].*Bfield(index_B) + II*E_orb(index) + II*E_VS(index_VS);
            
            if(index>1)
                MM = MM + kron(M,H);
            else
                MM = kron(M,H);
            end
        end
        mu_orb_VS(:,index_B,index_VS) = diag(MM);
        
%         mu(:,index_VS) = [mu; diag(MM)];
    end
%     for j=1:size(mu,2)
%         mu_orb_VS1(:,index_B,) = mu(:,1);
%     end
%     mu_orb_VS2(:,index_B) = mu(:,2);
end

for ii=1:size(mu_orb_VS,3)
    for i=1:size(mu_orb_VS,1)
        mod(ii,2)
        if(mod(ii,2)==0)
            if(mod(i,2)==0)
                line(Bfield,mu_orb_VS(i,:,ii),'Color','r','LineStyle','--');
            else
                line(Bfield,mu_orb_VS(i,:,ii),'Color','b','LineStyle','--');
            end
        else
            if(mod(i,2)==0)
                line(Bfield,mu_orb_VS(i,:,ii),'Color','r','LineStyle','-');
            else
                line(Bfield,mu_orb_VS(i,:,ii),'Color','b','LineStyle','-');
            end
        end
    end
end
xlabel('B-field [T]');ylabel('Energy [eV]');grid on;

size(mu_orb_VS)
mu_all = [];
for j=1:size(mu_orb_VS,3)
    mu_all = [mu_all;mu_orb_VS(:,:,j)];
end
size(mu_all)
mu_sorted = sort(mu_all,1,'ascend');

figure(fignum+1)
color = varycolor(size(mu_sorted,1));
for N_chosen=1:size(mu_sorted,1)
    
    if(N_chosen>1)
        offset = max(mu_chosen(N_chosen-1,:));
    else
        offset = 0;
    end
    
    mu_chosen(N_chosen,:) = mu_sorted(N_chosen,:) - min(mu_sorted(N_chosen,:)) + offset;
    
%     line(Bfield,mu_chosen(N_chosen,:),'LineStyle','-','LineWidth',4);
    line(Bfield,mu_chosen(N_chosen,:),'Color',color(N_chosen,:),'LineStyle','-','LineWidth',4);
end



% N_chosen = 19;
% for index_B = 1:length(Bfield)
%     mu_chosen(1,index_B) = mu_sorted(N_chosen,index_B);
% end
% line(Bfield,mu_chosen,'Color','m','LineStyle','-','LineWidth',4);


% 
% I = [1;1];
% vec(1) = [1;0;0;0];
% vec(2) = [0;1;0;0];
% vec(3) = [0;0;1;0];
% vec(4) = [0;0;0;1];
% 
% mu_1 = [0;0];
% mu_2 = mu_1 + U;
% mu_3 = mu_2 + U;
% mu_4 = mu_3 + U;

% mu_N 
% mu_d = mu0 + (g*uB*B)/2;

