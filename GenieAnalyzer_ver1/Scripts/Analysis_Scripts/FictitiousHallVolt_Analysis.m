function varargout = FictitiousHallVolt_Analysis(varargin)
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
    DataTable{1,1} = 'Gain [V/V]:';
    DataTable{1,2} = 100;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    name{1} = 'Vg';
    %VOLTAGE PROBE
    name{2} = 'Voltage Probe';
        
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3}; 
    Filename_List = varargin{4};
    
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
                            Vg_index = ii;
                        case 2
                            Vprobe_index = ii;                
                    end
                    break;
                end
            end
        end
               
        %-----------------START CODE HERE---------------------------------%
        % Access the data for the file number INDEX by using the variable
        % MatrixData. The index for each variable are given above
        
        %Initializes input parameters
        G = cell2mat(Variables(1));
        
        n=1;cnt=1;
        for ii=n:size(MatrixData,3)
            Vg = MatrixData(:,Vg_index,ii);
            Vprobe = MatrixData(:,Vprobe_index,ii)/G;
            delta_Vprobe(cnt,INDEX) = max(Vprobe)-min(Vprobe);
            Vg_vector(cnt) = Vg(1);
            cnt = cnt+1;
        end
             
        %------------------STOP CODE HERE---------------------------------%
    end
    
    HandleFig = figure('WindowStyle','normal','Name','Data Plot');
    cnt = 1;
    for INDEX=1:length(MatrixData_All)
        plot(Vg_vector,delta_Vprobe(:,INDEX),'*-');grid on;hold on;
        Legend(cnt) = Filename_List(INDEX);
        cnt = cnt+1;
    end
    xlabel('Gate Voltage [V]');
    ylabel('Amplitude of Probe Voltage [V]');
    title('Comparison among \DeltaV_{Hall} at different B-fields')
    CustomizeFigures(HandleFig);    
    legend(Legend); 
    close(HandleFig);
    hold off;
    
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
