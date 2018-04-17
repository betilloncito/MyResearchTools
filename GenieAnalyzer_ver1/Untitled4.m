clear all;
child = get(gca,'Children');

X = get(child,'XData');
Y = get(child,'YData');
Z = get(child,'ZData');
Iteration = 2;
mag = 0.5e-3;

for i=1:length(Y)
    
    sig = Z(i,:);
    sig_noiseless = ReduceNoise(sig,3,Iteration,0);
    [peaks,loc] = findpeaks(sig_noiseless);
    cnt=1;pk_x = [];pk_y = [];
    for j=1:length(loc)
        sig_noiseless(loc(j))
        if(sig_noiseless(loc(j)) > mag)
            pk_x(cnt) = X(loc(j));
            pk_y(cnt) = sig_noiseless(loc(j));
            cnt = cnt+1
        end
    end
    figure(100);plot(X,sig_noiseless);hold on;
    plot(X,sig,'r.');
    plot(pk_x,pk_y,'go');hold off;grid on;
    
    [xx,der] = Derivative(X,sig_noiseless);
    
    figure(101);plot(xx,der);
    grid on;
    
    if(length(pk_y)>1)
        pk_yy = sort(pk_y,'descend');
        n1 = find(pk_y==pk_yy(1));
        n2 = find(pk_y==pk_yy(2));
        
        sep(i) = pk_x(n1) - pk_x(n2);
    end
    
    pause;
end

figure(200);plot(Y,sep); grid on;

