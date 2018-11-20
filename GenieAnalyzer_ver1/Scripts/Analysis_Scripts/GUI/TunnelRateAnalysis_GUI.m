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

% Last Modified by GUIDE v2.5 10-Nov-2018 21:34:17

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

handles.VarDataTable = [{'V_Sweep1 (First sweep):'},{'Vacc_TL'}; {'V_Sweep2 (Second sweep):'},{'Vacc_TR'}; {'Gate:'},{'Vplg_T_M1'};...
    {'Current:'},{'Current'}; {'Sens. (V/A):'},{1e-8}; {'Pause:'},{0}; {'Smoothing Iter.'},{1};...
    {'a1:'},{'0.1,5'}; {'b1:'},{'1,25'}; {'a2:'},{'0.1,5'}; {'b2:'},{'1,25'}; {'Gamman Fit Type [1,2,B]:'},{'B'}; {'Fit Iter.:'},{2};...
    {'Xmin :'},{0}; {'Xmax :'},{0}; {'Ymin :'},{0}; {'Ymax :'},{0}; {'Volt Bias [mV] :'},{0.5}; {'Rmin [kOhm] :'},{'10,500'};...
    {'Io [pA]:'},{'1,10'}; {'HeaviSide_xo [V]:'},{'2.3,2.7'}; {'HeaviSide_yo [V]:'},{'2.5,2.9'}];
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
INDEX = get(handles.FilesAvailableListbox,'Value');

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
        
        %Initializes input parameters: Example
        Sens = cell2mat(VarTable(5,2));
        SmoothIter = cell2mat(VarTable(7,2));
        
        n_plg = size(MatrixData,1);
        n_sweep1 = size(MatrixData,3);
        n_sweep2 = size(MatrixData,4);
        
        Current = MatrixData(:,I_index,:,:);
        Current = reshape(Current,n_plg,n_sweep1,n_sweep2);
%         MinCurrent = min(min(min(Current)))
%         size(Current)
%         size(Current,1)*size(Current,2)*size(Current,3)
        
        Current_vec = sort(Current(:),'ascend');
        Current_cutoff = 1e-3;
        for i=1:length(Current_vec)
            if(Current_vec(i) > Current_cutoff)
                index = i;
                break;
            end
        end
        figure(1);
        H = histogram(Current_vec(1:index),10000);
        [HistMax_Val, HistMax_index] = max(H.Values);
        MinCurrent = mean([H.BinEdges(HistMax_index),H.BinEdges(HistMax_index+1)]);
        
        
        Vplg = MatrixData(:,Vtun_index,1,1);
        Vplg = reshape(Vplg,n_plg,1);
        V_sweep1 = MatrixData(1,V_sweep1_index,:,1);
        V_sweep1 = reshape(V_sweep1,n_sweep1,1);
        V_sweep2 = MatrixData(1,V_sweep2_index,1,:);
        V_sweep2 = reshape(V_sweep2,n_sweep2,1);        
        handles.Vplg = Vplg;                
        
        VarTable(14,2) = {min(V_sweep1)};
        VarTable(15,2) = {max(V_sweep1)};
        VarTable(16,2) = {min(V_sweep2)};
        VarTable(17,2) = {max(V_sweep2)};
        set(handles.VariableListTable,'Data',VarTable);
        
        Time = MatrixData(:,Time_index,:,:);
        Time = reshape(Time,n_plg,n_sweep1,n_sweep2);
        
        size(Time);
        size(Current);
        size(V_sweep1);
        size(V_sweep2);
        
        index_depL_descend = 1;
               
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
%                 maxPeak_Current(j,i) = max(Sens*Peaks);
                
                maxPeak_Current(j,i) = Sens*Peaks(round(length(Peaks)/2));

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
                %                 cnt_i = +1;cnt_i
            end
            %             cnt_i = 1;
            %             cnt_j = cnt_j+1;
        end
        maxPeak_Current = maxPeak_Current - MinCurrent*Sens;
        XY_plane=[0 90];
        
        for j=1:size(maxPeak_Current,1)
            maxPeak_Current_smoothY(j,:) = ReduceNoise(maxPeak_Current(j,:),3,SmoothIter,0);            
        end
        for i=1:size(maxPeak_Current_smoothY,2)
            maxPeak_Current_smoothYX(:,i) = ReduceNoise(maxPeak_Current_smoothY(:,i),3,SmoothIter,0);                
        end
        maxPeak_Current = maxPeak_Current_smoothYX;                
        size(maxPeak_Current)                                                 

        surf(V_sweep1,V_sweep2,log10(maxPeak_Current),'EdgeAlpha',0,'Parent',handles.axes1);
