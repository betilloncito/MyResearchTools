function varargout = SpinBlockadeSearch(varargin)
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
    DataTable{4,1} = 'Bias1: Current Threshold (%):';
    DataTable{4,2} = 0.04;       
    DataTable{5,1} = 'Bias2: Current Threshold (%):';
    DataTable{5,2} = 0.04; 
    DataTable{6,1} = 'Number of Triangles X:';
    DataTable{6,2} = 6;       
    DataTable{7,1} = 'Number of Triangles Y:';
    DataTable{7,2} = 5;
      
    DataTable{8,1} = 'Min Limit X:';
    DataTable{8,2} = 'none';       
    DataTable{9,1} = 'Min Limit Y:';
    DataTable{9,2} = 'none';
    
    DataTable{10,1} = 'Max Limit X:';
    DataTable{10,2} = 'none';       
    DataTable{11,1} = 'Max Limit Y:';
    DataTable{11,2} = 'none';
               
    DataTable{12,1} = 'Bar Width [V]:';
    DataTable{12,2} = 0.003;
    DataTable{13,1} = 'Pause Time (s):';
    DataTable{13,2} = 0.1;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'Vbias';
    %GATE L
    name{3} = 'VplgL';
    %GATE R
    name{4} = 'VplgR';
    %Time (optional)
    name{5} = 'Time';
    
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
                            VplgL_index = ii;
                        case 4
                            VplgR_index = ii;
                        case 5
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
        coeff_bias(1) = cell2mat(Variables(4));
        coeff_bias(2) = cell2mat(Variables(5));
        NumofTrianglesX = round(cell2mat(Variables(6)));                         
        NumofTrianglesY = round(cell2mat(Variables(7)));         
                 
        LimitX_min = cell2mat(Variables(8));                 
        LimitY_min = cell2mat(Variables(9));             
        LimitX_max = cell2mat(Variables(10));                
        LimitY_max = cell2mat(Variables(11)); 
        
        barwidth = cell2mat(Variables(12));
        wait_time = cell2mat(Variables(13));
        
        if(~strcmp(LimitX_min,'none'))
            LimitX_min = str2double(LimitX_min);
        end
        if(~strcmp(LimitY_min,'none'))
            LimitY_min = str2double(LimitY_min);
        end
        if(~strcmp(LimitX_max,'none'))            
            LimitX_max = str2double(LimitX_max);
        end
        if(~strcmp(LimitY_max,'none'))            
            LimitY_max = str2double(LimitY_max);
        end
        
        coeff_bias(3) = coeff_bias(2);
                
        for bias = 1:2
            coeff = coeff_bias(bias);
            
            Vplg2_o = [];Vplg2 = [];
            Vplg1_o = [];Vplg1 = [];
            Current_o = [];Current_oo = [];
            Current = [];
            
            switch MatrixData(1,VplgR_index,1,bias)
                case MatrixData(2,VplgR_index,1,bias)
                    %VplgL was swept first
                    Vplg2_o = reshape(MatrixData(1,VplgR_index,:,bias),size(MatrixData,3),1);
                    Vplg1_o = reshape(MatrixData(:,VplgL_index,1,bias),size(MatrixData,1),1);
                    Current_o = abs(reshape(MatrixData(:,I_index,:,bias),length(Vplg1_o),length(Vplg2_o)));
