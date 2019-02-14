function varargout = ExpDataLog(varargin)
% EXPDATALOG MATLAB code for ExpDataLog.fig
%      EXPDATALOG, by itself, creates a new EXPDATALOG or raises the existing
%      singleton*.
%
%      H = EXPDATALOG returns the handle to a new EXPDATALOG or the handle to
%      the existing singleton*.
%
%      EXPDATALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPDATALOG.M with the given input arguments.
%
%      EXPDATALOG('Property','Value',...) creates a new EXPDATALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExpDataLog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExpDataLog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExpDataLog

% Last Modified by GUIDE v2.5 02-Jan-2019 21:57:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExpDataLog_OpeningFcn, ...
                   'gui_OutputFcn',  @ExpDataLog_OutputFcn, ...
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


% --- Executes just before ExpDataLog is made visible.
function ExpDataLog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExpDataLog (see VARARGIN)

% Choose default command line output for ExpDataLog
handles.output = hObject;

set(handles.VarTable,'Enable','off');
set(handles.NoteEdit,'Enable','off');
set(handles.AddVarPushbutton,'Enable','off');
set(handles.DeleteVarPushbutton,'Enable','off');
set(handles.NumEdit,'Enable','off');
set(handles.NewLoggingTogglebutton,'Enable','off');
set(handles.SaveLoggingTogglebutton,'Enable','off');

handles.WorkDir = cd;

% handles.VarDataTable = [{'V_Sweep1 (First sweep):'},{'Vacc_TL'}; {'V_Sweep2 (Second sweep):'},{'Vacc_TR'}; {'Gate:'},{'Vplg_T_M1'};...
%     {'Current:'},{'Current'}; {'Sens. (V/A):'},{1e-8}; {'Pause:'},{0}; {'Smoothing Iter.'},{1};...
%     {'a1:'},{'0.1,5'}; {'b1:'},{'1,25'}; {'a2:'},{'0.1,5'}; {'b2:'},{'1,25'}; {'Gamman Fit Type [1,2,B]:'},{'B'}; {'Fit Iter.:'},{2};...
%     {'Xmin :'},{0}; {'Xmax :'},{0}; {'Ymin :'},{0}; {'Ymax :'},{0}; {'Volt Bias [mV] :'},{0.5}; {'Rmin [kOhm] :'},{'10,500'};...
%     {'Io [fA]:'},{'1,10'}; {'HeaviSide_xo [V]:'},{'2.3,2.7'}; {'HeaviSide_yo [V]:'},{'2.5,2.9'}];
% set(handles.VariableListTable,'Data',handles.VarDataTable);


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = ExpDataLog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function NoteEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NoteEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NoteEdit as text
%        str2double(get(hObject,'String')) returns contents of NoteEdit as a double


% --- Executes during object creation, after setting all properties.
function NoteEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoteEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddVarPushbutton.
function AddVarPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddVarPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table = get(handles.VarTable,'Data');
newRow = [{'NewVar'},{''},{''},{''}];

newtable = [table;newRow];
set(handles.VarTable,'Data',newtable);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DeleteVarPushbutton.
function DeleteVarPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteVarPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table = get(handles.VarTable,'Data');
numRow = str2double(get(handles.NumEdit,'String'));

if(numRow>1 && numRow<size(table,1))
    newtable = [table(1:numRow-1,:); table(numRow+1:end,:)];
elseif(numRow == 1)
    newtable = table(2:end,:);
elseif(numRow == size(table,1))
    newtable = table(1:numRow-1,:);  
end

set(handles.VarTable,'Data',newtable);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in SaveLoggingTogglebutton.
function SaveLoggingTogglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveLoggingTogglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName = get(handles.FilenameText,'String');
NowDir = cd;
cd(handles.WorkDir);

VarTable = get(handles.VarTable,'Data');
Note = get(handles.NoteEdit,'String')

fileID = fopen(FileName,'a+');
fprintf(fileID,'%-42s\r\n',['>>>Date: ',datestr(today)]);

for i=1:size(VarTable,1)
    VarNameLengths(i) = length(cell2mat(VarTable(i,1)));
end

for i = 1:size(VarTable,1)
    fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s : '], cell2mat(VarTable(i,1)));
    fprintf(fileID,'%10s,', cell2mat(VarTable(i,2)));
    fprintf(fileID,'%10s,', cell2mat(VarTable(i,3)));
    fprintf(fileID,'%10s\r\n', cell2mat(VarTable(i,4)));
