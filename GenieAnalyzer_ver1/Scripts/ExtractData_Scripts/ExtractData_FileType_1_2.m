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
                    StepCH_pts = str2double(strtrim(str(strSearch2_3+22:end)))
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
        for i=index+2:size(D,1)
            temp = str2double(strsplit(D{i,1},'\t'));
            I_temp(cnt,:) = temp(2:end);
            Vsweep_temp(cnt,1) = temp(1);
            cnt = cnt+1;
        end
        
        size(Vstep_temp)
        size(I_temp,2)
        %for i=1:size(I_temp,2)
        for i=1:StepCH_pts
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
elseif(fileType==4)
    Data_temp = importdata(filename);
    %     time = linspace(1,100,length(Data_temp))';
    %     Data.data = [time,Data_temp];
    Data.data = Data_temp;
    size(Data_temp)
    
    cd(NowDir);
    
    %     header = [{'Dummy Time'} {'Wavelength[nm]'} {'Voltage Bias[V]'} {'Preamp Voltage[V]'}]
    % power meter measurement: which only has two columns
    if(size(Data_temp,2)==2)
        header = [{'Wavelength (nm)'} {'PowerSignal (W)'}];    
    else
        header = [{'Wavelength (nm)'} {'Vbias (V)'} {'Current (V)'}];
    end
    
elseif(fileType==5)
    
    DATA = importdata(filename);
    
    if(isstruct(DATA))
%         header_string = cell2mat(DATA.textdata(1,1));
%         comma_index = strfind(header_string,',');
%         for i=1:length(comma_index)+1
%             if(i==1)
%                 header(i) = {header_string(1:comma_index(i)-1)};
%             elseif(i==length(comma_index)+1)
%                 header(i) = {header_string(comma_index(i-1)+1:end)};
%             else
%                 header(i) = {header_string(comma_index(i-1)+1:comma_index(i)-1)};
%             end
%         end
%         header = [header,{'Osc_time (s)'}]
%         
%         Osc_Data = DATA.textdata(2:end,end);
%         for ii=1:length(Osc_Data)
%             osc = cell2mat(Osc_Data(ii));
%             m1 = strfind(osc,'(');
%             m2 = strfind(osc,')');
%             
%             for i=1:length(m1)
%                 coord = osc(1,m1(i)+1:m2(i)-1);
%                 size(coord);
%                 k = strfind(coord,',');
%                 time(i,1) = str2double(coord(1,1:k-1));
%                 volt(i,1) = str2double(coord(1,k+1:end));
%             end
%             
%             for i=1:length(header)
%                 str2double(cell2mat(DATA.textdata(ii+1,i)))
%                 if(i==length(header))
%                     DATA_Matrix(:,i) = time;
%                 elseif(i==length(header)-1)
%                     DATA_Matrix(:,i) = volt;
%                 else
%                     DATA_Matrix(:,i) = str2double(cell2mat(DATA.textdata(ii+1,i)))*ones(length(time),1);
%                 end
%             end
%             DATA_Matrix_FULL = [DATA_Matrix_FULL;DATA_Matrix];
%         end
%         Data.data = DATA_Matrix_FULL;
    else
        header_string = cell2mat(DATA(1));
        comma_index = strfind(header_string,',');
        for i=1:length(comma_index)+1
            if(i==1)
                header(i) = {header_string(1:comma_index(i)-1)};
            elseif(i==length(comma_index)+1)
                header(i) = {header_string(comma_index(i-1)+1:end)};
            else
                header(i) = {header_string(comma_index(i-1)+1:comma_index(i)-1)};
            end
        end
        header = [header,{'Osc_time (s)'}];
        
        DATA_Matrix_FULL = [];
        for ii=2:length(DATA)
            line = cell2mat(DATA(ii));
            size(line);
            
            %NOTE: In the csv file there are several variables which are saved
            %in columns, and each row represents a single data acquisition event
            %where the value for all the variables are recorded. It is assumed
            %that in the csv file, the oscilloscope data is located on the
            %last column, i.e. all other variables within a row come before the
            %oscilloscope data. If this is not the case, the extraction code
            %below will fail
            
            comma_index = strfind(line,',');
            quotes_index = strfind(line,'"');
            
            for i=1:length(comma_index)
                if(comma_index(i)<quotes_index(1))
                    if(i==1)
                        storedVarValue(i) = str2double(line(1,1:comma_index(i)-1));
                    else
                        storedVarValue(i) = str2double(line(1,comma_index(i-1)+1:comma_index(i)-1));
                    end
                else
                    break;
                end
            end
            
            osc = line(1,quotes_index(1)+2:quotes_index(2)-2);
            size(osc);
            m1 = strfind(osc,'(');
            m2 = strfind(osc,')');
            
            for i=1:length(m1)
                coord = osc(1,m1(i)+1:m2(i)-1);
                size(coord);
                k = strfind(coord,',');
                time(i,1) = str2double(coord(1,1:k-1));
                volt(i,1) = str2double(coord(1,k+1:end));
            end
            
            for i=1:length(header)
                
                if(i==length(header))
                    DATA_Matrix(:,i) = time;
                elseif(i==length(header)-1)
                    DATA_Matrix(:,i) = volt;
                else
                    DATA_Matrix(:,i) = storedVarValue(i)*ones(length(time),1);
                end
            end
            
            DATA_Matrix_FULL = [DATA_Matrix_FULL;DATA_Matrix];
        end
        
        Data.data = DATA_Matrix_FULL;
        
    end
end

%header should be a cell array
%Data should be a structure that should at least have the field Data.data
varargout = {Data,header};