clear ;
child = get(gca,'Children');
hh = figure;
S = [1e-8,1e-7,1e-7,1e-7,1e-8];
cnt = 1; I = 1;
X = [];Y = [];
for i=1:length(child)
    if(isempty(X))
        XX = fliplr(get(child(i),'XData'));
        YY = fliplr(get(child(i),'YData'));
    else
        XX = get(child(i),'XData');
        YY = get(child(i),'YData');
    end
    
    X = [X, XX];
    Y = [Y, YY];
    i
    plot_color = get(child(i),'Color');
    linestyle = get(child(i),'LineStyle');
    if(mod(i,2)==0)
        x = X;
        y = Y*S(cnt);
        plot(x,y,'Color',plot_color,'LineStyle',linestyle);hold on;
        cnt = cnt+1;
%         I = 0;
        X = [];Y = [];
    end
    x = [];y =[];
%     I = I+1
    size(X)
    size(Y)
%     pause
end
% CustomizeFigures(hh);
hold off;


