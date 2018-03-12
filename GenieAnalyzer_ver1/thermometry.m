PEAK(1) = 1.1268e-07;
PEAK(2) = 9.0279e-08;
PEAK(3) = 7.6138e-08;
PEAK(4) = 6.0577e-08;
PEAK(5) = 4.958e-08;

Te(1) = 138;
Te(2) = 168;
Te(3) = 220;
Te(4) = 300;
Te(5) = 400;

Tmx(1) = 34;
Tmx(2) = 89;
Tmx(3) = 144;
Tmx(4) = 240;
Tmx(5) = 346;

figure(500);plot(Te, (1./PEAK)/1e6, 'bo');grid on;
xlabel('Te [mK]');ylabel('1/Gmax [MOhms]');

figure(501);plot(Tmx,Te,'ro');hold on;
plot(Tmx,Tmx,'k--');grid on;
xlabel('Thermometer [mK]');ylabel('Te [mK]');




