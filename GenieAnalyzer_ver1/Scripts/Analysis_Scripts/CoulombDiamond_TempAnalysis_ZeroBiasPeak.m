function varargout = CoulombDiamond_TempAnalysis_ZeroBiasPeak(varargin)
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
    DataTable{1,2} = 1e-9;
    DataTable{2,1} = 'Bias VoltDiv:';
    DataTable{2,2} = 100;
    DataTable{3,1} = 'Number of Bins:';
    DataTable{3,2} = 10000;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'current';    %name{1} = 'Current';
    %BIAS
    name{2} = 'bias';    %name{2} = 'Vbias';
    %GATE
    name{3} = 'g4';   %    name{3} = 'Vtun';
    %TIME
    name{4} = 'Time';
    
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
        for i=1:length(name)
            for ii=1:length(Headers)
                Current_Header = cell2mat(Headers(ii));
                n = strfind(Current_Header,' (');
                Headers_corrected = Current_Header(1:n-1);
                if(strcmp(name(i),Headers_corrected))
                    switch i
                        case 1
                            I_index = ii;
                        case 2
                            Vbias_index = ii;
                        case 3
                            Vtun_index = ii;
                        case 4
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
        
        global II;
        global Vtun;
        global Vbias_val;
        global FUNC;
        global Vbias;
        global ModelFit;
        global Vtun_o;
        global Vtun_o_index;
        global G_sim;
        global G_vec;        
        global GG_sim
        global GG_vec
        global Vtun_oo;
        global A_clamped;
        
%         %Initializes input parameters: Example        
        Sens = cell2mat(Variables(1));
        VoltDiv = cell2mat(Variables(2));
        binNum = cell2mat(Variables(3));

        %It is assumed that the x-axis is alaways the Vbias and the y-axis
        %is the gate
        Vtun_raw = MatrixData(1,Vtun_index,:);%3rd dimension
        Vbias = MatrixData(:,Vbias_index,1);%1st dimension
        
        %The reshape function organizes the current data in such a way that
        %the sweeping of the Vbias is organized in row vectors and the
        %stepping of the gate is organized in column vectors
        Current_raw = Sens*reshape(MatrixData(:,I_index,:),size(MatrixData,1),size(MatrixData,3));
        Vtun_raw = reshape(Vtun_raw,size(MatrixData,3),1);
        Vbias = reshape(Vbias,size(MatrixData,1),1)/VoltDiv;         
        
        %Remove noise from current:
        %Smoothing with respect Vtun
        SmoothNum = 2;
        for ii=1:SmoothNum
            II = [];
            for i = 1:size(Current_raw,1)
                I = smooth(Current_raw(i,:),3);
                II(i,:) = I;
            end
            Current = II;
        end
        %Smoothing with respect Vtun
        for ii=1:SmoothNum
            II = [];
            for i = 1:size(Current,2)
                I = smooth(Current(:,i),3);
                II(:,i) = I;
            end
            Current = II;
        end        

%         figure(109);
%         surf(Vbias,Vtun_raw,Current,'EdgeAlpha',0);
        %Display the reduction of noise on the current plots
%         figure(124)
%         for i=1:length(Vbias)
%             plot(Vtun_raw,Current_raw(i,:));grid on;hold on;
%             plot(Vtun_raw,Current(i,:),'*');            
%             title(['Vbias: ',num2str(Vbias(i)),'V'])
%             pause;
%             hold off;
%         end
%         pause;
        
        [Ncounts,edges] = histcounts(Current,binNum);
