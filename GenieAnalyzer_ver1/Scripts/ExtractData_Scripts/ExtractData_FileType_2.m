function varargout = ExtractData_FileType_2(filename,path,fileType)
NowDir = cd;
cd(path);

Data = importdata(filename);
cd(NowDir);

output = ExtractData_FileType_2_Dialog(Data.textdata);
 
% if(fileType==3)
%     header = 'Freq(Hz) Gain(dB)';
% else
%     header = cell2mat(handles.Data.textdata);
% end


% Z_index = str2double(get(handles.ZEdit,'String'));
    X_index = output.out1;
    Y_index = output.out2;
    
    %Gets necessary voltages and current vectors using user indeces
    X = handles.Data.data(:,X_index);
    Y = handles.Data.data(:,Y_index);
    Z = handles.Data.data(:,Z_index);
    
    IndexStart_Analysis = 1;
    %Determines start and end voltages for Vbias
    X_start = X(IndexStart_Analysis);
    Analysis_Index = 0;
%     ErrorCatching = 1;
    for k=2:length(X)
        if(X(k) == X_start)
%             ErrorCatching = 0;
            X_end = X(k-1);
            break;
        end
    end
%     if(ErrorCatching==1)
%         msgbox('X, Y and Z parameters are INVALID. Please correct these values');
%     end
    
    %Loops through Vbias to select data for constant Vg
    %Initialization
    counter = 0;
    for Main_Index=IndexStart_Analysis+1:length(X)
        %Finds end Vbias: a set of data for constant Vg
        if(X(Main_Index) == X_end)
            counter=counter+1;%counts number of data sets for constant Vg
            
            %Saves Vbias, Id and Vg into temp variables
            %Id(Vg,Vbias) -> (rows,columns)
            Z_Stored(counter,:) = Z(IndexStart_Analysis:Main_Index);
            
            if(Main_Index==length(X))
                X_Stored = X(IndexStart_Analysis:Main_Index);
            end
            Y_Stored(counter,1) = mean(Y(IndexStart_Analysis:Main_Index));
            
            IndexStart_Analysis = Main_Index+1;
        end
    end
    
    % for oo=1:length(Y_Stored)
    %     for o=1:length(Z_Stored)-1
    %         DerY(oo,o) = (Z_Stored(oo,o)-Z_Stored(oo,o+1))/(X_Stored(o)-X_Stored(o+1));
    %         DerX(o) = mean([X_Stored(o),X_Stored(o+1)]);
    %     end
    % end
    % Z_Stored = DerY;
    % X_Stored = DerX;
    
    handles.Z = log(abs(Z_Stored));
    handles.Z = Z_Stored;
    
    handles.X = X_Stored;
    handles.Y = Y_Stored;
    
    % set(handles.V_StartText,'String',V_start);
    % set(handles.V_EndText,'String',V_end);
    % set(handles.TotalDataSetText,'String',Analysis_Index);
    
    set(handles.SpanAcqPlotFigure,'CurrentAxes',handles.axes1);
    surf(handles.X,handles.Y,handles.Z,'EdgeColor','none');
    view(XY_plane);grid on;
    xlabel(x_label);ylabel(y_label);
    if(isempty(get(handles.MaxValColorEdit,'String'))==1 || ...
            isempty(get(handles.MinValColorEdit,'String'))==1)
        caxis([min(min(handles.Z)),max(max(handles.Z))])
        set(handles.MaxValColorEdit,'String',max(max(handles.Z)));
        set(handles.MinValColorEdit,'String',min(min(handles.Z)));
    else
        handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
            str2double(get(handles.MaxValColorEdit,'String'))];
        caxis(handles.ColorAxis_Min_Max);
    end
    colormap(jet(NumColors))