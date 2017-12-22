clc;clear all;

%alternative way to open file_data

file = 'Sweeper00016.dat';
fid = fopen(file);
data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);

Data = data{1,1};

for i=1:length(Data)
    str = Data{i,1};
    if(strcmp(str,'[DATA]'))
        index = i
        break;    
    end
end

cnt = 1;
for i=index+2:length(Data)
    temp = str2double(strsplit(Data{i,1},'\t'));
    I(cnt,:) = temp(2:end);
    V(cnt,1) = temp(1);

    cnt = cnt+1;
end
% for ii=1:size(data{1,1},1)
%     DATA.coord(ii) = str2double(cell2mat(data{1,1}(ii)));
% end
fclose(fid);
surf(I,'EdgeAlpha',0);
view(2);