%         HandleFig = figure('WindowStyle','normal','Name','Data Plot');       
%         histogram(Current,edges);grid on;
%         xlabel('Current Value [A]');ylabel('Number of Occurrences')
                        
        index = find(Ncounts>max(Ncounts)/2);
        Sigma_CurrentValue1 = mean([edges(index(1)),edges(index(1)+1)]);
        Sigma_CurrentValue2 = mean([edges(index(end)),edges(index(end)+1)]);
        NoiseAmp = abs(Sigma_CurrentValue1-Sigma_CurrentValue2);
        
        Ncounts_sorted = sort(Ncounts,'descend');
        index = find(Ncounts==Ncounts_sorted(1));
        MaxCurrentValue1 = mean([edges(index),edges(index+1)]);
        index = find(Ncounts==Ncounts_sorted(2));
        MaxCurrentValue2 = mean([edges(index),edges(index+1)]);        
        BaseCurrent = mean([MaxCurrentValue1,MaxCurrentValue2]);
               
        %Display the reduction of noise on the current plots
        figure(124)
        for i=1:length(Vbias)
            plot(Vtun_raw,Current(i,:));grid on;hold on;            
            title('Calculated Baseline for the current plots')
        end        
        plot([Vtun_raw(1),Vtun_raw(end)],BaseCurrent*[1,1],'--');
        Current = Current - BaseCurrent;
        hold off;pause;
            
        e = 1.602e-19;
        h = 6.626e-34;
        kB = 1.38e-23;
        
        %Calculate the Conductance
        %Take derivative of the current to calculate conductance and
        %calculate new averaged Vbias vector (size - 1)
        II = [];
        for i = 1:size(Current,2)
            I = Current(:,i);
            II(:,i) = I;
            size(diff(I))
            size(diff(Vbias))
            size(I)
            size(Vbias)
            G(:,i) = diff(I)./diff(Vbias);
        end
        for j=1:length(Vbias)-1
            Vbias_new(j) = mean(Vbias(j:j+1));
        end
        
        
%         figure(109);
%         surf(Vbias_new,Vtun_raw,G,'EdgeAlpha',0);
        
        figure(124)
        legend_str = [];
        for i=1:length(Vbias_new)
            plot(Vtun_raw,G(i,:));grid on;hold on;            
            title('Calculated Baseline for the current plots')
            legend_str = [legend_str,{num2str(Vbias_new(i))}]
            legend(legend_str)
        end  
        hold off;
        pause;
             
        
%         alpha_g = 0.25;
%         alpha_s = 0.5;
%         alpha_d = 0.2;
        
%         Vbias_val = Vbias(round(length(Vbias)/2));
%         C1 = e*((alpha_g)*mean(Vtun)-(alpha_s-1)*Vbias_val);
%         C1_val = C1;
%         C1_low = e*((alpha_g)*mean(Vtun)-(alpha_s-1)*Vbias(1));
%         C1_high = e*((alpha_g)*mean(Vtun)-(alpha_s-1)*Vbias(end));
%         A= 1e8;
%         T = 100e-3;
        
        %Par vector
        %par = [A,T,C1];
%         par = [A,T];
        
%         lb = [1e7,0.001];
%         ub = [1e9,50];
        
        options = optimset('Display','iter','MaxFunEvals',10000,'MaxIter',200,'TolFun',1e-8);
        %Model 1: kT << E_orb (single-level tunneling)
        %Model 1: kT >> E_orb (multi-level tunneling)
        FitRegime = questdlg('Would you like to use Model 1 or Model 2?','Fitting Option','Model 1','Model 2','Model 1');
        if(strcmp(FitRegime,'Model 1'))
            ModelFit = 1;
        elseif(strcmp(FitRegime,'Model 2'))
            ModelFit = 2;
        end

        cnt = 1;counter=1;
        for i=1:size(G,1)
            
            figure(124);            
            plot(Vtun_raw,G(i,:));grid on;
%             plot(Vtun,II(i,:));grid on;
            ylabel('Conductance [e^2/h]');xlabel('Vg [V]')
            title(['Vbias = ',num2str(Vbias_new(i)*1e3),'mV'])
            pause(0.1);
            
%             if(Vbias_new(i)>-0.45e-3 && Vbias_new(i)<0.45e-3)
            if(Vbias_new(i)>-0.35e-3 && Vbias_new(i)<0.35e-3)
           
                Fitchoice = questdlg('Would you like to FIT?','Fitting Option','Yes','No','Yes');
                 
                if(strcmp(Fitchoice,'Yes'))
                    G_vec = [];Vtun = [];
                    Vbias_val = Vbias_new(i) 
                    G_vec(:,1) = abs(G(i,:))/(e^2/h);

