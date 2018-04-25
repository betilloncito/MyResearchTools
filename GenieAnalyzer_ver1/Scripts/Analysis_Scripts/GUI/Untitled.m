alpha = 0.139;%eV/V
rate = 0.08;%T/min
scanTime = 46;%sec/scan
u = 5.788381e-5;%eV/T

child = get(gca,'Children');
X = get(child,'XData');
Y = get(child,'YData');

Y = Y*alpha;
YY = Y(4:75);
XX = linspace(0,4,length(YY));

% figure(23);
% plot(XX,YY,'ko--');hold on;grid on;
% pause;

del = [13,14,15,17,18,51,53,55,59,62,63,64,65]-3;
for i=1:length(del)
    YY(del(i)) = -0.1e-3;
end
% figure(23);
% plot(XX,YY,'ko--');hold on;grid on;

i=1;start=1;
while(i<length(YY))
    for i=start:length(YY)
        i;
        if(YY(i)==-0.1e-3)
            XX(i)=[];
            YY(i)=[];
            start=1;
            disp('deleted');
%             pause;
            break;
        end
        
    end
end

func = 'm*x';
modelVariables = {'m'};
fmodel = fittype(func, 'ind', {'x'}, 'coeff', modelVariables);

myfit = fit(XX',YY',fmodel);

vals = coeffvalues(myfit);
slope = vals(1);
line_fit = slope*XX;

% coeff = polyfit(X(4:75),Y(4:75),1);
% YY = polyval(coeff,X(4:75));
% g = coeff(1)*(0.139/(46/60*0.08))/(u*0.5);

%E = 1/2*u*g*B
%g = 2*(E/B)/u
g = 2*slope/u;

figure(232);
plot(XX,YY,'ko');hold on;grid on;
plot(linspace(0,4,length(Y(4:75))),Y(4:75),'g*');
plot(XX,line_fit,'r--');hold off;

disp(['g value: ',num2str(g)]);
%{
%}
