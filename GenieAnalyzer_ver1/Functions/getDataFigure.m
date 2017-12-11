function varargout = getDataFigure(varargin) 
% Extracts the x and y data from a figure for each line element or for a
% specific line element specified by the index given by user.
% The first parameter should the handle to the figure and the second should
% be the index of the line element to consider to make the extraction. If
% an index is not provided then the function will perform the extraction on
% all the line elements.

if(nargin==1)
    LineIndex = 0;
elseif(nargin==2)
    LineIndex = varargin{2};
end
HandleAxes = varargin{1};
    
% set(0,'CurrentFigure',HandleAxes);
% set(0,'ShowHiddenHandles','on');

axs_children = get(HandleAxes,'Children');
axs_line = findall(axs_children,'Type','Line');
axs_surf = findall(axs_children,'Type','Surface');

if(isempty(axs_surf)==0)
    xdata = axs_surf.XData;
    ydata = axs_surf.YData;
    zdata = axs_surf.ZData;
    
    varargout = {xdata,ydata,zdata};
else
    if(LineIndex==0)
        for k=length(axs_line):-1:1
            xdata{k} = get(axs_line(k),'XData');
            ydata{k} = get(axs_line(k),'YData');
        end
    else
        xdata{1} = get(axs_line(length(axs_line)-(LineIndex-1)),'XData');
        ydata{1} = get(axs_line(length(axs_line)-(LineIndex-1)),'YData');
    end
    varargout = {xdata,ydata};
end