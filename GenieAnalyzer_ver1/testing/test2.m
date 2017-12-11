x = linspace(1,100,100);
y = sin(x);
plot(x,y);

wait;

dcm_obj = datacursormode(gcf);
info_struct = getCursorInfo(dcm_obj)


for i=1:length(info_struct)
pos = info_struct(i).Position
x(i) = pos(1,1);
y(i) = pos(1,2);

end