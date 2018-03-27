Child = get(gca,'Children');

Power = [0,0.014,0.5,1.8,4,16,40];

Vbias = -0.8;
size(Child)
for I=1:length(Child)
    
    X = get(Child(I),'XData');
    Y = get(Child(I),'YData');
    
    for i=1:length(X);
%         X(i)
        if(i<length(X))
            if(X(i)<Vbias && X(i+1)>Vbias)
                index_x = i
                break;
            end
            if(X(i)>Vbias && X(i+1)<Vbias)
                index_x = i
                break;
            end
        end
        if(X(i)==Vbias)
            index_x = i
        end
    end
    Current(I) = Y(index_x);
end

figure;
plot(Power,fliplr(Current),'o--');grid on;
xlabel('Power Light [mW]'); ylabel('Current [A]')