function varargout = IRnw_AbsorptionPeakExtract(varargin)
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
    DataTable{1,1} = 'Preamp Sens [A/V]:';
    DataTable{1,2} = 1e-6;
    DataTable{2,1} = 'Bias VoltDiv:';
    DataTable{2,2} = 10;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'Vbias';
    %GATE
    name{3} = 'Wavelength';
    %VOLTAGE PROBE
%     name{4} = 'Voltage Probe';
%     %MAGNETIC FIELD
%     name{5} = 'Magnetic Field';
%     %Time (optional)
%     name{6} = 'Time';
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};
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
                Current_Header = cell2mat(Headers(ii));
                n = strfind(Current_Header,' (');
                Headers_corrected = Current_Header(1:n-1);
                if(strcmp(name(i),Headers_corrected))
                    switch i
                        case 1
                            I_index = ii;
                        case 2
                            Vbias_index = ii;
                        case 3
                            Lambda_index = ii;
%                         case 4
%                             Vprobe_index = ii;
%                         case 5
%                             MagField_index = ii;
%                         case 6
%                             Time_index = ii;
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
        
        
%         %Initializes input parameters: Example
        Sens = cell2mat(Variables(1));
        VoltDiv = cell2mat(Variables(2));
        
        Current = MatrixData(:,I_index,:);
        Vbias = MatrixData(:,Vbias_index,1);
        Lambda = MatrixData(1,Lambda_index,:);
        
        Current = reshape(Current,length(Vbias),length(Lambda));
        Vbias = reshape(Vbias,length(Vbias),1,1);
        Lambda = reshape(Lambda,length(Lambda),1,1);
        
        for i=1:size(Current,2)
            figure(100);
            plot(Vbias,log(abs(Current(:,i))));hold on;
            grid on;
            [val,ind] = min(log(abs(Current(:,i))))
            MinVolt(i) = Vbias(ind)
        end
        figure(200);
        plot(Lambda,MinVolt);
        %
        %------------------STOP CODE HERE---------------------------------%
    end
    
%     %Plotting Example
%     HandleFig = figure('WindowStyle','normal','Name','Data Plot');
%     plot(x,y);grid on;hold on;
%     xlabel(' ');ylabel(' ');title(' ');    
%     CustomizeFigures(HandleFig);
%     close(HandleFig);
%     Legend = {' '};
%     legend(Legend);    
%     hold off;
    
    %Do not edit this line
    varargout = {1};
end