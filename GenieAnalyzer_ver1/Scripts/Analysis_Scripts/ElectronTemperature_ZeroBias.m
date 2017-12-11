function varargout = ElectronTemperature_ZeroBias(varargin)
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
    DataTable{2,2} = 130;
    DataTable{3,1} = 'Bias Index:';
    DataTable{3,2} = 0;
    DataTable{4,1} = 'Gate Index:';
    DataTable{4,2} = 0;
    DataTable{5,1} = 'Current Index:';
    DataTable{5,2} = 0;
    DataTable{6,1} = 'Smooth Window:';
    DataTable{6,2} = 3;
    DataTable{7,1} = 'Smooth Iteration:';
    DataTable{7,2} = 5;
    DataTable{8,1} = 'Lever Arm:';
    DataTable{8,2} = 0.046;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %Bias
    name{1} = 'Vbias';
    %Gate
    name{2} = 'Vplg';
    %Current
    name{3} = 'Current';
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};
    
    if(cell2mat(Variables(3))~=0)
        Vbias_index = cell2mat(Variables(3));
    end
    if(cell2mat(Variables(4))~=0)
        Vg_index = cell2mat(Variables(4));
    end
    if(cell2mat(Variables(5))~=0)
        I_index = cell2mat(Variables(5));
    end
    
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
                            Vbias_index = ii;
                        case 2
                            Vg_index = ii;
                        case 3
                            I_index = ii;
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
        VoltDiv = cell2mat(Variables(2));
        window = cell2mat(Variables(5));
        Iteration = cell2mat(Variables(5));
        leverArm = cell2mat(Variables(8));
        
        %Global:
        global G_zeroPk;
        global Vg_zeroPk;
        global Vbias_zero;
        
        %Constants:
        e = 1.602e-19;
        h = 6.626e-34;        
        
        %Important: the current is inverted because when applying a
        %positive voltage the current is negative
        I_vec = MatrixData(:,I_index,:);
        I_vec = -S*reshape(I_vec,size(I_vec,1),size(I_vec,3));
        for i=1:size(I_vec,1)
            temp(:,i) = I_vec(i,:);
        end
        I_vec = temp;
        
        Vg_vec = MatrixData(1,Vg_index,:);
        Vg_vec = reshape(Vg_vec,size(Vg_vec,3),1);
        Vbias_vec = MatrixData(:,Vbias_index,1);
        Vbias_vec = reshape(Vbias_vec,size(Vbias_vec,1),1)/VoltDiv;
        
        for i=1:length(Vg_vec)
            I_smooth = ReduceNoise(I_vec(i,:),window,Iteration,0);
            %             I_smooth = I_vec(i,:);
            [Vbias_new(:,1),G_vec(i,:)] = Derivative(Vbias_vec,I_smooth,1);
        end
        
%         figure(101);
        for i=1:size(G_vec,2)
            G_smooth(:,i) = ReduceNoise(G_vec(:,i),window,Iteration,0);
            %             G_smooth = G_vec;
            peak(i) = max(G_smooth(:,i));
            
%             h1 = line(Vg_vec,G_vec(:,i)/(e^2/h),'Color','r');
%             h2 = line(Vg_vec,G_smooth(:,i)/(e^2/h),'Color','k');
%             legend([h1 h2],{num2str(Vbias_new(i)),[num2str(Vbias_new(i)),' index:',num2str(i)]})
%             title(['Vbias: ',num2str(Vbias_new(i))])
%             grid on;%pause;
        end
