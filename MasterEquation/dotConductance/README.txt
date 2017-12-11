Python and Matlab versions of a calculation for conduction through an arbitrarily connected and gated double dot system, based loosely on Rev. Mod. Phys. Vol. 75, No. 1

ToDO:
 - handle higher gate voltages (currently capped by only looking at electron occupation up to N=120)
 - make outFile.txt nicer (possibly include inFile parameters)
 - include matlab-Like debuggers
 - move inFile and outFile from working directories (note this can be done on command line, so nevermind)
 - add dI/dV calculation

Python notes:
inFile.txt stores all the inputs for the run
to Call from command line: python multiDot.py -i "inFile.txt" -o "outFile.txt" [-d]

-d or --DEBUG turns on a very verbose output (I don't recommend using it for resolution higher than ~1-2)

Matlab notes:
example matlab run:
realBias = linspace(-0.02,0.02,401);
realGate = linspace(-0.2,0.5,701)
for k = 1:max(size(realBias))
for j = 1:max(size(realGate))
realCurrent(k,j) = Kouwenhoven_Tunnelling_Fast(realBias(k),0,realGate(j),realGate(j),Temperature,70.57e-18,22.77e-18,22.89e-18,4.26e-18,21.03e-18,0.358e-18, 10e-18 , 30e-9, 0, 0, 1e-9, 30e-9);
end
fprintf('Done bias #%d at %2d:%2d\n', k, hour(now),minute(now));
end
realdIdV = diff(realCurrent,1,1)./repmat(transpose(diff(realBias)),1,max(size(realGate)));

debugging physics with matlab:
[ myCurrent, debug1, debug2, debug3, debug4]  = Kouwenhoven_Tunnelling_Fast(realBias(k),0,realGate(j),realGate(j),Temperature,70.57e-18,22.77e-18,22.89e-18,4.26e-18,21.03e-18,0.358e-18, 10e-18 , 30e-9, 0, 0, 1e-9, 30e-9);
plot(1:max(size(debug2)),debug2(1,1),1:max(size(debug2)),debug2(2,:),1:max(size(debug2)),debug2(3,:),1:max(size(debug2)),debug2(4,1),1:max(size(debug2)),debug3*1e-20); % Shows the energy level spacing for differing n1,n2
image(debug1,'CDataMapping','scaled') % Shows the time evolution of pVec
