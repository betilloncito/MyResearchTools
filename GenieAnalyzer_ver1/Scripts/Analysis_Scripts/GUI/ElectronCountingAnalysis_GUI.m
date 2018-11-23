function varargout = ElectronCountingAnalysis_GUI(varargin)
% ELECTRONCOUNTINGANALYSIS_GUI MATLAB code for ElectronCountingAnalysis_GUI.fig
%      ELECTRONCOUNTINGANALYSIS_GUI, by itself, creates a new ELECTRONCOUNTINGANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = ELECTRONCOUNTINGANALYSIS_GUI returns the handle to a new ELECTRONCOUNTINGANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      ELECTRONCOUNTINGANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELECTRONCOUNTINGANALYSIS_GUI.M with the given input arguments.
%
%      ELECTRONCOUNTINGANALYSIS_GUI('Property','Value',...) creates a new ELECTRONCOUNTINGANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ElectronCountingAnalysis_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ElectronCountingAnalysis_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ElectronCountingAnalysis_GUI

% Last Modified by GUIDE v2.5 06-Jul-2018 17:59:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ElectronCountingAnalysis_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ElectronCountingAnalysis_GUI_OutputFcn, ...
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


% --- Executes just before ElectronCountingAnalysis_GUI is made visible.
function ElectronCountingAnalysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ElectronCountingAnalysis_GUI (see VARARGIN)

% Choose default command line output for ElectronCountingAnalysis_GUI
handles.output = hObject;

%------------------------Do not Edit--------------------------------------%
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
%-------------------------------------------------------------------------%

%Needs to re-edit
handles.VarDataTable = [{'Vgate:'},{'VplgL_dot'}; {'Osc_Y [volt]:'},{'Osc_wave'};...
    {'Osc_X [time]:'},{'Osc_time'}; {'Dummy :'},{'Dummy'};...
    {'\alpha (eV/V):'},{'0.139'}; {'Threshold 1 [%]:'},{'50'};...
    {'Smoothing: Number of points:'},{'3'}; {'Smoothing: Number of Iterations:'},{'4'};...
    {'Delay (s)'},{'0'}; {'Hist. Bin Number:'},{'100'}; {'Hist. Smoothing: [numPts,Iter]'},{'5,3'}];
handles.FitDataParamTable = [{'Fermi Dirac "Start" [1 or 0]:'},{'1'}; {'Fermi MAX Value:'},{''}; {'Fermi MIN Value:'},{''};...
    {'Gamma Guess [Hz]:'},{'1e3'}; {'Delay Fermi (s):'},{'0'}];

set(handles.VariableListTable,'Data',handles.VarDataTable);
set(handles.FittingParamTable,'Data',handles.FitDataParamTable);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ElectronCountingAnalysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.ElectronCounting_Figure);


% --- Outputs from this function are returned to the command line.
function varargout = ElectronCountingAnalysis_GUI_OutputFcn(hObject, eventdata, handles) 
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
FitTable = get(handles.FittingParamTable,'Data');

%List the names used for the variables header
%V_GATE
name{1} = cell2mat(VarTable(1,2));    %name{1} = 'VplgL_dot';
%OSC_Y
name{2} = cell2mat(VarTable(2,2));    %name{2} = 'Osc_wave';
%OSC_X
name{3} = cell2mat(VarTable(3,2));   %    name{3} = 'Osc_time';
%Dummy
name{4} = cell2mat(VarTable(4,2));   %    name{3} = 'dummy';
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
                    Vgate_index = ii;
                case 2
                    OscY_index = ii;
                case 3
                    OscX_index = ii;
                case 4
                    Dummy_index = ii;
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

%Extracting Data

%Initializes input parameters: Example
%       S = cell2mat(VarTable(5,2));
alpha = str2double(cell2mat(VarTable(5,2)));
Thres1 = str2double(cell2mat(VarTable(6,2)))/100;

