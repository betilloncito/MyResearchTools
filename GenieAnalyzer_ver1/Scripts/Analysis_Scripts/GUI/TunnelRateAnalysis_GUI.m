function varargout = TunnelRateAnalysis_GUI(varargin)
% TUNNELRATEANALYSIS_GUI MATLAB code for TunnelRateAnalysis_GUI.fig
%      TUNNELRATEANALYSIS_GUI, by itself, creates a new TUNNELRATEANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = TUNNELRATEANALYSIS_GUI returns the handle to a new TUNNELRATEANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      TUNNELRATEANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUNNELRATEANALYSIS_GUI.M with the given input arguments.
%
%      TUNNELRATEANALYSIS_GUI('Property','Value',...) creates a new TUNNELRATEANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TunnelRateAnalysis_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TunnelRateAnalysis_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TunnelRateAnalysis_GUI

% Last Modified by GUIDE v2.5 19-Apr-2018 20:03:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TunnelRateAnalysis_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TunnelRateAnalysis_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TunnelRateAnalysis_GUI is made visible.
function TunnelRateAnalysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TunnelRateAnalysis_GUI (see VARARGIN)

% Choose default command line output for TunnelRateAnalysis_GUI
handles.output = hObject;

%Gets input which is the handle to the "calling" GUI (SpanAcpPlot)
handles.MainFigureHandle = varargin{1};
%Gets the data using the getappdata function
handles.Received_GUI_Data = getappdata(handles.MainFigureHandle,'GUI_Data');

%Saves the received data to local variables to be used throughout the GUI
% handles.OrgMatrixData = handles.Received_GUI_Data.OrgMatrixData;
% handles.Header_Vector = handles.Received_GUI_Data.Header_Vector;
% handles.Filenames_String = handles.Received_GUI_Data.Filenames_String;

set(handles.FilesAvailableListbox,'String',handles.Received_GUI_Data.Filenames_String);

%Global Variables:
handles.ChosenFiles_indeces = [];
handles.AvailableFiles_indeces = [1:1:length(handles.Received_GUI_Data.OrgMatrixData)];

handles.VarDataTable = [{'V_Sweep1 :'},{'Vacc_R'}; {'V_Sweep2 :'},{'Vacc_L'}; {'Gate:'},{'Vplg'};...
    {'Current:'},{'Current'}; {'Sens. (V/A):'},{1e-8}; {'Pause:'},{0}; {'Smoothing Iter.'},{1};...
    {'a1:'},{'0.1,100'}; {'b1:'},{'1,50'}; {'a2:'},{'0.1,100'}; {'b2:'},{'1,50'}; {'Fit Iter.:'},{3}];
set(handles.VariableListTable,'Data',handles.VarDataTable);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TunnelRateAnalysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.TunnelRateAnalysis_Figure);


% --- Outputs from this function are returned to the command line.
function varargout = TunnelRateAnalysis_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in AddAllPushbutton.
function AddAllPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddAllPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ChosenFiles_indeces = [1:1:length(handles.Received_GUI_Data.OrgMatrixData)];
handles.AvailableFiles_indeces = [];

set(handles.FilesChosenListbox,'String',handles.Received_GUI_Data.Filenames_String);
set(handles.FilesAvailableListbox,'String','');
set(handles.AddAllPushbutton,'enable','off');
set(handles.AddPushbutton,'enable','off');
set(handles.DeleteAllPushbutton,'enable','on');
set(handles.DeletePushbutton,'enable','on');

set(handles.FilesChosenListbox,'Value',1);
set(handles.FilesAvailableListbox,'Value',1);

% handles

guidata(hObject, handles);

% --- Executes on button press in DeleteAllPushbutton.
function DeleteAllPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteAllPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ChosenFiles_indeces = [];
handles.AvailableFiles_indeces = [1:1:length(handles.Received_GUI_Data.OrgMatrixData)];

set(handles.FilesChosenListbox,'String','');
set(handles.FilesAvailableListbox,'String',handles.Received_GUI_Data.Filenames_String);
set(handles.DeleteAllPushbutton,'enable','off');
set(handles.DeletePushbutton,'enable','off');
set(handles.AddAllPushbutton,'enable','on');
set(handles.AddPushbutton,'enable','on');

set(handles.FilesChosenListbox,'Value',1);
set(handles.FilesAvailableListbox,'Value',1);

% handles

guidata(hObject, handles);

% --- Executes on button press in AddPushbutton.
function AddPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
INDEX = get(handles.FilesAvailableListbox,'Value')

handles.ChosenFiles_indeces = [handles.ChosenFiles_indeces,handles.AvailableFiles_indeces(INDEX)];
handles.ChosenFiles_indeces = sort(handles.ChosenFiles_indeces,'ascend');
handles.AvailableFiles_indeces(INDEX) = [];

for i=1:length(handles.ChosenFiles_indeces)
    str_fileschosen(i) = handles.Received_GUI_Data.Filenames_String(handles.ChosenFiles_indeces(i));
end

