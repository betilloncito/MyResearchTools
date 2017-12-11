 child = get(gca,'Children');
 
%  for i=1:length(child)
%      X = get(child(i),'XData');
%      Y = get(child(i),'YData');
%      coeff = polyfit(X,Y,1);
%      slope(i) = coeff(1);   
%  end

X = get(child,'XData');
Y = get(child,'YData');

YY = log(Y);
[x,y] = Derivative(X,YY,1);

figure(22);plot(x,y)
% er1 = 9.5;
% er2 = 3.9;
% d1 = 31;
% d2 = 15;
% 
% d1 = d1*1e-9;d2 = d2*1e-9;
% D = (d1+d2);
% C = 8.854e-12*(er1*er2)/(er1*d2+er2*d1)
% er_eff = (er1*er2)/(er1*d2+er2*d1)*D

% er3 = 11.68;
% d3 = 2e-9;
% 
% Cx = 8.854e-12*(er_eff*er3)/(er_eff*d3+er3*D)