%                     Current_o = abs(max(max(abs(log(Current_o)))) - abs(log(Current_o)));
                    disp('in')
                otherwise
                    %VplgR was swept first
                    Vplg1_o = reshape(MatrixData(:,VplgR_index,1,bias),size(MatrixData,1),1);
                    Vplg2_o = reshape(MatrixData(1,VplgL_index,:,bias),size(MatrixData,3),1);
                    Current_o = abs(reshape(MatrixData(:,I_index,:,bias),length(Vplg1_o),length(Vplg2_o))); 
                    Current_o = log(Current_o);
                    disp('in')
            end
            
            if(strcmp(LimitX_min,'none'))
                LimitX_min = min(Vplg2_o);
            end
            if(strcmp(LimitY_min,'none'))
                LimitY_min = min(Vplg1_o);
            end
            if(strcmp(LimitX_max,'none'))
                LimitX_max = max(Vplg2_o);
            end
            if(strcmp(LimitY_max,'none'))
                LimitY_max = max(Vplg1_o);
            end
            
            [v,min_index2] = min(abs(Vplg2_o'-LimitX_min));
            [v,min_index1] = min(abs(Vplg1_o'-LimitY_min));
            [v,max_index2] = min(abs(Vplg2_o'-LimitX_max));
            [v,max_index1] = min(abs(Vplg1_o'-LimitY_max));
            
            %         min_index1 = strfind(Vplg1_o',LimitY_min)
            %         max_index2 = strfind(Vplg2_o',LimitX_max)
            %         max_index1 = strfind(Vplg1_o',LimitY_max)
            
            if(min_index1<max_index1)
                Vplg1 = Vplg1_o(min_index1:max_index1);
                Current_oo = Current_o(min_index1:max_index1,:);
            else
                Vplg1 = Vplg1_o(max_index1:min_index1);
                Current_oo = Current_o(max_index1:min_index1,:);
            end
            if(min_index2<max_index2)
                Vplg2 = Vplg2_o(min_index2:max_index2);
                Current = Current_oo(:,min_index2:max_index2);
            else
                Vplg2 = Vplg2_o(max_index2:min_index2);
                Current = Current_oo(:,max_index2:min_index2);
            end
            
%             figure(50);
%             surf(Vplg2,Vplg1,Current,'EdgeAlpha',0);
%             xlabel('X-axis');ylabel('Y-axis');
%             view([0 0 90]);
            
            binNum = 200;
            [Ncounts,edges] = histcounts(Current,binNum);
%             HandleFig = figure('WindowStyle','normal','Name','Data Plot');
%             histogram(Current,edges);grid on;
%             xlabel('Current Value [A]');ylabel('Number of Occurrences')
            
            Ncounts_sorted = sort(Ncounts,'descend');
            index = find(Ncounts==Ncounts_sorted(1));
            BaseCurrentValue = mean([edges(index),edges(index+1)]);                      
            Current = Current-BaseCurrentValue;            
            
            thres = coeff*max(max(Current));
            cnt = 1;
            Current_thres = [];Current_save = [];
            Vplg1_save = [];Vplg2_save = [];                        
            for m=1:size(Current,1)
                for n=1:size(Current,2)
                    %                 if(Vplg1(m)<LimitY_max && Vplg1(m)>LimitY_min && ...
                    %                         Vplg2(n)<LimitX_max && Vplg2(n)>LimitX_min)
                    
                    if(Current(m,n)>thres)
                        Current_thres(m,n) = 1;
                        Current_save(cnt,1) = Current(m,n);
                        Vplg1_save(cnt,1) = Vplg1(m);
                        Vplg2_save(cnt,1) = Vplg2(n);
                        
                        cnt = cnt+1;
                    else
                        Current_thres(m,n) = 0;
                    end
                    %                     Vplg1_cut(length(Vplg1_cut)+1) = Vplg1(m);
                    %                     Vplg2_cut(length(Vplg2_cut)+1) = Vplg2(n);
                    %                 end
                end
                %             pause;
            end
            
            %             figure(100);
            %             ax1 = axes;
            
            if(bias==1)
                fig1 = figure(100);ax1 = axes;
                set(fig1,'CurrentAxes',ax1);
                delete(ax1);ax1 = axes;
                surf(Vplg2,Vplg1,Current_thres,'EdgeAlpha',0);
                xlabel('X-axis');ylabel('Y-axis');
                view([0 0 90]);
            else
                fig2 = figure(101);ax2 = axes;
                set(fig2,'CurrentAxes',ax2);
                delete(ax2);ax2 = axes;
                surf(Vplg2,Vplg1,Current_thres,'EdgeAlpha',0);
                xlabel('X-axis');ylabel('Y-axis');
                view([0 0 90]);
            end
            
            idx = kmeans(Vplg2_save,NumofTrianglesX);
            
            CNT = 1;
            for i=1:NumofTrianglesX
                BigCluster_1 = Vplg1_save(idx==i);
                BigCluster_2 = Vplg2_save(idx==i);
                BigCluster_Current = Current_save(idx==i);
                
                idy = kmeans(BigCluster_1,NumofTrianglesY);
                
                set(fig1,'CurrentAxes',ax1);
                for j=1:NumofTrianglesY                    
                    line(BigCluster_2(idy==j),BigCluster_1(idy==j),2*ones(1,length(BigCluster_2(idy==j))),'Marker','o',...
                        'MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r',...
                        'LineStyle','none');
                    
                    Avg_Current(CNT,bias) = mean(BigCluster_Current(idy==j));
                    Avg_Vplg1(CNT,bias) = mean(BigCluster_1(idy==j));
                    Avg_Vplg2(CNT,bias) = mean(BigCluster_2(idy==j));
                    
                    CNT = CNT+1;
                    pause(wait_time);
                end
            end
            
%             figure(200);
            
        end        
        
        fig3 = figure(200);ax3 = axes;
        delete(ax3)
%         set(fig2,'CurrentAxes',ax2);
        scatterbar3(Avg_Vplg2(:,1),Avg_Vplg1(:,1),Avg_Current(:,1),barwidth)
        colormap('gray')
        xlabel('X-axis');ylabel('Y-axis');
        title('bias 1')
        grid on;view([0 0 90]);
        
        fig4 = figure(300);ax4 = axes;
        delete(ax4)
%         set(fig3,'CurrentAxes',ax3);
        scatterbar3(Avg_Vplg2(:,2),Avg_Vplg1(:,2),Avg_Current(:,2),barwidth)
        colormap('gray')
        xlabel('X-axis');ylabel('Y-axis');
        title('bias 1')
        grid on;view([0 0 90]);
        
%         fig5 = figure(400);ax5 = axes;
%         delete(ax5)
% %         set(fig3,'CurrentAxes',ax3);
%         scatterbar3(Avg_Vplg2(:,3),Avg_Vplg1(:,3),Avg_Current(:,3),barwidth)
%         colormap('gray')
%         xlabel('X-axis');ylabel('Y-axis');
%         title('bias 1')
%         grid on;view([0 0 90]);
        
%         line(Avg_Vplg2(:,1),Avg_Vplg1(:,1),Avg_Current(:,1),'Marker','o',...
%             'MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r',...
%             'LineStyle','none');
%         line(Avg_Vplg2(:,2),Avg_Vplg1(:,2),Avg_Current(:,2),'Marker','o',...
%             'MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b',...
%             'LineStyle','none');
        
        
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