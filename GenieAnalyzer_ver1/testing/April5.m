clear all;

%in F
Cx(:,1) = [2.52e-17,2.44e-17,2.12e-17,2.56e-17,2.33e-17,2.00e-17,2.00e-17];
Cx(:,2) = [2.37e-17,2.16e-17,2.16e-17,2.16e-17,2.21e-17,1.96e-17,2.11e-17];
Cx(:,3) = [3.39e-17,3.19e-17,2.62e-17,3.26e-17,3.62e-17,3.1e-17,2.75e-17];
Cx(:,4) = [3.85e-17,3.54e-17,3.15e-17,3.69e-17,3.74e-17,2.97e-17,2.82e-17];

Cy(:,1) = [2.47e-17,2.39e-17,2.22e-17,2.11e-17,1.97e-17,2.02e-17,2.12e-17];
Cy(:,2) = [2.88e-17,2.58e-17,2.91e-17,2.72e-17,2.58e-17,2.56e-17,2.23e-17];
Cy(:,3) = [4.26e-17,4.27e-17,4.26e-17,4.29e-17,4.27e-17,4.41e-17,3.55e-17];
Cy(:,4) = [3.53e-17,3.61e-17,3.53e-17,3.48e-17,3.21e-17,3.15e-17,2.84e-17];

Cgx(:,1) = [8.43e-18,8.26e-18,7.83e-18,9.68e-18,9.31e-18,8.00e-18,8.95e-18];
Cgx(:,2) = [8.64e-18,8.11e-18,7.99e-18,9.9e-18,9.42e-18,7.88e-18,9.04e-18];
Cgx(:,3) = [8.58e-18,8.15e-18,8.01e-18,9.4e-18,9.11e-18,7.67e-18,9.05e-18];
Cgx(:,4) = [8.62e-18,8.22e-18,7.78e-18,9.37e-18,9.07e-18,7.84e-18,8.62e-18];
    
Cgy(:,1) = [7.24e-18,7.04e-18,7.60e-18,7.32e-18,6.97e-18,7.02e-18,6.56e-18];
Cgy(:,2) = [8.52e-18,8.77e-18,8.36e-18,8.23e-18,8.61e-18,8.54e-18,8.48e-18];
Cgy(:,3) = [9.29e-18,9.32e-18,9.54e-18,9.81e-18,9.19e-18,9.19e-18,1.02e-17];
Cgy(:,4) = [7.77e-18,8.02e-18,8.31e-18,8.14e-18,7.88e-18,8.12e-18,8.06e-18];
    
Cleadx(:,1) = [1.42e-17,1.38e-17,1.16e-17,1.38e-17,1.17e-17,9.97e-18,8.43e-18];
Cleadx(:,2) = [1.27e-17,1.13e-17,1.13e-17,9.56e-18,1.07e-17,9.64e-18,1.05e-17];
Cleadx(:,3) = [2.17e-17,2.02e-17,1.56e-17,2e-17,2.23e-17,1.93e-17,1.68e-17];
Cleadx(:,4) = [2.6e-17,2.34e-17,2.08e-17,2.41e-17,2.45e-17,1.87e-17,1.71e-17];
    
Cleady(:,1) = [1.50e-17,1.45e-17,1.29e-17,1.15e-17,1.04e-17,1.11e-17,1.2e-17];
Cleady(:,2) = [1.79e-17,1.49e-17,1.84e-17,1.68e-17,1.52e-17,1.5e-17,1.23e-17];
Cleady(:,3) = [2.96e-17,2.98e-17,3.05e-17,2.99e-17,2.87e-17,3.08e-17,2.37e-17];
Cleady(:,4) = [2.37e-17,2.43e-17,2.41e-17,2.32e-17,2.04e-17,2.02e-17,1.78e-17];

Cm(:,1) = [2.54e-18,2.43e-18,1.78e-18,2.20e-18,2.25e-18,2.06e-19,2.66e-18];
Cm(:,2) = [2.39e-18,2.14e-18,2.32e-18,2.18e-18,1.95e-18,2.03e-18,1.53e-18];
Cm(:,3) = [3.66e-18,3.59e-18,2.62e-18,3.21e-18,4.77e-18,4.04e-18,1.69e-18];
Cm(:,4) = [3.87e-18,3.78e-18,2.91e-18,3.48e-18,3.8e-18,3.17e-18,2.52e-18];

%in eV
Ecx(:,1) = [6.44e-03,6.62e-03,7.60e-03,6.30e-03,6.96e-03,8.08e-3,8.13e-3];
Ecx(:,2) = [6.82e-3,7.48e-3,7.47e-3,7.47e-3,7.3e-3,8.26e-3,7.65e-3];
Ecx(:,3) = [4.77e-3,5.06e-3,6.15e-3,4.94e-3,4.49e-3,5.23e-3,5.84e-3];
Ecx(:,4) = [4.21e-3,4.58e-3,5.12e-3,4.38e-3,4.34e-3,5.44e-3,5.73e-3];
    
Ecy(:,1) = [6.55e-03,6.76e-03,7.25e-03,7.68e-03,8.24e-03,8.03e-3,7.68e-3];
Ecy(:,2) = [5.6e-3,6.26e-3,5.56e-3,5.93e-3,6.25e-3,6.31e-3,7.22e-3];
Ecy(:,3) = [3.8e-3,3.79e-3,3.78e-3,3.76e-3,3.81e-3,3.68e-3,4.52e-3];
Ecy(:,4) = [4.58e-3,4.49e-3,4.58e-3,4.65e-3,5.06e-3,5.13e-3,5.68e-3];

Ecm(:,1) = [6.61e-04,6.73e-04,6.07e-04,6.58e-04,7.97e-04,8.26e-4,1.02e-3];
Ecm(:,2) = [5.64e-4,6.19e-4,5.97e-4,5.97e-4,5.52e-4,6.57e-4,5.24e-4];
Ecm(:,3) = [4.1e-4,4.26e-4,3.77e-4,3.7e-4,5.02e-4,4.8e-4,2.78e-4];
Ecm(:,4) = [4.61e-4,4.8e-4,4.22e-4,4.38e-4,5.15e-4,5.47e-4,5.07e-4];

%in nm
Rx(1,:) = [30.4,29.5,25.7,31,28.1,24.2,24.2];
Rx(2,:) = [28.6,26.1,26.1,26.1,26.7,23.6,25.5];
Rx(3,:) = [41,38.6,31.7,39.5,43.7,37.5,33.3];
Rx(4,:) = [46.6,42.7,38.1,44.6,45.1,36,34.1];

Ry(1,:) = [29.9,28.9,26.9,25.5,23.8,24.4,25.7];
Ry(2,:) = [34.9,31.2,35.2,32.9,31.2,30.9,27];
Ry(3,:) = [51.5,51.6,51.5,51.8,51.6,53.2,42.9];
Ry(4,:) = [42.7,43.6,42.6,42.1,38.7,38.1,34.3];

% Ry = fliplr(Ry);
% Rx = fliplr(Rx);

VplgR = linspace(1.725,1.9,7);
VplgL = linspace(1.625,1.825,4);

figure;
surf(VplgR,VplgL,Rx);
view(2)
xlabel('VplgR');ylabel('VplgL');
title('Right Dot')
figure
surf(VplgR,VplgL,Ry);
view(2)
xlabel('VplgR');ylabel('VplgL');
title('Left Dot')