%         surf(V_sweep1,V_sweep2,maxPeak_Current,'EdgeAlpha',0,'Parent',handles.axes1);
        title(handles.axes1,'Experimental');xlabel(handles.axes1,'Vsweep1 [V]');ylabel(handles.axes1,'Vsweep2 [V]');
        set(handles.axes1,'XLim',[min(V_sweep1) max(V_sweep1)]);
        set(handles.axes1,'YLim',[min(V_sweep2) max(V_sweep2)]);
        view(handles.axes1,2);colormap('jet');
        colorbar(handles.axes1);
                
        min(min(maxPeak_Current))
        
guidata(hObject, handles);

% --- Executes on button press in FitPushbutton.
function FitPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FitPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global maxPeak_Current_fit;
global maxPeak_Current;
global maxPeak_Current_sim;
global V_sweep1_fit;
global V_sweep2_fit;
global V_sweep1;
global V_sweep2;
global Gamma_Fit_type;

VarTable = get(handles.VariableListTable,'Data');

Xmin = cell2mat(VarTable(14,2))
Xmax = cell2mat(VarTable(15,2))
Ymin = cell2mat(VarTable(16,2))
Ymax = cell2mat(VarTable(17,2))

xmin = SearchVal(V_sweep1,Xmin)
xmax = SearchVal(V_sweep1,Xmax)
ymin = SearchVal(V_sweep2,Ymin)
ymax = SearchVal(V_sweep2,Ymax)

if(xmin<xmax)
    maxPeak_Current_fit = maxPeak_Current(ymin:ymax,xmin:xmax);
    V_sweep1_fit = V_sweep1(xmin:xmax);
    V_sweep2_fit = V_sweep2(ymin:ymax);
elseif(xmin>xmax)
    maxPeak_Current_fit = maxPeak_Current(ymax:ymin,xmax:xmin);
    V_sweep1_fit = V_sweep1(xmax:xmin);
    V_sweep2_fit = V_sweep2(ymax:ymin);
end

child = get(handles.axes1,'Children');delete(child);
surf(V_sweep1_fit,V_sweep2_fit,log10(maxPeak_Current_fit),'EdgeAlpha',0,'Parent',handles.axes1);
%         surf(V_sweep1_fit,V_sweep2_fit,maxPeak_Current_fit,'EdgeAlpha',0,'Parent',handles.axes1);
title(handles.axes1,'Experimental');xlabel(handles.axes1,'Vsweep1 [V]');ylabel(handles.axes1,'Vsweep2 [V]')
view(handles.axes1,2);colormap('jet');
colorbar(handles.axes1);
set(handles.axes1,'XLim',[min(V_sweep1_fit) max(V_sweep1_fit)]);
set(handles.axes1,'YLim',[min(V_sweep2_fit) max(V_sweep2_fit)]);

%Initial values for fitting
A1 = 1e-4;
A2 = 1e-4;

a1_lim = cell2mat(VarTable(8,2));%0.1;
b1_lim = cell2mat(VarTable(9,2));%2;
a2_lim = cell2mat(VarTable(10,2));%0.1;
b2_lim = cell2mat(VarTable(11,2));%2;

Gamma_Fit_type = cell2mat(VarTable(12,2));

%       74.7624    0.0470   63.2273    0.4712
%       99.9999   -0.0139   36.9187    0.6806

n = strfind(a1_lim,',');
a1.lb = str2double(a1_lim(1:n-1));
a1.ub = str2double(a1_lim(n+1:end));
delta_a1 = (a1.ub - a1.lb);
n = strfind(b1_lim,',');
b1.lb = str2double(b1_lim(1:n-1));
b1.ub = str2double(b1_lim(n+1:end));
delta_b1 = (b1.ub - b1.lb);
n = strfind(a2_lim,',');
a2.lb = str2double(a2_lim(1:n-1));
a2.ub = str2double(a2_lim(n+1:end));
delta_a2 = (a2.ub - a2.lb);
n = strfind(b2_lim,',');
b2.lb = str2double(b2_lim(1:n-1));
b2.ub = str2double(b2_lim(n+1:end));
delta_b2 = (b2.ub - b2.lb);
% n = strfind(Io_lim,',');
% Io.lb = str2double(Io_lim(1:n-1));
% Io.ub = str2double(Io_lim(n+1:end));
% delta_Io = (Io.ub - Io.lb);

