function varargout = GeneralMath(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Offset X:';
    DataTable{1,2} = 0;
    DataTable{2,1} = 'Scale X:';
    DataTable{2,2} = 1;
    DataTable{3,1} = 'Offset Y:';
    DataTable{3,2} = 0;
    DataTable{4,1} = 'Scale Y:';
    DataTable{4,2} = 1;
    DataTable{5,1} = 'Offset Z:';
    DataTable{5,2} = 0;
    DataTable{6,1} = 'Scale Z:';
    DataTable{6,2} = 1;
    DataTable{7,1} = 'Line Index:';
    DataTable{7,2} = 0;
    
    varargout = {DataTable};
else
            
    HandleAxes = varargin{1};
    Variables = varargin{2};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    deltaX = cell2mat(Variables(1));
    Gx = cell2mat(Variables(2));
    deltaY = cell2mat(Variables(3));
    Gy = cell2mat(Variables(4));
    deltaZ = cell2mat(Variables(5));
    Gz = cell2mat(Variables(6));
    LineIndex = cell2mat(Variables(7));    
    
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
        XData_new = Gx*XData + deltaX;
        YData_new = Gy*YData + deltaY;
        ZData_new = Gz*ZData + deltaZ;
        
        varargout = {XData_new,YData_new,ZData_new};
    else                
        for i=1:size(XData,2)
            XData_new{i} = Gx*XData{i} + deltaX;
            YData_new{i} = Gy*YData{i} + deltaY;
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