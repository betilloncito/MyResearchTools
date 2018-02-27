VoltDiv = 10;
S = 1e-4;

X = [];Y=[];

child = get(gca,'Children')

figure
for i = 1:length(child)
    X(i,:) = get(child(i),'XData')/VoltDiv;
    Y(i,:) = get(child(i),'YData')*S;
    
    plot(X(i,:),abs(Y(i,:)));hold on;
   
end
xlabel('Vbias [V]');ylabel('Current [A]')
title('Substrate')
% YY = Y(1,:) - Y(2,:);
% plot(X(1,:),YY);hold on;
hold off;grid on;