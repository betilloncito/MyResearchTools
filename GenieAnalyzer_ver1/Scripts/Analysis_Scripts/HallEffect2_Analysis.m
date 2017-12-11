function varargout = HallEffect2_Analysis(varargin)

%Code assumes all files have the same indices labelling (i.e. each
%variables is found under the same column in each file).

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Preamp Sens [A/V]:';
    DataTable{1,2} = 1e-6;
    DataTable{2,1} = 'Gain (Vx) [V/V]:';
    DataTable{2,2} = 100;
    DataTable{3,1} = 'Gain (Vhall) [V/V]:';
    DataTable{3,2} = 100;
    DataTable{4,1} = 'Number of Hall Probes:';
    DataTable{4,2} = 1;
    DataTable{5,1} = 'Start at pt INDEX:';
    DataTable{5,2} = 1;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %GATE
    name{2} = 'Vg';
    %VOLTAGE PROBE
    name{3} = 'Voltage Probe';
    %MAGNETIC FIELD
    name{4} = 'Magnetic Field';
    
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
                            Vg_index = ii;
                        case 3
                            Vprobe_index = ii;
                        case 4
                            MagField_index = ii;
                    end
                    break;
                end
            end
        end
        %-----------------START CODE HERE-----------------------------------------%
        % Access the data for the file number INDEX by using the variable
        % MatrixData. The index for each variable are given above
        
        % Code assumes that the files are grouped by probes. In other 
        % words,all the files corresponding to a probe at different B 
        % fields are followed one after the other (it does not matter the 
        % order, i.e. the B field can change any way throughout the group
        % of files. Then the files for the next probe follows). 
        % Within a group of files, the Hall files are always first followed
        % by a single longitudinal voltage file. It also assumes that each 
        % probe has the same number of Hall files.
        
        %Initializes input parameters
        S = Variables(1);
        G_Vx = Variables(2);
        G_Vh = Variables(3);
        NumHallProbes = Variables(4);
        start = Variables(5);
        NumTotalFiles = length(MatrixData_All);
        NumHallFiles = NumTotalFiles/NumHallProbes-1;
        NumTotalProbeFiles = NumHallFiles+1;
        e = 1.602e-19;
        geo_factor = 1;
        
        cnt=1;
        Vhall = [];
%         Vx = [];
        for ii=start:size(MatrixData,3)
%             if(mod(INDEX-1,NumHallProbes)==0)
            if(INDEX == 1)
               G = G_Vx;
            else
               G = G_Vh;
            end
            Vg = MatrixData(:,Vg_index,ii);
            I = MatrixData(:,I_index,ii)*S;
            Vprobe = MatrixData(:,Vprobe_index,ii)/G;
            
%             plot(I,Vprobe);grid on;hold on;
                        
            Coeff = polyfit(I,Vprobe,1);
            slope1 = Coeff(1);
            b_inter = Coeff(2);
            
%             if(mod(INDEX-1,NumHallProbes)~=0)
            if(INDEX ~= 1)
                B = MatrixData(:,MagField_index,ii)/10;%in Tesla                                       
%                 SheetDensity(cnt,INDEX) = B(1)/(abs(slope1)*e);
                Vhall(:,ii) = Vprobe;
                
                plot(Vhall(:,ii),Vx(:,ii));grid on;hold on;
                
                Vg_vector(cnt,INDEX) = Vg(1)                  
            else  
                Vx(:,ii) = Vprobe;
%                 for index=INDEX-NumHallFiles:INDEX-1
%                     mobility(cnt,index) = 1e4*geo_factor/(SheetDensity(cnt,index)*e*abs(slope1)); 
%                 end                    
            end    
            pause;
            cnt = cnt+1;
        end
        hold off;
        
        %------------------STOP CODE HERE-----------------------------------------%
    end
    
%     Legend = {'1T (Probe: 2-12)' '1T (Probe: 4-6)' '1.5T (Probe: 2-12)' ...
%         '1.5T (Probe: 4-6)' '2T (Probe: 2-12)' '2T (Probe: 4-6)'};
%     
%     HandleFig = figure('WindowStyle','normal','Name','Data Plot');
%     for INDEX=1:length(MatrixData_All)
%         if(mod(INDEX,NumTotalProbeFiles)~=0)
%             plot(Vx(:,INDEX),Vhall(:,INDEX),'*-');grid on;hold on;
%         end
%     end
%     xlabel('Gate Voltage [V]');
%     ylabel('Sheet Density, n, [m^{-2}]');
%     title('Sheet Density vs Gate Voltage at different B fields');    
%     CustomizeFigures(HandleFig);
%     close(HandleFig);
%     legend(Legend);    
%     hold off;
%     
%     HandleFig = figure('WindowStyle','normal','Name','Data Plot');
%     for INDEX=1:length(MatrixData_All)     
%         if(mod(INDEX,NumTotalProbeFiles)~=0)
%             plot(Vg_vector(:,INDEX),mobility(:,INDEX),'*-');grid on;hold on;
%         end
%     end
%     xlabel('Gate Voltage [V]');
%     ylabel('Mobility, \mu, [cm^2/Vs]');
%     title('Mobility vs Gate Voltage at different B fields');
%     CustomizeFigures(HandleFig);
%     close(HandleFig);
%     legend(Legend);    
%     hold off;
%     
%     HandleFig = figure('WindowStyle','normal','Name','Data Plot');
%     for INDEX=1:length(MatrixData_All)   
%         if(mod(INDEX,NumTotalProbeFiles)~=0)
%             plot(SheetDensity(:,INDEX),mobility(:,INDEX),'*-');grid on;hold on;
%         end
%     end
%     xlabel('Sheet Density, n, [m^{-2}]');
%     ylabel('Mobility, \mu, [cm^2/Vs]');
%     title('Mobility vs Gate Voltage at different B fields');
%     CustomizeFigures(HandleFig);
%     close(HandleFig);
%     legend(Legend);    
%     hold off;    
    
    varargout = {1};
end