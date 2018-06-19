function varargout = Shifting2DPlots(varargin)
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
    DataTable{1,1} = 'Shift Amount:';
    DataTable{1,2} = 5;
    DataTable{2,1} = 'Shift Index:';
    DataTable{2,2} = 1;
    
    varargout = {DataTable};
else
    
    HandleAxes = varargin{1};
    Variables = varargin{2};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    shiftAmount = cell2mat(Variables(1));
    shiftIndex = cell2mat(Variables(2));    
    
    %Get data from figure: DO NOT EDIT THIS LINE---------------------------
    axs_children = get(HandleAxes,'Children');
    axs_surf = findall(axs_children,'Type','Surface');    
    if(isempty(axs_surf)==0)
        [XData,YData,ZData] = getDataFigure(HandleAxes);       
    else
        [XData,YData] = getDataFigure(HandleAxes,LineIndex);
    end
    %----------------------------------------------------------------------
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
    %
    %------------------STOP CODE HERE---------------------------------%
    
    if(shiftAmount>0)
        Zshift_below = ZData(1:shiftIndex,1:end-shiftAmount+1);
        Zshift_above = ZData(shiftIndex+1:end,shiftAmount:end);
        
        Z_new = [Zshift_below;Zshift_above];
        X_new = XData(shiftAmount:end);
    else
        shift = abs(shift);
        Zshift_below = ZData(1:shiftIndex,shiftAmount:end);
        Zshift_above = ZData(shiftIndex+1:end,1:end-shiftAmount+1);
        
        Z_new = [Zshift_below;Zshift_above];
        X_new = XData(shiftAmount:end);
    end
    
    
%     surf(X_new,Y,Z_new,'EdgeAlpha',0);
%     colormap('jet')
%     view(2);
    varargout = {X_new,YData,Z_new};
    
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
%     varargout = {1};
end