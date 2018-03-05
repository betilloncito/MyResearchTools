function varargout = ExtractData_FileType_1_2(filename,path,fileType)
NowDir = cd;
cd(path);

if(fileType==1)
    Data = importdata(filename);
    cd(NowDir);
    
    header = Data.textdata;
elseif(fileType==2)% edit code so the headers are extracted automatically from file
    Data = importdata(filename);
    cd(NowDir);
    
    header = [{'Freq(Hz)'} {'Gain(dB)'}];
elseif(fileType==3)
    %alternative way to open file_data
    fid = fopen(filename);
    data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);
    fclose(fid);
    cd(NowDir);
    
    D = data{1,1};
    
    %Determines whether the data is 3D or 1D
    ScanType = 1;
    for i=1:length(D)
        str = D{i,1};
        strSearch_ScanType = strfind(str,'3D Sweeper>Step channel 1: Channel');
        if(~isempty(strSearch_ScanType))
            ScanType_str = strtrim(str(strSearch_ScanType+34:end));
            if(~strcmp(ScanType_str,'- no signal -'))
                ScanType = 2;
                break;
            end
        end
    end
    
    if(ScanType==2)
        %If the data is 3D, then:
        %Loops over the file to extract the name of the sweep and step channels
        %and the start, stop, number of points of the step channel. Loop breaks
        %as soon as the line "3D Sweeper>Acquired channels" is reached.
        for i=1:length(D)
            str = D{i,1};
            strSearch1 = strfind(str,'Sweep channel: Name');
            strSearch2 = strfind(str,'Step channel 1: Name');
            strSearch2_1 = strfind(str,'Step channel 1: Start');
            strSearch2_2 = strfind(str,'Step channel 1: Stop');
            strSearch2_3 = strfind(str,'Step channel 1: Points');
            strSearch3 = strfind(str,'Acquire channels');
            strSearch_STOP = strfind(str,'3D Sweeper>Acquired channels');
            
            if(isempty(strSearch_STOP))
                
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
            else
                break;
            end
        end
        
        %Loops over the file to find the "DATA" flag which lets you know after
        %which line the data will begin
        for i=1:length(D)
            str = D{i,1};
            if(strcmp(str,'[DATA]'))
                index = i;
                break;
            end
        end
        Vstep_temp = linspace(StepCH_start,StepCH_stop,StepCH_pts);
        
        cnt = 1;      I = [];    Vsweep = [];    Vstep = [];
        for i=index+2:length(D)
            temp = str2double(strsplit(D{i,1},'\t'));
            I_temp(cnt,:) = temp(2:end);
            Vsweep_temp(cnt,1) = temp(1);
            cnt = cnt+1;
        end
        
        for i=1:size(I_temp,2)
            I = [I;I_temp(:,i)];
            Vsweep = [Vsweep;Vsweep_temp(:,1)];
            Vstep = [Vstep;Vstep_temp(i)*ones(size(I_temp,1),1)];
        end
        Time = linspace(0,10,size(Vstep,1))';
        
        size(Time)
        size(Vsweep)
        size(Vstep)
        size(I)
        
        header = [{'Time'} {SweepCH_Name} {StepCH_Name} {AcquiredCH_Name}];
        Data.data = [Time,Vsweep,Vstep,I];
        
    elseif(ScanType==1)
                
        for i=1:length(D)
            str = D{i,1};
            strSearch1 = strfind(str,'Sweep channel: Name');
            strSearch3 = strfind(str,'Acquire channels');
            strSearch_STOP = strfind(str,'3D Sweeper>Acquired channels');
            
            if(isempty(strSearch_STOP))
                
                if(~isempty(strSearch1))
                    SweepCH_Name = strtrim(str(strSearch1+19:end));
                end
                if(~isempty(strSearch3))
                    AcquiredCH_Name = strtrim(str(strSearch3+16:end));
                end
            else
                break;
            end
        end
        
         %Loops over the file to find the "DATA" flag which lets you know after
        %which line the data will begin
        for i=1:length(D)
            str = D{i,1};
            if(strcmp(str,'[DATA]'))
                index = i;
                break;
            end
        end
        
        cnt = 1;      I = [];    Vsweep = [];    Vstep = [];
        for i=index+2:length(D)
            temp = str2double(strsplit(D{i,1},'\t'));
            I(cnt,:) = temp(2:end);
            Vsweep(cnt,1) = temp(1);
            cnt = cnt+1;
%             pause;
        end
        
        Time = linspace(0,10,size(Vsweep,1))';
        header = [{'Time'} {SweepCH_Name} {AcquiredCH_Name}];
        Data.data = [Time,Vsweep,I];
        
    end
end

%header should be a cell array
%Data should be a structure that should at least have the field Data.data
varargout = {Data,header};