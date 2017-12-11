% fig = get(0,'CurrentFigure');
% ax = get(fig,'CurrentAxes');
% axs_children = get(ax,'Children');
% axs_line = findall(axs_children,'Type','Line');
% 
% k=length(axs_line);
% x = get(axs_line(k),'XData');
% y = get(axs_line(k),'YData');
% figure(222)
% plot(xdata,ydata)
% pause;

Fs = 1/abs(x(1)-x(2));
L = length(x);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
YY = 2*abs(Y(1:NFFT/2+1));

% Plot single-sided amplitude spectrum.
figure(222);
plot(f,YY);grid on;hold on;
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

der = diff(YY)./diff(f);
for i=1:length(f)-1
    favg(i) = mean([f(i),f(i+1)]);
end
% figure(333)
% plot(favg,der)

cnt = 1;
for i=1:length(der)-1
   if(der(i)>0 && der(i+1)<0)
       power(cnt) = YY(i+1)
       f_new(cnt) = f(i+1)
       cnt = cnt+1;
   end    
end
plot(f_new,power,'r*');
hold off;

alpha = 10;
ff = linspace(f_new(1),f_new(end),1000);
figure(44);
plot(log10(f_new),log10(power),'b-');hold off;
grid on;
coeff = polyfit(log10(f_new),log10(power),1);
A = -coeff(1)
inter = coeff(2)

figure(54);
plot(f_new,power,'r*');grid on;hold on;
fun = 10^(inter)./(f.^(A));
plot(f,fun,'r');
plot(f,YY,'k');
hold off;