%lowerbound and upper bound (optional)
lb = [a1.lb, b1.lb, a2.lb, b2.lb];
ub = [a1.ub, b1.ub, a2.ub, b2.ub];

searchIter = cell2mat(VarTable(13,2));
searchVec_Gamma = [];
% searchVec_Gamma_1 = [];
% searchVec_Gamma_2 = [];

Offset_percent = 0.1;
b1.vec = linspace(b1.lb + Offset_percent*delta_b1, b1.ub - Offset_percent*delta_b1, searchIter)';
a2.vec = linspace(a2.lb + Offset_percent*delta_a2, a2.ub - Offset_percent*delta_a2, searchIter)';
b2.vec = linspace(b2.lb + Offset_percent*delta_b2, b2.ub - Offset_percent*delta_b2, searchIter)';
% Io = linspace(Io.lb + Offset_percent*delta_Io, Io.ub - Offset_percent*delta_Io, searchIter)';

if(strcmp(Gamma_Fit_type,'B'))
    
    for iii=1:searchIter
        for ii=1:searchIter
            for i=1:searchIter
                newsearchIter = [linspace(a1.lb + Offset_percent*delta_a1, a1.ub - Offset_percent*delta_a1, searchIter)',...
                    b1.vec(i)*ones(searchIter,1), a2.vec(ii)*ones(searchIter,1), b2.vec(iii)*ones(searchIter,1)];
                searchVec_Gamma = [searchVec_Gamma; newsearchIter];
            end
        end
    end
    
elseif(strcmp(Gamma_Fit_type,'1'))
    
    for i=1:searchIter
        newsearchIter = [linspace(a1.lb + Offset_percent*delta_a1, a1.ub - Offset_percent*delta_a1, searchIter)',...
            b1.vec(i)*ones(searchIter,1)];
        searchVec_Gamma = [searchVec_Gamma; newsearchIter];
    end
    
elseif(strcmp(Gamma_Fit_type,'2'))

    for i=1:searchIter
        newsearchIter = [linspace(a2.lb + Offset_percent*delta_a2, a2.ub - Offset_percent*delta_a2, searchIter)',...
            b2.vec(i)*ones(searchIter,1)];
        searchVec_Gamma = [searchVec_Gamma; newsearchIter];
    end
    
end

options = optimset('TolFun',1e-10,'TolX',1e-8,'MaxFunEvals',1e3,'MaxIter',1e3);
for i=1:size(searchVec_Gamma,1)
    par = searchVec_Gamma(i,:);
    %             Opt_par = fminunc(@FidCalc,par,options);
    if(strcmp(Gamma_Fit_type,'B'))
        Opt_par = fmincon(@FidCalc_2Gamma,par,[],[],[],[],lb,ub,[],options);
        Opt_par_vec(i,:) = Opt_par;
        Final_Fidelity(i) = FidCalc_2Gamma(Opt_par);
        
    elseif(strcmp(Gamma_Fit_type,'1'))
        Opt_par = fmincon(@FidCalc_1Gamma,par,[],[],[],[],lb,ub,[],options);
        Opt_par_vec(i,:) = Opt_par;
        Final_Fidelity(i) = FidCalc_1Gamma(Opt_par);
        
    elseif(strcmp(Gamma_Fit_type,'2'))
        Opt_par = fmincon(@FidCalc_1Gamma,par,[],[],[],[],lb,ub,[],options);
        Opt_par_vec(i,:) = Opt_par;
        Final_Fidelity(i) = FidCalc_1Gamma(Opt_par);
        
    end
%     pause;
    %             title(handles.axes2,['Simulation iteration: ',num2str(i),'/',num2str(size(searchVec,1))]);
    %             pause;
end
child = get(handles.axes3,'Children');delete(child);
line([1:1:size(searchVec_Gamma,1)],Final_Fidelity,'Parent',handles.axes3,'Color','k','Marker','o');
title(handles.axes3,['Fidelities: ',num2str(min(Final_Fidelity))]);
[MIN_Final_Fidelity, MIN_index] = min(Final_Fidelity)
Fit_var = Opt_par_vec(MIN_index,:)
if(strcmp(Gamma_Fit_type,'B'))
    FidCalc_2Gamma(Fit_var);
else
    FidCalc_1Gamma(Fit_var);
end