str_filesavailable = {};
for i=1:length(handles.AvailableFiles_indeces)
    str_filesavailable(i) = handles.Received_GUI_Data.Filenames_String(handles.AvailableFiles_indeces(i));
end

set(handles.FilesChosenListbox,'String',str_fileschosen);
set(handles.FilesAvailableListbox,'String',str_filesavailable);
set(handles.FilesChosenListbox,'Value',1);
set(handles.FilesAvailableListbox,'Value',1);

if(isempty(str_filesavailable)==1)
    set(handles.AddAllPushbutton,'enable','off');
    set(handles.AddPushbutton,'enable','off');
    
    set(handles.DeleteAllPushbutton,'enable','on');
end
set(handles.DeletePushbutton,'enable','on');

% handles

guidata(hObject, handles);

% --- Executes on button press in DeletePushbutton.
function DeletePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DeletePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
INDEX = get(handles.FilesChosenListbox,'Value')

handles.AvailableFiles_indeces = [handles.AvailableFiles_indeces,handles.ChosenFiles_indeces(INDEX)];
handles.AvailableFiles_indeces = sort(handles.AvailableFiles_indeces,'ascend');
handles.ChosenFiles_indeces(INDEX) = [];

str_fileschosen = {};
for i=1:length(handles.ChosenFiles_indeces)
    str_fileschosen(i) = handles.Received_GUI_Data.Filenames_String(handles.ChosenFiles_indeces(i));
end

for i=1:length(handles.AvailableFiles_indeces)
    str_filesavailable(i) = handles.Received_GUI_Data.Filenames_String(handles.AvailableFiles_indeces(i));
end

set(handles.FilesChosenListbox,'String',str_fileschosen);
set(handles.FilesAvailableListbox,'String',str_filesavailable);
set(handles.FilesChosenListbox,'Value',1);
set(handles.FilesAvailableListbox,'Value',1);

if(isempty(str_fileschosen)==1)
    set(handles.AddAllPushbutton,'enable','on');
    
    set(handles.DeleteAllPushbutton,'enable','off');
    set(handles.DeletePushbutton,'enable','off');
end
set(handles.AddPushbutton,'enable','on');

% handles

guidata(hObject, handles);


% --- Executes on button press in ExtractPushbutton.
function ExtractPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

chosenFile = get(handles.FilesChosenListbox,'Value');
INDEX = handles.ChosenFiles_indeces(chosenFile);

VarTable = get(handles.VariableListTable,'Data');
%List the names used for the variables header
%CURRENT
name{1} = cell2mat(VarTable(4,2));    %name{1} = 'Current';
%GATE
name{2} = cell2mat(VarTable(3,2));   %    name{3} = 'Vtun';
%V_sweep1
name{3} = cell2mat(VarTable(1,2));   %    name{3} = 'Vtun';
%V_sweep2
name{4} = cell2mat(VarTable(2,2));   %    name{3} = 'Vtun';
%TIME
name{5} = 'Time';

% for INDEX=1:length(handles.ChosenFiles_indeces)
    %Loops over each saved data set.
%     for INDEX=1:length(MatrixData_All)
        %Figuring out the correct index for each variable
        if(size(handles.Received_GUI_Data.OrgMatrixData,2)==1)
            Headers = handles.Received_GUI_Data.Header_Vector{INDEX};
            MatrixData = handles.Received_GUI_Data.OrgMatrixData{INDEX};
        end
        if(size(handles.Received_GUI_Data.Header_Vector,2)>1)
            temp = handles.Received_GUI_Data.Header_Vector{INDEX};
            Headers = temp{1};
            temp = handles.Received_GUI_Data.OrgMatrixData{INDEX};
            MatrixData = temp{1};
        end
        Counter_index = [];
        for i=1:length(name)
            for ii=1:length(Headers)
                Current_Header = cell2mat(Headers(ii));
                n = strfind(Current_Header,' (');
                if(isempty(n))
                    Headers_corrected = Current_Header;
                else
                    Headers_corrected = Current_Header(1:n-1);
                end
                if(strcmp(name(i),Headers_corrected))
                    switch i
                        %the case # must match the index in the variable
                        %name
                        case 1
                            I_index = ii;
                        case 2
                            Vtun_index = ii;
                        case 3
                            V_sweep1_index = ii;
                        case 4
                            V_sweep2_index = ii;
                        case 5
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
        %-----------------------------------------------------------------%
        global V_sweep1;
        global V_sweep2;
        global maxPeak_Current;
        global maxPeak_Current_sim;
        
        %Extracting Data
        
        %Initializes input parameters: Example
        Sens = cell2mat(VarTable(5,2));
        SmoothIter = cell2mat(VarTable(7,2));
        
        n_plg = size(MatrixData,1);
        n_sweep1 = size(MatrixData,3);
        n_sweep2 = size(MatrixData,4);
        
        Current = MatrixData(:,I_index,:,:);
        Current = reshape(Current,n_plg,n_sweep1,n_sweep2);
                
        Vplg = MatrixData(:,Vtun_index,1,1);
        Vplg = reshape(Vplg,n_plg,1);
        V_sweep1 = MatrixData(1,V_sweep1_index,:,1);
        V_sweep1 = reshape(V_sweep1,n_sweep1,1);
        V_sweep2 = MatrixData(1,V_sweep2_index,1,:);
        V_sweep2 = reshape(V_sweep2,n_sweep2,1);        
        handles.Vplg = Vplg;                
        
        Time = MatrixData(:,Time_index,:,:);
        Time = reshape(Time,n_plg,n_sweep1,n_sweep2);
        
        size(Time)
        size(Current)
        size(V_sweep1)
        size(V_sweep2)
        
        index_depL_descend = 1;
               
