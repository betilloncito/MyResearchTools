function varargout = BiasTriangle_TempAnalysis(varargin)
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
    DataTable{3,1} = 'Bias [V]:';
    DataTable{3,2} = 0.1;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'Vbias';
    %GATE
    name{3} = 'Vg';
    %VOLTAGE PROBE
    name{4} = 'VplgL';
    %MAGNETIC FIELD
    name{5} = 'VplgR';
    %Time (optional)
    name{6} = 'Time';
    
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
                            Vg_index = ii;
                        case 4
                            VplgL_index = ii;
                        case 5
                            VplgR_index = ii;
                        case 6
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
        voltDiv = cell2mat(Variables(2));
        Vbias = cell2mat(Variables(3));
        
        VplgL = MatrixData(:,VplgL_index,1);
        VplgR = reshape(MatrixData(1,VplgR_index,:),size(MatrixData(1,VplgR_index,:),3),1);
        Current = reshape(MatrixData(:,I_index,:),length(VplgL),length(VplgR));
        
        figure(500);
        surf(VplgR,VplgL,Current,'EdgeAlpha',0);
        view(2);
        

%         pause;
        
        %first run
%         pt1.VplgR = 1.6663;%x
%         pt1.VplgL = 1.361;%y        
%         pt2.VplgR = 1.6703;%x
%         pt2.VplgL = 1.36435;%y

        %Second run
        pt1.VplgR = 0.7961;%x
        pt1.VplgL = 0.8218;%y
        pt2.VplgR = 0.7895;%x
        pt2.VplgL = 0.8134;%y

        line([pt1.VplgR,pt2.VplgR],[pt1.VplgL,pt2.VplgL],[max(max(Current)),max(max(Current))],'LineWidth',4);
%         pause;
        
        m = (pt1.VplgL-pt2.VplgL)/(pt1.VplgR-pt2.VplgR);
        b = pt1.VplgL - m*pt1.VplgR;
        lever = 0;
        bb = linspace(b-0.019,b+0.006,50);
        for p=1:length(bb)
            b = bb(p);
            cnt = 1;
            for i=1:length(VplgR)
                
                y = m*VplgR(i) + b;
                
                index_y = 0;
                for ii=1:length(VplgL)-1
                    if(VplgL(ii)<y && VplgL(ii+1)>y)
                        index_y = ii;
                        break;
                    elseif(VplgL(ii)>y && VplgL(ii+1)<y)
                        index_y = ii;
                        break;
                    end
                end
                
                if(index_y ~= 0)
                    Current_val(cnt) = Current(index_y,i);
                    VplgR_val(cnt) = VplgR(i);
                    VplgL_val(cnt) = VplgL(index_y);                   
                    cnt = cnt+1;
                end                 
            end
            Mag_V = sqrt((VplgR_val(1)-VplgR_val(end))^2 + (VplgL_val(1)-VplgL_val(end))^2)
            V = linspace(0,Mag_V,length(Current_val));
            figure(500);
            line(VplgR_val,VplgL_val,Current_val),'r';
%             pause;

            figure(400);
            line(V,Current_val);
%             pause;
        
%         pause;
        
%         figure(501);grid on;
%         for i=1:size(Current_val,2)
%             I = abs(Current_val);
%             for N=1:3
%                 I = smooth(I,3);
%             end
%             V = [1:1:length(I)]';
%             plot(V,I);
%             
%                         der = diff(I)./diff(V);
%                         figure;
%                         plot(der);
%                         hold on;
%                         pause;
%         end
%                 hold off;
%         
        %159
        %113.5
        if(lever==0)
            prompt = {'Vbias:','Delta:'};
            dlg_title = 'Lever';
            num_lines = 1;
            def = {num2str(Vbias),num2str(0.0146)};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            
            lever = (str2double(answer(1))/voltDiv)/str2double(answer(2))
        end
        
        global I_fit
        global I_sim        
        global V_fit
        global edgeConst;
        
        options = optimset('Display','iter','MaxFunEvals',10000,'MaxIter',200,'TolFun',1e-8);
%         for i=1:size(Current_val,2)
            I = abs(Current_val);
