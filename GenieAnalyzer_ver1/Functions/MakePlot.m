function MakePlot(X,Y,x_label,y_label,Title,Legend,doubleAxes,y_label2)
axis_label_Size = 30;
axis_Number_Size = 24;
title_Size = 26;
LineWidth_Size = 2;
Marker_Size = 12;
LineStyle = 'none';
% X = [0,25,50,100,200,300,400,500]';
% %Thickness data
% Y(:,1) = [23.36,49.40,48.68,47.60,51.46,53.39,58.66,60.83]';
% Y(:,1) = [23.07,49.22,48.59,47.53,51.12,53.14,58.51,60.70]';
% Y(:,2) = [22.73,49.39,48.72,47.63,51.21,53.21,58.49,60.63]';
% Y(:,3) = [20.68,46.72,46,44.92,48.31,50.29,55.45,57.51]';
% Y(:,4) = [18.85,45.15,44.35,43.28,46.51,48.53,53.65,55.68]';
% Y(:,5) = [17.28,42.9,41.94,40.85,43.9,45.99,51.08,53.05]';
% Y(:,6) = [15.98,17.05,18.57,18.63,19.43,19.04,19.17,19.31]';
% Y(:,7) = [14.93,37.96,36.42,35.27,37.97,40.43,45.80,47.71]';
% Y(:,8) = [14.93,37.94,36.21,34.65,39.06,40.95,45.89,47.76]';

% Y(:,1) = [0,38.8,40.35,39.6,40.71,42.88,48.9,51.65]';
% Y(:,2) = [14.93,5.32,7.52,8.15,4.7,4.61,4.44,4.52]';

% color1 = 'brkmc';
color = 'brkbrkgcm';
marker = 'o^s*d\v+';
marker_cnt = 0;

if(doubleAxes==1)
    color_cnt = 0;LegendSort={};
    for i=1:2:size(Y,2)
        color_cnt = color_cnt+1;
        if(i==1)
            figure(2)
            [ax,p1,p2] = plotyy(X,Y(:,i),X,Y(:,i+1));grid on;hold on;
            set(p1,'LineStyle',LineStyle);
            set(p1,'LineWidth',LineWidth_Size);set(p1,'MarkerSize',Marker_Size);set(p1,'Marker',marker(1));
            set(p1,'Color',color(color_cnt));set(p1,'MarkerFaceColor',color(color_cnt));
            set(p2,'LineStyle',LineStyle);
            set(p2,'LineWidth',LineWidth_Size);set(p2,'MarkerSize',Marker_Size);set(p2,'Marker',marker(2));
            set(p2,'Color',color(color_cnt));set(p2,'MarkerFaceColor',color(color_cnt));
        else
            set(gcf,'CurrentAxes',ax(1));
            line(X,Y(:,i),'LineStyle',LineStyle,'LineWidth',LineWidth_Size,'Marker',marker(1),'MarkerSize',Marker_Size,...
                'MarkerFaceColor',color(color_cnt),'Color',color(color_cnt));grid on;
            set(gcf,'CurrentAxes',ax(2));
            line(X,Y(:,i+1),'LineStyle',LineStyle,'LineWidth',LineWidth_Size,'Marker',marker(2),'MarkerSize',Marker_Size,...
                'MarkerFaceColor',color(color_cnt),'Color',color(color_cnt));grid on;
        end
%         {cell2mat(Legend(color_cnt*2)),cell2mat(Legend(color_cnt))}
        LegendSort_Even(color_cnt) = Legend(color_cnt*2);
        LegendSort_Odd(color_cnt) = Legend(2*color_cnt-1);
    end    
    LegendSort = [LegendSort_Even,LegendSort_Odd];
    set(ax,{'ycolor'},{'k';'k'})   
    hold off;
    set(ax(1),'FontSize',axis_Number_Size);
    set(ax(2),'FontSize',axis_Number_Size);
    set(gcf,'Color','w');
    xlabel(ax(1),x_label,'fontsize',axis_label_Size,'interpreter','LaTex');
    ylabel(ax(1),y_label,'fontsize',axis_label_Size,'interpreter','LaTex');
    ylabel(ax(2),y_label2,'fontsize',axis_label_Size,'interpreter','LaTex');
    title(Title,'FontSize',title_Size,'interpreter','LaTex');
    legend(LegendSort)
else
    figure('WindowStyle','normal','Name','Data Plot');
    set(gcf,'Color','w');
    set(gca,'FontSize',axis_Number_Size);
    if(size(Y,2)>2)
        for i=1:size(Y,2)
            if(mod(i-1,6)+1==1)
                marker_cnt = marker_cnt+1;
            end
            
            if(i>3 && i<8)
                if(isnan(Y(:,i))==0)
                    line(X,Y(:,i),'LineStyle',LineStyle,'LineWidth',LineWidth_Size,'Marker',marker(2),'MarkerSize',Marker_Size,...
                        'MarkerFaceColor',color(i),'Color',color(i));grid on;
                end
            else
                line(X,Y(:,i),'LineStyle',LineStyle,'LineWidth',LineWidth_Size,'Marker',marker(1),'MarkerSize',Marker_Size,...
                    'MarkerFaceColor',color(i),'Color',color(i));grid on;
            end
        end        
    else
        for i=1:size(Y,1)
            if(mod(i-1,6)+1==1)
                marker_cnt = marker_cnt+1;
            end
            
            if(i>3 && i<8)
                if(isnan(Y(i))==0)
                    line(X(i),Y(i),'LineStyle',LineStyle,'LineWidth',LineWidth_Size,'Marker',marker(2),'MarkerSize',Marker_Size,...
                        'MarkerFaceColor',color(i),'Color',color(i));grid on;
                end
            else
                line(X(i),Y(i),'LineStyle',LineStyle,'LineWidth',LineWidth_Size,'Marker',marker(1),'MarkerSize',Marker_Size,...
                    'MarkerFaceColor',color(i),'Color',color(i));grid on;
            end
        end
    end
    legend(Legend)
    xlabel(x_label,'fontsize',axis_label_Size,'interpreter','LaTex');
    ylabel(y_label,'fontsize',axis_label_Size,'interpreter','LaTex');
    title(Title,'FontSize',title_Size,'interpreter','LaTex');
end
% legend({'Initial','Opt1 @ 0W','Opt2 @ 0W','Opt1 @ 500W','Opt3 @ 0W',...
%     'Opt4* @ 0W No Cauchy','Opt4* @ 0W Cauchy','Opt4* @ 0W Cauchy, Al const'})