GaussWin = str2double(cell2mat(VarTable(7,2)));
Iteration = str2double(cell2mat(VarTable(8,2)));
Delay = str2double(cell2mat(VarTable(9,2)));

Hist_BinNumber = str2double(cell2mat(VarTable(10,2)));
Hist_smooth = cell2mat(VarTable(11,2));
n = strfind(Hist_smooth,',');
Hist_smooth_numPts = str2double(Hist_smooth(1:n-1));
Hist_smooth_Iter = str2double(Hist_smooth(n+1:end));

FermiStart = str2double(cell2mat(FitTable(1,2)));
Fermi_Max = str2double(cell2mat(FitTable(2,2)));
Fermi_Min = str2double(cell2mat(FitTable(3,2)));
Gamma_Guess = str2double(cell2mat(FitTable(4,2)));
Delay_Fermi = str2double(cell2mat(FitTable(5,2)));

n1 = size(MatrixData,1);%Osc time
n3 = size(MatrixData,3);%dummy
n4 = size(MatrixData,4);%Vgate

OscY = MatrixData(:,OscY_index,:,:);
size(OscY);
handles.OscY = reshape(OscY,n1,n3*n4);
for i=1:size(handles.OscY,2)
    handles.OscY(:,i) = ReduceNoise(handles.OscY(:,i),GaussWin,Iteration,0);
end
size(handles.OscY);

OscX = MatrixData(:,OscX_index,1,1);
handles.OscX = reshape(OscX,n1,1);
size(handles.OscX);

Vgate = MatrixData(1,Vgate_index,1,:);
handles.Vgate_nonrepeat = reshape(Vgate,n4,1);
handles.Vgate=[];
for i=1:length(handles.Vgate_nonrepeat)
    handles.Vgate = [handles.Vgate; handles.Vgate_nonrepeat(i,1)*ones(n3,1)];
end
size(handles.Vgate);

Dummy = MatrixData(1,Dummy_index,:,1);
handles.Dummy = reshape(Dummy,n3,1);
size(handles.Dummy);

%-----------------------------------------------------------------%

for i=1:size(handles.OscY,2)
    difference(:,i) = abs(diff(handles.OscY(:,i)));
end
for i=1:size(difference,2)
    amplitude(i) = max(difference(:,i)) - min(difference(:,i));
end
Delta_amplitude = max(amplitude)-min(amplitude);
% Amp_Thres = min(amplitude) + Delta_amplitude*Thres1;

% axs_new = get(fig,'CurrentAxes');
child = get(handles.axes1,'Children');
delete(child);
Hist_Obj = histogram(handles.axes1,amplitude,Hist_BinNumber);
Hist_freq_raw = Hist_Obj.Values;
Hist_Xval = Hist_Obj.BinEdges(1:end-1) + Hist_Obj.BinWidth/2;
Hist_freq = ReduceNoise(Hist_freq_raw,Hist_smooth_numPts,Hist_smooth_Iter,0);
line(Hist_Xval,Hist_freq,'Parent',handles.axes1,...
    'Marker','o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','k','LineStyle','--','Color','r');
grid(handles.axes1,'on');
[pks,loc] = findpeaks(Hist_freq,'SortStr','descend');
Delta_amplitude_correct = Hist_Xval(loc(1)) - Hist_Xval(loc(2));
Amp_Thres = Hist_Xval(loc(2)) + Delta_amplitude_correct*Thres1;
line([Amp_Thres,Amp_Thres],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
    'Marker','none','LineStyle','-','Color','g','LineWidth',3);
line([Hist_Xval(loc(1)),Hist_Xval(loc(1))],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
    'Marker','none','LineStyle','--','Color','b','LineWidth',2);
line([Hist_Xval(loc(2)),Hist_Xval(loc(2))],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
    'Marker','none','LineStyle','--','Color','b','LineWidth',2);