surf(V_sweep1_fit,V_sweep2_fit,log10(maxPeak_Current_sim),'EdgeAlpha',0,'Parent',handles.axes2);
%         surf(V_sweep1_fit,V_sweep2_fit,maxPeak_Current_sim,'EdgeAlpha',0,'Parent',handles.axes2)
title(handles.axes2,['Simulation: ',num2str(MIN_Final_Fidelity)]);xlabel(handles.axes2,'Vsweep1 [V]');ylabel(handles.axes2,'Vsweep2 [V]');
view(handles.axes2,2);colormap('jet');
set(handles.axes2,'XLim',[min(V_sweep1_fit) max(V_sweep1_fit)]);
set(handles.axes2,'YLim',[min(V_sweep2_fit) max(V_sweep2_fit)]);
ColorAxis_Min_Max = [min(min(log10(maxPeak_Current_fit))),max(max(log10(maxPeak_Current_fit)))];
%         ColorAxis_Min_Max = [min(min(maxPeak_Current)),max(max(maxPeak_Current))];
caxis(handles.axes2,ColorAxis_Min_Max);
colorbar(handles.axes2);

%Fitting resultant values
%         A1 = Opt_par(1)
%         A2 = Opt_par(2)
if(strcmp(Gamma_Fit_type,'B'))
    a1_fit = Fit_var(1);
    b1_fit = Fit_var(2);
    a2_fit = Fit_var(3);
    b2_fit = Fit_var(4);
    
    Gamma_1 = exp(a1_fit*(V_sweep1_fit + b1_fit));
    Gamma_2 = exp(a2_fit*(V_sweep2_fit + b2_fit));
    
    %         figure(200);
    semilogy(V_sweep1_fit,Gamma_1,'Color','r','Parent',handles.axes4);grid(handles.axes4,'on');
    xlabel(handles.axes4,'Vsweep1 [V]');ylabel(handles.axes4,'\Gamma_1 [Hz]');
    %         figure(201);
    semilogy(V_sweep2_fit,Gamma_2,'Color','k','Parent',handles.axes5);grid(handles.axes5,'on');
    xlabel(handles.axes5,'Vsweep2 [V]');ylabel(handles.axes5,'\Gamma_2 [Hz]');
    
    figure(100);
    line(V_sweep1_fit,Gamma_1,'Color','r');
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
    
    line(V_sweep2_fit,Gamma_2,'Parent',ax2,'Color','k');
    xlabel(ax2,'Vsweep2 [V]');
    ylabel(ax2,'\Gamma_2 [Hz]');
    grid on;
    
    VarTable = get(handles.VariableListTable,'Data');
    VarTable(8,3) = {a1_fit};
    VarTable(9,3) = {b1_fit};
    VarTable(10,3) = {a2_fit};
    VarTable(11,3) = {b2_fit};
    % VarTable(12,3) = {Io};
    set(handles.VariableListTable,'Data',VarTable);

elseif(strcmp(Gamma_Fit_type,'1'))
    a1_fit = Fit_var(1);
    b1_fit = Fit_var(2);
    
    Gamma_1 = exp(a1_fit*(V_sweep1_fit + b1_fit));
    
    %         figure(200);
    semilogy(V_sweep1_fit,Gamma_1,'Color','r','Parent',handles.axes4);grid(handles.axes4,'on');
    xlabel(handles.axes4,'Vsweep1 [V]');ylabel(handles.axes4,'\Gamma_1 [Hz]');

    child = get(handles.axes5,'Children');delete(child);

    figure(100);
    line(V_sweep1_fit,Gamma_1,'Color','r');
    ax1 = gca; % current axes
    xlabel(ax1,'Vsweep1 [V]');
    ylabel(ax1,'\Gamma_1 [Hz]');
    ax1.XColor = 'r';
    ax1.YColor = 'r';
    grid on;
    
    VarTable = get(handles.VariableListTable,'Data');
    VarTable(8,3) = {a1_fit};
    VarTable(9,3) = {b1_fit};
    VarTable(10,3) = {''};
    VarTable(11,3) = {''};
    % VarTable(12,3) = {Io};
    set(handles.VariableListTable,'Data',VarTable);