%         cnt_i = 1;cnt_j = 1;
        maxPeak_Current = [];
        for j=1:n_sweep2
            for i=index_depL_descend:n_sweep1
                
                Peaks = Current(:,i,j);
                %abs(MatrixData(:,I_index,x,y));
                %                 Vtun = MatrixData(:,Vtun_index,x,y);
                
                %                 VdepL_temp = MatrixData(1,VdepL_index,x,y);
                %                 VdepR_temp = MatrixData(1,VdepR_index,x,y);
                
                %                 V1(cnt_x) = V_sweep1(x);
                %                 V2(cnt_y) = V_sweep2(y);
                
                %Maximum peak only-----------------------------------------
                maxPeak_Current(j,i) = max(Sens*Peaks);
                %----------------------------------------------------------
                
                %Average of all peaks--------------------------------------
                % %                 %Simple peak search
                % % %               %  height = abs(max(Y)-min(Y));
                % %                 %     sig_noiseless = ReduceNoise(sig,3,Iteration,0);
                % %                 % cnt=1;pk_x = [];pk_y = [];
                % %                 % for j=1:length(loc)
                % %                 %     sig(loc(j))
                % %                 %     if(sig(loc(j)) > mag_per*height)
                % %                 %         pk_x(cnt) = Xcrop(loc(j));
                % %                 %         pk_y(cnt) = sig(loc(j));
                % %                 %         cnt = cnt+1
                % %                 %     end
                % %                 % end
                
                %                 [peaks_chosen,loc] = findpeaks(Peaks);
                %                 sortedPks = sort(peaks_chosen,'descend');
                %                 maxPeak_Current(cnt_y,cnt_x) = mean(sortedPks(1:7));
                %----------------------------------------------------------
                
                %                 maxPeak_Current(cnt_y,cnt_x) = mean(S*Peaks);
                %                 VdepL(i,j) = MatrixData(1,VdepL_index,i,j);
                %                 VdepR(i,j) = MatrixData(1,VdepR_index,i,j);
                %                 figure(100);plot(Vtun,Peaks);grid on;hold on;
                if(cell2mat(VarTable(6,2)) > 0)
                    if(size(maxPeak_Current,1)>1)
                        child = get(handles.axes1,'Children');delete(child);
                        surf(maxPeak_Current,'EdgeAlpha',0,'Parent',handles.axes1)
                        title(handles.axes1,'Experimental:');xlabel(handles.axes1,'Vsweep1 [V]');ylabel(handles.axes1,'Vsweep2 [V]')
                        view(handles.axes1,2);colormap('jet');
                    end
                    
                    child = get(handles.axes3,'Children');delete(child);
                    line(Vplg,Peaks,'Parent',handles.axes3,'Color','k');
                    line([Vplg(1),Vplg(end)],maxPeak_Current(j,i)*[1,1]/Sens,...
                        'Parent',handles.axes3,'Color','r','LineStyle','--');
                    title(handles.axes3,['Vsweep1: ',num2str(V_sweep1(i)),' and Vsweep2: ',num2str(V_sweep2(j))]);
                    pause(cell2mat(VarTable(6,2)));
                end
                %                 cnt_i = cnt_i+1;
            end
            %             cnt_i = 1;
            %             cnt_j = cnt_j+1;
        end
        XY_plane=[0 90];
        
        for j=1:size(maxPeak_Current,1)
            maxPeak_Current_smoothY(j,:) = ReduceNoise(maxPeak_Current(j,:),3,SmoothIter,0);            
        end
        for i=1:size(maxPeak_Current_smoothY,2)
            maxPeak_Current_smoothYX(:,i) = ReduceNoise(maxPeak_Current_smoothY(:,i),3,SmoothIter,0);                
        end
        maxPeak_Current = maxPeak_Current_smoothYX;
        
        surf(V_sweep1,V_sweep2,maxPeak_Current,'EdgeAlpha',0,'Parent',handles.axes1)
        title(handles.axes1,'Experimental');xlabel(handles.axes1,'Vsweep1 [V]');ylabel(handles.axes1,'Vsweep2 [V]')        
        view(handles.axes1,2);colormap('jet');  
        colorbar(handles.axes1);
        
        %{%}                   
        
        %Initial values for fitting
        A1 = 1e-4;        
        A2 = 1e-4;    
        
        a1_lim = cell2mat(VarTable(8,2));%0.1;
        b1_lim = cell2mat(VarTable(9,2));%2;        
        a2_lim = cell2mat(VarTable(10,2));%0.1;
        b2_lim = cell2mat(VarTable(11,2));%2;
        
