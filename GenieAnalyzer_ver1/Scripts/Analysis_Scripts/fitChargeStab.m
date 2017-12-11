function varargout = fitChargeStab(varargin)
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
    DataTable{2,2} = 100;
    DataTable{3,1} = 'Bias Volt:';
    DataTable{3,2} = 0.1;
    DataTable{4,1} = 'DataSet Index:';
    DataTable{4,2} = 1;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'Vbias';
    %GATE
    name{3} = 'Vtun';
    %VOLTAGE PROBE
    name{4} = 'VplgL';
    %MAGNETIC FIELD
    name{5} = 'VplgR';
    %Time (optional)
    name{6} = 'Time';
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};   
    %---------------------------------------------------------------------%
    %Loops over each saved data set.
    
    %Added code: allows flexbility of what data was recorded in the
    %experiment, i.e. either a Vbias or Vtun could have been recorded so
    %this allows the code to work for both cases.
    Vbias_index = 0;
    Vtun_index = 0;
    
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
                            Vtun_index = ii;
                        case 4
                            VplgL_index = ii;
                        case 5
                            VplgR_index = ii;
                        case 6
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
        bias = cell2mat(Variables(4));
        
        if(Vbias_index==0)
            Vbias = cell2mat(Variables(3));
        else
            Vbias = MatrixData(1,Vbias_index,1,bias);
        end
                       
        switch MatrixData(1,VplgR_index,1,bias)
            case MatrixData(2,VplgR_index,1,bias)
                %VplgL was swept first
                Vplg2 = reshape(MatrixData(1,VplgR_index,:,bias),size(MatrixData,3),1);
                Vplg1 = reshape(MatrixData(:,VplgL_index,1,bias),size(MatrixData,1),1);
                Current = abs(reshape(MatrixData(:,I_index,:,bias),length(Vplg1),length(Vplg2)));
                %                     Current_o = abs(max(max(abs(log(Current_o)))) - abs(log(Current_o)));
%                 disp('in')
            otherwise
                %VplgR was swept first
                Vplg1 = reshape(MatrixData(:,VplgR_index,1,bias),size(MatrixData,1),1);
                Vplg2 = reshape(MatrixData(1,VplgL_index,:,bias),size(MatrixData,3),1);
                Current = abs(reshape(MatrixData(:,I_index,:,bias),length(Vplg1),length(Vplg2)));
                Current = log(Current);
%                 disp('in')
        end
        
        
        fitChargeStab_Plot(Vplg2,Vplg1,Current,Vbias);
%         h = figure;
%         uiwait(h);
        
%         figure(100);
%         surf(Vplg2,Vplg1,Current,'EdgeAlpha',0);
%         view([0 0 90]);
%         disp('done');
        
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
    varargout = {999};
end