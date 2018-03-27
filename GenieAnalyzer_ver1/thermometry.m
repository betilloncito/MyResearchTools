e = 1.60217662e-19; %C
% h = 6.62607004e-34; %J*s
h = 4.135667662e-15; % eV*s
% h=1;
kB = 8.6173303e-5; %eV/K
alpha = 0.04; % lever arm eV/V
% alpha = 1;

% PEAK(1) = 1.1268e-07;
% PEAK(2) = 9.0279e-08;
% PEAK(3) = 7.6138e-08;
% PEAK(4) = 6.0577e-08;
% PEAK(5) = 4.958e-08;
% 
% Te(1) = 138;
% Te(2) = 168;
% Te(3) = 220;
% Te(4) = 300;
% Te(5) = 400;
% 
% Tmx(1) = 34;
% Tmx(2) = 89;
% Tmx(3) = 144;
% Tmx(4) = 240;
% Tmx(5) = 346;

PEAK(1) = 3.7356e-06;
PEAK(2) = 2.0304e-06;
PEAK(3) = 1.2794e-6;
PEAK(4) = 8.9355e-7;
PEAK(5) = 6.2134e-7;
PEAK(6) = 3.8295e-07;

Te(1) = 35.02;
Te(2) = 60.26;
Te(3) = 94.32;
Te(4) = 138.12;
Te(5) = 247.05;
Te(6) = 438.32;

Tmx(1) = 34.75;
Tmx(2) = 61.1;
Tmx(3) = 100.6;
Tmx(4) = 150.25;
Tmx(5) = 251.5;
Tmx(6) = 462.5;

Delta_Vg(1) = abs(-0.4184 - (-0.4186));
Delta_Vg(2) = abs(-0.4182 - (-0.4187));
Delta_Vg(3) = abs(-0.4181 - (-0.4188));
Delta_Vg(4) = abs(-0.4178 - (-0.4189));
Delta_Vg(5) = abs(-0.4175 - (-0.4193));
Delta_Vg(6) = abs(-0.4163 - (-0.4196));

FWHM.meas(1) = alpha*Delta_Vg(1)/h;
FWHM.meas(2) = alpha*Delta_Vg(2)/h;
FWHM.meas(3) = alpha*Delta_Vg(3)/h;
FWHM.meas(4) = alpha*Delta_Vg(4)/h;
FWHM.meas(5) = alpha*Delta_Vg(5)/h;
FWHM.meas(6) = alpha*Delta_Vg(6)/h;

FWHM.theory(1) = 3.5*kB*Te(1)*1e-3/h;
FWHM.theory(2) = 3.5*kB*Te(2)*1e-3/h;
FWHM.theory(3) = 3.5*kB*Te(3)*1e-3/h;
FWHM.theory(4) = 3.5*kB*Te(4)*1e-3/h;
FWHM.theory(5) = 3.5*kB*Te(5)*1e-3/h;
FWHM.theory(6) = 3.5*kB*Te(6)*1e-3/h;

P = [50.0, 130.0, 165.0, 320, 335,    720, 775,  1235, 1765];
T = [61.1, 88.89, 100.6, 140, 150.25, 239, 251,   347,  465];

coeff = polyfit(Te,(1./PEAK)/1e6,1);
figure(500);
plot(Te, (1./PEAK)/1e6, 'bo');grid on;hold on;
plot([0,Te],coeff(1)*[0,Te]+coeff(2),'k--');hold off;
xlabel('Te [mK]');ylabel('1/Gmax [MOhms]');
title(['1/PEAK vs. Te >> Te = 0 intersect : ',num2str(coeff(2))]);
legend('Data','Linear Fit')

figure(501);
plot(Tmx,Te,'ro');grid on;hold on;
plot(Tmx,Tmx,'k--');hold off;
xlabel('Thermometer [mK]');ylabel('Te [mK]');
title('electron vs. lattice temperature');

FWHM.theory = FWHM.theory/(1e9);
FWHM.meas = FWHM.meas/(1e9);

coeff = polyfit(Te,FWHM.meas,1);
figure(503);
plot(Te,FWHM.meas,'go');hold on;grid on;
% plot(Te,FWHM.theory,'rs');
plot([0,Te],coeff(1)*[0,Te]+coeff(2),'k--');hold off;
xlabel('Te [mK]');ylabel('FWHM [GHz]');
title(['Experimental: Te = 0 intersect : ',num2str(coeff(2)*1e3),'MHz']);
legend('Data','Theory','Data Fit')

% figure(504);
% plot(P,T,'o-');grid on;
% xlabel('Power [uW]');ylabel('Temperature [mK]');
% title('Heating curve for DilFridge')



