function varargout = TranconductanceCurve_Analysis(varargin)
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
    DataTable{2,1} = 'Smoothing Factor:';
    DataTable{2,2} = 0;
    DataTable{3,1} = 'Transcond. Curves per File:';
    DataTable{3,2} = 1;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'Current';
    %GATE
    name{2} = 'Vg';
    
    %Initializes MatrixData and Variables from the input varargin
    MatrixData_All = varargin{1};
    Variables = varargin{2};
    Headers_All = varargin{3};
    Filenames_String = varargin{4};
      
    %---------------------------------------------------------------------%
    %Loops over each saved data set.
    for INDEX=1:length(MatrixData_All)   
        filename = Filenames_String(1:end);
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
                    end
                    break;
                end
                %Allows code to work for the default header label of Vg or the optional
                %label Vacc
                if(i==2 && strcmp(Headers_corrected,'Vacc'))
                    Vg_index = ii;
                end
            end
        end        
        
        %-----------------START CODE HERE---------------------------------%
        % Access the data for the file number INDEX by using the variable
        % MatrixData. The index for each variable are given above
        NumTransCurves_per_file = cell2mat(Variables(3));
        
        for kk=1:NumTransCurves_per_file
                        
            %Initializes input parameters
            S = cell2mat(Variables(1));
            SmoothOrder = cell2mat(Variables(2));
            size(MatrixData)
            Vg = MatrixData(:,Vg_index,kk);
            I = MatrixData(:,I_index,kk)*S;
            I = ReduceNoise(I,3,SmoothOrder,0);
            
            HandleFig = figure('WindowStyle','normal','Name','Data Plot');
            plot(Vg,I);grid on;hold on;
            xlabel('Gate Voltage [V]');
            ylabel('Current [A]');
            title(['Transconductance Curve: ',filename(1:end),' dataset#: ',num2str(kk)]);
            CustomizeFigures(HandleFig);
            close(HandleFig);hold off;
            
            [Vg_new,der_I] = Derivative(Vg,log10(I));
            
            HandleFig = figure;
            %         plot(Vg,log10(I));hold on;grid on;
            plot(Vg_new,der_I);hold on;grid on;
            xlabel('Gate Voltage [V]');
            ylabel('Derivative of Log(I) [arb.]');            
            title(['Estimation of Turn On Voltage: ',filename(1:end),' dataset#: ',num2str(kk)])            
            CustomizeFigures(HandleFig);
            close(HandleFig);
        end
        
        %------------------STOP CODE HERE---------------------------------%
    end
    
    %Do not edit this line
    varargout = {1};
end
