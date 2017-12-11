function CustomizeFigures(varargin) 
% HandleFig,title_label,TextBox_opt

if(nargin==1)
    title_label = [];
    TextBox_opt = 0;
elseif(nargin==2)
    title_label = varargin{2};
    TextBox_opt = 0;
elseif(nargin==3)
    title_label = varargin{2};
    TextBox_opt = varargin{3};
end
HandleFig = varargin{1};
    
set(0,'CurrentFigure',HandleFig);
set(0,'ShowHiddenHandles','on');

axs_children = get(gca,'Children');
axs_line = findall(axs_children,'Type','Line');
axs_text = findall(axs_children,'Type','Text');
axs_surf = findall(axs_children,'Type','Surface');

axis_label_Size = 30;
axis_Number_Size = 24;
title_Size = 22;

if(isempty(axs_surf)==0)     
    set(get(gca,'Title'),'FontSize',title_Size);  
    set(get(gca,'YLabel'),'FontSize',axis_label_Size);  
            
    set(gcf,'Color','w');
    set(gca,'FontSize',axis_Number_Size);
    
else    
    for k=length(axs_line):-1:1
        xdata = get(axs_line(k),'XData');
        ydata = get(axs_line(k),'YData');
        plot_color = get(axs_line(k),'Color');
                        
        linestyle = get(axs_line(k),'LineStyle');
        linewidth = 2;
        marker = get(axs_line(k),'Marker');
        markeredgecolor = get(axs_line(k),'MarkerEdgeColor');
        markerfacecolor = get(axs_line(k),'MarkerFaceColor');
        markersize = 10;
        
        if(k==length(axs_line))
            if(isempty(title_label))
                title_label = get(get(gca,'Title'),'String');
            end
            y_label = get(get(gca,'YLabel'),'String');
            x_label = get(get(gca,'XLabel'),'String');
            figure('WindowStyle','normal','Name','Data Plot');
            set(gcf,'Color','w');
        end
        h = gca;
        plot(h,xdata,ydata,'Color',plot_color,...
            'LineStyle',linestyle,'LineWidth',linewidth,...
            'Marker',marker,'MarkerEdgeColor',markeredgecolor,...
            'MarkerFaceColor',markerfacecolor,'MarkerSize',markersize);
        grid on;hold on;
        set(gca,'FontSize',axis_Number_Size);
        title(title_label,'FontSize',title_Size);
        xlabel(x_label,'fontsize',axis_label_Size);
        ylabel(y_label,'fontsize',axis_label_Size);
    end
end
if(TextBox_opt==1)
    text_String = get(axs_text(end),'String');
    text_Position = get(axs_text(end),'Position');
    text_BackColor = get(axs_text(end),'BackgroundColor');
    text_EdgeColor = get(axs_text(end),'EdgeColor');
    text_FontSize = get(axs_text(end),'FontSize');
    
    text('String',text_String,'Parent',gca,'Position',text_Position,...
        'BackgroundColor',text_BackColor,'EdgeColor',text_EdgeColor,...
        'FontSize',axis_Number_Size);
end

hold off;