pk_B = [];
pk_E = [];
trace =[];

g = 2;
Alpha = 0.11;
uB = 5.788381e-5;

child = get(gca,'Children');
X = get(child,'XData');
Y = get(child,'YData');
Z = get(child,'ZData');

size(Z,1)

for i=1:size(Z,1)
    trace = Z(i,:);
    pk_E(i) = X(trace==max(trace));
    pk_B(i) = Y(i);
end

coeff = polyfit(pk_B,pk_E,1);
slope = coeff(1);%m = g*uB/(2*alpha)

alpha = g*uB/(2*slope);
% g_factor = slope*2*Alpha/(uB);

figure(6);
plot(pk_B,pk_E,'o');hold on;
plot(pk_B,pk_B*slope+coeff(2),'r');
title(['alpha = ',num2str(alpha)]);
% title(['g-factor = ',num2str(g_factor)]);