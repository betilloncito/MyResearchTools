child = get(gca,'Children');

e = 1.602e-19; %C
h = 6.626e-34; %J*s
kB = 8.6173e-5; %eV/K
alpha = 0.05; % lever arm eV/V

stop = 254;
figure(99)
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