clc;
clear all;
child = [];
child = get(gca,'Children');

e = 1.60217662e-19; %C
h = 6.62607004e-34; %J*s
kB = 8.6173303e-5; %eV/K
alpha = 0.04; % lever arm eV/V

S = 1e-8;
Vac = 0.1/1e4;

start = 130;
start = 700; %138mK
% start = 510; %168mK
% start = 465;
start = 1;

figure(99)

G_raw = [];Vgg = [];
%averaging several traces
for j=1:length(child)
    Vgg = get(child(j),'XData');
    G_raw(j,:) = get(child(j),'YData');    
end
% GG = mean(G_raw,1);
GG = G_raw;

GG = GG*S/Vac;

% size(GG)
% size(Vgg)
% plot(Vgg,GG);grid on;hold on;
% pause;

 plot(Vgg,GG,'b');grid on;hold on;
%  plot(Vgg(1:stop),GG(1:stop),'r'); hold off;
 plot(Vgg(start:end),GG(start:end),'r'); hold off;
  
%  Vg = Vgg(1:stop); G = GG(1:stop);
 Vg = Vgg(start:end); G = GG(start:end);
 
 G = G/(2*e^2/h);
 
 func = strcat(num2str(1/(2*kB)),'*C2*cosh((',num2str(alpha),'*(Vg - Vo))/(2*',num2str(kB),'*T))^(-2)/T');
 modelVariables = {'T','C2','Vo'};
 fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
 size(Vg)
 size(G)
 
 T_start  = 50e-3;
 C2_start = 2*max(G)*kB*T_start;
 Vo_start = Vg(G==max(G)); %V
 
 myfit_G = fit(Vg', G', fmodel, 'Start', [T_start, C2_start, Vo_start]);
 
 vals = coeffvalues(myfit_G);
 T_fit = vals(1);C2_fit = vals(2);Vo_fit = vals(3);
 
 figure(998)
 plot(myfit_G,Vg,G)
 % plot(myfit_G,V_g-Vo,G);
 grid on;legend off;
 % figure(998)
 % semilogy(myfit_G,V_g-Vo,G);grid on;
 
 title(['Fit: temperature=',num2str(T_fit*1000),'mK and C2=',num2str(C2_fit),' and Vo=',num2str(Vo_fit),'V'])

 Peak = max(G)*(2*e^2/h);
 disp(['Peak height is: ',num2str(Peak)])
 
 quit = 'N';
 prompt = {'C2[arb.]:','Vo[V]:','T[mK]:'};
 dlg_title = 'Input';
 num_lines = 1;
 def = {num2str(C2_fit),num2str(Vo_fit),num2str(T_fit*1000)};
 answer = inputdlg(prompt,dlg_title,num_lines,def);
 while(1)       
     C2_myfit = str2double(answer(1));
     Vo_myfit = str2double(answer(2));
     T_myfit = str2double(answer(3))/1000;
     
     G_calc = C2_myfit/(2*kB*T_myfit)*cosh((alpha*(Vg-Vo_myfit))/(2*kB*T_myfit)).^(-2);
     
     figure(888)
%      plot(Vg,G,'b.');hold on;
%      plot(Vg,G_calc,'r');hold off;
     semilogy(Vg,G,'b.');hold on;
     semilogy(Vg,G_calc,'r');hold off;
     grid on;
     
     pause;
     prompt = {'Quit [Y/N]?:'};
     dlg_title = 'Input';
     num_lines = 1;
     def = {'N'};
     quit = inputdlg(prompt,dlg_title,num_lines,def);
     
     if(strcmp(quit,'N'))
         prompt = {'C2[arb.]:','Vo[V]:','T[mK]:'};
         dlg_title = 'Input';
         num_lines = 1;
         def = {num2str(C2_myfit),num2str(Vo_myfit),num2str(T_myfit*1000)};
         answer = inputdlg(prompt,dlg_title,num_lines,def);
     else
         break;
     end
 end 
 %{
 %}
 
 
 %{
for j=1:length(child)
    Vg = get(child(j),'XData');
    G = get(child(j),'YData');
    %     Y_new = Y/max(Y);
    plot(Vg,G);grid on;hold on;
    plot(Vg(1:stop),G(1:stop)); hold off;
    
    Vg = Vg(1:stop);
    G = G(1:stop);
    
    G = G/(2*e^2/h);
    
    % figure(999)
    % plot(V_g-Vo,G);grid on;
    % figure(998)
    % semilogy(V_g-Vo,G);grid on;
    
    % func = strcat(num2str(1/(2*kB)),'*C2*cosh((',num2str(alpha),'*(Vg - ',num2str(Vo),'))/(2*',num2str(kB),'*T))^(-2)/T');
    func = strcat(num2str(1/(2*kB)),'*C2*cosh((',num2str(alpha),'*(Vg - Vo))/(2*',num2str(kB),'*T))^(-2)/T');
    
    modelVariables = {'T','C2','Vo'};
    fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
    size(Vg)
    size(G)
    
    T_start  = 50e-3;
    C2_start = 2*max(G)*kB*T_start;
    Vo_start = Vg(G==max(G)); %V
    
    myfit_G = fit(Vg', G', fmodel, 'Start', [T_start, C2_start, Vo_start]);
    
    vals = coeffvalues(myfit_G);
    T_fit = vals(1);C2_fit = vals(2);Vo_fit = vals(3);
    
    figure(999)
    plot(myfit_G,Vg,G)
    % plot(myfit_G,V_g-Vo,G);
    grid on;
    % figure(998)
    % semilogy(myfit_G,V_g-Vo,G);grid on;
    
    title(['Fit: temperature=',num2str(T_fit),' and C2=',num2str(C2_fit),' and Vo=',num2str(Vo_fit)])
    
    pause;
end
 %}
 