%             for N=1:3
%                 I = smooth(I,3);
%             end
            V = lever*V;
            figure(100);
            plot(V,I,'b-');hold on;
            
            END = 30;INIT = 1;
            while(1)
                %                 plot(V,I,'b-');hold on;
                
                prompt = {'Start:','End:','Rise(1) or Fall(0) Edge :'};
                dlg_title = 'Fit Range';
                num_lines = 1;
                def = {num2str(INIT),num2str(END),num2str(1)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);                
                
                if(~isempty(answer))
                    edgeConst =  str2double(answer(3));
                    init = str2double(answer(1));
                    fin = str2double(answer(2));
                    END = fin;
                    INIT = init;
                    
                    I_fit = I(init:fin);
                    V_fit = V(init:fin);
                    figure(100);
                    plot(V_fit,I_fit,'r*');
                    
                    Fitchoice = questdlg('Would you like to change the range?','Fitting Option','Yes','No','Yes');
                    Vo = V_fit(round(length(V_fit)/2));
                    T = 300e-3;
                    Amp = 1;
                    if(strcmp(Fitchoice,'No'))
                        while(1)
                            I_fit = I_fit - min(I_fit);
                            I_fit = I_fit/max(I_fit);
                            
                            par = [T,Vo,Amp];
                            
                            lb = [0.01,Vo*0.75,0.8];
                            ub = [10,Vo*1.25,1];
                            Opt_par = fmincon(@FidCalc,par,[],[],[],[],lb,ub,[],options);
                            
                            Constant_T = Opt_par(1);
                            Constant_Vo = Opt_par(2);
                            Constant_Amp = Opt_par(3);
                            
                            figure(105);
                            plot(V_fit,I_fit,'r*');hold on;
                            plot(V_fit,I_sim,'b--');hold off;
                            title(['Lattice Temp = ',num2str(Constant_T),' and Vo = ',num2str(Constant_Vo)])
                            pause;
                            
                            prompt = {'Temperature:','Vo:','Amplitude: '};
                            dlg_title = 'Fit Range';
                            num_lines = 1;
                            def = {num2str(Constant_T),num2str(Constant_Vo),num2str(Constant_Amp)};
                            answer = inputdlg(prompt,dlg_title,num_lines,def);
                            
                            if(~isempty(answer))
                                T = str2double(answer(1));
                                Vo = str2double(answer(2));
                                Amp = str2double(answer(3));
                            else
                                
                                T = Constant_T;
                                Vo = Constant_Vo;
                                Amp = Constant_Amp;
                                
                                while(1)
                                    par = [T,Vo,Amp];
                                    FunEval(par)
                                    prompt = {'Temperature:','Vo:','Amplitude:'};
                                    dlg_title = 'Fit Range';
                                    num_lines = 1;
                                    def = {num2str(T),num2str(Vo),num2str(Amp)};
                                    answer = inputdlg(prompt,dlg_title,num_lines,def);
                                    
                                    if(isempty(answer))
                                        break;
                                    else
                                        T = str2double(answer(1));
                                        Vo = str2double(answer(2));
                                        Amp = str2double(answer(3));
                                        
                                        figure(105);
                                        plot(V_fit,I_fit,'r*');hold on;
                                        plot(V_fit,I_sim,'b--');hold off;
                                        title(['Lattice Temp = ',num2str(Constant_T),' and Vo = ',num2str(Constant_Vo),...
                                            ' and Amp = ',num2str(Constant_Amp)])
%                                         pause;
                                    end
%                                     if()
                                    
                                end
                                
                                break;
                            
                            end
                        end
                        
                        figure(100);
                        hold off;
                        break;
                    else
                        figure(100);
                        hold off;
                        plot(V,I,'b-');hold on;
                    end
                    
                    %                     pause;
                    %                     hold off;
                else
                    hold off;
                    break;
                end
                    
%                 else
%                     break;
%                 end
                                    
            end
%         end
        end
        
        
        
        %
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
global I_fit;
global I_sim;
global V_fit;
global edgeConst;

e = 1.602e-19;
h = 6.626e-34;
kB = 1.38e-23;

T = par(1);
Vo = par(2);
Amp = par(3);

I_sim = Amp*abs(1*edgeConst - 1./(exp(e*(V_fit-Vo)/(kB*T)) + 1));

size(I_sim)
size(I_fit)

diffSquares = sum((I_sim-I_fit).^2);

fidelity = diffSquares*1e5
pause(0.01);
end

function out = FunEval(par)
global I_fit;
global I_sim;
global V_fit;
global edgeConst;

e = 1.602e-19;
h = 6.626e-34;
kB = 1.38e-23;

T = par(1);
Vo = par(2);
Amp = par(3);

I_sim = Amp*abs(1*edgeConst - 1./(exp(e*(V_fit-Vo)/(kB*T)) + 1));

% diffSquares = sum((I_sim-I_fit).^2);

out = 1;
pause(0.01);
end