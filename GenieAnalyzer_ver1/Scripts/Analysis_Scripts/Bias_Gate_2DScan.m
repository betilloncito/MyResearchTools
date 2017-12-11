function varargout = Bias_Gate_2DScan(varargin)
%Analyzes a file where the bias and gate are swept. It gives the current
%vs. bias curves and a plot of the device resistance at each gate voltage

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Preamp Sens [A/V]:';
    DataTable{1,2} = 1e-6;
    DataTable{2,1} = 'Bias VoltDiv:';
    DataTable{2,2} = 100;
    DataTable{3,1} = 'Divider R_GND [Ohms]:';
    DataTable{3,2} = 1e3;
    DataTable{4,1} = 'Source Line R [Ohms]:';
    DataTable{4,2} = 122.5;
    DataTable{5,1} = 'Drain Line R [Ohms]:';
    DataTable{5,2} = 122.5;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'Vbias';
    %GATE
    name{3} = 'Vg';
    %Voltage Probe
    name{4} = 'Voltage Probe';
    
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
                            Vprobe_index = ii;
                    end
                    break;
                end
            end
        end        
        
        %-----------------START CODE HERE---------------------------------%
        % Access the data for the file number INDEX by using the variable
        % MatrixData. The index for each variable are given above
        %Analyses 2D scans of Vbias and Vg.
           
        %Initializes input parameters
        S = cell2mat(Variables(1));
        VoltDiv = cell2mat(Variables(2));
        R_GND = cell2mat(Variables(3));
        R_source = cell2mat(Variables(4));
        R_drain = cell2mat(Variables(5));
        R_div = R_GND*VoltDiv;
                
        HandleFig = figure('WindowStyle','normal','Name','Data Plot');
        for ii=1:size(MatrixData,3)
            Vbias = MatrixData(:,Vbias_index,ii)/VoltDiv;
            Vo = MatrixData(:,Vbias_index,ii);
            I = MatrixData(:,I_index,ii)*S;
            Vg(ii) = MatrixData(1,Vg_index,ii);
            Vprobe = MatrixData(:,Vprobe_index,ii);
            
            Coeff = polyfit(Vbias,I,1);
            Rt = 1/abs(Coeff(1));
            I_zerobias(ii) = Coeff(2);
            
            II = abs([I(1),I(end)]);VVo = abs([Vo(1),Vo(end)]);
            alpha = (R_GND+R_drain)*(R_source+R_div) + R_GND*R_drain;
            AA = II*(R_div+R_source+R_GND);
            BB = II*(R_drain*(R_div+R_source+R_GND)+alpha) - VVo*R_GND;
            CC = II*R_drain*alpha-VVo*R_GND*R_drain;
            
            rx1 = mean((-BB + sqrt(BB.^2 - 4*AA.*CC))./(2*AA));
            rx2 = mean((-BB - sqrt(BB.^2 - 4*AA.*CC))./(2*AA));
            
            if(rx1>0 && rx2<0)
                rx(ii) = rx1;                
            elseif(rx2>0 && rx1<0)
                rx(ii) = rx2;
            end
                                                
%             plot(Vbias,I);hold on;grid on;
%             xlabel('Voltage Bias[V]');
%             ylabel('Current [A]');
%             title('Currrent vs. Bias Curves')
            
            plot(I,Vprobe);hold on;grid on;
            ylabel('Voltage Hall[V]');
            xlabel('Current [A]');
            title('Currrent vs. Bias Curves')
        end
        hold off;
        CustomizeFigures(HandleFig);
        close(HandleFig);
        
        n=1;
        HandleFig = figure('WindowStyle','normal','Name','Data Plot');
        semilogy(Vg(n:end),rx(n:end),'*-');grid on;
        xlabel('Gate Voltage [V]');
        ylabel('Hall Bar Resistance [\Omega]');
        title('Hall Bar Resistance [\Omega] vs. Gate Voltage [V]')
        CustomizeFigures(HandleFig);
        close(HandleFig);
        
        %------------------STOP CODE HERE---------------------------------%
    end
    
    %Do not edit this line
    varargout = {1};
end