function varargout = TransconductanceAnalysis(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Sensitivity [A/V]:';
    DataTable{1,2} = 1e-8;
    DataTable{2,1} = 'Line Index:';
    DataTable{2,2} = 0;
    DataTable{3,1} = 'Smoothing Factor:';
    DataTable{3,2} = 0;
    DataTable{4,1} = 'limits for subthreshold [min,max]:';
    DataTable{4,2} = '1,2';
    
    varargout = {DataTable};
else
            
    HandleAxes = varargin{1};
    Variables = varargin{2};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    Sens = cell2mat(Variables(1));
    LineIndex = cell2mat(Variables(2));    
    Iteration = cell2mat(Variables(3));
    Limits = cell2mat(Variables(4));
    
    %Get data from figure: DO NOT EDIT THIS LINE---------------------------
    axs_children = get(HandleAxes,'Children');
    axs_surf = findall(axs_children,'Type','Surface');    
    if(isempty(axs_surf)==0)
        [XData,YData,ZData] = getDataFigure(HandleAxes);       
    else
        [XData,YData] = getDataFigure(HandleAxes,LineIndex);
    end
    %----------------------------------------------------------------------
    n=strfind(Limits,',');
    Min = str2double(Limits(1:n-1));
    Max = str2double(Limits(n+1:end));
    
    HandleFig = figure;
    HandleAxes = axes;grid on;
    HandleFig2 = figure;
    HandleAxes2 = axes;grid on;
    size(XData,2)
    if(isempty(axs_surf)==1)
        for i=1:size(XData,2)
            YData_smooth{i} = Sens*ReduceNoise(YData{i},3,Iteration,0);
            YData_log{i} = log10(abs(YData_smooth{i}));
            [XData_der{i},YData_der{i}] = Derivative(XData{i},YData_log{i},1);
            [val, ind] = max(YData_der{i});
            line(XData{i},YData_log{i},'Parent',HandleAxes,'Color','b');
            line(XData_der{i},YData_der{i},'Parent',HandleAxes2,'Color','k');
            tempX = XData{i};
            tempY = YData_log{i};
            tempDer = YData_der{i};
            line(tempX(ind),tempY(ind),'Marker','o','MarkerEdgeColor','r','Parent',HandleAxes);
            
            Min_index = find(tempX==Min)
            Max_index = find(tempX==Max)
            if(Min_index<Max_index)
                SubThresSwing(i) = mean(tempDer(Min_index:Max_index));
            else
                SubThresSwing(i) = mean(tempDer(Max_index:Min_index));
            end
        end
        title(['Subthreshold swing: ',num2str(mean(SubThresSwing)),' [V/dec]'])
        xlabel('Gate Voltage [V]');
        ylabel('Derivative of Log(I) [arb.]');
    end
    varargout = {XData,YData};        
    
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