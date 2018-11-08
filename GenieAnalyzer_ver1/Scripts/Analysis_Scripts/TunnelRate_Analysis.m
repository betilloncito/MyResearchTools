function varargout = TunnelRate_Analysis(varargin)
%Analyses the transconductance curve for Current vs. Vg.
%Code assumes all files have the same indices labelling (i.e. each
%variables is found under the same column in each file). Also if more than
%one file has been opened for analysis, then the analysis is simply looped
%over each file.

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Preamp Sens [A/V]:';
    DataTable{1,2} = 1e-8;
    DataTable{2,1} = 'Vbias [V]:';
    DataTable{2,2} = -0.1;
    DataTable{3,1} = 'Bias VoltDiv:';
    DataTable{3,2} = 100;
    DataTable{4,1} = 'Zero Current Ref-level:';
    DataTable{4,2} = -7e-5;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %LEFT BARRIER
    name{2} = 'Vacc_TL';
    %RIGHT BARRIER
    name{3} = 'Vacc_TR';
    %GATE
    name{4} = 'Vplg_T_M1';
    %Time (optional)
    name{5} = 'Time';
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};
    %---------------------------------------------------------------------%
    %Loops over each saved data set.
    for INDEX=1:length(MatrixData_All)
        %Figuring out the correct index for each variable
        if(size(MatrixData_All,2)==1)
            Headers = Headers_All{INDEX};
            MatrixData = MatrixData_All{INDEX};
        end
        if(size(Headers_All,2)>1)
            temp = Headers_All{INDEX};
            Headers = temp{1};
            temp = MatrixData_All{INDEX};
            MatrixData = temp{1};
        end
        for x=1:length(name)
            for ii=1:length(Headers)
                Current_Header = cell2mat(Headers(ii));
                n = strfind(Current_Header,' (');
                Headers_corrected = Current_Header(1:n-1);
                if(strcmp(name(x),Headers_corrected))
                    switch x
                        case 1
                            I_index = ii;
                        case 2
                            VdepL_index = ii;
                        case 3
                            VdepR_index = ii;
                        case 4
                            Vtun_index = ii;
                        case 5
                            Time_index = ii;
                    end
                    break;
                end
            end
        end
        
        %-----------------START CODE HERE---------------------------------%
        % MatrixData contains all the data in the file number INDEX. To access
        % the data for a specific file, use number INDEX:
        % i.e. MatrixData(INDEX)
        % MatrixData has n+1 dimensions where n represents the number of
        % sweeps performed when the data was taken. For example, if a
        % three sweeps were done (i.e. bias sweep) then MatrixData would
        % have 4 dimensions:
        % *1st dim: is the number of data points taken during the 1st sweep
        % *2nd dim: is the number of variables stored during each sweep
        % *3rd dim: is the number of data points taken during the 2nd sweep
        % *4th dim: is the number of data points taken during the 3rd sweep
        %  ...
        % *nth dim: is the number of data points taken during the nth sweep
        
        
        %Initializes input parameters: Example
        S = cell2mat(Variables(1));
        Vbias = cell2mat(Variables(2));
        VoltDiv = cell2mat(Variables(3));
        Baseline = cell2mat(Variables(4));
        
        global maxPeak_Current;
        global maxPeak_Current_sim;
        global VdepL;
        global VdepR;
        
        maxPeak_Current = [];
        maxPeak_Current_sim = [];
        
        %This coefficient is based on the fact that a positive bias
        %produces a measurement of negative current from the preamp:
        if(Vbias>0)
           S = -S; 
        end        
        
        %VdepR was stepped last and VdepL was stepped first: Therefore the
        %index y and x correspond to VdepR and VdepL, respectively.
        VdepR = MatrixData(1,VdepR_index,1,:);%y
        VdepL = MatrixData(1,VdepL_index,:,1);%x  
%         VdepR = MatrixData(1,VdepR_index,:,1);%x
%         VdepL = MatrixData(1,VdepL_index,1,:);%y
        
        VdepR = reshape(VdepR,length(VdepR),1,1,1);
        VdepL = reshape(VdepL,length(VdepL),1,1,1);
        
%         VdepL_limit = 0.3;
%         VdepL_limit = 0.4;
%         index_depL_ascend = 0;
        index_depL_descend = 1;
