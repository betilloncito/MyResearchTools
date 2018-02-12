VoltDiv = -10;
S = 1e-7;

X = [];Y=[];

child = get(gca,'Children')

figure
for i = 1:length(child)
    X(i,:) = get(child(i),'XData')/VoltDiv;
    Y(i,:) = get(child(i),'YData')*S;
   
    if i==1
        disp = 'dd'
       Y(i,:)=ReduceNoise(Y(i,:),3,3,0);
    end
    
    semilogy(X(i,:),abs(Y(i,:)));hold on;
   
end

% YY = Y(1,:) - Y(2,:);
% plot(X(1,:),YY);hold on;
hold off;grid on;


Artislife32