%       74.7624    0.0470   63.2273    0.4712
%       99.9999   -0.0139   36.9187    0.6806
               
        n = strfind(a1_lim,',');
        a1.lb = str2double(a1_lim(1:n-1));
        a1.ub = str2double(a1_lim(n+1:end));
        n = strfind(b1_lim,',');
        b1.lb = str2double(b1_lim(1:n-1));
        b1.ub = str2double(b1_lim(n+1:end));
        n = strfind(a2_lim,',');
        a2.lb = str2double(a2_lim(1:n-1));
        a2.ub = str2double(a2_lim(n+1:end));
        n = strfind(b2_lim,',');
        b2.lb = str2double(b2_lim(1:n-1));
        b2.ub = str2double(b2_lim(n+1:end));
        
        %lowerbound and upper bound (optional)
        lb = [a1.lb, b1.lb, a2.lb, b2.lb];
        ub = [a1.ub, b1.ub, a2.ub, b2.ub];
        
        searchIter = cell2mat(VarTable(12,2));
        searchVec = [];
        b1 = linspace(b1.lb,b1.ub,searchIter)';
        a2 = linspace(a2.lb,a2.ub,searchIter)';
        b2 = linspace(b2.lb,b2.ub,searchIter)';
        
        for iii=1:searchIter
            for ii=1:searchIter
                for i=1:searchIter
                    newsearchIter = [linspace(a1.lb,a1.ub,searchIter)',...
                        b1(i)*ones(searchIter,1),a2(ii)*ones(searchIter,1),b2(iii)*ones(searchIter,1)];
                    searchVec = [searchVec; newsearchIter];
                end
            end
        end
        size(searchVec)
        
        options = optimset('TolFun',1e-5,'TolX',1e-5,'MaxFunEvals',100000,'MaxIter',10000);                
        for i=1:size(searchVec,1)
            par = searchVec(i,:);
%             Opt_par = fminunc(@FidCalc,par,options);
            Opt_par = fmincon(@FidCalc,par,[],[],[],[],lb,ub,[],options);
            
            Opt_par_vec(i,:) = Opt_par;
            Final_Fidelity(i) = FidCalc(Opt_par_vec);
            
%             title(handles.axes2,['Simulation iteration: ',num2str(i),'/',num2str(size(searchVec,1))]);
%             pause;
        end
        child = get(handles.axes3,'Children');delete(child);
        line([1:1:size(searchVec,1)],Final_Fidelity,'Parent',handles.axes3,'Color','k','Marker','o');
        title(handles.axes3,'Fidelities');        
                    
        [MIN_Final_Fidelity, MIN_index] = min(Final_Fidelity);
        Fit_var = Opt_par_vec(MIN_index,:);        
        FidCalc(Fit_var);
        
%         figure(69);
        surf(V_sweep1,V_sweep2,maxPeak_Current_sim,'EdgeAlpha',0,'Parent',handles.axes2)
        title(handles.axes2,['Simulation: ',num2str(MIN_Final_Fidelity)]);xlabel(handles.axes2,'Vsweep1 [V]');ylabel(handles.axes2,'Vsweep2 [V]')
        view(handles.axes2,2);colormap('jet');              
        ColorAxis_Min_Max = [min(min(maxPeak_Current)),max(max(maxPeak_Current))];
        caxis(handles.axes2,ColorAxis_Min_Max);
        colorbar(handles.axes2);
        
        %Fitting resultant values
%         A1 = Opt_par(1)      
%         A2 = Opt_par(2)      
        a1 = Fit_var(1);
        b1 = Fit_var(2);       
        a2 = Fit_var(3);
        b2 = Fit_var(4);
        
        VarTable = get(handles.VariableListTable,'Data');
        VarTable(8,3) = {a1};
        VarTable(9,3) = {b1};
        VarTable(10,3) = {a2};
        VarTable(11,3) = {b2};
        set(handles.VariableListTable,'Data',VarTable);
        
        Gamma_1 = exp(a1*(V_sweep1 + b1));
        Gamma_2 = exp(a2*(V_sweep2 + b2));
        
%         figure(200);
        semilogy(V_sweep1,Gamma_1,'Color','r','Parent',handles.axes4);grid(handles.axes4,'on');
        xlabel(handles.axes4,'Vsweep1 [V]');ylabel(handles.axes4,'\Gamma_1 [Hz]');
%         figure(201);
        semilogy(V_sweep2,Gamma_2,'Color','k','Parent',handles.axes5);grid(handles.axes5,'on');
        xlabel(handles.axes5,'Vsweep2 [V]');ylabel(handles.axes5,'\Gamma_2 [Hz]');        
        
        figure(100);
        line(V_sweep1,Gamma_1,'Color','r')
        ax1 = gca; % current axes
        xlabel(ax1,'Vsweep1 [V]');
        ylabel(ax1,'\Gamma_1 [Hz]');
        ax1.XColor = 'r';
        ax1.YColor = 'r';
        
        ax1_pos = ax1.Position; % position of first axes
        ax2 = axes('Position',ax1_pos,...
            'XAxisLocation','top',...
            'YAxisLocation','right',...
            'Color','none');
        
        line(V_sweep2,Gamma_2,'Parent',ax2,'Color','k')
        xlabel(ax2,'Vsweep2 [V]');
        ylabel(ax2,'\Gamma_2 [Hz]');
        grid on;                                                                                        
        