%         for i=1:length(VdepL)-1
%             VdepL(i)
%             if(VdepL(i)<VdepL_limit && VdepL(i+1)>VdepL_limit)
%                 index_depL_ascend = i
%                 break;
%             elseif(VdepL(i)>VdepL_limit && VdepL(i+1)<VdepL_limit)
%                 index_depL_descend = i
%                 VdepL = VdepL(index_depL_descend:end);
%                 break;
%             end                        
%         end        
        
        size(MatrixData,4);
        size(MatrixData,3);
        size(VdepL);
        size(VdepR);
%         pause;
        
%         Baseline = 0*mean(mean(mean(MatrixData(:,I_index,:,:))));

        cnt_x = 1;
        cnt_y = 1;
        maxPeak_Current = [];
        for y=1:size(MatrixData,4)
            for x=index_depL_descend:size(MatrixData,3)
                
                Peaks = abs(MatrixData(:,I_index,x,y) - Baseline);
                Vtun = MatrixData(:,Vtun_index,x,y);
                
                VdepL_temp = MatrixData(1,VdepL_index,x,y);              
                VdepR_temp = MatrixData(1,VdepR_index,x,y);
                
                %Maximum peak only-----------------------------------------
%                 maxPeak_Current(cnt_y,cnt_x) = max(S*Peaks);
                
                pks = findpeaks(Peaks);
                maxPeak_Current(cnt_y,cnt_x) = mean(S*pks(1:4));
%                 maxPeak_Current(cnt_y,cnt_x) = max(S*Peaks);
                %----------------------------------------------------------
                
                %Average of all peaks--------------------------------------
% %                 %Simple peak search
% % %               %  height = abs(max(Y)-min(Y));
% %                 %     sig_noiseless = ReduceNoise(sig,3,Iteration,0);
% %                 % cnt=1;pk_x = [];pk_y = [];
% %                 % for j=1:length(loc)
% %                 %     sig(loc(j))
% %                 %     if(sig(loc(j)) > mag_per*height)
% %                 %         pk_x(cnt) = Xcrop(loc(j));
% %                 %         pk_y(cnt) = sig(loc(j));
% %                 %         cnt = cnt+1
% %                 %     end
% %                 % end
                
%                 [peaks_chosen,loc] = findpeaks(Peaks);
%                 sortedPks = sort(peaks_chosen,'descend');
%                 maxPeak_Current(cnt_y,cnt_x) = mean(sortedPks(1:7));
                %----------------------------------------------------------
                
%                 maxPeak_Current(cnt_y,cnt_x) = mean(S*Peaks);
                %                 VdepL(i,j) = MatrixData(1,VdepL_index,i,j);
                %                 VdepR(i,j) = MatrixData(1,VdepR_index,i,j);
%                 figure(100);plot(Vtun,Peaks);grid on;hold on;
%                 pause;
                cnt_x = cnt_x+1;                
            end
            cnt_x = 1;
            cnt_y = cnt_y+1;
%             hold off;
        end      
%         pause;
        
        XY_plane=[0 90];
        disp('o')
        size(VdepR);
        size(VdepL);
        size(maxPeak_Current);            
        
        for i=1:size(maxPeak_Current,2)
        maxPeak_Current(:,i) = smooth(maxPeak_Current(:,i),3);
        end
        for i=1:size(maxPeak_Current,1)
        maxPeak_Current(i,:) = smooth(maxPeak_Current(i,:),3);
        end
        
        figure(790);
%         surf(VdepL,VdepR,log(abs(maxPeak_Current)),'EdgeAlpha',0)
        surf(VdepL,VdepR,maxPeak_Current,'EdgeAlpha',0)
        %         surf(VdepR,VdepL,maxPeak_Current,'EdgeAlpha',0)
        title('Experimental:');xlabel('VdepL [V]');ylabel('VdepR [V]')
        view(XY_plane);colormap('jet');
        colorbar;
        
        figure(78);
        %         surf(VdepL,VdepR,log(abs(maxPeak_Current)),'EdgeAlpha',0)
        surf(VdepL,VdepR,log10(maxPeak_Current),'EdgeAlpha',0)
        %         surf(VdepR,VdepL,maxPeak_Current,'EdgeAlpha',0)
        title('Experimental:');xlabel('VdepL [V]');ylabel('VdepR [V]')
        view(XY_plane);colormap('jet');
        colorbar;
                               
        %Initial values for fitting
        A1 = 1e-4;        
        A2 = 1e-4;    
        
%         a1 = 1.9;
%         b1 = 5;        
%         a2 = 2.5;
%         b2 = 5;
         
        a1 = 1.6;
        b1 = 10;
        a2 = 5;
        b2 = 1;
        
