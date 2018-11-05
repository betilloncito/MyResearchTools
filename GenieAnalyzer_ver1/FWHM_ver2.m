child = get(gca, 'Children');

for i=1:length(child)
    
    x = get(child(i),'XData');
    y = get(child(i),'YData');
    
    pk = max(y);
    y = y - pk/2;
%     figure;plot(y);
%     hold on;
    
    for ii=1:length(y)-1
        
        if(y(ii)<0 && y(ii+1)>0)
            x1 = mean(x(ii:ii+1));
            break;
        elseif(y(ii)>0 && y(ii+1)<0)
            x1 = mean(x(ii:ii+1));
            break;
        elseif(y(ii)==0)
            x1 = x(ii);
            break;
        end
    end
    for jj=ii+1:length(y)-1
        
        if(y(jj)<0 && y(jj+1)>0)
            x2 = mean(x(jj:jj+1));
            break;
        elseif(y(jj)>0 && y(jj+1)<0)
            x2 = mean(x(jj:jj+1));
            break;
        elseif(y(jj)==0)
            x2 = x(jj);
            break;
        end
    end
    fhwm(i) = abs(x1-x2);
    
end