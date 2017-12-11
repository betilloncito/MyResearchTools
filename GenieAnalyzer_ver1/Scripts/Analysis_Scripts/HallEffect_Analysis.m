function varargout = HallEffect_Analysis(varargin)

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
    DataTable{5,2} = '1';
    
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
    Filename_List = varargin{4};
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
        S = cell2mat(Variables(1));
        G_Vx = cell2mat(Variables(2));
        G_Vh = cell2mat(Variables(3));
        NumHallProbes = cell2mat(Variables(4));
        start = cell2mat(Variables(5));
        
        if(isempty(strfind(start,','))==0)
            n = strfind(start,',');
            start_array(1) = str2double(start(1:n(1)-1));
            for i=2:length(n)
                start_array(i) = str2double(start(n(i-1)+1:n(i)-1));
            end
            start_array(length(start_array)+1) = str2double(start(n(end)+1:end));
        else
            start_array(1:NumHallProbes) = str2double(start);
        end
        
        NumTotalFiles = length(MatrixData_All);
        NumHallFiles = NumTotalFiles/NumHallProbes-1;
        NumTotalProbeFiles = NumHallFiles+1;
        e = 1.602e-19;
        geo_factor = 1;
        
        cnt=1;
        if(INDEX==1)
            start_index = 1;
            stored_INDEX = 1;
        elseif(mod(INDEX-1,NumTotalProbeFiles)==0)
            start_index = start_index+1;
        end
        for ii=start_array(start_index):size(MatrixData,3)
            if(mod(INDEX,NumTotalProbeFiles)~=0)
                G = G_Vh;
            else
                G = G_Vx;
            end
            Vg = MatrixData(:,Vg_index,ii);
            I = MatrixData(:,I_index,ii)*S;
            Vprobe = MatrixData(:,Vprobe_index,ii)/G;
            
            %             plot(I,Vprobe);grid on;hold on;
            
            Coeff = polyfit(I,Vprobe,1);
            slope1 = Coeff(1);
            
            if(mod(INDEX,NumTotalProbeFiles)~=0)
                B = MatrixData(:,MagField_index,ii)/10;%in Tesla
                SheetDensity(cnt,INDEX) = B(1)/(abs(slope1)*e);
                Vg_vector(cnt,INDEX) = Vg(1);
            else
                for index=INDEX-NumHallFiles:INDEX-1
                    mobility(cnt,index) = 1e4*geo_factor/(SheetDensity(cnt,index)*e*abs(slope1));
                end
            end
            %             pause;
            cnt = cnt+1;
        end
        %         hold off;
        if(mod(INDEX,NumTotalProbeFiles)==0)
            if(stored_INDEX==1)
                HandleFig1 = figure('WindowStyle','normal','Name','Data Plot');
                HandleAxes1 = gca;
                leg_cnt = 1;
            end            
            for Looping_INDEX=stored_INDEX:INDEX
                if(mod(Looping_INDEX,NumTotalProbeFiles)~=0)
                    plot(HandleAxes1,Vg_vector(:,Looping_INDEX),SheetDensity(:,Looping_INDEX),'*-');grid on;hold on;
                    Legend(leg_cnt) = Filename_List(Looping_INDEX);
                    leg_cnt = leg_cnt+1;
                end
            end
            xlabel('Gate Voltage [V]');
            ylabel('Sheet Density, n, [m^{-2}]');
            title('Sheet Density vs Gate Voltage at different B fields');            
%             hold off;
            
            if(stored_INDEX==1)
                HandleFig2 = figure('WindowStyle','normal','Name','Data Plot');
                HandleAxes2 = gca;
            end
            for Looping_INDEX=stored_INDEX:INDEX
                if(mod(Looping_INDEX,NumTotalProbeFiles)~=0)
                    plot(HandleAxes2,Vg_vector(:,Looping_INDEX),mobility(:,Looping_INDEX),'*-');grid on;hold on;
                end
            end
            xlabel('Gate Voltage [V]');
            ylabel('Mobility, \mu, [cm^2/Vs]');
            title('Mobility vs Gate Voltage at different B fields');
%             CustomizeFigures(HandleFig);
%             close(HandleFig);
%             legend(Legend);
%             hold off;

            if(stored_INDEX==1)
                HandleFig3 = figure('WindowStyle','normal','Name','Data Plot');
                HandleAxes3 = gca;
            end
            for Looping_INDEX=stored_INDEX:INDEX
                if(mod(Looping_INDEX,NumTotalProbeFiles)~=0)
                    plot(HandleAxes3,SheetDensity(:,Looping_INDEX),mobility(:,Looping_INDEX),'*-');grid on;hold on;
                end
            end
            xlabel('Sheet Density, n, [m^{-2}]');
            ylabel('Mobility, \mu, [cm^2/Vs]');
            title('Mobility vs Sheet Density at different B fields');
%             CustomizeFigures(HandleFig);
%             close(HandleFig);
%             legend(Legend);
%             hold off;
            
            stored_INDEX = INDEX+1;
            Vg_vector = [];
            mobility = [];
            SheetDensity = [];
        end
        
        %------------------STOP CODE HERE-----------------------------------------%
    end
    CustomizeFigures(HandleFig1);
    close(HandleFig1);
    legend(Legend);
    CustomizeFigures(HandleFig2);
    close(HandleFig2);
    legend(Legend);
    CustomizeFigures(HandleFig3);
    close(HandleFig3);
    legend(Legend);
    
    %     Legend = {'1T (Probe: 2-12)' '1T (Probe: 4-6)' '1.5T (Probe: 2-12)' ...
    %         '1.5T (Probe: 4-6)' '2T (Probe: 2-12)' '2T (Probe: 4-6)'};
    
    varargout = {1};
end