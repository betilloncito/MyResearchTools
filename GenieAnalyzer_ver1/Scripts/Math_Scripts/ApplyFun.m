function varargout = ApplyFun(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Order:';
    DataTable{1,2} = 1;
    DataTable{2,1} = 'Line Index:';
    DataTable{2,2} = 0;
    DataTable{3,1} = 'Smoothing Factor:';
    DataTable{3,2} = 0;
    DataTable{4,1} = 'Type of Function [log]:';
    DataTable{4,2} = 'log';
    
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
        for i=1:size(ZData,1)
           Z_new(i,:) = ReduceNoise(ZData(i,:),3,10,0);
        end
        if(strcmp(Plot2D_Der,'log'))
            ZData_new = log10(abs(Z_new));            
        elseif(strcmp(Plot2D_Der,'log'))
            ZData_new = abs(Z_new);
        else
            ZData_new = Z_new;
        end
        XData_new = XData;
        YData_new = YData;
        
        varargout = {XData_new,YData_new,ZData_new};
    else
        YData = ReduceNoise(YData,3,Iteration,0);
        for i=1:size(XData,2)
            if(strcmp(Plot2D_Der,'log'))
%                 YData = cell2mat(YData);
                YData_new{i} = log10(abs(YData{i}));
                XData_new{i} = XData{i};
            elseif(strcmp(Plot2D_Der,'abs'))
                YData = cell2mat(YData);
                YData_new = abs(YData);
                
            else
                YData_new{i} = YData{i};
                XData_new{i} = XData{i};
            end
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
    
    %Do not edit this line
    
end