function varargout = DerivativeFun(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Order:';
    DataTable{1,2} = 1;
    DataTable{2,1} = 'Line Index (1D only):';
    DataTable{2,2} = 0;
    DataTable{3,1} = 'Smoothing Factor:';
    DataTable{3,2} = 0;
    DataTable{4,1} = '2D Plots: Derivative [dx or dy]:';
    DataTable{4,2} = 'dx';
    
    varargout = {DataTable};
else
            
    HandleAxes = varargin{1};
    Variables = varargin{2};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    order = cell2mat(Variables(1));
    LineIndex = cell2mat(Variables(2));    
    Iteration = cell2mat(Variables(3));
    Plot2D_Der = cell2mat(Variables(4));
    
    %Get data from figure: DO NOT EDIT THIS LINE---------------------------
    axs_children = get(HandleAxes,'Children');
    axs_surf = findall(axs_children,'Type','Surface');    
    if(isempty(axs_surf)==0)
        [XData,YData,ZData] = getDataFigure(HandleAxes,LineIndex);       
    else
        [XData,YData] = getDataFigure(HandleAxes,LineIndex);
    end
    %----------------------------------------------------------------------
    
    if(isempty(axs_surf)==0)
        if(strcmp(Plot2D_Der,'dx'))
            YData_new = YData;
            for i=1:length(YData)
                ZData_noiseless = ReduceNoise(ZData(i,:),3,Iteration,0);
                [XData_new,ZData_new(i,:)] = Derivative(XData,ZData_noiseless,order);
            end
        else
            XData_new = XData;
            for i=1:length(XData)
                ZData_noiseless = ReduceNoise(ZData(:,i),3,Iteration,0);
                [YData_new,ZData_new(i,:)] = Derivative(YData,ZData_noiseless,order);
            end
        end
        
        varargout = {XData_new,YData_new,ZData_new};
    else        
        for i=1:size(XData,2)
            YData{i} = ReduceNoise(YData{i},3,Iteration,0);
            [XData_new{i},YData_new{i}] = Derivative(XData{i},YData{i},order);
        end        
        varargout = {XData_new,YData_new};
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
    
   
end