child = get(handles.axes3,'Children');
delete(child);
line(handles.Vgate,amplitude,'Parent',handles.axes3,'Marker','o','LineStyle','none','Color','b');
line([handles.Vgate(1),handles.Vgate(end)],[Amp_Thres,Amp_Thres],'Parent',handles.axes3,...
    'Marker','none','LineStyle','--','Color','r');
grid(handles.axes3,'on');

for i=1:size(difference,2)
    
    [pks,loc] = findpeaks(difference(:,i));
    Avg_Osc(i) = mean(handles.OscY(:,i));
    
    ElectronCount = 0;
    saved_OscY = []; saved_OscX = [];
    saved_pk = []; saved_x = [];
    for ii=1:length(pks)
        
        if( pks(ii) > Amp_Thres)
            ElectronCount = ElectronCount + 1;
            saved_OscY(ElectronCount) = handles.OscY(loc(ii),i);
            saved_OscX(ElectronCount) = handles.OscX(loc(ii),1);
            
            saved_pk(ElectronCount) = difference(loc(ii),i);
            saved_x(ElectronCount) = loc(ii);
        end
        
    end
    
    if(Delay > 0)
        child = get(handles.axes1,'Children');
        delete(child);
        line(linspace(1,length(difference(:,i)),length(difference(:,i))),difference(:,i),'Parent',handles.axes1,...
            'Marker','none','LineStyle','-','Color','k');
        line([1,length(difference(:,i))],[Amp_Thres,Amp_Thres],'Parent',handles.axes1,...
            'Marker','none','LineStyle','--','Color','r');
        if(ElectronCount>0)
            line(saved_x,saved_pk,'Parent',handles.axes1,'Marker','o','LineStyle','none','Color','g');
        end
        grid(handles.axes1,'on');
        
        child = get(handles.axes2,'Children');
        delete(child);
        line(handles.OscX,handles.OscY(:,i),'Parent',handles.axes2,'Marker','none','LineStyle','-','Color','k');
        if(ElectronCount>0)
            line(saved_OscX,saved_OscY,'Parent',handles.axes2,'Marker','o','LineStyle','none','Color','r');
        end
        grid(handles.axes2,'on');
        title({['Electron Counts: ',num2str(ElectronCount),'  Vg: ',num2str(handles.Vgate(i,1))],['Iteration: ',num2str(i)]},'Parent',handles.axes2)
        pause(Delay);
    end
    
    ElectronCountsPerSecond_final (i) = ElectronCount/(max(handles.OscX)-min(handles.OscX));
end

%         cnt = 1;
for i=1:n4
    
    ElectronCountsPerSecond_final_cumul(i) = sum(ElectronCountsPerSecond_final((i-1)*n3+1:i*n3));
    Avg_Osc_cumul(i) = mean(Avg_Osc((i-1)*n3+1:i*n3));
    
    %             if(i==1)
    %                 ElectronCount_final_cumul(cnt) = ElectronCount_final(i);
    %             elseif(handles.Vgate(i-1) == handles.Vgate(i))
    %                 ElectronCount_final_cumul(cnt) = ElectronCount_final(i) + ElectronCount_final_cumul(cnt);
    %             else
    %                 cnt = cnt+1;
    %                 ElectronCount_final_cumul(cnt) = ElectronCount_final(i);
    %             end
end

%fits: FERMI DIST.
%Renormalize the data to be fit

if(Delay_Fermi>0)
%     child = get(handles.axes1,'Children');delete(child);
%     line(handles.Vgate_nonrepeat,Avg_Osc_cumul,'Parent',handles.axes1,'Marker','.','LineStyle','none','Color','b');
%     grid(handles.axes1,'on');
%     title(handles.axes1,'Average Occupansy vs. Vgate');
%     pause(Delay_Fermi);
end
if(isnan(Fermi_Min))
    Avg_Osc_cumul_norm = (Avg_Osc_cumul - min(Avg_Osc_cumul));
