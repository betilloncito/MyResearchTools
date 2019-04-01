clear all;
clc;
dataDeleted=1;
a = [4,5,4.5,4.3,7,5,6,5.5,35]
aa = a;
while(dataDeleted == 1)
    dataDeleted = 0;
    AA = abs(a-median(a));
    std(AA);
    cnt = 1;
    for i=1:length(a)
        if(AA(i)<=2*std(AA))
            b(cnt) = a(i)
            cnt = cnt+1;
        else
            dataDeleted = 1;
        end
    end
    a = b
    b = [];
    length(a)
    pause;
end
figure;
line([1:1:length(a)],a,'MarkerSize',15,'Marker','o','MarkerFaceColor','none',...
    'MarkerEdgeColor','b','LineStyle','none');
line([1:1:length(aa)],aa,'Marker','o','MarkerFaceColor','r',...
    'LineStyle','none');