elseif(strcmp(Gamma_Fit_type,'2'))
    a2_fit = Fit_var(1);
    b2_fit = Fit_var(2);
    
    Gamma_2 = exp(a2_fit*(V_sweep2_fit + b2_fit));
    
    %         figure(200);
    semilogy(V_sweep2_fit,Gamma_2,'Color','r','Parent',handles.axes5);grid(handles.axes5,'on');
    xlabel(handles.axes5,'Vsweep2 [V]');ylabel(handles.axes5,'\Gamma_2 [Hz]');

    child = get(handles.axes4,'Children');delete(child);

    figure(100);
    line(V_sweep2_fit,Gamma_2,'Color','r');
    ax1 = gca; % current axes
    xlabel(ax1,'Vsweep2 [V]');
    ylabel(ax1,'\Gamma_2 [Hz]');
    ax1.XColor = 'k';
    ax1.YColor = 'k';
    grid on;
    
    VarTable = get(handles.VariableListTable,'Data');
    VarTable(8,3) = {''};
    VarTable(9,3) = {''};
    VarTable(10,3) = {a2_fit};
    VarTable(11,3) = {b2_fit};
    % VarTable(12,3) = {Io};
    set(handles.VariableListTable,'Data',VarTable);
end

%{
%}

guidata(hObject, handles);

function fidelity = FidCalc_2Gamma(par)
global V_sweep1_fit;
global V_sweep2_fit;
global maxPeak_Current_fit;
global maxPeak_Current_sim;

maxPeak_Current_sim = [];
e = 1.602e-19;
% I_min = 1e-12;

a1 = par(1);
b1 = par(2);

a2 = par(3);
b2 = par(4);

Gamma_1 = exp(a1*(V_sweep1_fit + b1));
Gamma_2 = exp(a2*(V_sweep2_fit + b2));

for y=1:length(Gamma_2)
    for x=1:length(Gamma_1)
        maxPeak_Current_sim(y,x) = e*Gamma_2(y)*Gamma_1(x)/(Gamma_2(y) + Gamma_1(x));
    end
end

% Total_Resistance_sim = 1./maxPeak_Current_sim + 1/I_min;
% Total_Resistance_exp = 1./maxPeak_Current;

diffSquares = sum(sum((log10(maxPeak_Current_fit) - log10(maxPeak_Current_sim)).^2));
% diffSquares = sum(sum((Total_Resistance_exp - Total_Resistance_sim).^2));

fidelity = diffSquares*1e1;

if(isnan(fidelity))
    diffSquares      
    pause;
end

function fidelity = FidCalc_1Gamma(par)
global V_sweep1_fit;
global V_sweep2_fit;
global maxPeak_Current_fit;
global maxPeak_Current_sim;
global Gamma_Fit_type;

maxPeak_Current_sim = [];
e = 1.602e-19;
% I_min = 1e-12;

a = par(1);
b = par(2);

if(strcmp(Gamma_Fit_type,'1'))
    Gamma = exp(a*(V_sweep1_fit + b));    
    
    for y=1:length(V_sweep2_fit)
        for x=1:length(Gamma)
            maxPeak_Current_sim(y,x) = e*Gamma(x);
        end
    end

elseif(strcmp(Gamma_Fit_type,'2'))
    Gamma = exp(a*(V_sweep2_fit + b));
    
    for y=1:length(Gamma)
        for x=1:length(V_sweep1_fit)
            maxPeak_Current_sim(y,x) = e*Gamma(y);
        end
    end
end

diffSquares = sum(sum((log10(maxPeak_Current_fit) - log10(maxPeak_Current_sim)).^2));
% diffSquares = sum(sum((Total_Resistance_exp - Total_Resistance_sim).^2));

fidelity = diffSquares*1e1;

if(isnan(fidelity))
    diffSquares      
    pause;
end

% --- Executes on button press in FindSplitPushbutton.
function FindSplitPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FindSplitPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maxPeak_Current_fit;
global maxPeak_Current;
global maxPeak_Current_sim;
global V_sweep1_fit;
global V_sweep2_fit;
global V_sweep1;
global V_sweep2;
global GammaFit_param;
global Bias_volt;
global X_on_value;
global Y_on_value;

VarTable = get(handles.VariableListTable,'Data');
Bias_volt = cell2mat(VarTable(18,2))/1000;

Xmin = cell2mat(VarTable(14,2))
Xmax = cell2mat(VarTable(15,2))
Ymin = cell2mat(VarTable(16,2))
Ymax = cell2mat(VarTable(17,2))

xmin = SearchVal(V_sweep1,Xmin)
xmax = SearchVal(V_sweep1,Xmax)
ymin = SearchVal(V_sweep2,Ymin)
ymax = SearchVal(V_sweep2,Ymax)

if(xmin<xmax)
    maxPeak_Current_fit = maxPeak_Current(ymin:ymax,xmin:xmax);
    V_sweep1_fit = V_sweep1(xmin:xmax);
    V_sweep2_fit = V_sweep2(ymin:ymax);
