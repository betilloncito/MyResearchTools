function varargout = ElectronTransitions(varargin)
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
    DataTable{2,1} = 'Noise Amplitude:';
    DataTable{2,2} = 0.2;
    DataTable{3,1} = 'Bias VoltDiv:';
    DataTable{3,2} = 100;
    
    varargout = {DataTable};
else
    %List the names used for the variables header
    %CURRENT
    name{1} = 'VplgL_dot';
    %BIAS
    name{2} = 'Dummy';
    %GATE
    name{3} = 'Osc_wave';
    %Time (optional)
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
                            VplgL_dot_index = ii;
                        case 2
                            Dummy_index = ii;
                        case 3
                            Osc_wave_index = ii;
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
        
        
        % Initializes input parameters: Example
        NoiseAmp = cell2mat(Variables(2));     

        %         VplgL_val = 14;
        size(MatrixData,3);
        CNT=1;
        for VplgL_val=1:size(MatrixData,4)
            
            delta_high_all = [];delta_low_all = [];
            delta_low = [];delta_high = [];
            for iter=1:size(MatrixData,3)
                disp(['Vplg: ',num2str(MatrixData(1,VplgL_dot_index,iter,VplgL_val))]);
                disp(['iter: ',num2str(iter)])
                
                osc_data = MatrixData(:,Osc_wave_index,iter,VplgL_val);
                osc_time = MatrixData(:,Time_index,iter,VplgL_val);
                N=20;
                for i=1:N
                    osc_data = smooth(osc_data,3);
                end
                amp = max(osc_data)-min(osc_data);
                figure(900);plot(osc_time,osc_data);
                
                if(NoiseAmp<amp)
                    osc_data = osc_data-min(osc_data)-amp/2;
                    cnt_high=1;cnt_low=1;
                    time1=[];
                    figure(200);
                    for ii=1:length(osc_data)-1
                        plot(osc_time(1:ii),osc_data(1:ii));
                        if(isempty(time1))
                            if(osc_data(ii)>0 && osc_data(ii+1)<0)
                                time1 = osc_time(ii+1);
                                %                         pause;
                                %                     break;
                            end
                            if(osc_data(ii)<0 && osc_data(ii+1)>0)
                                time1 = osc_time(ii+1);
                                %                         pause;
                                %                     break;
                            end
                        else
                            if(osc_data(ii)>0 && osc_data(ii+1)<0)
                                time2 = osc_time(ii+1);
                                delta_high(cnt_high) = time2-time1;
                                cnt_high=cnt_high+1;
                                time1=time2;
                                %                         pause;
                                %                     break;
                            end
                            if(osc_data(ii)<0 && osc_data(ii+1)>0)
                                time2 = osc_time(ii+1);
                                delta_low(cnt_low) = time2-time1;
                                cnt_low=cnt_low+1;
                                time1=time2;
                                %                         pause;
                                %                     break;
                            end
                        end                        
                    end                    
                    
                    figure(400);plot(osc_time,osc_data);
                    figure(401);hold on;
                    if(~isempty(delta_high))
                        plot(delta_high,'r*');
                        delta_high_all = [delta_high_all,delta_high];
                    end
                    if(~isempty(delta_low))
                        plot(delta_low,'b*');hold off;
                        delta_low_all = [delta_low_all,delta_low];
                    end
                    
                else
                    disp('data has no noticable electron transitions')
                end
            end
            binNum = 50;
            if(~isempty(delta_low_all) && ~isempty(delta_high_all))
                figure(30);histogram(delta_low_all,binNum);
                [Ncounts,edges] = histcounts(delta_low_all,binNum);
            
                Ncounts_sorted = sort(Ncounts,'descend');
                index = find(Ncounts==Ncounts_sorted(1));
                Avg_delta_low(CNT) = mean([edges(index),edges(index+1)]);
            
                figure(31);histogram(delta_high_all,binNum);
                [Ncounts,edges] = histcounts(delta_high_all,binNum);
                
                Ncounts_sorted = sort(Ncounts,'descend');
                index = find(Ncounts==Ncounts_sorted(1));
                Avg_delta_high(CNT) = mean([edges(index),edges(index+1)]);
                
                Vpgl_dot_vec(CNT) = MatrixData(1,VplgL_dot_index,iter,VplgL_val);
                
                disp(['Avg_delta_low: ',num2str(Avg_delta_low(CNT))]);
                disp(['Avg_delta_high: ',num2str(Avg_delta_high(CNT))]);
                
                CNT=CNT+1;
            end                        
%             pause;
        end
        
        figure;plot(Vpgl_dot_vec,Avg_delta_low,'b*');hold on;
        plot(Vpgl_dot_vec,Avg_delta_high,'r*');hold off;
        
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