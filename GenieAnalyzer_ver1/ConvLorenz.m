function intResult = ConvLorenz(Gamma, T, C2, Vo, alpha, Vg)
%Returns the convolution integral to fit a lorenztian peak (in units of 2e^2/h)

%constants
e = 1.60217662e-19; %C
kB = 8.6173303e-5; %eV/K

syms E

fun = (C2/(kB*T))*pi*(Gamma/2)/((Gamma/2)^2 + (e*alpha*(Vg - Vo) - E)^2)*cosh(E/kB*T)^(-2);

intResult = int(fun, E);