guidata(hObject, handles);

function fidelity = FidCalc(par)
global V_sweep1;
global V_sweep2;
global maxPeak_Current;
global maxPeak_Current_sim;

maxPeak_Current_sim = [];
e = 1.602e-19;

a1 = par(1);
b1 = par(2);

a2 = par(3);
b2 = par(4);

Gamma_1 = exp(a1*(V_sweep1 + b1));
Gamma_2 = exp(a2*(V_sweep2 + b2));

for y=1:length(Gamma_2)
    for x=1:length(Gamma_1)
        maxPeak_Current_sim(y,x) = e*Gamma_2(y)*Gamma_1(x)/(Gamma_2(y) + Gamma_1(x));
    end
end
diffSquares = sum(sum((maxPeak_Current - maxPeak_Current_sim).^2));

fidelity = diffSquares*1e17;
% pause(1);



% --- Executes on button press in ApplyMathScriptPushbutton.
function ApplyMathScriptPushbutton_Callback(hObject, eventdata, handles)

filename = get(handles.MathScriptText,'String');
TableData = get(handles.VariableListTable,'Data');
UserInputVaribles = (TableData(:,2));

% x_label = get(handles.XaxisEdit,'String');
% y_label = get(handles.YaxisEdit,'String');

set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes1);
axs_children = get(handles.axes1,'Children');
axs_line_unflipped = findall(axs_children,'Type','Line');
axs_surf = findall(axs_children,'Type','Surface');

%Saves Main directory
NowDir = cd;
cd(handles.ScriptPath_Math);
%Applies a script which was uploaded given the filename of the script and
%the global variable with the organized data from all files opened

if(isempty(axs_surf)==0)
    [XData,YData,ZData] = feval(filename(1:end-2),handles.axes1,UserInputVaribles);
elseif(isempty(axs_line_unflipped)==0)
    [XData_unflipped,YData_unflipped] = feval(filename(1:end-2),handles.axes1,UserInputVaribles);
    XData = fliplr(XData_unflipped);
    YData = fliplr(YData_unflipped);
else
    [answer] = feval(filename(1:end-2),UserInputVaribles);    
end
%returns to Main directory
cd(NowDir);

if(isempty(axs_surf)==0)
    delete(axs_children);
    
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes1);
    surf(XData,YData,ZData,'EdgeColor','none');
    XY_plane = [0 90];view(XY_plane);grid on;
%     xlabel(x_label);ylabel(y_label);
%     colormap_List = get(handles.ColorMapPopupmenu,'String');
%     colormap_index = get(handles.ColorMapPopupmenu,'Value');
%     colormap_choice = strtrim(cell2mat(colormap_List(colormap_index)));
%     colormap(colormap_choice);
    
%     set(handles.MaxValColorEdit,'String',max(max(ZData)));
%     set(handles.MinValColorEdit,'String',min(min(ZData)));
    
elseif(isempty(axs_line_unflipped)==0)
    axs_line = flipud(axs_line_unflipped);
    disp('here');
    size(axs_line_unflipped)
    for k=1:length(axs_line)
        plot_color{k} = get(axs_line(k),'Color');
        linestyle{k} = get(axs_line(k),'LineStyle');
        linewidth{k} = get(axs_line(k),'LineWidth');
        marker{k} = get(axs_line(k),'Marker');
        markeredgecolor{k} = get(axs_line(k),'MarkerEdgeColor');
        markerfacecolor{k} = get(axs_line(k),'MarkerFaceColor');
        markersize{k} = get(axs_line(k),'MarkerSize');
    end
    delete(axs_children);
    
    for k=1:size(XData,2)
%          XData{k}
% %          YData{k}
%         line(XData{k},YData{k})
%         XData
%         X = XData{k};
%         Y = YData{k}

        line(XData{k},YData{k},'Color',plot_color{k},'LineStyle',linestyle{k},'LineWidth',linewidth{k},...
            'Marker',marker{k},'MarkerEdgeColor',markeredgecolor{k},'MarkerFaceColor',markerfacecolor{k},...
            'MarkerSize',markersize{k});
%         pause;
    end    
%     xlabel(x_label);ylabel(y_label);
    
else
    set(handles.MathResultText,'String',[num2str(answer),'%']);
end

guidata(hObject, handles);

