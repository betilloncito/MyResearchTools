
clc;
clear all;

child = get(gca,'Children');

X= get(child,'XData');
Y= get(child,'YData');
Z= get(child,'ZData');

% bias = -3.3e-6;
bias = 199.4e-6;
bias = 197.5e-6;
bias = 14.25e-6;
bias = 7.5;

min_bias = 180e-6;
max_bias = 190e-6;
min_bias = -5;
max_bias = 15;

Inv = -1;

min_g = -0.459;
max_g = -0.467;

for i=1:length(X);
    if(i<length(X))
        if(X(i)<bias && X(i+1)>bias)
            index_x = i
            break;
        end
        if(X(i)>bias && X(i+1)<bias)
            index_x = i
            break;
        end
    end
    if(X(i)==bias)
        index_x = i
    end
end

for i=1:length(X);
    if(i<length(X))
        if(X(i)<min_bias && X(i+1)>min_bias)
            index_x_min = i
            break;
        end
        if(X(i)>min_bias && X(i+1)<min_bias)
            index_x_min = i
            break;
        end
    end
    if(X(i)==min_bias)
        index_x_min = i
    end
end

for i=1:length(X);
    if(i<length(X))
        if(X(i)<max_bias && X(i+1)>max_bias)
            index_x_max = i
            break;
        end
        if(X(i)>max_bias && X(i+1)<max_bias)
            index_x_max = i
            break;
        end
    end
    if(X(i)==bias)
        index_x_max = i
    end
end


for i=1:length(Y);
    if(i<length(Y))
        if(Y(i)<min_g && Y(i+1)>min_g)
            index_y_min = i
            break;
        end
        if(Y(i)>min_g && Y(i+1)<min_g)
            index_y_min = i
            break;
        end
    end
    if(Y(i)==min_g)
        index_y_min = i
    end
end

for i=1:length(Y);
    if(i<length(Y))
        if(Y(i)<max_g && Y(i+1)>max_g)
            index_y_max = i
            break;
        end
        if(Y(i)>max_g && Y(i+1)<max_g)
            index_y_max = i
            break;
        end
    end
    if(Y(i)==max_g)
        index_y_max = i
    end
end

% figure(998);
if(index_y_min<index_y_max)
    V_g = Y(index_y_min:index_y_max);
    GG = -Z(index_y_min:index_y_max,index_x);
    if(index_x_min<index_x_max)
        G = -Z(index_y_min:index_y_max,index_x_min:index_x_max);
        Vbias = X(index_x_min:index_x_max);
    else
        G = -Z(index_y_min:index_y_max,index_x_max:index_x_min);
        Vbias = X(index_x_max:index_x_min);
    end
%     if(min(G)<0)
%         G = G+min(G);
%     end
else
    V_g = Y(index_y_max:index_y_min);
    GG = -Z(index_y_max:index_y_min,index_x);
    if(index_x_min<index_x_max)
        G = -Z(index_y_max:index_y_min,index_x_min:index_x_max);
        Vbias = X(index_x_min:index_x_max);
    else
        G = -Z(index_y_max:index_y_min,index_x_max:index_x_min);
        Vbias = X(index_x_max:index_x_min);
    end
%     if(min(GG)<0)
%         GG = GG+min(GG);
%     end
end

figure(444);
surf(Vbias,V_g,G*Inv,'EdgeAlpha',0);view(2);
figure(434)
plot(V_g,GG*Inv);grid on;
title(['bias:',num2str(X(index_x))]);


% pause;
G_avg = mean(G,2);
figure(555);
plot(V_g,G_avg*Inv);grid on;hold on;
% G_avg_1 = [G(1:find(G_avg==max(G_avg))),fliplr(G(1:find(G_avg==max(G_avg))))]
% V_g_1 = V_g(1:length(G_avg_1))

% size(V_g_1)
% size(G_avg_1)

% plot(V_g_1,G_avg_1);


%{
G = G_avg;
G = GG;

e = 1.602e-19; %C
h = 6.626e-34; %J*s
kB = 8.6173e-5; %eV/K
alpha = 0.05; % lever arm eV/V
Vo = V_g(G==max(G)); %V
G = G/(2*e^2/h);

% figure(999)
% plot(V_g-Vo,G);grid on;
% figure(998)
% semilogy(V_g-Vo,G);grid on;

func = strcat(num2str(1/(2*kB)),'*C2*cosh((',num2str(alpha),'*(Vg - ',num2str(Vo),'))/(2*',num2str(kB),'*T))^(-2)/T');
modelVariables = {'T','C2'};
fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
size(V_g)
size(G)
T_start  = 50e-3;
C2_start = 2*max(G)*kB*T_start
myfit_G = fit(V_g', G, fmodel, 'Start', [T_start, C2_start]);

vals = coeffvalues(myfit_G);
T_fit = vals(1);C2_fit = vals(2);

figure(999)
plot(myfit_G,V_g,G)
% plot(myfit_G,V_g-Vo,G);grid on;
% figure(998)
% semilogy(myfit_G,V_g-Vo,G);grid on;

title(['Fit: temperature=',num2str(T_fit),' and C2=',num2str(C2_fit)])
%}







