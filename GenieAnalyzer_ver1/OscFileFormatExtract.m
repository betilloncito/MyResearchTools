format long;
Dir = cd;
dname = uigetdir(Dir,'Select directory for group of files');
cd(dname)

list = dir(dname);

S = 1e-11;
Vpp = [0.1,0.4,0.8,1.9,1,1.1,1.1,1.2,1.4,1.6,1.7,1.8,2,2.2,2.4,2.6,3,3.4,3.6,3.8,4,4.25,4.5,4.5,0.05];
Vpp = Vpp*1000;
cnt=1;
% size(list,1)
% length(Vpp)
for i=1:size(list,1)
    filenames = list(i).name;

    if(~strcmp(filenames,'.') && ~strcmp(filenames,'..'))
        
        Data = importdata(filenames);
        
        Data(1,1)
        for N=1:1
            data = cell2mat(Data(N+1,1));
            p = strfind(data,',');
            n = strfind(data,'(');
            m = strfind(data,')');
            
            scopeDataAvg=0;
            for i=1:length(n)
                scope_data = data(n(i)+1:m(i)-1);
                u = strfind(scope_data,',');
%                 
%                 scope_dataX(i,N) = str2double(scope_data(1:u-1));
%                 scope_dataY(i,N) = str2double(scope_data(u+2:end));
                %         pause;
                
                scopeDataAvg = scopeDataAvg + str2double(scope_data(u+2:end));                
            end
            scopeDataAvg=scopeDataAvg/length(n)*S/1e-15;
            
            figure(341);line(Vpp(cnt),scopeDataAvg,'Marker','o',...
                'MarkerFaceColor','r','MarkerEdgeColor','k');
            grid on;%hold on;
            xlabel('Applied Voltage Pulse [mV]')
            ylabel('Current [fA]')
%             pause;
        end
        cnt = cnt+1;
    end
    
end
cd(Dir)
% hold off;