% --- Executes on button press in OpenMathScriptPushbutton.
function OpenMathScriptPushbutton_Callback(hObject, eventdata, handles)
%Saves Current directory
NowDir = cd;
n = findstr(NowDir,'\Scripts\');
cd([NowDir(1:n(1)-1),'\Scripts\Math_Scripts']);

[handles.ScriptFilename, handles.ScriptPath_Math, Filterindex] = uigetfile('*.m', 'Choose a file');
if(handles.ScriptPath_Math~=0)
    set(handles.ApplyMathScriptPushbutton,'Enable','on');
    set(handles.MathScriptText,'String',handles.ScriptFilename);
    
    %Used for setting up the necessary variables the user needs to input for
    %analysis: it's like a dummy call to the function which initializes the
    %variable table    
    cd(handles.ScriptPath_Math);
    [handles.VariableTableInfo] = feval(handles.ScriptFilename(1:end-2));
    set(handles.VariableListTable,'Data',handles.VariableTableInfo);
    
end
%returns to Main directory
cd(NowDir)

guidata(hObject, handles);

% --- Executes on button press in ExtractionSetupPushbutton.
function ExtractionSetupPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractionSetupPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.VariableListTable,'Data',handles.VarDataTable);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in FindSplitPushbutton.
function FindSplitPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FindSplitPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

child = get(handles.axes1,'Children');
X = get(child,'XData');
if(size(X,1)>1)
    X = X';
end
Y = get(child,'YData');
% if(size(X,1)>1)
%     X = X';
% end
Z = get(child,'ZData');

Iteration = 1;

VarTable = get(handles.VariableListTable,'Data');

xmin = cell2mat(VarTable(7,2));
xmax = cell2mat(VarTable(8,2));

pauseOpt = cell2mat(VarTable(9,2));
GaussNum = cell2mat(VarTable(10,2));
 

for i=1:length(Y)
    child_2 = get(handles.axes2,'Children');
    delete(child_2);
%     disp(['Current line',num2str(i)]);
    
    for ii=1:length(X);
        if(ii<length(X))
            if(X(ii)<xmin && X(ii+1)>xmin)
                index_xmin = ii;
                break;
            end
            if(X(ii)>xmin && X(ii+1)<xmin)
                index_xmin = ii;
                break;
            end
        end
        if(X(ii)==xmin)
            index_xmin = ii;
        end
    end
    for ii=1:length(X);
        if(ii<length(X))
            if(X(ii)<xmax && X(ii+1)>xmax)
                index_xmax = ii;
                break;
            end
            if(X(ii)>xmax && X(ii+1)<xmax)
                index_xmax = ii;
                break;
            end
        end
        if(X(ii)==xmax)
            index_xmax = ii;
        end
    end
            
    if(index_xmin<index_xmax)
        sig = Z(i,index_xmin:index_xmax);
        Xcrop = X(index_xmin:index_xmax);
    else
        sig = Z(i,index_xmax:index_xmin);
        Xcrop = X(index_xmax:index_xmin);
    end
    sig = ReduceNoise(sig,3,Iteration,0);
    
%     %Simple peak search----------------------------------------------------
%     height = abs(max(sig)-min(sig));
%     %     sig_noiseless = ReduceNoise(sig,3,Iteration,0);
%     [peaks,loc] = findpeaks(sig);
%     cnt=1;pk_x = [];pk_y = [];
%     for j=1:length(loc)
%         sig(loc(j))
%         if(sig(loc(j)) > mag_per*height)
%             pk_x(cnt) = Xcrop(loc(j));
%             pk_y(cnt) = sig(loc(j));
%             cnt = cnt+1
%         end
%     end
%     %----------------------------------------------------------------------

    %Gaussian Fit----------------------------------------------------------
    %normalize and remove offsets
    if(min(sig)<0)
        sig = sig+abs(min(sig));
    else
        sig = sig-min(sig);
    end
    sig_fit = sig/max(sig);%normalize the y values

    %code to add points to sig
    temp_sig_fit = [];
    temp_Xcrop = [];