%       74.7624    0.0470   63.2273    0.4712
%       99.9999   -0.0139   36.9187    0.6806
        
        %Par vector 
        par = [a1,b1,a2,b2];
        
        %lowerbound and upper bound (optional)
        lb = [0.01,-50,0.01,-50];
        ub = [100,50,100,50];
        
        options = optimset('TolFun',1e-10,'TolX',1e-8,'MaxFunEvals',100000,'MaxIter',10000);        
        
%         Opt_par = fminsearch(@FidCalc,par,options)
        Opt_par = fmincon(@FidCalc,par,[],[],[],[],lb,ub,[],options)
        
        figure(69);
        surf(VdepL,VdepR,maxPeak_Current_sim,'EdgeAlpha',0)
        title('Simulation:');xlabel('VdepL [V]');ylabel('VdepR [V]')
        view(XY_plane);colormap('jet');
        colorbar; 
        
        figure(68);
        surf(VdepL,VdepR,log10(maxPeak_Current_sim),'EdgeAlpha',0)
        title('Simulation:');xlabel('VdepL [V]');ylabel('VdepR [V]')
        view(XY_plane);colormap('jet');
        colorbar;
        
        %Fitting resultant values
%         A1 = Opt_par(1)      
%         A2 = Opt_par(2)      
        a1 = Opt_par(1)
        b1 = Opt_par(2)        
        a2 = Opt_par(3)
        b2 = Opt_par(4)
        
        Gamma_R = exp(a1*(VdepR + b1));
        Gamma_L = exp(a2*(VdepL + b2));
        
        figure(200);
        semilogy(VdepR,Gamma_R,'Color','r');grid on;
        xlabel('Vdep_R [V]');ylabel('\Gamma_R [Hz]');
        figure(201);
        semilogy(VdepL,Gamma_L,'Color','k');grid on;
        xlabel('Vdep_L [V]');ylabel('\Gamma_L [Hz]');
%         for j=1:length(VdepR)
%             for i=1:length(VdepL)
%                 Gamma_R = exp(a1*(VdepR(i) + b1));
%                 Gamma_L = exp(a2*(VdepL + b2));
%                 diff_Gamma(i,j) = Gamma_R-Gamma_L
%             end
%         end
        
        figure(59)
        line(VdepR,Gamma_R,'Color','r')
        ax1 = gca; % current axes
        xlabel(ax1,'Vdep_R [V]');
        ylabel(ax1,'\Gamma_R [Hz]');
        ax1.XColor = 'r';
        ax1.YColor = 'r';
        
        ax1_pos = ax1.Position; % position of first axes
        ax2 = axes('Position',ax1_pos,...
            'XAxisLocation','top',...
            'YAxisLocation','right',...
            'Color','none');
        
        line(VdepL,Gamma_L,'Parent',ax2,'Color','k')
        xlabel(ax2,'Vdep_L [V]');
        ylabel(ax2,'\Gamma_L [Hz]');
        grid on;
           
       
        
        
        %------------------STOP CODE HERE---------------------------------%
    end
    
    %     %Plotting Example
    %     HandleFig = figure('WindowStyle','normal','Name','Data Plot');
    %     plot(x,y);grid on;hold on;
    %     xlabel(' ');ylabel(' ');title(' ');
    %     CustomizeFigures(HandleFig);
    %     close(HandleFig);
    %     Legend = {' '};
    %     legend(Legend);
    %     hold off;
    
    %Do not edit this line
    varargout = {1};
end
end


function fidelity = FidCalc(par)
global VdepL;
global VdepR;
global maxPeak_Current;
global maxPeak_Current_sim;

maxPeak_Current_sim = [];
e = 1.602e-19;

par;

a1 = par(1);
b1 = par(2);

a2 = par(3);
b2 = par(4);

Gamma_R = exp(a1*(VdepR + b1));
Gamma_L = exp(a2*(VdepL + b2));

size(Gamma_R);
size(Gamma_L);

for x=1:length(Gamma_L)
    for y=1:length(Gamma_R)
        maxPeak_Current_sim(y,x) = e*Gamma_R(y)*Gamma_L(x)/(Gamma_R(y) + Gamma_L(x));
    end
end    
diffSquares = sum(sum((maxPeak_Current - maxPeak_Current_sim).^2));

fidelity = diffSquares*1e20
% pause(1);
end

