function varargout = CurvePieceTogether_Lockin(varargin)
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
    DataTable{1,1} = 'Lockin Sens [V/V]:';
    DataTable{1,2} = '1';
    DataTable{2,1} = 'X Variable Name:';
    DataTable{2,2} = 'Freq';
    DataTable{3,1} = 'Y Variable Name:';
    DataTable{3,2} = 'Lock_in_amp';
    
    varargout = {DataTable};
else
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};
    
    %List the names used for the variables header
    %X
    name{1} = cell2mat(Variables(2));
    %Y
    name{2} = cell2mat(Variables(3));
    
    name{3} = 'Time';
    
    %---------------------------------------------------------------------%
    %Loops over each saved data set.
    for INDEX=1:length(MatrixData_All)        
        %Figuring out the correct index for each variable
        if(size(MatrixData_All,2)==1)
            Headers = Headers_All{INDEX};
            MatrixData = MatrixData_All{INDEX};
        end
        if(size(Headers_All,2)>1)
            temp = Headers_All{INDEX};
            Headers = temp{1};
            temp = MatrixData_All{INDEX};
            MatrixData = temp{1};
        end                     
        for i=1:length(name)
            for ii=1:length(Headers)
%                 Headers
%                 cell2mat(Headers(ii))
                Current_Header = cell2mat(Headers(ii));
                n = strfind(Current_Header,' (');
                Headers_corrected = Current_Header(1:n-1);
                if(strcmp(name(i),Headers_corrected))
                    switch i
                        case 1
                            X_index = ii;
                        case 2
                            Y_index = ii;
                        case 3
                            Time_index = ii;
                    end
                    break;
                end
            end
        end
                       
        %-----------------START CODE HERE---------------------------------%
        % MatrixData contains all the data in the file number INDEX. To access
        % the data for a specific file, use number INDEX: 
        % i.e. MatrixData(INDEX)
        % MatrixData has n+1 dimensions where n represents the number of
        % sweeps performed when the data was taken. For example, if a
        % three sweeps were done (i.e. bias sweep) then MatrixData would
        % have 4 dimensions: 
        % *1st dim: is the number of data points taken during the 1st sweep
        % *2nd dim: is the number of variables stored during each sweep
        % *3rd dim: is the number of data points taken during the 2nd sweep
        % *4th dim: is the number of data points taken during the 3rd sweep
        %  ...
        % *nth dim: is the number of data points taken during the nth sweep
       
        
        %Initializes input parameters: Example
        S_all = cell2mat(Variables(1));
        n = strfind(S_all,',');
        
        if(isempty(n)==0)
            for i=1:length(n)+1
                if(i==1)
                    S{1} = S_all(1:n(i)-1);
                elseif(i==length(n)+1)
                    S{i} = S_all(n(i-1)+1:end);
                else
                    S{i} = S_all(n(i-1)+1:n(i)-1);
                end
            end
            Sens = str2double(cell2mat(S(INDEX)))
        else
            Sens = S_all;
        end
        
        N = length(MatrixData(:,X_index));
        if(INDEX==1)
            X(1:N) = MatrixData(:,X_index);
            Ytemp(1:N) = MatrixData(:,Y_index);
            Y(1:N) = Ytemp*Sens/10;
        else
            X(length(X)+1:length(X)+N) = MatrixData(:,X_index);
            Ytemp(1:N) = MatrixData(:,Y_index);
            size(Ytemp)
            size(Y)
            Y(length(Y)+1:length(Y)+N) = Ytemp*Sens/10;
        end
        
        %------------------STOP CODE HERE---------------------------------%
    end
    Y = 20*log10(Y/max(Y));   
    
%         Plotting Example
        HandleFig = figure('WindowStyle','normal','Name','Data Plot');
        plot(X,Y);grid on;hold on;
        xlabel('Frequency (Hz)');ylabel('Attenuation (dB)');title(' ');
        CustomizeFigures(HandleFig);
        close(HandleFig);
        Legend = {' '};
        legend(Legend);
        hold off;
    
    %Do not edit this line
    varargout = {1};
end