elseif(xmin>xmax)
    maxPeak_Current_fit = maxPeak_Current(ymax:ymin,xmax:xmin);
    V_sweep1_fit = V_sweep1(xmax:xmin);
    V_sweep2_fit = V_sweep2(ymax:ymin);
end

child = get(handles.axes1,'Children');delete(child);
surf(V_sweep1_fit,V_sweep2_fit,log10(maxPeak_Current_fit),'EdgeAlpha',0,'Parent',handles.axes1);
%         surf(V_sweep1_fit,V_sweep2_fit,maxPeak_Current_fit,'EdgeAlpha',0,'Parent',handles.axes1);
title(handles.axes1,'Experimental');xlabel(handles.axes1,'Vsweep1 [V]');ylabel(handles.axes1,'Vsweep2 [V]')
view(handles.axes1,2);colormap('jet');
colorbar(handles.axes1);
set(handles.axes1,'XLim',[min(V_sweep1_fit) max(V_sweep1_fit)]);
set(handles.axes1,'YLim',[min(V_sweep2_fit) max(V_sweep2_fit)]);

%Initial values for fitting

a1_lim = cell2mat(VarTable(8,2));%0.1;
b1_lim = cell2mat(VarTable(9,2));%2;
a2_lim = cell2mat(VarTable(10,2));%0.1;
b2_lim = cell2mat(VarTable(11,2));%2;

Rmin_lim = cell2mat(VarTable(19,2));
Io_lim = cell2mat(VarTable(20,2));
X_on_lim = cell2mat(VarTable(21,2));
Y_on_lim = cell2mat(VarTable(22,2));

n = strfind(Rmin_lim,',');
Rmin.lb = str2double(Rmin_lim(1:n-1));
Rmin.ub = str2double(Rmin_lim(n+1:end));
delta_Rmin = (Rmin.ub - Rmin.lb);
n = strfind(Io_lim,',');
Io.lb = str2double(Io_lim(1:n-1));
Io.ub = str2double(Io_lim(n+1:end));
delta_Io = (Io.ub - Io.lb);
n = strfind(X_on_lim,',');
if(isempty(n))
    X_on_value = str2double(X_on_lim);
else
    X_on.lb = str2double(X_on_lim(1:n-1));
    X_on.ub = str2double(X_on_lim(n+1:end));
    delta_X_on = (X_on.ub - X_on.lb);
    X_on.fit = [];
end
if(isempty(n))
    Y_on_value = str2double(Y_on_lim);    
else
    n = strfind(Y_on_lim,',');
    Y_on.lb = str2double(Y_on_lim(1:n-1));
    Y_on.ub = str2double(Y_on_lim(n+1:end));
    delta_Y_on = (Y_on.ub - Y_on.lb);
    Y_on.fit = [];
end

% Gamma_Fit_type = cell2mat(VarTable(12,2));
%       74.7624    0.0470   63.2273    0.4712
%       99.9999   -0.0139   36.9187    0.6806

n = strfind(a1_lim,',');
if(isempty(n))
    GammaFit_param.a1 = str2double(a1_lim);
end
n = strfind(b1_lim,',');
if(isempty(n))
    GammaFit_param.b1 = str2double(b1_lim);
end
n = strfind(a2_lim,',');
if(isempty(n))
    GammaFit_param.a2 = str2double(a2_lim);
end
n = strfind(b2_lim,',');
if(isempty(n))
    GammaFit_param.b2 = str2double(b2_lim);
end

searchIter = cell2mat(VarTable(13,2));
searchVec = [];
Offset_percent = 0.1;
%lowerbound and upper bound (optional)
if(isempty(X_on_value) && isempty(Y_on_value))
    lb = [Rmin.lb, Io.lb, X_on.lb, Y_on.lb];
    ub = [Rmin.ub, Io.ub, X_on.ub, Y_on.ub];
    
    Io.vec = linspace(Io.lb + Offset_percent*delta_Io, Io.ub - Offset_percent*delta_Io, searchIter)';
    X_on.vec = linspace(X_on.lb + Offset_percent*delta_X_on, X_on.ub - Offset_percent*delta_X_on, searchIter)';
    Y_on.vec = linspace(Y_on.lb + Offset_percent*delta_Y_on, Y_on.ub - Offset_percent*delta_Y_on, searchIter)';
    
    for iii=1:searchIter
        for ii=1:searchIter
            for i=1:searchIter
                newsearchIter = [linspace(Rmin.lb + Offset_percent*delta_Rmin, Rmin.ub - Offset_percent*delta_Rmin, searchIter)',...
                    Io.vec(i)*ones(searchIter,1), X_on.vec(ii)*ones(searchIter,1), Y_on.vec(iii)*ones(searchIter,1)];
                searchVec = [searchVec; newsearchIter];
            end
        end
    end
