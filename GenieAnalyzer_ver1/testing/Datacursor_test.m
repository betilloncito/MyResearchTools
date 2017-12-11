% 
% f = [logspace(5,9,300),linspace(1e9,3e9,50)];
% a = num2str(f(1));
% for i=2:length(f)
% a = [a,',',num2str(f(i))];
% end
% disp(a)

dcm_obj = datacursormode(gcf);
info_struct = getCursorInfo(dcm_obj);


for i=1:length(info_struct)
pos = info_struct(i).Position;
x(i) = pos(1,1)
y(i) = pos(1,2)
% pause
end
% DeltaX = abs(x(1)-x(2));
% disp(['Peak Separation: ',num2str(DeltaX*1e3),'mV'])

