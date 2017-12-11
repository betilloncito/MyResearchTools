function varargout = ZeemanSplit_OscData2(varargin)
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
    name{2} = 'Osc_marker';
    
%     name{3} = 'Read1';
%     name{3} = 'timeLoad';
    name{3} = 'VplgL_dot';
    %Time (optional)
    name{4} = 'Time';
    
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
                            Osc_marker_index = ii;
                        case 3
                            SweepVar_index = ii;
                        case 4
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
        
        SweepVar_vec = MatrixData(1,SweepVar_index,:);
        SweepVar_vec = reshape(SweepVar_vec,1,size(SweepVar_vec,3));
        
        osc_marker = MatrixData(:,Osc_marker_index,1);
        delta_osc_marker = max(osc_marker)-min(osc_marker);
        for k=1:length(osc_marker)-1
            if(abs(osc_marker(k)-osc_marker(k+1)) > 0.25*delta_osc_marker)
               time_ref1=k;
               break;
            end
        end
        for kk=k+1:length(osc_marker)-1
            if(abs(osc_marker(kk)-osc_marker(kk+1)) > 0.25*delta_osc_marker)
               time_ref2=kk; 
               break;
            end
        end
        
%         time_ref = size(MatrixData,1);
%         time_ref = 612;    

        time_ref1 = time_ref1+0*abs(time_ref2-time_ref1);
%         time_ref2 = 940;
        
%         for time_ref = 500:10:700
            movieIter=1;
         for movie=1:movieIter
            y=[];x=[];
            for VplgL_val=1:size(SweepVar_vec,2)
                
                %1.3365
                %1.335
%                 if(VplgL_dot_vec(VplgL_val)>1.3365)
                    
                    osc_data = MatrixData(:,Osc_wave_index,VplgL_val);
                    
%                     osc_data = osc_data-osc_data(1,1,1);
                    
                    osc_time = MatrixData(:,Time_index,VplgL_val);
                    
                    osc_marker = (osc_marker-min(osc_marker))/max((osc_marker-min(osc_marker)))*(max(osc_data)-min(osc_data)) + min(osc_data);
                    
                    figure(21);plot(osc_time,osc_data,'b');hold on;
                    plot(osc_time,osc_marker,'g');
                    plot(osc_time(time_ref1:time_ref2),osc_data(time_ref1:time_ref2),'r');
%                         'o','MarkerEdgeColor','k',...
%                         'MarkerFaceColor','r');
                    title(['SwwepVar: ',num2str(SweepVar_vec(VplgL_val))]);
                    hold off;grid on;
%                     pause(0.1)
                    pause;
                    %{%}
%                     y(VplgL_val) = osc_data(time_ref);
                    osc_data_saved(:,VplgL_val,INDEX) = osc_data(time_ref1:time_ref2);
                    
%                     y(VplgL_val) = mean(osc_data(time_ref1:time_ref2)/min(osc_data(time_ref1:time_ref2)));
                    DD = osc_data(time_ref1:time_ref2)-min(osc_data(time_ref1:time_ref2));
                    DD = osc_data(time_ref1:time_ref2);

                    %                     y(VplgL_val) = mean(osc_data(time_ref1:time_ref2));
                    
                    y(VplgL_val) = mean(DD);
%                     y(VplgL_val) = max(osc_data(time_ref1:time_ref2));

                    x(VplgL_val) = SweepVar_vec(VplgL_val);
                    
                    
                    
%                 end
            end
         end
            
            N=5;
            window = 3;
            temp_y = y;
            loess_degree = 10;
            for i=1:N
                temp_y = smooth(temp_y,window);
%                 temp_y = smooth(x,temp_y,loess_degree,'loess');
            end
            osc_data = temp_y;
            
            maxVal = max(osc_data);
            
            figure;hold on;
            plot(x,osc_data,'k');grid on;
            plot(x,y,'r');
%         end
        hold off;
%         
        %------------------STOP CODE HERE---------------------------------%
    end
    
    
    %{
    L = size(osc_data_saved,2)+1;
    for i=1:size(osc_data_saved,2)
        h = L-i;
        figure(321);plot(osc_data_saved(:,i,1),'r');hold on;
        plot(osc_data_saved(:,h,2),'b');hold off;
        grid on;
        
        size(osc_data_saved(:,i,1))
        size(osc_data_saved(:,h,2))
        
        D(:,i) = osc_data_saved(:,i,1)-osc_data_saved(:,h,2);
        
        pause;
    end    
     
    figure;
    for j=1:size(D,2)
%        
        plot(D(:,j));hold on;grid on;
        pause;
    end
    hold off;

    ave = mean(D);
    T = linspace(30,1,30);
    size(ave)
    figure;
    plot(T,ave);grid on;
    
    %}
    
    
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