else
    Avg_Osc_cumul_norm = (Avg_Osc_cumul - Fermi_Min);
end
if(Delay_Fermi>0)
%     child = get(handles.axes1,'Children');delete(child);
%     line(handles.Vgate_nonrepeat,Avg_Osc_cumul_norm,'Parent',handles.axes1,'Marker','.','LineStyle','none','Color','b');
%     grid(handles.axes1,'on');
%     title(handles.axes1,'Average Occupancy - Min Value vs. Vgate');
%     pause(Delay_Fermi);
end
if(isnan(Fermi_Max))
    Avg_Osc_cumul_norm = Avg_Osc_cumul_norm/max(Avg_Osc_cumul_norm);
else
    Avg_Osc_cumul_norm = Avg_Osc_cumul_norm/Fermi_Max;
end
kB = 8.6173303e-5;%eV/K

if(FermiStart==1)
    func = strcat('1/(exp(',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1)');
else
    func = strcat('1/(exp(-1*',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1)');
end
modelVariables = {'Te','mu'};
fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);

%         Here I define values for the starting "guess" for the fitting parameters
Te_start  = 100e-3;
[val, ind] = max(abs(diff(Avg_Osc_cumul_norm)));
mu_start = handles.Vgate_nonrepeat(ind(1));

[myfit,gof] = fit(handles.Vgate_nonrepeat, Avg_Osc_cumul_norm', fmodel,...
    'Start', [Te_start, mu_start],...
    'TolFun',1e-45,'TolX',1e-45,'MaxFunEvals',1000,'MaxIter',1000);

%         The 3 lines below are used to estimate error bars on the values for the
%         fitting parameters
ci = confint(myfit,0.95);
Te_fit_ebar = ci(:,1);
mu_fit_ebar = ci(:,2);

%         vals contains the final values for the fitting parameters
vals = coeffvalues(myfit);
Te_fit = vals(1);mu_fit = vals(2);

% child = get(handles.axes1,'Children');
% delete(child);
% set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes1);
% plot(myfit,handles.Vgate_nonrepeat,Avg_Osc_cumul_norm);
% line([mu_start,mu_start], [min(Avg_Osc_cumul_norm),max(Avg_Osc_cumul_norm)],'Parent',handles.axes1,'Marker','none','LineStyle','--','Color','g');
% %         line(handles.Vgate_nonrepeat,Avg_Osc_cumul,'Parent',handles.axes1,'Marker','o','LineStyle','none','Color','b');
% grid(handles.axes1,'on');
% title(handles.axes1, [{'N_{occupancy} vs. Vgate'},...
%     {['Fit: T_e=',num2str(round(Te_fit*1000,1)),' (',num2str(round((Te_fit-Te_fit_ebar(1))*1000,1)),', ',num2str(round((Te_fit-Te_fit_ebar(2))*1000,1)),' [95% CI]) mK']},...
%     {['mu=',num2str(mu_fit),' (',num2str(round((mu_fit-mu_fit_ebar(1)),6)),', ',num2str(round((mu_fit-mu_fit_ebar(2)),6)),' [95% CI]) V']}],...
%     'FontSize',10);


%fits: Electron Transition Curve
%Renormalize the data to be fit
func = strcat('Gamma*(1/(exp(',num2str(alpha),'*(Vg - ',num2str(mu_fit),')/(',num2str(kB*Te_fit),')) + 1))',...
    '*(1 - 1/(exp(',num2str(alpha),'*(Vg - ',num2str(mu_fit),')/(',num2str(kB*Te_fit),')) + 1))');

func = strcat('Gamma*(1/(exp(',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1))',...
    '*(1 - 1/(exp(',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1))');
ModelVar_start = [Gamma_Guess, Te_start, mu_start];

modelVariables = {'Gamma', 'Te', 'mu'};
fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);