%                     if(strcmp(FitRegime,'Model 1'))
%                         G_vec(:,1) = abs(G(i,:))/(e^2/h);
%                     elseif(strcmp(FitRegime,'Model 2'))
%                         G_vec(:,1) = abs(G(i,:))/(e^2/h);
%                     end
                    figure(232)
                    plot(Vtun_raw,G_vec);grid on;
                    ylabel('Conductance [e^2/h]');xlabel('Vg')
                    pause;
                    
                    RangeOtion = questdlg('Would you like to change the range?','Range Option','Yes','No','Yes');
                    if(strcmp(RangeOtion,'No'))
                        quit = 0;
                        Vtun = Vtun_raw;
                    else
                        quit = 1;
                        START_index = 1;
                        END_index = length(G_vec);
                    end
                    
                    while(quit == 1)                        
                        prompt = {'START:','END:'};
                        dlg_title = 'Readjust Start and End points';
                        num_lines = 1;
                        def = {num2str(START_index),num2str(END_index)};
                        answer = inputdlg(prompt,dlg_title,num_lines,def);
                        
                        START_index = str2double(answer(1));
                        END_index = str2double(answer(2));
                        
                        figure(232)
                        plot(Vtun_raw,G_vec);grid on;hold on;
                        plot(Vtun_raw(START_index:END_index),G_vec(START_index:END_index),'*');hold off;
                        ylabel('Conductance [e^2/h]');xlabel('Vg')
%                         pause;
                        
                        RangeOtion = questdlg('Would you like to change the range again?','Range Option','Yes','No','Yes');
                        if(strcmp(RangeOtion,'No'))
                            quit = 0;
                            Vtun = Vtun_raw(START_index:END_index);
                            G_vec = G_vec(START_index:END_index)
                        end
                        
                    end
                    
                    %             plot(Vtun,Current(i,:));grid on;
                    %             ylabel('Current');xlabel('Vg')
                    %             pause;
                    
                    Go = max(G_vec);
                    Vtun_o_index = find(G_vec==Go);
                    Vtun_o = Vtun-Vtun(Vtun_o_index);                                        
                    
                    %             G_vec = G_vec/Go;%only for Classical regime
                    
                    %             G_norm = G_vec/Go;
                    %             myfit = fit(Vtun_o, G_vec, fmodel2, 'StartPoint',[1e-7,100e-3])
                    %             figure(100);
                    %             plot(myfit,Vtun_o,G_vec);
                    %             title(['Vbias = ',num2str(Vbias_new(i)*1e3),'mV ',num2str(counter)])
                    
                    %----------
                    A = 60;%units of 100kHz
                    T = 300e-3;
                    alpha_g = 0.322;
%                     C = 1;
                    while(1)
                        
                        par = [T,alpha_g,A];
                        %                 lb = [0.01,0.07,1e-9];
                        %                 ub = [0.8,0.15,1e-6];
                        
                        lb = [0.01,0.322*0.95,0.1];
                        ub = [0.8,0.322*1.05,500];
                        
                        
                        Opt_par = fmincon(@FidCalc_Conv,par,[],[],[],[],lb,ub,[],options);
                        %             Opt_par = fminsearch(@FidCalc_Conv,par,options);
                        
                        Constant_T = Opt_par(1)
                        Constant_alpha_g = Opt_par(2)
                        A_clamped = Opt_par(3)
%                         Constant_C = par(4)
                        
                        prompt = {'Temperature (K):','Alpha_g:','A constant:'};
                        dlg_title = 'Readjust Starting Guess';
                        num_lines = 1;
                        def = {num2str(Constant_T),num2str(Constant_alpha_g),...
                            num2str(A_clamped)};
                        answer = inputdlg(prompt,dlg_title,num_lines,def)
                        
                        if(isempty(answer))
                            T = Constant_T;
                            alpha_g = Constant_alpha_g;
                            A = A_clamped;
%                             C = Constant_C;
                            break;
                            %                 else
                            %                     if(Constant_T==str2double(answer(1)) && Constant_alpha_g==str2double(answer(2)) && ...
                            %                             A_clamped==str2double(answer(3)))
                            %                         T = str2double(answer(1));
                            %                         alpha_g = str2double(answer(2));
                            %                         A = str2double(answer(3));
                            %                         disp('ddd')
                            %                         break;
                            %                     end
                        end
                        
                        T = str2double(answer(1));
                        alpha_g = str2double(answer(2));
                        A = str2double(answer(3));
