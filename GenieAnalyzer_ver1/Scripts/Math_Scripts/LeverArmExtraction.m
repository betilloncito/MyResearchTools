function varargout = LeverArmExtraction(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Sensitivity [A/V]:';
    DataTable{1,2} = 1e-8;
    DataTable{2,1} = 'Peak Finding Axis X or Y:';
    DataTable{2,2} = 'X';    
    DataTable{3,1} = 'Sacling of Pk. Finding Axis:';
    DataTable{3,2} = 100;
    DataTable{4,1} = 'Smoothing Factor:';
    DataTable{4,2} = 2;
    DataTable{5,1} = 'X limits [min,max]:';
    DataTable{5,2} = '';
    DataTable{6,1} = 'Y limits [min,max]:';
    DataTable{6,2} = '';
    DataTable{7,1} = 'Number of k-cluster [integer]:';
    DataTable{7,2} = 13;
    DataTable{8,1} = 'Number of Chosen Peaks [integer]:';
    DataTable{8,2} = 6;
    DataTable{9,1} = 'Number of k-clustering sections [integer]:';
    DataTable{9,2} = 6;
    
    varargout = {DataTable};
else
            
    HandleAxes = varargin{1};
    Variables = varargin{2};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    Sens = cell2mat(Variables(1));
    PeakFindingAxis = cell2mat(Variables(2));    
    Scaling_PeakFindingAxes = round(cell2mat(Variables(3)));
    Iteration = cell2mat(Variables(4));
    LimitsX = cell2mat(Variables(5));
    LimitsY = cell2mat(Variables(6));
    kcluster_num = round(cell2mat(Variables(7)));
    ChosenPks_num = round(cell2mat(Variables(8)));
    kclustering_sections = round(cell2mat(Variables(9)));
    
    %Get data from figure: DO NOT EDIT THIS LINE---------------------------
    axs_children = get(HandleAxes,'Children');
    axs_surf = findall(axs_children,'Type','Surface');    
    if(isempty(axs_surf)==0)
        [XData,YData,ZData] = getDataFigure(HandleAxes);  
        %         ZData = ZData*Sens;
        Labels_X = get(HandleAxes,'XLabel');
        Labels_Y = get(HandleAxes,'YLabel');
        
        axis_Number_Size = 20;
        title_Size = 10;
        axis_label_Size = 20;
        
        Data_2D_ERROR = 0;
        surf_Plotted = 0;
    else
        msgbox('Data plotted is not a 2D surface. Lever-arm extraction will not work','Error','error');
        Data_2D_ERROR = 1;
    end
    %----------------------------------------------------------------------
    %Executes only if the plotted data is 2D
    if(Data_2D_ERROR == 0)
        nx=strfind(LimitsX,',');
        if(~isempty(nx))
            Min_X = str2double(LimitsX(1:nx-1));
            Max_X = str2double(LimitsX(nx+1:end));
            [val, Min_X_index] = min(abs(XData - Min_X));
            [val, Max_X_index] = min(abs(XData - Max_X));
            if(Min_X_index < Max_X_index)
                startX_index = Min_X_index
                endX_index = Max_X_index
            else
                startX_index = Max_X_index
                endX_index = Min_X_index
            end
        else
            startX_index = 1;
            endX_index = length(XData);
        end
        ny=strfind(LimitsY,',');
        if(~isempty(ny))
            Min_Y = str2double(LimitsY(1:ny-1));
            Max_Y = str2double(LimitsY(ny+1:end));
            [val, Min_Y_index] = min(abs(YData - Min_Y));
            [val, Max_Y_index] = min(abs(YData - Max_Y));
            if(Min_Y_index < Max_Y_index)
                startY_index = Min_Y_index;
                endY_index = Max_Y_index;
            else
                startY_index = Max_Y_index;
                endY_index = Min_Y_index;
            end
        else
            startY_index = 1;
            endY_index = length(YData);
        end
        
        HandleAxes = CustomizeFigures;
        Cluster_X = {};Cluster_Y = {};
        Cluster_X_FULL = {};
        Cluster_Y_FULL = {};
        UserContinue = 'Yes';
        if(strcmp(PeakFindingAxis,'X'))
            Delta = floor(length(YData(startY_index:endY_index))/kclustering_sections);
            ITER = 1;
            while(ITER <= kclustering_sections && strcmp(UserContinue,'Yes')==1)
                Peaks_z = {};Peaks_y = {};Peaks_x = {};
                for i=startY_index+Delta*(ITER-1):startY_index+Delta*(ITER)
%                     start_index = startY_index+Delta*(ITER-1);
%                     end_index = startY_index+Delta*(ITER);
                    
                    tempZ = ZData(i,startX_index:endX_index);
                    tempX = XData(startX_index:endX_index);
                    ZData_smooth = ReduceNoise(tempZ,3,Iteration,0);
                    
                    [pks,loc] = findpeaks(ZData_smooth);
                    Peaks_x = [Peaks_x; {tempX(loc)}];
                    Peaks_y = [Peaks_y; {YData(i)/Scaling_PeakFindingAxes*ones(1,length(tempX(loc)))}];
                    Peaks_z = [Peaks_z; {tempZ(loc)}];
                end
                colNum_max = max(cellfun(@numel,Peaks_x));
                Padded_X = -999*ones(size(Peaks_x,1),colNum_max);
                Padded_Y = -999*ones(size(Peaks_x,1),colNum_max);
                for j=1:size(Peaks_x,1)
                    rowx = Peaks_x{j};
                    rowy = Peaks_y{j};
                    Padded_X(j,1:length(rowx)) = rowx;
                    Padded_Y(j,1:length(rowy)) = rowy;
                end
                Padded_X_vec = reshape(Padded_X,[numel(Padded_X),1]);
                Padded_Y_vec = reshape(Padded_Y,[numel(Padded_Y),1]);
                %             Padded_X_vec = reshape(Padded_X',[numel(Padded_X),1]);
                %             Padded_Y_vec = reshape(Padded_Y',[numel(Padded_Y),1]);
                Peaks_x_vec = Padded_X_vec(Padded_X_vec ~= -999);
                Peaks_y_vec = Padded_Y_vec(Padded_Y_vec ~= -999);
                
                if(surf_Plotted == 0)
                    surf(XData,YData,ZData,'EdgeColor','none','Parent',HandleAxes);
                    XY_plane = [0 90];view(HandleAxes, XY_plane);
                    set(HandleAxes,'XLim',sort([XData(startX_index),XData(endX_index)],'ascend'));
                    set(HandleAxes,'YLim',sort([YData(startY_index),YData(endY_index)],'ascend'));
                    xlabel(HandleAxes, Labels_X.String);ylabel(HandleAxes, Labels_Y.String);
                    surf_Plotted = 1;
                end
                idx = kmeans([Peaks_x_vec,Peaks_y_vec],kcluster_num);
                color_set = varycolor(kcluster_num);
                
                if(isempty(Cluster_X))
                    cnt=1;
                    for i=1:kcluster_num
                        temp_Cluster_X = Peaks_x_vec(idx==i);
                        temp_Cluster_Y = Peaks_y_vec(idx==i);
                        line(temp_Cluster_X,temp_Cluster_Y*Scaling_PeakFindingAxes,...
                            max(max(ZData))*ones(1,length(temp_Cluster_X)),...
                            'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                            'MarkerFaceColor','none','Parent',HandleAxes);
                        pause;
                        cnt = cnt+1;
                    end
                    UserContinue = questdlg('Contiue?','Input','Yes','No','Yes');
                    if(strcmp(UserContinue,'Yes'))
                        for i=1:kcluster_num
                            X_pos(i) = mean(Peaks_x_vec(idx==i));
                        end
                        X_pos_sorted = sort(X_pos,'ascend')
                        n = ceil(length(X_pos_sorted)/2)-floor(ChosenPks_num/2);
                        nn = ceil(length(X_pos_sorted)/2)+(ChosenPks_num-floor(ChosenPks_num/2)-1);
                        Chosen_X_pos_sorted = X_pos_sorted(n:nn)
%                         cnt = 1;
                        for i=1:length(Chosen_X_pos_sorted)
                            for ii=1:kcluster_num
                                if(Chosen_X_pos_sorted(i) == X_pos(ii))
                                    Cluster_X{i,ITER} = Peaks_x_vec(idx==ii);
                                    Cluster_Y{i,ITER} = Peaks_y_vec(idx==ii);
                                    Cluster_X_FULL{i} = Peaks_x_vec(idx==ii);
                                    Cluster_Y_FULL{i} = Peaks_y_vec(idx==ii);
                                    line(Cluster_X{i,ITER},Cluster_Y{i,ITER}*Scaling_PeakFindingAxes,...
                                        max(max(ZData))*ones(1,length(Cluster_X{i,ITER})),...
                                        'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                                        'MarkerFaceColor',color_set(i,:),'Parent',HandleAxes);
                                    pause;
                                    break;
%                                     cnt = cnt+1;
                                end
                            end
                        end
                    end
                    
                elseif(~isempty(Cluster_X))
                    cnt=1;
                    for i=1:kcluster_num
                        temp_Cluster_X = Peaks_x_vec(idx==i);
                        temp_Cluster_Y = Peaks_y_vec(idx==i);
                        line(temp_Cluster_X,temp_Cluster_Y*Scaling_PeakFindingAxes,...
                            max(max(ZData))*ones(1,length(temp_Cluster_X)),...
                            'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                            'MarkerFaceColor','none','Parent',HandleAxes);
                        pause;
                        cnt = cnt+1;
                    end
                    UserContinue = questdlg('Contiue?','Input','Yes','No','Yes');
                    if(strcmp(UserContinue,'Yes'))
                        for ii=1:size(Cluster_Y,1)                            
                            for i=1:kcluster_num
                                vec_x = Peaks_x_vec(idx==i);
                                vec_y = Peaks_y_vec(idx==i);
                                
                                if(length(vec_y) > length(Cluster_Y{ii,ITER-1}))
                                    %                                 disp('padding 1');
                                    PadVecY = -999*ones(length(vec_y),1);
                                    PadVecX = -999*ones(length(vec_x),1);
                                    PadVecY(1:length(Cluster_Y{ii,ITER-1}),1) = Cluster_Y{ii,ITER-1};
                                    PadVecX(1:length(Cluster_X{ii,ITER-1}),1) = Cluster_X{ii,ITER-1};
                                    %                                 [PadVecX,PadVecY]
                                    %                                 [vec_x,vec_y]
                                    Cluster_match = intersect([PadVecX,PadVecY], [vec_x,vec_y],'rows');
                                elseif(length(vec_y) < length(Cluster_Y{ii,ITER-1}))
                                    %                                 disp('padding 2');
                                    PadVecY = -999*ones(length(Cluster_Y{ii,ITER-1}),1);
                                    PadVecX = -999*ones(length(Cluster_X{ii,ITER-1}),1);
                                    PadVecY(1:length(vec_y),1) = vec_y;
                                    PadVecX(1:length(vec_x),1) = vec_x;
                                    %                                 [PadVecX,PadVecY]
                                    %                                 [Cluster_X{ii,ITER-1},Cluster_Y{ii,ITER-1}]
                                    Cluster_match = intersect([PadVecX,PadVecY],[Cluster_X{ii,ITER-1},Cluster_Y{ii,ITER-1}],'rows');
                                else
                                    %                                 disp('no padding ');
                                    %                                 vec_y
                                    %                                 Cluster_Y{ii,ITER-1}
                                    %                                 [vec_x,vec_y]
                                    %                                 [Cluster_X{ii,ITER-1},Cluster_Y{ii,ITER-1}]
                                    Cluster_match = intersect([vec_x,vec_y],[Cluster_X{ii,ITER-1},Cluster_Y{ii,ITER-1}],'rows');
                                end
                                
                                if(~isempty(Cluster_match))
                                    Cluster_X{ii,ITER} = vec_x;
                                    Cluster_Y{ii,ITER} = vec_y;
                                    Cluster_X_FULL{ii} = [Cluster_X_FULL{ii};Cluster_X{ii,ITER}]
                                    Cluster_Y_FULL{ii} = [Cluster_Y_FULL{ii};Cluster_Y{ii,ITER}]
                                    line(Cluster_X{ii,ITER},Cluster_Y{ii,ITER}*Scaling_PeakFindingAxes,...
                                        max(max(ZData))*ones(1,length(Cluster_X{ii,ITER})),...
                                        'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                                        'MarkerFaceColor',color_set(ii,:),'Parent',HandleAxes);
                                    pause;
                                end
                            end
                        end
                    end
                end
                
                set(HandleAxes,'FontSize',axis_Number_Size);
                %             title(HandleAxes, title_label,'FontSize',title_Size);
                xlabel(HandleAxes, Labels_X.String,'fontsize',axis_label_Size);
                ylabel(HandleAxes, Labels_Y.String,'fontsize',axis_label_Size);
                
                ITER = ITER + 1;
            end
        elseif(strcmp(PeakFindingAxis,'Y'))
            Peaks_z = {};Peaks_y = {};Peaks_x = {};
            for i=startX_index:endX_index
                tempZ = ZData(startY_index:endY_index,i);
                tempY = YData(startY_index:endY_index);
                ZData_smooth = ReduceNoise(tempZ,3,Iteration,0);
                
                [pks,loc] = findpeaks(ZData_smooth);
                Peaks_y = [Peaks_y; {tempY(loc)}];
                Peaks_x = [Peaks_x; {XData(i)*ones(1,length(tempY(loc)))}];
                Peaks_z = [Peaks_z; {tempZ(loc)}];
            end
            colNum_max = max(cellfun(@numel,Peaks_y));
            Padded_X = -999*ones(size(Peaks_y,1),colNum_max);
            Padded_Y = -999*ones(size(Peaks_y,1),colNum_max);
            for j=1:size(Peaks_y,1)
                rowx = Peaks_x{j};
                rowy = Peaks_y{j};
                Padded_X(j,1:length(rowx)) = rowx;
                Padded_Y(j,1:length(rowy)) = rowy;
            end
            
            Padded_X_vec = reshape(Padded_X,[numel(Padded_X),1]);            
            Padded_Y_vec = reshape(Padded_Y,[numel(Padded_Y),1]);
%             
%             Padded_X_vec = reshape(Padded_X',[numel(Padded_X),1]);            
%             Padded_Y_vec = reshape(Padded_Y',[numel(Padded_Y),1]);
            
            Peaks_x_vec = Padded_X_vec(Padded_X_vec ~= -999)
            Peaks_y_vec = Padded_Y_vec(Padded_Y_vec ~= -999)
            
            surf(XData,YData,ZData,'EdgeColor','none','Parent',HandleAxes);
            XY_plane = [0 90];view(HandleAxes, XY_plane);
            xlabel(HandleAxes, Labels_X.String);ylabel(HandleAxes, Labels_Y.String);
            %             line(Peaks_x,Peaks_y,max(max(ZData))*ones(1,length(Peaks_x)),...
            %                 'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
            %                 'MarkerFaceColor','r','Parent',HandleAxes);
            
            idx = kmeans([Peaks_x_vec,Peaks_y_vec],kcluster_num);
            color_set = varycolor(kcluster_num);
            for i=1:kcluster_num
                Cluster_X{i} = Peaks_x_vec(idx==i);
                Cluster_Y{i} = Peaks_y_vec(idx==i);
                line(Cluster_X{i},Cluster_Y{i},max(max(ZData))*ones(1,length(Cluster_X{i})),...
                    'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                    'MarkerFaceColor',color_set(i,:),'Parent',HandleAxes);
            end
            
            set(HandleAxes,'FontSize',axis_Number_Size);
            %             title(HandleAxes, title_label,'FontSize',title_Size);
            xlabel(HandleAxes, Labels_X.String,'fontsize',axis_label_Size);
            ylabel(HandleAxes, Labels_Y.String,'fontsize',axis_label_Size);
            
            %             line(XData,ZData(1,:),'Color','b','LineStyle','-','Parent',HandleAxes);
            %             line(XData,ZData_smooth,'Color','r','Parent',HandleAxes);
            %             line(Peaks_x,Peaks_y,'LineStyle','none','Marker','o','Parent',HandleAxes);
            
        else
            msgbox('Invalid axis to find peaks. Enter either X or Y','Error','error');
        end
        
        %         isempty(Cluster_X_FULL)
        %         UserContinue
        length(Cluster_X_FULL)
        if(isempty(Cluster_X_FULL)==0 && strcmp(UserContinue,'Yes')==1)
            child = get(HandleAxes,'Children');delete(child);
            
            surf(XData,YData,ZData,'EdgeColor','none','Parent',HandleAxes);
            XY_plane = [0 90];view(HandleAxes, XY_plane);
            set(HandleAxes,'XLim',sort([XData(startX_index),XData(endX_index)],'ascend'));
            set(HandleAxes,'YLim',sort([YData(startY_index),YData(endY_index)],'ascend'));
            xlabel(HandleAxes, Labels_X.String);ylabel(HandleAxes, Labels_Y.String);
            set(HandleAxes,'FontSize',axis_Number_Size);
            %             title(HandleAxes, title_label,'FontSize',title_Size);
            xlabel(HandleAxes, Labels_X.String,'fontsize',axis_label_Size);
            ylabel(HandleAxes, Labels_Y.String,'fontsize',axis_label_Size);
            
            color_set = varycolor(length(Cluster_X_FULL));
            for cnt=1:length(Cluster_X_FULL)
                coeff = polyfit(Cluster_X_FULL{cnt},Cluster_Y_FULL{cnt}*Scaling_PeakFindingAxes,1);
                slope(cnt) = coeff(1);%y_inter(cnt) = coeff(2);
            end
            slope_avg = mean(slope)
            for cnt=1:length(Cluster_X_FULL)
                X_line = Cluster_X_FULL{cnt};
                Y_line = Cluster_Y_FULL{cnt};
                sizeMidpt = round(length(Y_line));
                y_inter(cnt) = Y_line(sizeMidpt)*Scaling_PeakFindingAxes - slope_avg*X_line(sizeMidpt); 
            
                line(Cluster_X_FULL{cnt},Cluster_Y_FULL{cnt}*Scaling_PeakFindingAxes,...
                    max(max(ZData))*ones(1,length(Cluster_X_FULL{cnt})),...
                    'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                    'MarkerFaceColor',color_set(cnt,:),'MarkerSize',2,...
                    'Parent',HandleAxes);
                line([X_line(1),X_line(end)],slope_avg*[X_line(1),X_line(end)]+y_inter(cnt),...
                    max(max(ZData))*ones(1,2),'LineStyle','-','Color','r',...
                    'LineWidth',3,'Parent',HandleAxes);
                pause;
            end
            
            leverArm_Y = mean(diff(y_inter))
            leverArm_X = mean(diff(-y_inter./slope_avg))
            title(HandleAxes, {['Lever-Arm (GateX): ',num2str(leverArm_X),' [V/e]']},...
                {['Lever-Arm (GateY): ',num2str(leverArm_Y),' [V/e]']},...
                {['Lever-Arm Ratio (X/Y): ',num2str(leverArm_X/leverArm_Y)]},...
                'FontSize',title_Size);
        end
        
        varargout = {XData,YData,ZData};
    end
    
    %------------------STOP CODE HERE---------------------------------%
        
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
    
end