%         Here I define values for the starting "guess" for the fitting parameters
%         ModelVar_start  = Gamma_Guess;

[myfit,gof] = fit(handles.Vgate_nonrepeat, ElectronCountsPerSecond_final_cumul', fmodel,...
    'Start', ModelVar_start,...
    'TolFun',1e-45,'TolX',1e-45,'MaxFunEvals',1000,'MaxIter',1000);

%         The 3 lines below are used to estimate error bars on the values for the
%         fitting parameters
ci = confint(myfit,0.9999);
Gamma_fit_ebar = ci(:,1);
Te_fit_ebar = ci(:,2);
mu_fit_ebar = ci(:,3);

%         vals contains the final values for the fitting parameters
vals = coeffvalues(myfit);
Gamma_fit = vals(1);
Te_fit = vals(2);mu_fit = vals(3);

child = get(handles.axes2,'Children');
delete(child);

set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes2);
plot(myfit,handles.Vgate_nonrepeat,ElectronCountsPerSecond_final_cumul);
%         line(handles.Vgate_nonrepeat,ElectronCount_final_cumul,'Parent',handles.axes2,'Marker','o','LineStyle','none','Color','b');
grid(handles.axes2,'on');
title(handles.axes2, [{'<r_e> vs. Vgate'},...
    {['Fit: Gamma=',num2str(round(Gamma_fit,1)),' (',num2str(round((Gamma_fit-Gamma_fit_ebar(1)),1)),', ',num2str(round((Gamma_fit-Gamma_fit_ebar(2)),1)),' [95% CI]) Hz']},...
    {['Te =',num2str(Te_fit*1000),'mK']}],...
    'FontSize',13);




%         line(handles.Vgate,ElectronCount_final,'Parent',handles.axes2,'Marker','o','LineStyle','none','Color','b');

%         line([handles.Vgate(1),handles.Vgate(end)],[Amp_Thres,Amp_Thres],'Parent',handles.axes3,...
%             'Marker','none','LineStyle','--','Color','r');

%         handles.Current = (transpose(Current));
%
%         size(Current)
%         if(isempty(Vtun_index))
%             Vbias = MatrixData(:,Vbias_index,1);
%             Vbias = reshape(Vbias,n1,1);
%             handles.Vbias = Vbias;
%             handles.Vplg = [];
%         else
%             Vplg = MatrixData(:,Vtun_index,1);
%             Vplg = reshape(Vplg,n1,1);
%             handles.Vplg = Vplg;
%             handles.Vbias = [];
%
%             size(Vplg)
%         end
%         Time = MatrixData(:,Time_index,:);
%         Time = reshape(Time,n1,n3);
%         handles.Time = (transpose(Time));
%
%         size(Time)
%
%         Bfield = MatrixData(1,Bfield_index,:);
%         Bfield = reshape(Bfield,n3,1);
%         handles.Bfield = Bfield;
%
%         size(Bfield)
%         %-----------------------------------------------------------------%
%
%         child = get(handles.axes1,'Children');
%         delete(child);
%
%         surf(handles.Vplg,handles.Bfield,handles.Current,'EdgeAlpha',0,'Parent',handles.axes1);
%         XY_plane=[0 90];
%         view(handles.axes1,2);
disp('>>>DONE<<<')
guidata(hObject, handles);


% --- Executes on button press in ApplyMathScriptPushbutton.
function ApplyMathScriptPushbutton_Callback(hObject, eventdata, handles)

if(get(handles.AxesNum1Radiobutton,'Value'))
    axesHandle = handles.axes1;
elseif(get(handles.AxesNum2Radiobutton,'Value'))
    axesHandle = handles.axes2;
elseif(get(handles.AxesNum3Radiobutton,'Value'))
    axesHandle = handles.axes3;
end

filename = get(handles.MathScriptText,'String');
TableData = get(handles.VariableListTable,'Data');
UserInputVaribles = (TableData(:,2));