%                         C = str2double(answer(4));
                        
                        %             TunnelRate = Constant_A*e/h;
                        %             disp(['Tunnel Rate: ',num2str(round(TunnelRate/1e6)),'MHz'])
                    end
                    
                    Fighandle = figure(339);
                    dont_save = 0;
                    Temp_file = 30;%mK
                    while(1)
                        plot(Vtun_oo,GG_sim,'r');hold on;
                        plot(Vtun_oo,GG_vec,'b--');hold off;grid on;
                        title([{['Model ',num2str(ModelFit),' Fitting : Lattice Temp=',num2str(Temp_file),'mK and Vbias=',...
                            num2str(Vbias_new(i)*1e3),'mV']};{['T=',num2str(T),', alpha_g=',...
                            num2str(alpha_g),', A=',num2str(A),'MHz']}])
                        xlabel('Vplg-Vres [V]');
                        if(ModelFit==1)
                            ylabel('Conductance [e^2/h]');
                        else
                            ylabel('Amplitude [arb.]');
                        end
                        set(gcf,'Color','w');
                        set(gca,'FontSize',15);
                        ax = gca;
                        ax.TitleFontSizeMultiplier = 0.8;
                        
%                         set(gca,'Ylim',[min(GG_vec), max(GG_vec)]);
                        
                        prompt = {'Temperature (K):','Alpha_g:','A constant:'};
                        dlg_title = 'Readjust Starting Guess';
                        num_lines = 1;
                        def = {num2str(T),num2str(alpha_g),...
                            num2str(A)};
                        answer = inputdlg(prompt,dlg_title,num_lines,def);
                        
                        if(isempty(answer))
                            dont_save = 1;
                            break;
                        else
                            if(T==str2double(answer(1)) && alpha_g==str2double(answer(2)) && ...
                                    A==str2double(answer(3)))
                                break;
                            end
                        end
                        
                        T = str2double(answer(1));
                        alpha_g = str2double(answer(2));
                        A = str2double(answer(3));
%                         C = str2double(answer(4));

                        par = [T,alpha_g,A];
                        FunEval(par)
                        
                    end
                                        
                    if(dont_save==0)
%                         Dir = cd;
%                         cd([Dir,'\Figs\fig30mK']);
%                         savefig(['Fit_',num2str(Temp_file),'mK_fig',num2str(cnt)]);
%                         cd(Dir);
%                         close(Fighandle)
                        
                        T_calc(cnt) = T;
                        alpha_g_calc(cnt) = alpha_g;
                        A_calc(cnt) = A;
%                         C_calc(cnt) = C;
                        Vbias_record(cnt) = Vbias_val;
                        cnt = cnt+1;
                    end
                    
                    %             figure(339);
                    %             semilogy(Vtun_oo,GG_sim,'r');hold on;
                    %             semilogy(Vtun_oo,GG_vec,'b--');hold off;
                    %             set(gca,'Ylim',[min(GG_vec), max(GG_vec)]);
                    %             pause;
                    
                    %---------------
                    
                    %             [myfit,gof] = fit(Vtun_o, G_norm, fmodel1, 'StartPoint',[50e-3])
                    %             ci = confint(myfit)
                    
                    %             if(~any(counter==[18,20,21,22,23,24,25,26,27,28,29,30,32]))%30mK
                    %             if(~any(counter==[linspace(20,30,11),32]))%110mK
                    %             if(~any(counter==[16,linspace(18,27,10),30]))%110mK
                    %             if(~any(counter==[14,16,linspace(18,24,7),26,28]))%250mK
                    %             if(~any(counter==[17,19,21,22,23,24,25,26,27,29,31]))%250mK
                    
                    %               if(~any(counter==[linspace(15,33,19),37,50]))%30mK
                    
                    %                 T_calc(cnt) = myfit.T
                    % %                 A_calc(cnt) = myfit.A
                    %                 Vbias_record(cnt) = Vbias_new(i);
                    %                 lower_error(cnt) = ci(1);
                    %                 upper_error(cnt) = ci(2);
                    % %
                    %                 figure(333);
                    %                 plot(myfit,Vtun_o,G_norm);grid on;
                    %                 set(gca,'YScale','log');
                    % %                 semilogy(Vtun,G_vec);grid on;
                    %                 ylabel('Conductance [e^2/h]');xlabel('Vg [V]')
                    %                 title(['Vbias = ',num2str(Vbias_new(i)*1e3),'mV'])
                    %                 pause;
                    %                 cnt = cnt+1;
                    %             end
                    
                    %             figure(333);
                    %             plot(Vtun,G_vec);grid on;
                    %             ylabel('Conductance [e^2/h]');xlabel('Vg [V]')
                    %             title(['Vbias = ',num2str(Vbias_new(i)*1e3),'mV'])
                    %             pause;
                    
                    %             counter=counter+1;
                    
                    %             T = 100e-3;
                    %             FUN = 1./cosh(0.25*1.602e-19*(Vtun_o)/(2*1.38e-23*T)).^2;
                    %             plot(Vtun_o,G_norm);grid on;hold on;
                    %             plot(Vtun_o,FUN);grid on;hold off;
                    %             ylabel('Fit Fun');xlabel('Vg')
                    
                    
                end
            end
        end
        
        figure(221);
        plot(Vbias_record,T_calc,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);grid on;
        ylabel('Temperature [K]');xlabel('Vbias [V]')        
