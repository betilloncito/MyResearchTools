function varargout = BarrierAnalysis(varargin)
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
    DataTable{1,2} = 1e-6;
    DataTable{2,1} = 'Bias VoltDiv:';
    DataTable{2,2} = 100;
    DataTable{3,1} = 'Gate Label';
    DataTable{3,2} = 'Vdep';
    DataTable{4,1} = 'Vgate HIGH';
    DataTable{4,2} = 0;
    DataTable{5,1} = 'Vgate LOW';
    DataTable{5,2} = 2;
    DataTable{6,1} = 'Num. Pts. X';
    DataTable{6,2} = 20;
    DataTable{7,1} = 'Num. Pts. Y';
    DataTable{7,2} = 20;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'Vbias';
    %TEMPERATURE
    name{3} = 'Temperature';
    %Time (optional)
    name{4} = 'Time';
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};
    %GATE: Label defined by user
    name{5} = cell2mat(Variables(3));
    %---------------------------------------------------------------------%
    %Loops over each saved data set.
    length(MatrixData_All)
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
                            Temp_index = ii;
                        case 4
                            Time_index = ii;
                        case 5
                            Vg_index = ii;
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
        
        %Constants
        global delta_s;
        global delta_phi;
        global delta_Ro;
        
        global Vbias;
        global Current;
        global Vgate;
        global Temperature;
        global Current_Sim;
        
        Vbias = [];
        Current = [];
        Vgate = [];
        Temperature = [];
        Current_Sim = [];
        
        kB = 1.38064e-23;
        T = 20;
        e = 1.60217e-19;
        h = 6.62607e-34;
        m = 0.191*9.10938e-31;
        tol = 0.1;
        N = 20;
        M = 20;
        
        %Initializes input parameters:
        S = cell2mat(Variables(1));
        VoltDiv = cell2mat(Variables(2));
        Vgate_high = cell2mat(Variables(4));
        Vgate_low = cell2mat(Variables(5));
        Nx = cell2mat(Variables(6));
        Ny = cell2mat(Variables(7));
        
        %Extract Experimental Data     
        Vgate = MatrixData(1,Vg_index,:);      
        Vgate = reshape(Vgate,1,[]);
  
        cnt = 1;
        %Vgate is increasing
        if(Vgate(2)-Vgate(1)>0)
            disp('increase')           
            for i=1:length(Vgate)
                if(Vgate(i) > Vgate_low)
                    index_Vg(cnt) = i;
                    cnt = cnt+1;
                    for ii=i:length(Vgate)
                        if(Vgate(ii) >= Vgate_high)
                            index_Vg(cnt) = ii;
                            break;
                        end
                    end
                    break;
                end           
            end
                        
        %Vgate is decreasing
        elseif(Vgate(2)-Vgate(1)<0)
             disp('decrease')           
            for i=1:length(Vgate)
                if(Vgate(i) < Vgate_high)
                    index_Vg(cnt) = i;
                    cnt = cnt+1;
                    for ii=i:length(Vgate)
                        if(Vgate(ii) <= Vgate_low)
                            index_Vg(cnt) = ii;
                            break;
                        end
                    end
                    break;
                end           
            end
            
        end                          
        Vgate = [];
        
        NN = round((index_Vg(2)-index_Vg(1)+1)/Ny);
        cnt = 1;
%         I_index
%         index_Vg(1)
%         index_Vg(2)
%         NN
        size(Current)
        for i=index_Vg(1):NN:index_Vg(2)
            Vbias(1,:) = MatrixData(:,Vbias_index,i)/VoltDiv;
            Current(cnt,:) = MatrixData(:,I_index,i)*S;
            Temperature(cnt) = mean(MatrixData(:,Temp_index,i));
            Vgate(cnt) = MatrixData(1,Vg_index,i);
            cnt = cnt+1;
%             pause;
        end

        MM = round((length(Vbias)+1)/Nx);
        cnt = 1;
        for i=1:MM:length(Vbias)
            Vbias_temp(1,cnt) = Vbias(1,i);
            Current_temp(:,cnt) = Current(:,i);
            cnt = cnt+1;
        end
        Current = Current_temp;
        Vbias = Vbias_temp;
%         surf(Vbias,Vgate,Current)
%         pause;
                
                
        %Initial guess for parameters:
        par = [20,0,5,4.5,1];
        lb = [10,0,0,4,1];
        ub = [60,1,20,7,5];
        tic
        options = optimset('MaxFunEvals',1000);
%         Opt_par = fminsearch(@FidCalc,par,options)
        Opt_par = fmincon(@FidCalc,par,[],[],[],[],lb,ub,[],options)
        timer = toc
%         N = length(Vgate);
%         s = Opt_par(1)*1e-9;
%         phi = 10.^(linspace(Opt_par(2),Opt_par(3),N));
%         Ro = 10^Opt_par(4);
        
