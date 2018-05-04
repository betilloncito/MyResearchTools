child = get(gca,'Children');

X = get(child,'XData');
Y = get(child,'YData');
Z = get(child,'ZData');

shiftOPT = 1;
SaveOPT = 0;

if(shiftOPT ==1)
    y_index = 54;
    %Positive shift moves the bottom region to the right
    shift = 18;
    
    if(shift>0)
        Zshift_below = Z(1:y_index,1:end-shift+1);
        Zshift_above = Z(y_index+1:end,shift:end);
        
        Z_new = [Zshift_below;Zshift_above];
        X_new = X(shift:end);
    else
        shift = abs(shift);
        Zshift_below = Z(1:y_index,shift:end);
        Zshift_above = Z(y_index+1:end,1:end-shift+1);
        
        Z_new = [Zshift_below;Zshift_above];
        X_new = X(shift:end);
    end
    
    size(Z_new)
    size(Z)
    size(X_new)
    size(Y)
    
    figure;
    surf(X_new,Y,Z_new,'EdgeAlpha',0);
    colormap('jet')
    view(2);
    
elseif(SaveOPT==1)
    Derivative(X,Y)
end