else
    lb = [Rmin.lb, Io.lb];
    ub = [Rmin.ub, Io.ub];
    
    Io.vec = linspace(Io.lb + Offset_percent*delta_Io, Io.ub - Offset_percent*delta_Io, searchIter)';
    
    for i=1:searchIter
        newsearchIter = [linspace(Rmin.lb + Offset_percent*delta_Rmin, Rmin.ub - Offset_percent*delta_Rmin, searchIter)',...
            Io.vec(i)*ones(searchIter,1)];
        searchVec = [searchVec; newsearchIter];
    end
end

options = optimset('TolFun',1e-10,'TolX',1e-8,'MaxFunEvals',1e3,'MaxIter',1e3);
for i=1:size(searchVec,1)
    par = searchVec(i,:);
    %             Opt_par = fminunc(@FidCalc,par,options);
    Opt_par = fmincon(@FidCalc_TotalCurr,par,[],[],[],[],lb,ub,[],options);
    Opt_par_vec(i,:) = Opt_par;
    Final_Fidelity(i) = FidCalc_TotalCurr(Opt_par);
    
%     pause;
end
child = get(handles.axes3,'Children');delete(child);
line([1:1:size(searchVec,1)],Final_Fidelity,'Parent',handles.axes3,'Color','k','Marker','o');
title(handles.axes3,['Fidelities: ',num2str(min(Final_Fidelity))]);
[MIN_Final_Fidelity, MIN_index] = min(Final_Fidelity)
Fit_var = Opt_par_vec(MIN_index,:)
FidCalc_TotalCurr(Fit_var);

surf(V_sweep1_fit,V_sweep2_fit,log10(maxPeak_Current_sim),'EdgeAlpha',0,'Parent',handles.axes2);
%         surf(V_sweep1_fit,V_sweep2_fit,maxPeak_Current_sim,'EdgeAlpha',0,'Parent',handles.axes2)
title(handles.axes2,['Simulation: ',num2str(MIN_Final_Fidelity)]);xlabel(handles.axes2,'Vsweep1 [V]');ylabel(handles.axes2,'Vsweep2 [V]');
view(handles.axes2,2);colormap('jet');
set(handles.axes2,'XLim',[min(V_sweep1_fit) max(V_sweep1_fit)]);
set(handles.axes2,'YLim',[min(V_sweep2_fit) max(V_sweep2_fit)]);
ColorAxis_Min_Max = [min(min(log10(maxPeak_Current_fit))),max(max(log10(maxPeak_Current_fit)))];
%         ColorAxis_Min_Max = [min(min(maxPeak_Current)),max(max(maxPeak_Current))];
caxis(handles.axes2,ColorAxis_Min_Max);
colorbar(handles.axes2);

%Fitting resultant values
if(isempty(X_on_value) && isempty(Y_on_value))
    Rmin_fit = Fit_var(1);
    Io_fit = Fit_var(2);
    X_on_fit = Fit_var(3);
    Y_on_fit = Fit_var(4);
    
    VarTable = get(handles.VariableListTable,'Data');
    VarTable(19,3) = {Rmin_fit};
    VarTable(20,3) = {Io_fit};
    VarTable(21,3) = {X_on_fit};
    VarTable(22,3) = {Y_on_fit};
    set(handles.VariableListTable,'Data',VarTable);
else
    Rmin_fit = Fit_var(1);
    Io_fit = Fit_var(2);
    
    VarTable = get(handles.VariableListTable,'Data');
    VarTable(19,3) = {Rmin_fit};
    VarTable(20,3) = {Io_fit};
    set(handles.VariableListTable,'Data',VarTable);
end

%{
Gamma_1 = exp(a1.fit*(V_sweep1_fit + b1.fit));
Gamma_2 = exp(a2.fit*(V_sweep2_fit + b2.fit));

%         figure(200);
semilogy(V_sweep1_fit,Gamma_1,'Color','r','Parent',handles.axes4);grid(handles.axes4,'on');
xlabel(handles.axes4,'Vsweep1 [V]');ylabel(handles.axes4,'\Gamma_1 [Hz]');
%         figure(201);
semilogy(V_sweep2_fit,Gamma_2,'Color','k','Parent',handles.axes5);grid(handles.axes5,'on');
xlabel(handles.axes5,'Vsweep2 [V]');ylabel(handles.axes5,'\Gamma_2 [Hz]');

figure(100);
line(V_sweep1_fit,Gamma_1,'Color','r');
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

line(V_sweep2_fit,Gamma_2,'Parent',ax2,'Color','k');
xlabel(ax2,'Vsweep2 [V]');
ylabel(ax2,'\Gamma_2 [Hz]');
grid on;

%}

