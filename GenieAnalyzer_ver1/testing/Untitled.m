%{
child = get(gca,'Children');
X = get(child,'XData');
Y = get(child,'YData');
% i = [7,9,10,11,12];%30mK
% i = [5,7,8,9,10,11,12];%110mK
% i = [6,7,8,9,10,11];%180mK
% i = [5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,22];%250mK
i = [4,6,7,8,9,10,11,12,13,14,15,19,20,21,23,25,26,27];%375mK

 for ii=1:length(i)
    XX(ii) = X(i(ii));
    YY(ii) = Y(i(ii));
end
avg = mean(YY);

figure;
plot(XX,YY,'Marker','o','MarkerSize',4,'MarkerFaceColor','r',...
    'MarkerEdgeColor','k','LineStyle','none');
grid on;
xlabel('Vbias [V]');

% ylabel('Temperature [K]');
ylabel('Alpha_g');
% ylabel('A constant');

T = 375;
% title([{['Lattice Temperature = ',num2str(T),'mK']};{['Average Value=',num2str(avg),'K']}]);
title([{['Lattice Temperature = ',num2str(T),'mK']};{['Average Value=',num2str(avg)]}]);
set(gcf,'Color','w');
set(gca,'FontSize',15);
ax = gca;
ax.TitleFontSizeMultiplier = 0.8;
%}
e = 1.602e-19;h = 6.626e-34;

Te = [0.27203,0.32143,0.37109,0.44799,0.58333];
Te = Te-0.2*0;
A = [0.0112,0.019339,0.025556,0.033932,0.066684]*1e-7*e/h;

T = [0.03,0.11,0.18,0.25,0.375];

figure;
plot(T,Te,'Marker','o','MarkerSize',4,'MarkerFaceColor','r',...
    'MarkerEdgeColor','k','LineStyle','--');
grid on;
xlabel('Lattice Temperature [K]');ylabel('Electron Temperature [K]');

% figure;
% plot(T,A,'Marker','o','MarkerSize',4,'MarkerFaceColor','r',...
%     'MarkerEdgeColor','k','LineStyle','--');
% grid on;
% xlabel('Lattice Temperature [K]');ylabel('Tunneling Rate [K]');