end
if(~isempty(Note))
    fprintf(fileID,'%-42s\r\n','>>>Notes:');
    fprintf(fileID,'%-42s\r\n', Note);
end
fprintf(fileID,'%-42s\r\n','-----------------------------------------------');
fclose(fileID);

set(handles.NewLoggingTogglebutton,'Value',0.0);
set(handles.SaveLoggingTogglebutton,'Value',1.0);
set(handles.NewLoggingTogglebutton,'Enable','on');
set(handles.SaveLoggingTogglebutton,'Enable','off');

set(handles.VarTable,'Enable','off');
set(handles.NoteEdit,'Enable','off');
set(handles.AddVarPushbutton,'Enable','off');
set(handles.DeleteVarPushbutton,'Enable','off');
set(handles.NumEdit,'Enable','off');

cd(NowDir);

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in NewLoggingTogglebutton.
function NewLoggingTogglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to NewLoggingTogglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.NewLoggingTogglebutton,'Value',1.0);
set(handles.SaveLoggingTogglebutton,'Value',0.0);
set(handles.NewLoggingTogglebutton,'Enable','off');
set(handles.SaveLoggingTogglebutton,'Enable','on');

set(handles.VarTable,'Enable','on');
set(handles.NoteEdit,'Enable','on');
set(handles.AddVarPushbutton,'Enable','on');
set(handles.DeleteVarPushbutton,'Enable','on');
set(handles.NumEdit,'Enable','on');

% Update handles structure
guidata(hObject, handles);

function NumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumEdit as text
%        str2double(get(hObject,'String')) returns contents of NumEdit as a double


% --- Executes during object creation, after setting all properties.
function NumEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.WorkDir);

[FileName,PathName,FilterIndex] = uiputfile('*.txt','Select directory and filename to save new dta log file');

prompt = {'Enter the DEVICE ID for the current Experiment'};
dlg_title = 'Device ID';
num_lines = 1;
def = {'SiDD???'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

if(isnumeric(FileName)==0 && isempty(answer)==0)
    
    handles.deviceID = answer;
    set(handles.DeviceText,'String',answer);
    set(handles.FilenameText,'String',FileName);
    
    handles.WorkDir = PathName;
    cd(handles.WorkDir);
    fileID = fopen(FileName,'w');
    fprintf(fileID,'%-42s\r\n','***** Experimental Data Logging *****');
    fprintf(fileID,'%-42s\r\n',['Device ID: ',cell2mat(answer)]);
    fprintf(fileID,'%-42s\r\n','');
    fprintf(fileID,'%-42s\r\n','-----------------------------------------------');
    fclose(fileID);
    
    set(handles.VarTable,'Enable','on');
    set(handles.NoteEdit,'Enable','on');
    set(handles.AddVarPushbutton,'Enable','on');
    set(handles.DeleteVarPushbutton,'Enable','on');
    set(handles.NumEdit,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Enable','off');
    set(handles.SaveLoggingTogglebutton,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Value',1.0);
    set(handles.SaveLoggingTogglebutton,'Value',0.0);
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.WorkDir);

[FileName,PathName,FilterIndex] = uigetfile('*.txt','Select file to open');

if(isnumeric(FileName)==0)
    
    handles.WorkDir = PathName;
    cd(handles.WorkDir);
    
    fileID = fopen(FileName,'r');        
    Line = textscan(fileID,'%s',1,'HeaderLines',1,'Delimiter','\r\n');
    Line_str = cell2mat(Line{1});
    n = strfind(Line_str,':');
    deviceInfo = Line_str(n(1)+2:end);
    fclose(fileID);

    set(handles.DeviceText,'String',deviceInfo);
    set(handles.FilenameText,'String',FileName);
       
    set(handles.VarTable,'Enable','on');
    set(handles.NoteEdit,'Enable','on');
    set(handles.AddVarPushbutton,'Enable','on');
    set(handles.DeleteVarPushbutton,'Enable','on');
    set(handles.NumEdit,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Enable','off');
    set(handles.SaveLoggingTogglebutton,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Value',1.0);
    set(handles.SaveLoggingTogglebutton,'Value',0.0);
    
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);
