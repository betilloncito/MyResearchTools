function varargout = Dummy(varargin)
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
    DataTable{2,1} = 'AverageData [y/n]:';
    DataTable{2,2} = 'n';
    DataTable{3,1} = 'Bias VoltDiv:';
    DataTable{3,2} = 100;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %BIAS
    name{2} = 'VplgL';
    %GATE
    name{3} = 'Time';
    
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
                            VplgL_index = ii;
                        case 3
                            time_index = ii;
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
        AverageData = cell2mat(Variables(1));
        
        I = -MatrixData(:,I_index);
        I = I - min(I)*1.01;
        min(I)
        VplgL = MatrixData(:,VplgL_index);
        
        GaussWin=5;Iteration=30;
        II = ReduceNoise(I,GaussWin,Iteration,0);

        [VplgL_2,II_2] = Derivative(VplgL,II,1);

        PeakX = [];PeakY = [];
        cnt = 1;
        for i=1:length(II_2)-1
            if(II_2(i)>0 && II_2(i+1)<0)
               PeakX(cnt) = VplgL(i);
               PeakY(cnt) = II(i);
               cnt = cnt+1;
            end
        end
       
%         figure(13);
%         plot(VplgL,II);hold on;
%         plot(PeakX,PeakY,'*');hold off;
%         pause;
        
        [HighPk,N] = max(PeakY);
        HighPk_x = PeakX(N);
        
        cnt=1;
        deltaY = [];
        deltaX = [];
        index = [];
        for i=1:length(PeakY)
            if(i~=N)
                deltaY(cnt) = HighPk-PeakY(i);
                deltaX(cnt) = abs(HighPk_x-PeakX(i));
                index(cnt) = i;
                cnt = cnt+1;
            end
        end
        
        fun = deltaY./deltaX;
        [val,ind] = min(fun);
        NN = index(ind);
        
%         figure(11);plot(deltaX);
%         figure(22);plot(deltaY);
%         figure(33);plot(fun);
%         pause;
        
        SelectPeakY = [PeakY(N),PeakY(NN)];
        SelectPeakX = [PeakX(N),PeakX(NN)];
        
        AmpEff(INDEX) = abs(diff(SelectPeakX));
        
%         figure(14);
%         plot(VplgL,II);hold on;
%         plot(SelectPeakX,SelectPeakY,'*');
%         hold off;
%         pause;
        
         
        %------------------STOP CODE HERE---------------------------------%
    end
    
    temp = [1.5,2,2.5,3,3.5,4,4.5];%500kHz
    
    P = polyfit(temp,AmpEff(1:7),1);
    A = polyval(P,1);
    AmpEff = [A,AmpEff];
    
    %units in Volts
    AmpPulse = [1,1.5,2,2.5,3,3.5,4,4.5];%500kHz
%     AmpPulse(2,:) = [1,1.5,2,2.5,3,3.5,4,4.5];%181kHz
%     AmpPulse(3,:) = [1,1.5,2,2.5,3,3.5,4,4.5];%95kHz
    Freq = [500,181,95];

    AmpEff_M(1,:) = AmpEff(1:8);
    AmpEff_M(2,:) = AmpEff(9:16);
    AmpEff_M(3,:) = AmpEff(17:24);

%     size(AmpEff_M)
%     size(Freq)
%     size(AmpPulse)
    
    figure(999);
    surf(AmpPulse,Freq,AmpEff_M,'EdgeAlpha',0);
    view(2)
%     hold on;
%     plot(AmpPulse,AmpEff,'*-');grid on;
    
    
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