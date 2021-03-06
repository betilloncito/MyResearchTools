%alternative way to open file_data
file = 'Sweeper00016.dat';
fid = fopen(file);
data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);
fclose(fid);

D = data{1,1};

for i=1:length(D)
    str = D{i,1};
    strSearch1 = strfind(str,'Sweep channel: Name');
    strSearch2 = strfind(str,'Step channel 1: Name');
    strSearch2_1 = strfind(str,'Step channel 1: Start');
    strSearch2_2 = strfind(str,'Step channel 1: Stop');
    strSearch2_3 = strfind(str,'Step channel 1: Points');
    strSearch3 = strfind(str,'Acquire channels');

    if(~isempty(strSearch1))
        SweepCH_Name = strtrim(str(strSearch1+19:end));
    end
    if(~isempty(strSearch2))
        StepCH_Name = strtrim(str(strSearch2+20:end));
    end
    if(~isempty(strSearch2_1))
        StepCH_start = str2double(strtrim(str(strSearch2_1+21:end)));
    end
    if(~isempty(strSearch2_2))
        StepCH_stop = str2double(strtrim(str(strSearch2_2+20:end)));
    end
    if(~isempty(strSearch2_3))
        StepCH_pts = str2double(strtrim(str(strSearch2_3+22:end)));
    end
    if(~isempty(strSearch3))
        AcquiredCH_Name = strtrim(str(strSearch3+16:end));
    end
    if(strcmp(str,'[DATA]'))
        index = i;
        break;    
    end
end
 header = [{SweepCH_Name} {StepCH_Name} {AcquiredCH_Name}];
 
 Vstep_temp = linspace(StepCH_start,StepCH_stop,StepCH_pts);

cnt = 1;
I = [];
Vsweep = [];
Vstep = [];
for i=index+2:length(D)
    temp = str2double(strsplit(D{i,1},'\t'));
    I_temp(cnt,:) = temp(2:end);
    Vsweep_temp(cnt,1) = temp(1)
%     
%     I = [I;temp(2:end)'];
%     
%     
%     Vsweep = [Vsweep;temp(1)*ones(N,1)];
    cnt = cnt+1;
%     
%     Vstep = [Vstep;Vstep_temp]
end

for i=1:size(I_temp,2)
   I = [I;I_temp(:,i)];
   Vsweep = [Vsweep;Vsweep_temp(:,1)];
   Vstep = [Vstep;Vstep_temp(i)*ones(size(I_temp,1),1)];
end
size(I)
size(Vsweep)
size(Vstep)

surf(Vstep_temp,Vsweep_temp,I_temp,'EdgeAlpha',0);
view(2);

Data.data = [Vsweep,Vstep,I];




