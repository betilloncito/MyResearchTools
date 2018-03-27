%{
%InAs

A = pi*(1e-3/2)^2;
Power = [0, 3.15, 20.6, 81]/A; %mW

Vbias_zero_arrayNW = [(-6.4+2.4)/2, -342, -427.2, -479.5]; %mV
Vbias_zero_singleNW = [(-22.8+18.8)/2, -171.2, (-225.6-211.5)/2, -223.2]; %mV

figure;
plot(Power/Power(2),Vbias_zero_arrayNW-Vbias_zero_arrayNW(1),'ro--');hold on;
plot(Power/Power(2),Vbias_zero_singleNW-Vbias_zero_singleNW(1),'bo--');hold off;
grid on;
ylabel('Vbias Shift [mV]');xlabel('Power Density [arb.]');

%}

%GaAs

A = pi*(1e-3/2)^2;
Power = [0, 3.15, 31.7]/A; %mW

Vbias_zero_array(1,:) = [-6.8, -164.4, -390]; %mV M1
Vbias_zero_array(2,:) = [-8.8, -224, -545.6]; %mV M2
Vbias_zero_array(3,:) = [-11.6, -228.8, -573.6]; %mV M3
Vbias_zero_array(4,:) = [-7.6, -201.2, -533.2]; %mV M4

figure;
plot(Power/Power(2),Vbias_zero_array(1,:)-Vbias_zero_array(1,1),'ro--');hold on;
plot(Power/Power(2),Vbias_zero_array(2,:)-Vbias_zero_array(2,1),'bo--');hold on;
plot(Power/Power(2),Vbias_zero_array(3,:)-Vbias_zero_array(3,1),'ko--');hold on;
plot(Power/Power(2),Vbias_zero_array(4,:)-Vbias_zero_array(4,1),'go--');hold on;
grid on;
ylabel('Vbias Shift [mV]');xlabel('Power Density [arb.]');