%         for i=1:length(phi)
%             phi_i = phi(i);
%             CalcCurrent(s,phi_i,V_bar(j),T)
%         end
        XY_plane=[0 90];
        figure(79);
        surf(Vbias,Vgate,Current,'EdgeColor','none');
        title('Experimental:');xlabel('Vbias [V]');ylabel('Vdep-Right [V]')
        view(XY_plane);colormap('jet');
        figure(69);        
        surf(Vbias,Vgate,Current_Sim,'EdgeColor','none');
        view(XY_plane);colormap('jet');
        title('Simulation')
        
%         size(Vbias)
%         size(Vgate)
%         size(Current)
%         figure(44);
%         surf(Vbias,Vgate,Current);
        
        
  

%         plot(Vbias,Vbias./I_sim,'b');grid on;
%         plot(Vbias,Vbias./Current,'r');grid on;
%         pause;
        
        
        %         end
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
global Vbias;
global Current;
global Vgate;
global Temperature;
global Current_Sim;

par

diffSquares = 0;
e = 1.602e-19;
N = length(Vgate);
s = par(1)*1e-9;
% phi = e*10.^(linspace(par(2),par(3),N));
AA = par(5);
phi = e*AA.^(linspace(par(2),par(3),N))*1e-3;
Ro = 10^par(4);
% size(Vbias)
for i=1:length(phi)
    phi_i = phi(i);
    V_bar(1,:) = Vbias/2;
    V_res = Vbias/2;
    T = Temperature(i);
    for ww=1:20
    %while(1)
        for ii=1:length(Vbias)
            I_sim = CalcCurrent(s,phi_i,V_bar(ii),T);
            if(I_sim==0)
                R_bar(1,ii) = Ro;
            else
                R_bar(1,ii) = abs(V_bar(ii)/I_sim);
            end            
        end
%         size(Vbias)
%         size(R_bar)
        It(1,:) = -Vbias./(R_bar+Ro);
%         size(It)
%         figure(11);plot(Vbias,V_bar);grid on;
%         pause;
        V_bar = V_bar*0.7 + It.*R_bar*0.3;
                
%         

        
        %if(diff<tol)
            %break;
        %end
    %end    
    end
    Current_Sim(i,:) = It;
%     figure(12);
%     plot(Vbias,Current(i,:),'b');hold on;
%     plot(Vbias,It,'r');    
%     size(It)
%     size(Current(i,:))
    
    diffSquares = sum((Current(i,:) - It).^2) + diffSquares;
    
%     pause;
    
%     for j=1:length(Vbias)
%         I_sim(i,j) = -CalcCurrent(s,phi_i,V_bar(j),T);
%     end      
%     figure(11);
%     plot(Vbias,Current(i,:),'b');hold on;
%     plot(Vbias,I_sim(i,:),'g');
%     pause;
end

% diffSquares = (Current - I_sim).^2;
% figure(22);
% surf(Vbias,Vgate,Current);
% figure(33);
% surf(Vbias,Vgate,I_sim);
% pause;
fidelity = diffSquares*1e13

end

% function varargout = D(E,phi,s)
% h = 6.62607e-34;
% 
% if(E>phi)
%     varargout = 1;
% else
%     varargout = exp(-4*pi*s/h*sqrt(2*m*(phi-E)));
% end
% % .*heaviside(phi-E)+heaviside(E-phi);
% 
% end

function varargout = CalcCurrent(s,phi,V,T)
%Constants
kB = 1.38064e-23;
e = 1.60217e-19;
h = 6.62607e-34;
m = 0.191*9.10938e-31;

% s = 17e-9;
% phi = 2.5e-3*e;
% V = Vo - I*Ro

E = linspace(-V,V,100)*e/2;
mu = 0*e;

%Functions
% FD_1 = @(E) 1./(exp(((E-e*V/2) - mu)/(kB*T)) + 1);
% FD_2 = @(E) 1./(exp(((E+e*V/2) - mu)/(kB*T)) + 1);
% FD_fun = @(E) FD_1(E)-FD_2(E);
% D = @(E) exp(-4*pi*s/h*sqrt(2*m*(phi-E))).*heaviside(phi-E)+heaviside(E-phi);

FD_1 = 1./(exp(((E-e*V/2) - mu)/(kB*T)) + 1);
FD_2 = 1./(exp(((E+e*V/2) - mu)/(kB*T)) + 1);
D = exp(-4*pi*s/h*sqrt(2*m*(phi-E))).*heaviside(phi-E)+heaviside(E-phi);

I_sim = -e/h*sum(D.*(FD_1-FD_2))*abs(E(1)-E(2));
% alpha = V/s;
% W = @(E) 2*((alpha*s + phi) - E).^(3/2)/(3*alpha) - 2*(phi-E).^(3/2)/(3*alpha);
% D = @(E) exp(-4*pi*sqrt(2*m)*W(E)/h).*heaviside(phi-E)+heaviside(E-phi);

% G = @(E) D(E).*FD_fun(E);
% I_sim = -e/h*integral(G,min(E),max(E));

varargout = {I_sim};

end


function varargout = OptimizeOper(s,grad_s,phi,grad_phi,Ro,grad_Ro,Vo,I,T,INDEX,fidelity)
global delta_s;
global delta_phi;
global delta_Ro;
        
