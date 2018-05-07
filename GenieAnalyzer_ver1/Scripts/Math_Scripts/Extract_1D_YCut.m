function varargout = Extract_1D_YCut(varargin)
%Analyses the transconductance curve for Current vs. Vg.
%Code assumes all files have the same indices labelling (i.e. each
%variables is found under the same column in each file). Also if more than
%one file has been opened for analysis, then the analysis is simply looped
%over each file.

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'X-value:';
    DataTable{1,2} = 0.1965;
    DataTable{2,1} = 'Min Y-value:';
    DataTable{2,2} = -0.3036;
    DataTable{3,1} = 'Max Y-value:';
    DataTable{3,2} = -0.3049;
    DataTable{4,1} = 'Inverse Option:';
    DataTable{4,2} = -1;
    
    varargout = {DataTable};
else
%     %List the names used for the variables header
%     %CURRENT
%     name{1} = 'Current';
%     %BIAS
%     name{2} = 'Vbias';
%     %GATE
%     name{3} = 'Vg';
%     %VOLTAGE PROBE
%     name{4} = 'Voltage Probe';
%     %MAGNETIC FIELD
%     name{5} = 'Magnetic Field';
%     %Time (optional)
%     name{6} = 'Time';
%     
%     %Initializes MatrixData and Variables from the input varargin
    HandleAxes = varargin{1};
    Variables = varargin{2};
%     Headers_All = varargin{3};
%     %---------------------------------------------------------------------%
%     %Loops over each saved data set.
%     for INDEX=1:length(MatrixData_All)
%         %Figuring out the correct index for each variable
%         if(size(MatrixData_All,2)==1)
%             Headers = Headers_All{INDEX};
%             MatrixData = MatrixData_All{INDEX};
%         end
%         if(size(Headers_All,2)>1)
%             temp = Headers_All{INDEX};
%             Headers = temp{1};
%             temp = MatrixData_All{INDEX};
%             MatrixData = temp{1};
%         end
%         for i=1:length(name)
%             for ii=1:length(Headers)
%                 Current_Header = cell2mat(Headers(ii));
%                 n = strfind(Current_Header,' (');
%                 Headers_corrected = Current_Header(1:n-1);
%                 if(strcmp(name(i),Headers_corrected))
%                     switch i
%                         case 1
%                             I_index = ii;
%                         case 2
%                             Vbias_index = ii;
%                         case 3
%                             Vg_index = ii;
%                         case 4
%                             Vprobe_index = ii;
%                         case 5
%                             MagField_index = ii;
%                         case 6
%                             Time_index = ii;
%                     end
%                     break;
%                 end
%             end
%         end
%         
%         %-----------------START CODE HERE---------------------------------%
%         % MatrixData contains all the data in the file number INDEX. To access
%         % the data for a specific file, use number INDEX:
%         % i.e. MatrixData(INDEX)
%         % MatrixData has n+1 dimensions where n represents the number of
%         % sweeps performed when the data was taken. For example, if a
%         % three sweeps were done (i.e. bias sweep) then MatrixData would
%         % have 4 dimensions:
%         % *1st dim: is the number of data points taken during the 1st sweep
%         % *2nd dim: is the number of variables stored during each sweep
%         % *3rd dim: is the number of data points taken during the 2nd sweep
%         % *4th dim: is the number of data points taken during the 3rd sweep
%         %  ...
%         % *nth dim: is the number of data points taken during the nth sweep
%         
%         
%         %         %Initializes input parameters: Example
%         %         S = cell2mat(Variables(1));
%         %
%         %------------------STOP CODE HERE---------------------------------%
%     end
    
    child = get(HandleAxes,'Children');
    X = get(child,'XData');
    Y = get(child,'YData');
    Z = get(child,'ZData');
    
    X_value = cell2mat(Variables(1));
    Y_min = cell2mat(Variables(2));
    Y_max = cell2mat(Variables(3));
    Inv = cell2mat(Variables(4));
    
    bias = X_value;
    min_bias = bias*0.99;
    max_bias = bias*1.01;
    
    min_g = Y_min;
    max_g = Y_max;
    
    for i=1:length(X);
        if(i<length(X))
            if(X(i)<bias && X(i+1)>bias)
                index_x = i
                break;
            end
            if(X(i)>bias && X(i+1)<bias)
                index_x = i
                break;
            end
        end
        if(X(i)==bias)
            index_x = i
        end
    end
    
    for i=1:length(X);
        if(i<length(X))
            if(X(i)<min_bias && X(i+1)>min_bias)
                index_x_min = i
                break;
            end
            if(X(i)>min_bias && X(i+1)<min_bias)
                index_x_min = i
                break;
            end
        end
        if(X(i)==min_bias)
            index_x_min = i
        end
    end
    
    for i=1:length(X);
        if(i<length(X))
            if(X(i)<max_bias && X(i+1)>max_bias)
                index_x_max = i
                break;
            end
            if(X(i)>max_bias && X(i+1)<max_bias)
                index_x_max = i
                break;
            end
        end
        if(X(i)==max_bias)
            index_x_max = i
        end
    end
        
    if(~isnan(min_g))        
        for i=1:length(Y);
            if(i<length(Y))
                if(Y(i)<min_g && Y(i+1)>min_g)
                    index_y_min = i
                    break;
                end
                if(Y(i)>min_g && Y(i+1)<min_g)
                    index_y_min = i
                    break;
                end
            end
            if(Y(i)==min_g)
                index_y_min = i
            end
        end
    else
        index_y_min = find(Y == min(Y));
    end
    
    if(~isnan(max_g))
        for i=1:length(Y);
            if(i<length(Y))
                if(Y(i)<max_g && Y(i+1)>max_g)
                    index_y_max = i
                    break;
                end
                if(Y(i)>max_g && Y(i+1)<max_g)
                    index_y_max = i
                    break;
                end
            end
            if(Y(i)==max_g)
                index_y_max = i
            end
        end
    else
        index_y_max = find(Y == max(Y));
    end
    
    % figure(998);
    if(index_y_min<index_y_max)
        V_g = Y(index_y_min:index_y_max);
        GG = -Z(index_y_min:index_y_max,index_x);
        if(index_x_min<index_x_max)
            G = -Z(index_y_min:index_y_max,index_x_min:index_x_max);
            Vbias = X(index_x_min:index_x_max);
        else
            G = -Z(index_y_min:index_y_max,index_x_max:index_x_min);
            Vbias = X(index_x_max:index_x_min);
        end
        %     if(min(G)<0)
        %         G = G+min(G);
        %     end
    else
        V_g = Y(index_y_max:index_y_min);
        GG = -Z(index_y_max:index_y_min,index_x);
        if(index_x_min<index_x_max)
            G = -Z(index_y_max:index_y_min,index_x_min:index_x_max);
            Vbias = X(index_x_min:index_x_max);
        else
            G = -Z(index_y_max:index_y_min,index_x_max:index_x_min);
            Vbias = X(index_x_max:index_x_min);
        end
        %     if(min(GG)<0)
        %         GG = GG+min(GG);
        %     end
    end
    
%     figure(444);
%     surf(Vbias,V_g,G*Inv,'EdgeAlpha',0,'Parent',handles.axes1);view(2);

%     line(V_g,GG*Inv,'Parent',HandleAxes);grid on;
    title(['bias:',num2str(X(index_x))],'Parent',HandleAxes);   
    
%     G_avg = mean(G,2);
%     figure(555);
%     plot(V_g,G_avg*Inv);grid on;hold on;

    %Do not edit this line
    varargout = {V_g,GG*Inv,[]};
end