% x_label = get(handles.XaxisEdit,'String');
% y_label = get(handles.YaxisEdit,'String');

set(handles.ElectronCounting_Figure,'CurrentAxes',axesHandle);
axs_children = get(axesHandle,'Children');
axs_line_unflipped = findall(axs_children,'Type','Line');
axs_surf = findall(axs_children,'Type','Surface');

%Saves Main directory
NowDir = cd;
cd(handles.ScriptPath_Math);
%Applies a script which was uploaded given the filename of the script and
%the global variable with the organized data from all files opened

if(isempty(axs_surf)==0)
    [XData,YData,ZData] = feval(filename(1:end-2),axesHandle,UserInputVaribles);
elseif(isempty(axs_line_unflipped)==0)
    [XData_unflipped,YData_unflipped] = feval(filename(1:end-2),axesHandle,UserInputVaribles);
    XData = fliplr(XData_unflipped);
    YData = fliplr(YData_unflipped);
else
    [answer] = feval(filename(1:end-2),UserInputVaribles);    
end
%returns to Main directory
cd(NowDir);

if(isempty(axs_surf)==0)
    delete(axs_children);
    
    set(handles.ElectronCounting_Figure,'CurrentAxes',axesHandle);
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
n = findstr(NowDir,'\Scripts\')
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
cd(NowDir);
guidata(hObject, handles);

% --- Executes on button press in SaveParamPushbutton.
function SaveParamPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveParamPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.VarDataTable = get(handles.VariableListTable,'Data');
guidata(hObject, handles);

% --- Executes on button press in ExtractionSetupPushbutton.
function ExtractionSetupPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractionSetupPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.VariableListTable,'Data',handles.VarDataTable);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in OpenFigureWindowPushbutton.
function OpenFigureWindowPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFigureWindowPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(0,'CurrentFigure',handles.ElectronCounting_Figure);
set(0,'ShowHiddenHandles','on');

if(get(handles.AxesNum1Radiobutton,'Value')==1)
    set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes1);
    
elseif(get(handles.AxesNum2Radiobutton,'Value')==1)
    set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes2);

elseif(get(handles.AxesNum3Radiobutton,'Value')==1)
    set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes3);
end

axs_children = get(gca,'Children');
axs_line = findall(axs_children,'Type','Line');
axs_text = findall(axs_children,'Type','Text');
axs_surf = findall(axs_children,'Type','Surface');
axs_hist = findall(axs_children,'Type','Histogram');

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

    xlabel(x_label);ylabel(y_label);
    
    CustomizeFigures(gcf);

    XY_plane=[0 90];
    view(XY_plane);
    NumColors = 1000;
    colormap_List = get(handles.ColorMapPopupmenu,'String');
    colormap_index = get(handles.ColorMapPopupmenu,'Value');
    colormap_choice = strtrim(cell2mat(colormap_List(colormap_index)));
    colormap(colormap_choice);
    handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
        str2double(get(handles.MaxValColorEdit,'String'))];
    caxis(handles.ColorAxis_Min_Max);

end
hold off;

guidata(hObject, handles);


%--------------------------------------------------------------------------
%----------------------------Unused Callback Functions---------------------
%--------------------------------------------------------------------------

% --- Executes on selection change in FilesAvailableListbox.
function FilesAvailableListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FilesAvailableListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilesAvailableListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilesAvailableListbox


% --- Executes on selection change in FilesChosenListbox.
function FilesChosenListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FilesChosenListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilesChosenListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilesChosenListbox


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
%----------------------------Create Functions------------------------------
%--------------------------------------------------------------------------

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
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
%----------------------------Close Function------------------------------
%--------------------------------------------------------------------------

% --- Executes when user attempts to close ElectronCounting_Figure.
function ElectronCounting_Figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ElectronCounting_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.Received_GUI_Data.NowDir);
% Hint: delete(hObject) closes the figure
delete(hObject);