%         pause;
        
        figure(223);
        plot(Vbias_record,alpha_g_calc,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);grid on;
        ylabel('Alpha');xlabel('Vbias [V]')        
%         pause;
        
        figure(224);
        plot(Vbias_record,A_calc,'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);grid on;
        ylabel('A');xlabel('Vbias [V]')        
        pause;
        
        HandleFig = figure('WindowStyle','normal','Name','Data Plot');
        cnt=1;
        for i=1:size(Current,1)
            
            peakCurve = abs(Current(i,:)-BaseCurrent);
            
            if(max(peakCurve)>NoiseAmp)
                MaxPeak(cnt,INDEX) = max(peakCurve)
                max(peakCurve)
                middle = max(peakCurve)/2
                
                n = find(peakCurve==max(peakCurve));
                nn=1;
                while(n-nn>0)
                    if(peakCurve(n-nn)<middle)
                        index1 = n-nn;
                        break;
                    end
                    nn = nn+1;
                end
                nn=1;
                while(n+nn<length(peakCurve))
                    if(peakCurve(n+nn)<middle)
                        index2 = n+nn;
                        break;  
                    end
                    nn = nn+1;
                end
                
                plot(Vtun(n),peakCurve(n),'o');hold on;
                plot(Vtun(index1),peakCurve(index1),'*');
                plot(Vtun(index2),peakCurve(index2),'*');
                plot(Vtun,peakCurve);hold off;
                FHWM(cnt,INDEX) = abs(Vtun(index1)-Vtun(index2));
                Vbias_saved(cnt,INDEX) = Vbias(i);
                pause;
                cnt=cnt+1;
            end
        end
        
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
    
    HandleFig1 = figure('WindowStyle','normal','Name','Data Plot');
    ax1 = axes;grid on;
    xlabel('Vbias [V]');ylabel('Full Half Width Maximum [V]')
    HandleFig2 = figure('WindowStyle','normal','Name','Data Plot');
    ax2 = axes;grid on;
    xlabel('Vbias [V]');ylabel('Max Peak [A]')
    
    for q=1:size(Vbias_saved,2)
        set(HandleFig1,'CurrentAxes',ax1)
        line(Vbias_saved(:,q),FHWM(:,q),'Marker','*','Parent',ax1);
        set(HandleFig2,'CurrentAxes',ax2)
        line(Vbias_saved(:,q),MaxPeak(:,q),'Marker','*','Parent',ax2);
        pause;
    end
    
    %Do not edit this line
    varargout = {1};
end
end


function fidelity = FidCalc_Conv(par)
global II;
global Vtun;
global Vbias_val;
global FUNC;
global Vbias;
global ModelFit;
global Vtun_o
global G_sim
global G_vec
global GG_sim
global GG_vec
global Vtun_o_index;
global Vtun_oo;

e = 1.602e-19;
h = 6.626e-34;
kB = 1.38e-23;

E_orb = 1e-3;
% alpha_s = 0.001;
% alpha_d = 0.7;

T = par(1);
alpha_g = par(2);
A = par(3)*1e6;
% C = par(4)*1e-3;

% Gamma = par(3);

%all units in eV
width = 3.5*kB*T/e;
% Elim = 2*Vbias_val;
% Enum = abs(round(4*Vbias_val/(0.05*width)));
% Enum = length(Vtun);

E = alpha_g*Vtun_o;
dE = e*abs(E(2)-E(1));
size(E);
% delta_E = abs(E(1)-E(2));

% for i=1:length(Vtun)
%     fun1 = 1./(cosh(E/(2*kB*T))).^2;
%     fun2 = (pi*Gamma*e/2)./((Gamma*e/2)^2 + (e*alpha_g*Vtun_o(i)-E).^2);
% %     figure(22);
% %     plot(E,fun1,'r');hold on;
% %     figure(23);
% %     plot(E,fun2,'b');hold off;
% %     pause(0.1);
%     convo(i) = sum(fun1.*fun2)*delta_E;
% end
% figure(66);

% Theta = @(X) heaviside(e*(E+abs(X)/2))-heaviside(e*(E-abs(X)/2));
% X = Vbias_val;
Theta = heaviside(e*(E+abs(Vbias_val)/2))-heaviside(e*(E-abs(Vbias_val)/2));
% figure(66);
% plot(E,Theta);grid on;
% pause;

Der_Fermi = 1/(4*kB*T)*sech(e*E/(2*kB*T)).^(2);
% Der_Fermi = @(XX) 1/(4*kB*T)*sech(e*XX/(2*kB*T)).^(2);
% XX = E;
% Der_Fermi = sech(e*E/(2*kB*T)).^(2);
% figure(67);
% plot(E,Der_Fermi);grid on;
% pause;

% T_coeff = (h*A)^2./((e*E).^2 + (h*A)^2);
T_coeff = A;
% T_coeff = @(XXX) (h*A)^2./((e*XXX).^2 + (h*A)^2);
% XXX = E;
% figure(686);
% plot(E,T_coeff);grid on;
% pause;

Convo_fun1 = conv(Der_Fermi,Theta,'same')*dE;
% Convo_fun1 = conv(Der_Fermi(XX),Theta(X),'same')*dE;
% figure(900);
% plot(Convo_fun1);grid on;
% pause;

% Convo_total = C*conv(T_coeff,Convo_fun1,'same')*dE;
Convo_total = e*Convo_fun1*T_coeff;
% figure(901);
% plot(Convo_total);grid on;
% pause;
size(Convo_fun1);
% G_sim = Convo_total;

ModelFit;

%Model 1
if(ModelFit == 2)
    G_sim = sech(e*E/(2.5*kB*T)).^(2);
%Model 2
elseif(ModelFit == 1)
    G_sim = (e^2/(4*kB*T))*(A/2)*sech(e*E/(2*kB*T)).^(2)/(e^2/h);
end

Go = max(G_sim);
index = round(mean(find(G_sim==Go)));
Vtun_o_index;

size(G_sim);
size(G_vec);

if(index<Vtun_o_index)
    GG_sim = G_sim(1:end-abs(Vtun_o_index-index));
    if(ModelFit == 1)
        GG_vec = G_vec(abs(Vtun_o_index-index)+1:end); 
    elseif(ModelFit == 2)
        GG_vec = G_vec(abs(Vtun_o_index-index)+1:end)/max(G_vec);
    end
    Vtun_oo = Vtun_o(1:end-abs(Vtun_o_index-index));
else
    GG_sim = G_sim(abs(Vtun_o_index-index)+1:end);
    if(ModelFit == 1)
        GG_vec = G_vec(1:end-abs(Vtun_o_index-index));
    elseif(ModelFit == 2)
        GG_vec = G_vec(1:end-abs(Vtun_o_index-index))/max(G_vec);
    end
    
    Vtun_oo = Vtun_o(1:end-abs(Vtun_o_index-index));
end

size(GG_sim);
size(GG_vec);
size(Vtun_oo);

figure(39);
plot(Vtun_oo,GG_sim,'r');hold on;
plot(Vtun_oo,GG_vec,'b*');hold off;

% figure(39);
% plot(Vtun_oo,GG_sim,'r');
% figure(40)
% plot(Vtun_oo,GG_vec,'b*');

diffSquares = sum((GG_sim-GG_vec).^2);

fidelity = diffSquares*1e21
pause(0.01);
% pause(1);
% pause
end

function out = Fermi(E,Ef,T)

kB = 1.38e-23;

out = 1./(1+exp((E-Ef)/(kB*T)));
% size(out)

end

function out = FunEval(par)
global II;
global Vtun;
global Vbias_val;
global FUNC;
global Vbias;
global ModelFit;
global Vtun_o
global G_sim
global G_vec
global GG_sim
global GG_vec
global Vtun_o_index;
global Vtun_oo;

e = 1.602e-19;
h = 6.626e-34;
kB = 1.38e-23;

E_orb = 1e-3;
% alpha_s = 0.001;
% alpha_d = 0.7;

T = par(1);
alpha_g = par(2);
A = par(3)*1e6;
% C = par(4)*1e-3;

% Gamma = par(3);

%all units in eV
width = 3.5*kB*T/e;
% Elim = 2*Vbias_val;
% Enum = abs(round(4*Vbias_val/(0.05*width)));
% Enum = length(Vtun);

E = alpha_g*Vtun_o;
dE = e*abs(E(2)-E(1));

size(E);
% delta_E = abs(E(1)-E(2));

% for i=1:length(Vtun)
%     fun1 = 1./(cosh(E/(2*kB*T))).^2;
%     fun2 = (pi*Gamma*e/2)./((Gamma*e/2)^2 + (e*alpha_g*Vtun_o(i)-E).^2);
% %     figure(22);
% %     plot(E,fun1,'r');hold on;
% %     figure(23);
% %     plot(E,fun2,'b');hold off;
% %     pause(0.1);
%     convo(i) = sum(fun1.*fun2)*delta_E;
% end
% figure(66);

Theta = heaviside(e*(E+abs(Vbias_val)/2))-heaviside(e*(E-abs(Vbias_val)/2));
% figure(66);
% plot(E,Theta);grid on;
% pause;

Der_Fermi = 1/(4*kB*T)*sech(e*E/(2*kB*T)).^(2);
% Der_Fermi = sech(e*E/(2*kB*T)).^(2);
% figure(67);
% plot(E,Der_Fermi);grid on;
% pause;

% T_coeff = (h*A)^2./((e*E).^2 + (h*A)^2);
T_coeff = A;

Convo_fun1 = conv(Der_Fermi,Theta,'same')*dE;

% Convo_total = C*conv(T_coeff,Convo_fun1,'same')*dE;
Convo_total = e*Convo_fun1*T_coeff;

% figure(68);
% plot(Convo_fun);grid on;

size(Convo_total);

% G_sim = Convo_total;
% G_sim = sech(e*E/(2*kB*T)).^(2);

ModelFit;

%Model 2
if(ModelFit == 2)
    G_sim = sech(e*E/(2.5*kB*T)).^(2);
%Model 1
elseif(ModelFit == 1)
    G_sim = e^2/(4*kB*T)*(A/2)*sech(e*E/(2*kB*T)).^(2)/(e^2/h);
end

Go = max(G_sim);
index = round(mean(find(G_sim==Go)));

if(index<Vtun_o_index)
    if(ModelFit == 1)
        GG_vec = G_vec(abs(Vtun_o_index-index)+1:end);
    elseif(ModelFit == 2)
        GG_vec = G_vec(abs(Vtun_o_index-index)+1:end)/max(G_vec);
    end
    GG_sim = G_sim(1:end-abs(Vtun_o_index-index));
    Vtun_oo = Vtun_o(1:end-abs(Vtun_o_index-index));
else
    if(ModelFit == 1)
        GG_vec = G_vec(1:end-abs(Vtun_o_index-index));
    elseif(ModelFit == 2)
        GG_vec = G_vec(1:end-abs(Vtun_o_index-index))/max(G_vec);
    end
    GG_sim = G_sim(abs(Vtun_o_index-index)+1:end);
%     GG_vec = G_vec(1:end-abs(Vtun_o_index-index))/max(G_vec);
    Vtun_oo = Vtun_o(1:end-abs(Vtun_o_index-index));
end

diffSquares = sum((GG_sim-GG_vec).^2);

out = diffSquares*1e5;
end