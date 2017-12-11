function varargout = PulseCalibration_ChargePumping(varargin)
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
    DataTable{2,1} = 'AverageData [y/n]:';
    DataTable{2,2} = 'n';
    DataTable{3,1} = 'Bias VoltDiv:';
    DataTable{3,2} = 100;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current_sensor';
    %BIAS
    name{2} = 'VplgL_dot';
    %GATE
    name{3} = 'dummy';
    
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
                            I_sens_index = ii;
                        case 2
                            VplgL_dot_index = ii;
                        case 3
                            dummy_index = ii;
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
        AverageData = cell2mat(Variables(1));
        
        dummy_vec = MatrixData(1,dummy_index,:);
        VplgL_dot_vec = MatrixData(:,VplgL_dot_index,1);
        VplgL_dot_vec = reshape(VplgL_dot_vec,1,size(VplgL_dot_vec,1));
        
        if(strcmp(AverageData,'y'))
            cnt = 1;
            for dummy_iter=1:5:length(dummy_vec)
                
                for i=0:4
                    I_sens_temp = MatrixData(:,I_sens_index,dummy_iter+1);
                    I_sens_vec(i+1,:) = reshape(I_sens_temp,1,size(I_sens_temp,1));
                    
                    %                 figure(500);plot(I_sens_avg)
                    
                end
                I_sens_avg(cnt,:) = mean(I_sens_vec,1);
                cnt = cnt+1;
            end
            surf(I_sens_avg,'EdgeAlpha',0);
            view(2)
        else
            for dummy_iter=1:length(dummy_vec)
                I_sens_raw = MatrixData(:,I_sens_index,dummy_iter);
                
                N=1;
                window = 3;
                temp_y = I_sens_raw;
                for i=1:N
                    temp_y = smooth(temp_y,window);
                end
                I_sens_vec = temp_y;
                I_sens_der = diff(I_sens_vec)./diff(VplgL_dot_vec)';
                L=length(I_sens_der);
                ind = [];
                for p=1:2
                    %                 size(I_sens_vec)
                    %                 size(VplgL_dot_vec)
                    if(p==1)
                        ampDiff = abs(I_sens_der(1:L/2));
                    else
                        ampDiff = abs(I_sens_der(L/2:L));
                    end
                    ind = kmeans(ampDiff,2);
                end
                
                for j=1:length(VplgL_dot_vec)-1
                    VplgL_dot_avg(j)=mean(VplgL_dot_vec(j:j+1));
                end
                
                
                
%                 plot(VplgL_dot_vec,I_sens_raw);hold on;
%                 plot(VplgL_dot_vec,I_sens_vec);hold off;
              
%                 plot(VplgL_dot_avg,I_sens_der)
                
                plot(VplgL_dot_avg(ind==1),ampDiff(ind==1),'r*');hold on;
                plot(VplgL_dot_avg,ampDiff,'k');
                plot(VplgL_dot_avg(ind==2),ampDiff(ind==2),'b*');hold off;
                grid on;
                pause(1);
            end
        end
%         I_sens_vec = MatrixData(:,I_sens__index,dummy_iter);
         
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