guidata(hObject, handles);

function fidelity = FidCalc_TotalCurr(par)
global V_sweep1_fit;
global V_sweep2_fit;
global maxPeak_Current_fit;
global maxPeak_Current_sim;
global GammaFit_param;
global Bias_volt;
global X_on_value;
global Y_on_value;

maxPeak_Current_sim = [];
e = 1.602e-19;
% I_min = 1e-12;

if(length(par)>2)
    Rmin = par(1)*1e3;
    Io = par(2)*1e-12;
    X_on = par(3);
    Y_on = par(4);
else
    Rmin = par(1)*1e3;
    Io = par(2)*1e-12;
    X_on = X_on_value;
    Y_on = Y_on_value;
end

% a2 = par(3);
% b2 = par(4);

Gamma_1 = exp(GammaFit_param.a1*(V_sweep1_fit + GammaFit_param.b1));
Gamma_2 = exp(GammaFit_param.a2*(V_sweep2_fit + GammaFit_param.b2));

for y=1:length(Gamma_2)
    for x=1:length(Gamma_1)
        maxPeak_Current_Gamma(y,x) = e*Gamma_2(y)*Gamma_1(x)/(Gamma_2(y) + Gamma_1(x));
    end
end

Rt_exp = Bias_volt./maxPeak_Current_fit;

fun = maxPeak_Current_Gamma.*StepFun(V_sweep1_fit,V_sweep2_fit,X_on,Y_on) + Io*(1 - StepFun(V_sweep1_fit,V_sweep2_fit,X_on,Y_on));
Rt_sim = Rmin + Bias_volt*((Rt_exp - Rmin)./Rt_exp)./fun;
maxPeak_Current_sim = Bias_volt./Rt_sim;

diffSquares = sum(sum((log10(maxPeak_Current_fit) - log10(maxPeak_Current_sim)).^2));
% diffSquares = sum(sum((Total_Resistance_exp - Total_Resistance_sim).^2));

fidelity = diffSquares*1e1;

if(isnan(fidelity))
    diffSquares      
    pause;
end

function output = StepFun(x,y,xo,yo)

for ii=1:length(y)    
    for i=1:length(x)
        H(ii,i) = heaviside(x(i)-xo)*heaviside(y(ii)-yo);
    end
end

output = H;


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

function Index = SearchVal(Vec,val)
for ii=1:length(Vec)
    if(ii<length(Vec))
        if(Vec(ii)<val && Vec(ii+1)>val)
            Index = ii;
            break;
        end
        if(Vec(ii)>val && Vec(ii+1)<val)
            Index = ii;
            break;
        end
    end
    if(Vec(ii)==val)
        Index = ii;
        break;
    end
end

% --- Executes on button press in OpenFigureWindowPushbutton.
function OpenFigureWindowPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFigureWindowPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(0,'CurrentFigure',handles.TunnelRateAnalysis_Figure);
set(0,'ShowHiddenHandles','on');

if(get(handles.AxesNum1Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes1);
    CLim = get(handles.axes1,'CLim');
    
elseif(get(handles.AxesNum2Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes2);
    CLim = get(handles.axes2,'CLim');

elseif(get(handles.AxesNum3Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes3);
    CLim = get(handles.axes3,'CLim');
    
elseif(get(handles.AxesNum4Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes4);
    CLim = get(handles.axes4,'CLim');
    
elseif(get(handles.AxesNum5Radiobutton,'Value')==1)
    set(handles.TunnelRateAnalysis_Figure,'CurrentAxes',handles.axes5);
    CLim = get(handles.axes5,'CLim');
    
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
    EdgeAlpha = get(axs_surf,'EdgeAlpha');
    FaceAlpha = get(axs_surf,'FaceAlpha');
    CData = get(axs_surf,'CData');
    
    figure('WindowStyle','normal','Name','Data Plot');    
    surf(xdata,ydata,zdata,'EdgeColor',EdgeColor,'EdgeAlpha',EdgeAlpha,...
        'FaceAlpha',FaceAlpha,'CData',CData,'CLim',CLim)
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


