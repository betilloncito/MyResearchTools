function varargout = ZeemanSplit_OscData(varargin)
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
    DataTable{2,1} = 'Gain [V/V]:';
    DataTable{2,2} = 100;
    DataTable{3,1} = 'Bias VoltDiv:';
    DataTable{3,2} = 100;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Osc_wave';
    %BIAS
%     name{2} = 'VplgL_dot';
    
    name{2} = 'Read1';
    %Time (optional)
    name{3} = 'Time';
    
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
                            Osc_wave_index = ii;
                        case 2
                            VplgL_dot_index = ii;
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
        
        
        %         %Initializes input parameters: Example
        %         S = cell2mat(Variables(1));
        
        VplgL_dot_vec = MatrixData(1,VplgL_dot_index,:);
        VplgL_dot_vec = reshape(VplgL_dot_vec,1,size(VplgL_dot_vec,3));
        
        time_ref = size(MatrixData,1);
        time_ref = 612;
        
        time_ref1 = 700;
        time_ref2 = 940;
        
%         for time_ref = 500:10:700
            y=[];x=[];
            for VplgL_val=1:size(VplgL_dot_vec,2)
                
                %1.3365
                %1.335
%                 if(VplgL_dot_vec(VplgL_val)>1.3365)
                    
                    osc_data = MatrixData(:,Osc_wave_index,VplgL_val);
                    osc_time = MatrixData(:,Time_index,VplgL_val);
                    
                    
                    figure(21);plot(osc_time,osc_data);hold on;
                    plot(osc_time(time_ref1:time_ref2),osc_data(time_ref1:time_ref2),'r');
%                         'o','MarkerEdgeColor','k',...
%                         'MarkerFaceColor','r');
                    title(['Vplg: ',num2str(VplgL_dot_vec(VplgL_val)),'V']);
                    hold off;grid on;
                    pause
                    %{%}
%                     y(VplgL_val) = osc_data(time_ref);
                    y(VplgL_val) = mean(osc_data(time_ref1:time_ref2));
                    x(VplgL_val) = VplgL_dot_vec(VplgL_val);
                    
%                 end
            end
            
            N=50;
            window = 10;
            for i=1:N
                osc_data = smooth(y,window);
            end
            
            figure;hold on;
            plot(x,osc_data,'k');grid on;
            plot(x,y,'r');
%         end
        hold off;
        
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