%     figure(900);plot(Xcrop,sig_fit,'r');hold on;
%     size(Xcrop)
%     pause;
    for j=1:length(sig_fit)-1
        numpts = round(sig_fit(j+1)*100);
              
        if(numpts<50)
            numpts=2;
        end
        
        if(numpts>2)
            slope = diff(sig_fit(j:j+1))/diff(Xcrop(j:j+1));
            y_int = sig_fit(j) - slope*Xcrop(j);
            
            newPts_Xcrop = linspace(Xcrop(j),Xcrop(j+1),numpts);
            if(j==length(sig_fit)-1)
                newPts_sig_fit = slope*newPts_Xcrop + y_int;
                temp_Xcrop = [temp_Xcrop, newPts_Xcrop];
            else
                newPts_sig_fit = slope*newPts_Xcrop(1:end-1) + y_int;
                temp_Xcrop = [temp_Xcrop, newPts_Xcrop(1:end-1)];
            end
            temp_sig_fit = [temp_sig_fit, newPts_sig_fit];
            
        else
            if(j==length(sig_fit)-1)
                temp_Xcrop = [temp_Xcrop, Xcrop(j:j+1)];
                temp_sig_fit = [temp_sig_fit, sig_fit(j:j+1)'];
            else
                temp_Xcrop = [temp_Xcrop, Xcrop(j)];
                temp_sig_fit = [temp_sig_fit, sig_fit(j)];
            end
        end
    end
    sig_fit = temp_sig_fit';
    Xcrop = temp_Xcrop;
    
%     size(sig_fit)
%     size(Xcrop)
%     figure(900);line(Xcrop,sig_fit,'bo');hold off;
%     pause;

%     weights = 2.^(sig_fit*10);
    weights = (sig_fit>0.3)*9 + 1;
    
%     figure(444);plot(Xcrop,weights,'b',Xcrop,sig_fit,'r.');
%     pause;

    if(GaussNum>1)
        func = 'A1*exp(-(Vg - B1)^2/(2*C1^2)) + A2*exp(-(Vg - B2)^2/(2*C2^2))';
        modelVariables = {'A1','B1','C1','A2','B2','C2'};
        fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
    else
        func = 'A1*exp(-(Vg - B1)^2/(2*C1^2))';
        modelVariables = {'A1','B1','C1'};
        fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
    end
    
%     lowerVal = [0,min(Xcrop),]
%     myfit_G = fit(Xcrop', sig_fit', fmodel, 'lower', LowerVal,'upper',UpperVal);
    A1_start = 0.02;    A2_start = 0.02;
    B1_start = min(Xcrop);    B2_start = max(Xcrop);
    C1_start = (max(Xcrop)-min(Xcrop))*0.01;    C2_start = (max(Xcrop)-min(Xcrop))*0.01;
        
    A_lower = 0.1;
%     B_lower = 2.0160;
    B_lower = min(Xcrop) + (max(Xcrop)-min(Xcrop))*0.2;
    C_lower = (max(Xcrop)-min(Xcrop))*0.01;
    
    A_upper = 1;
%     B_upper = 2.0185;
    B_upper = max(Xcrop) - (max(Xcrop)-min(Xcrop))*0.2;
    C_upper = (max(Xcrop)-min(Xcrop))*0.2;
    
    if(GaussNum>1)
        StartVal = [A1_start, B1_start, C1_start, A2_start, B2_start, C2_start];
        LowerVal = [A_lower, B_lower, C_lower, A_lower, B_lower, C_lower];
        UpperVal = [A_upper, B_upper, C_upper, A_upper, B_upper, C_upper];
    else
        StartVal = [A1_start, B1_start, C1_start];
        LowerVal = [A_lower, B_lower, C_lower];
        UpperVal = [A_upper, B_upper, C_upper];
    end
%     exclude2 = sig_fit < 0.25;
    
    myfit = fit(Xcrop',sig_fit,fmodel,'Weights',weights,...
        'Start',StartVal,'lower',LowerVal,'upper',UpperVal,...
        'TolFun',1e-8,'TolX',1e-6,'MaxFunEvals',600,'MaxIter',400);
    
    vals = coeffvalues(myfit);
    A1_fit = vals(1);   B1_fit = vals(2);   C1_fit = vals(3);
    gauss1 = A1_fit*exp(-(Xcrop-B1_fit).^2./(2*C1_fit^2));
% size(Xcrop)
% size(sig_fit)
%     myfit = fit(Xcrop', sig_fit, fmodel);
%     A1_fit = A1_start;   B1_fit = B1_start;   C1_fit = C1_start;
%     A2_fit = A1_start;   B2_fit = B1_start;   C2_fit = C1_start;    
%     A1_fit = 1;
%     A2_fit = 1;

    child = get(handles.axes3,'Children');delete(child);
    grid on;legend off;
    line(Xcrop,gauss1,'Parent',handles.axes3,'LineStyle','--','Color','k');
    if(GaussNum>1)
        A2_fit = vals(4);   B2_fit = vals(5);   C2_fit = vals(6);
        Separation(i) = abs(B1_fit - B2_fit);    
        gauss2 = A2_fit*exp(-(Xcrop-B2_fit).^2./(2*C2_fit^2));
        line(Xcrop,gauss2,'Parent',handles.axes3,'LineStyle','-.','Color','g');
    else
        PeakPos(i) = B1_fit;
    end
    
% figure(300);
child = get(handles.axes2,'Children');delete(child);
set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes2);
plot(myfit,Xcrop,sig_fit);grid on;
title(['B-field: ',num2str(Y(i))])
if(i<length(Y))
    legend off;
end
% plot(myfit,Xcrop,sig_fit);grid on;
% plot(Xcrop,sig_fit);hold on;

% figure(302);

    %----------------------------------------------------------------------
    
    
%     line(Xcrop,sig_fit,'Parent',handles.axes2,'LineStyle','-','Color','blue');
%     line(pk_x,pk_y,'Parent',handles.axes2,'LineStyle','none','Color','red','Marker','o');
%     grid on;
    
    if(length(pk_y)>1)
        pk_yy = sort(pk_y,'descend');
        n1 = find(pk_y==pk_yy(1));
        n2 = find(pk_y==pk_yy(2));
        
        sep(i) = abs(pk_x(n1) - pk_x(n2));
    end
    
    if(pauseOpt>0)
        pause(pauseOpt);
    end
end

child = get(handles.axes3,'Children');delete(child);
if(GaussNum>1) 
    line(Y,Separation,'Parent',handles.axes3,'LineStyle','--','Color','k','Marker','o');
else
    line(Y,PeakPos,'Parent',handles.axes3,'LineStyle','--','Color','k','Marker','o');
end
% figure(231);plot(sep);grid on;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in OpenFigureWindowPushbutton.
function OpenFigureWindowPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFigureWindowPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(0,'CurrentFigure',handles.TunnelRateAnalysis_Figure);
set(0,'ShowHiddenHandles','on');

if(get(handles.AxesNum1Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes1);
    
elseif(get(handles.AxesNum2Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes2);

elseif(get(handles.AxesNum3Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes3);
    
elseif(get(handles.AxesNum4Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes4);
    
elseif(get(handles.AxesNum5Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes5);
    
end

axs_children = get(gca,'Children');
axs_line = findall(axs_children,'Type','Line');
axs_text = findall(axs_children,'Type','Text');
axs_surf = findall(axs_children,'Type','Surface');
ax = gca;
title_label = ax.Title.String;
x_label = ax.XLabel.String;
y_label = ax.YLabel.String;

if(isempty(axs_line)==0)
%     CustomizeFigures(gcf,title_label,0);
    CustomizeFigures(gcf);
    xlabel(x_label);ylabel(y_label);
end
% for k=length(axs_line):-1:1
%     xdata = get(axs_line(k),'XData');
%     ydata = get(axs_line(k),'YData');
%     plot_color = get(axs_line(k),'Color');
%     
%     linestyle = get(axs_line(k),'LineStyle');
%     linewidth = get(axs_line(k),'LineWidth');
%     marker = get(axs_line(k),'Marker');
%     markeredgecolor = get(axs_line(k),'MarkerEdgeColor');
%     markerfacecolor = get(axs_line(k),'MarkerFaceColor');
%     markersize = get(axs_line(k),'MarkerSize');
%     
%     if(k==length(axs_line))
%         figure('WindowStyle','normal','Name','Data Plot');
%     end
%     h = gca;
%     plot(h,xdata,ydata,'Color',plot_color,...
%         'LineStyle',linestyle,'LineWidth',linewidth,...
%         'Marker',marker,'MarkerEdgeColor',markeredgecolor,...
%         'MarkerFaceColor',markerfacecolor,'MarkerSize',markersize);
%     grid on;hold on;
%     title(title_label);xlabel(x_label);ylabel(y_label);
% end


for k=1:length(axs_text)
    text_String = get(axs_text(k),'String');
    size(text_String);
    if(size(text_String,1)>1)
        text_Position = get(axs_text(k),'Position');
        text_BackColor = get(axs_text(k),'BackgroundColor');
        text_EdgeColor = get(axs_text(k),'EdgeColor');
        text_FontSize = get(axs_text(k),'FontSize');
        
        text('String',text_String,'Parent',gca,'Position',text_Position,...
            'BackgroundColor',text_BackColor,'EdgeColor',text_EdgeColor,...
            'FontSize',text_FontSize);
    end
end

if(isempty(axs_surf)==0)
        
    xdata = get(axs_surf,'XData');
    ydata = get(axs_surf,'YData');
    zdata = get(axs_surf,'ZData');
    EdgeColor = get(axs_surf,'EdgeColor');
    FaceAlpha = get(axs_surf,'FaceAlpha');
    CData = get(axs_surf,'CData');
    
    figure('WindowStyle','normal','Name','Data Plot');    
    surf(xdata,ydata,zdata,'EdgeColor',EdgeColor,...
        'FaceAlpha',FaceAlpha,'CData',CData)
    CustomizeFigures(gcf);
    xlabel(x_label);ylabel(y_label);
        
    XY_plane=[0 90];
    view(XY_plane);
    NumColors = 1000;
%     colormap_List = get(handles.ColorMapPopupmenu,'String');
%     colormap_index = get(handles.ColorMapPopupmenu,'Value');
%     colormap_choice = strtrim(cell2mat(colormap_List(colormap_index)));
    colormap('jet');
%     handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
%         str2double(get(handles.MaxValColorEdit,'String'))];
%     caxis(handles.ColorAxis_Min_Max);

end
hold off;

guidata(hObject, handles);


%--------------------------------------------------------------------------

% --- Executes on selection change in FilesAvailableListbox.
function FilesAvailableListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FilesAvailableListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilesAvailableListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilesAvailableListbox


% --- Executes during object creation, after setting all properties.
function FilesAvailableListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilesAvailableListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FilesChosenListbox.
function FilesChosenListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FilesChosenListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilesChosenListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilesChosenListbox


% --- Executes during object creation, after setting all properties.
function FilesChosenListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilesChosenListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------

% --- Executes when TunnelRateAnalysis_Figure is resized.
function TunnelRateAnalysis_Figure_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to TunnelRateAnalysis_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close TunnelRateAnalysis_Figure.
function TunnelRateAnalysis_Figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to TunnelRateAnalysis_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.Received_GUI_Data.NowDir);
% Hint: delete(hObject) closes the figure
delete(hObject);
