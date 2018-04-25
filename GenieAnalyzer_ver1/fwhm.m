child = get(gca,'Children');

figure;
for I=1:length(child)
    
    X = get(child(I),'XData');
    Y = get(child(I),'YData');      
    
    HM = max(Y)/2;
    
    for i=1:length(Y)
        if(Y(i) > HM)
            coeff = polyfit(X(i-1:i),Y(i-1:i),1);
            x1 = (HM-coeff(2))/coeff(1);
            
            for ii=i:length(Y)
                if(Y(ii) < HM)
                    coeff = polyfit(X(ii-1:ii),Y(ii-1:ii),1);
                    x2 = (HM-coeff(2))/coeff(1);
                    
                    break;
                end
            end
            break;
        end        
    end
    FWHM(I) = x1-x2;
    
    line(X,Y/max(Y));
end
    
AC = [0.15,0.1,0.076,0.05]/1e4;
figure;
plot(AC/1e-6,FWHM/1e-3,'o');
xlabel('V_{ac} [\muV]');xlabel('FWHM [mV]');
grid on;
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','left',...
    'Color','none');
e = 1.60217662e-19;h = 6.626e-34;
kB = 1.380648e-23/e;
line(AC/kB,FWHM/1e-3,'Parent',ax2);