%         pause;
        hold off;
        
        prompt = {'Index'};
        dlg_title = 'Choose index for the zero bias Conductance peak';
        num_lines = 1;
        def = {'1'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        
        nn = find(peak==min(peak))
        nn = str2double(answer{1})
        G_smooth_peak = max(G_smooth(:,nn));
        
        G_zeroPk = G_smooth(:,nn)/(e^2/h);
        Vg_zeroPk = leverArm*(Vg_vec-Vg_vec(G_zeroPk==max(G_zeroPk)));
        Vbias_zero = Vbias_new(nn)

        figure(99);
        semilogy(Vg_zeroPk,G_zeroPk);
        title(['Vbias: ',num2str(Vbias_zero)]);
        Fitchoice = questdlg('Would you like to readjust the data range to fit?','Fitting Option','Yes','No','Yes');
        if(strcmp(Fitchoice,'Yes'))
            INIT = 1;
            END = length(G_zeroPk);
            while(1)
                prompt = {'Start:','End:'};
                dlg_title = 'Readjust Fitting Range';
                num_lines = 1;
                def = {num2str(INIT),num2str(END)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                if(~isempty(answer))
                    INIT = str2double(answer{1})
                    END = str2double(answer{2})
                end
                figure(99);
                semilogy(Vg_zeroPk,G_zeroPk);hold on;
                semilogy(Vg_zeroPk(INIT:END),G_zeroPk(INIT:END),'r*');hold off;
                title(['Vbias: ',num2str(Vbias_zero)]);
                
                Fitchoice = questdlg('Would you like to readjust the data range to fit?','Fitting Option','Yes','No','Yes');
                if(strcmp(Fitchoice,'No'))
                    break;
                end
            end
            G_zeroPk = G_zeroPk(INIT:END);
            Vg_zeroPk = Vg_zeroPk(INIT:END); 
        end
        
        %Initial values:
        T = 0.05;%in units of K
        Gamma = 30;%in units of GHz
        Vg_shift = 10e-6;
        
        %Par vector
%         par = [T,Gamma,Vg_shift]
        par = [T,Vg_shift]

        %         par = [T];
        
        %lowerbound and upper bound (optional)
        lb = [0.01,0.1];
        ub = [0.8,1000];
        
        options = optimset('MaxFunEvals',1000);
        
        Opt_par = fminsearch(@FidCalc,par,options)
%         Opt_par = fmincon(@FidCalc,par,[],[],[],[],lb,ub,[],options)
        T_fit = Opt_par(1)
%         Gamma_fit = Opt_par(2)
%         gamma_fit = Opt_par(3)

        %{
        %}
        
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
global G_zeroPk
global Vg_zeroPk;

e = 1.602e-19;
kB = 1.3806e-23;
h = 6.626e-34;

%in units of K
T = par(1)
%in units of J
% gamma = h*par(2)*1e9;
% gamma_o = par(2)

Vg_shift = par(2)

%The following fits are applied when gamma is smaller than kT
%Regime: kT << Delta_E "Single Level"
% GG_zeroPk = G_zeroPk;Vgg_zeroPk = Vg_zeroPk;
% G_sim = 1/(4*kB*T)*(gamma/2)*sech(e*(Vg_zeroPk + Vg_shift)/(2*kB*T)).^2;
%Regime: kT >> Delta_E "Many level"
GG_zeroPk = G_zeroPk/max(G_zeroPk);Vgg_zeroPk = Vg_zeroPk;
G_sim = sech(e*(Vg_zeroPk + Vg_shift)/(2.5*kB*T)).^2;

%The following fit is used when gamma is larger or comparable to kT
%{
dE = e*(Vg_zeroPk(1)-Vg_zeroPk(2));
ThermBroad = 1/(4*kB*T)*sech(e*Vg_zeroPk/(2*kB*T)).^2;
figure(400);plot(Vg_zeroPk,ThermBroad);grid on;
Lorenz = (gamma)^2./((gamma)^2 + (e*Vg_zeroPk).^2);
figure(401);plot(Vg_zeroPk,Lorenz);grid on;
Convo_fun = conv(Lorenz,ThermBroad,'same')*dE;
figure(402);plot(Vg_zeroPk,Convo_fun);grid on;
Degen = 2;
G_sim = Degen*Convo_fun;

Vtun_o_index = find(G_zeroPk==max(G_zeroPk));
index = round(mean(find(G_sim==max(G_sim))));

size(G_sim);
size(G_zeroPk);

if(index<Vtun_o_index)
    GG_zeroPk = G_zeroPk(abs(Vtun_o_index-index)+1:end);
    G_sim = G_sim(1:end-abs(Vtun_o_index-index));
    Vgg_zeroPk = Vg_zeroPk(1:end-abs(Vtun_o_index-index));
else
    G_sim = G_sim(abs(Vtun_o_index-index)+1:end);
    GG_zeroPk = G_zeroPk(1:end-abs(Vtun_o_index-index));
    Vgg_zeroPk = Vg_zeroPk(1:end-abs(Vtun_o_index-index));
end

size(G_sim);
size(GG_zeroPk);
size(Vgg_zeroPk);

%}

diffSquares = sum((GG_zeroPk - G_sim).^2);

figure(49);
% semilogy(Vg_zeroPk,G_sim,'r');
% plot(Vg_zeroPk,G_sim,'r');
plot(Vgg_zeroPk,G_sim,'r');
hold on;
% figure(38);
% semilogy(Vg_zeroPk,G_zeroPk,'b*');
% plot(Vg_zeroPk,G_zeroPk,'b*');
plot(Vgg_zeroPk,GG_zeroPk,'b');
hold off;

fidelity = diffSquares*1e7;
disp(['Fid: ',num2str(fidelity)]);

pause;
end