I

switch INDEX
    case 1
        if(grad_s==0)
            I_sim = CalcCurrent(s,phi,Ro,Vo,I,T)
            fidelity(1) = abs((I-I_sim)/I);
            I_sim = CalcCurrent(s+delta_s,phi,Ro,Vo,I,T)
            fidelity(2) = abs((I-I_sim)/I)
            
            grad_s = (fidelity(2)-fidelity(1))/(delta_s)
%             if(fidelity(2)<fidelity(1))
%                 s_new = s+delta_s
%             else
%                 s_new = s
%             end
        else
            if(grad_s>0)
                disp('pos')
                s_new = s-delta_s
                I_sim = CalcCurrent(s_new,phi,Ro,Vo,I,T)
                fidelity(2) = abs((I-I_sim)/I)
            elseif(grad_s<0)
                disp('neg')
                s_new = s+delta_s
                I_sim = CalcCurrent(s_new,phi,Ro,Vo,I,T)
                fidelity(2) = abs((I-I_sim)/I)
            else
                fidelity(2) = fidelity(1);
            end
            
            grad_s = (fidelity(2)-fidelity(1))/(s_new-s)            
        end
        if(fidelity(2)<fidelity(1))
            s_new = s+delta_s
            fid = fidelity(2);
        else
            s_new = s
            fid = fidelity(1);
        end
        phi_new = phi;
        Ro_new = Ro;
        
    case 2
        if(grad_phi==0)
            I_sim = CalcCurrent(s,phi,Ro,Vo,I,T)
            fidelity(1) = abs((I-I_sim)/I);
            I_sim = CalcCurrent(s,phi+delta_phi,Ro,Vo,I,T)
            fidelity(2) = abs((I-I_sim)/I)
            
            grad_phi = (fidelity(2)-fidelity(1))/(delta_phi)
        else
            if(grad_phi>0)
                disp('pos')
                phi_new = phi-delta_phi
                I_sim = CalcCurrent(s,phi_new,Ro,Vo,I,T)
                fidelity(2) = abs((I-I_sim)/I)
            elseif(grad_phi<0)
                disp('neg')
                phi_new = phi+delta_phi
                I_sim = CalcCurrent(s,phi_new,Ro,Vo,I,T)
                fidelity(2) = abs((I-I_sim)/I)
            else
                fidelity(2) = fidelity(1);
            end
            
            grad_phi = (fidelity(2)-fidelity(1))/(phi_new-phi)
        end
        if(fidelity(2)<fidelity(1))
            phi_new = phi+delta_phi
            fid = fidelity(2);
        else
            phi_new = phi            
            fid = fidelity(1);
        end
        s_new = s;
        Ro_new = Ro;
        
    case 3
        if(grad_Ro==0)
            I_sim = CalcCurrent(s,phi,Ro,Vo,I,T)
            fidelity(1) = abs((I-I_sim)/I);
            I_sim = CalcCurrent(s,phi,Ro+delta_Ro,Vo,I,T)
            fidelity(2) = abs((I-I_sim)/I)
            
            grad_Ro = (fidelity(2)-fidelity(1))/(delta_Ro)
            
        else
            if(grad_Ro>0)
                disp('pos')
                Ro_new = Ro-delta_Ro
                I_sim = CalcCurrent(s,phi,Ro_new,Vo,I,T)
                fidelity(2) = abs((I-I_sim)/I)
            elseif(grad_Ro<0)
                disp('neg')
                Ro_new = Ro+delta_Ro
                I_sim = CalcCurrent(s,phi,Ro_new,Vo,I,T)
                fidelity(2) = abs((I-I_sim)/I)
            else
                fidelity(2) = fidelity(1);
            end
            
            grad_Ro = (fidelity(2)-fidelity(1))/(Ro_new - Ro)
        end        
        if(fidelity(2)<fidelity(1))
            Ro_new = Ro+delta_Ro
            fid = fidelity(2);
        else
            Ro_new = Ro
            fid = fidelity(1);
        end
        phi_new = phi;
        s_new = s;
end

varargout = {s_new,grad_s,phi_new,grad_phi,Ro_new,grad_Ro,fid};

% pause;
% 
% iter = 1;
% tolerance*I
%             
% while(1)
%     
%     if(grad_s>0)
%         disp('pos')
%         I_sim = CalcCurrent(s-delta_s,phi,Ro,Vo,I,T)
%         fidelity(iter+1) = I-I_sim
%     elseif(grad_s<0)
%         disp('neg')
%         s = s+delta_s;
%         I_sim = CalcCurrent(s+delta_s,phi,Ro,Vo,I,T)
%         fidelity(iter+1) = I-I_sim
%     else
%         break;
%     end
%     tolerance*I
%     
%     grad_s = (fidelity(iter)-fidelity(iter+1))/(delta_s)
%     iter = iter+1
%     pause;
%     
%     if(abs(fidelity(iter)) < abs(tolerance*I))
%         break;
%     end
% end
end







