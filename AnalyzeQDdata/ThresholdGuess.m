function varargout = ThresholdGuess(coeff)

%Need to use get file function to make this more user friendly
dir = 'G:\Dropbox RESEARCH Backup\Waterloo - SeaGate\Spintronics Research\Dot Analysis\TestedDevices\SiDD207\SiDD207-1-1-1116\SiDD207b-1-1-1116_bottom\DATA DilFridge\';
fname = '2017-03-12_12-15-02.csv';
DataImport = importdata([dir,fname]);
data = DataImport.data;

%Need to make code to automatically determine this from the file header
Current_index = 4;
VplgR_index = 2;
VplgL_index = 3;

Current = abs(data(:,Current_index));
VplgR = data(:,VplgR_index);
VplgL = data(:,VplgL_index);
thres = max(Current)*coeff

%Row vectors
VplgR_u = sort(unique(VplgR),'ascend');
VplgL_u = sort(unique(VplgL),'ascend');

dim_VplgR = length(VplgR_u);
dim_VplgL = length(VplgL_u);

switch VplgR(1)    
    case VplgR(2)
        Current_matrix = transpose(reshape(Current,dim_VplgL,dim_VplgR));      
        
        VplgR_mat = repmat(VplgR_u,1,dim_VplgL);
        VplgL_mat = repmat(VplgL_u',dim_VplgR,1);
    otherwise
        Current_matrix = transpose(reshape(Current,dim_VplgR,dim_VplgL));
        VplgR_mat = repmat(VplgR_u',dim_VplgL,1);
        VplgL_mat = repmat(VplgL_u,1,dim_VplgR);
end

span = 5;
for i=1:size(Current_matrix,1)    
    Current_matrix(i,:) = smooth(Current_matrix(i,:),span,'moving');
end
% Current_matrix = flipud(fliplr(Current_matrix));

cnt=1;
EdgeVals = [VplgR(1),VplgR(end),VplgL(1),VplgL(end)];
% 1.6640    1.6720    1.3600    1.3670
for index = 1:length(Current)-1
   if(Current(index)<thres && Current(index+1)>thres) 
       if(not(any(VplgR(index)==EdgeVals)) && not(any(VplgL(index)==EdgeVals)))
           save_index(cnt) = index;
           cnt = cnt+1;
       end
   elseif(Current(index)>thres && Current(index+1)<thres) 
       if(not(any(VplgR(index)==EdgeVals)) && not(any(VplgL(index)==EdgeVals)))
           save_index(cnt) = index;
           cnt = cnt+1;
       end
   end       
end

fighandle = figure(203);
surf(VplgL_u,VplgR_u,Current_matrix,'EdgeAlpha',0);
colormap('gray')
view([0 0 90]);
xlabel('VplgL [V]');ylabel('VplgR [V]');

% figure(23);
% surf(VplgL_u,VplgR_u,VplgR_mat,'EdgeAlpha',0);
% colormap('gray')
% view([0 0 90]);
% figure(22);
% surf(VplgL_u,VplgR_u,VplgL_mat,'EdgeAlpha',0);
% colormap('gray')
% view([0 0 90]);

 pause;
set(groot,'CurrentFigure',fighandle);
for i=1:length(save_index)    
    Vx(i) = VplgL(save_index(i));
    Vy(i) = VplgR(save_index(i));
    A(i) = max(Current);
    line(Vx(i),Vy(i),A(i),'Marker','o','MarkerSize',3,'MarkerEdgeColor','r',...
        'MarkerFaceColor','r')
%     pause;
end

Pk_index = find(Vy==min(Vy));
line(Vx(Pk_index),Vy(Pk_index),A(Pk_index),'Marker','o','MarkerSize',3,'MarkerEdgeColor','g',...
        'MarkerFaceColor','g')


end