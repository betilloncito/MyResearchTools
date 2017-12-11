function test
a=[];J=8;
for kkk=1:6
    for kk=1:4
        for k=1:3
            R=[];
            for i=1:J
                R(i,:) = [rand,rand,rand];
            end
            R = [linspace(1,J,J)',R];
            tempa = [ones(J,1)+kkk,ones(J,1)+kk,ones(J,1)+k,R];
            a=[a;tempa];
        end
    end
end

a
% pause;
index_input = [4,3,2,1];
index = index_input;
index_temp = [];
cnt=1;
for i=1:size(a,1)
%     a(i,:);
%     a(i+1,:);
    for p=1:length(index)
        if(a(i,index(p))~=a(i+1,index(p)))
            index_array(cnt) = index(p);
            cnt=cnt+1;            
        else
           index_temp = [index_temp,index(p)];
        end
    end   
    if(isempty(index_temp))
        break;
    end
    index = index_temp;
    index_temp=[];
%     pause;    
end
if(any(index_input~=index_array))
    msgbox(['WARNING: User input for sweep indices was NOT in order of nested loops.',...
        'Correct ordered of nested loops has been detected']);
end

% pause
% index_array = [4,3,2,1];
n = ones(1,4);
for kk=1:length(index_array);
    for i=2:size(a,1)
        i;
        if(i==2)
            startVal = a(i-1,index_array(kk));
        end
        if(a(i-1,index_array(kk)) ~= a(i,index_array(kk)))
            if(startVal == a(i,index_array(kk)))
                break;
            end
            n(kk) = n(kk)+1;        
        end   
%         pause;
    end
end
nn = [n(1),size(a,2),n(2:end)];

% 
% oldVal = zeros(length(index_array),1);
% Store=0;k_val=3;
% oldVal=[];newVal=[];
% pause;

M=ones(nn);
% [row,col] = size(a);
L=nn(1)*nn(2);
count=1;io=1;
for i=2:size(a,1)

    i;
    if(a(i-1,index_array(2)) ~= a(i,index_array(2)) || i==size(a,1))
        if(i==size(a,1))
            i=i+1;
        end

        Store=1;
        M(L*(count-1)+1:L*count) = a(io:i-1,:);
        count=count+1;
        io=i;

    end

end
nn





