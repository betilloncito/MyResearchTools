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

% Last Modified by GUIDE v2.5 11-Mar-2019 20:04:34

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
set(handles.DeleteNumEdit,'Enable','off');
set(handles.NewLoggingTogglebutton,'Enable','off');
set(handles.SaveLoggingTogglebutton,'Enable','off');
% set(handles.SavedLogItems_Listbox,'String',{'<<empty>>','<<empty>>',...
%     '<<empty>>','<<empty>>','<<empty>>'});
set(handles.SavedLogItems_Listbox,'String',{...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>'});

handles.WorkDir = cd;
handles.TemplateDir = cd;

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
numRow = str2double(get(handles.DeleteNumEdit,'String'));

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
VarNames_ERROR = 0;
for i=1:size(VarTable,1)
    VarName = cell2mat(VarTable(i,1));
    m = any(strfind(VarName,':'))
    n = strcmp(VarName,'-----------------------------------------------')
    if(m==1 || n==1)
        VarNames_ERROR = 1;
        break;
    end
    VarNameLengths(i) = length(cell2mat(VarTable(i,1)));
    if(i==1)
       FirstEntry_ID = cell2mat(VarTable(i,2));
    end
end
Note = get(handles.NoteEdit,'String');

if(VarNames_ERROR == 0)
    fileID = fopen(FileName,'a+');
    fprintf(fileID,'%-42s\r\n',['>>>Date: ',datestr(today)]);
    %
    % for i=1:size(VarTable,1)
    %     VarNameLengths(i) = length(cell2mat(VarTable(i,1)));
    %     if(i==1)
    %        FirstEntry_ID = cell2mat(VarTable(i,2));
    %     end
    % end
    
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
    set(handles.DeleteNumEdit,'Enable','off');
    
    SavedLogItems_list = get(handles.SavedLogItems_Listbox,'String');
    for i=1:length(SavedLogItems_list)-1
        long_Entry = SavedLogItems_list{i};
        m = strfind(long_Entry,'>');
        n = strfind(long_Entry,'<');
        entry = long_Entry(m(2)+1:n(3)-1);
        if(strcmp(entry,'empty'))
            New_list{i+1} = ['<HTML><FONT color="gray">',entry,'</Font></html>'];
        else
            New_list{i+1} = ['<HTML><FONT color="black">',entry,'</Font></html>'];
        end
    end
    
    % uicontrol(handles.SavedLogItems_Listbox)
    % uicontrol('String', ...
    % {'<HTML><FONT color="red">Hello</Font></html>', 'world', ...
    %  '<html><font style="font-family:impact;color:green"><i>What a', ...
    %  '<Html><FONT color="blue" face="Comic Sans MS">nice day!</font>'});
    
    New_list{1} = ['<HTML><FONT color="red">',FirstEntry_ID,'</Font></html>'];
    set(handles.SavedLogItems_Listbox,'String',New_list);
else
    msgbox('Do NOT use : in Variable Names. Do NOT use - (repeatedly) in Variable Names.', 'Error','error');
    set(handles.SaveLoggingTogglebutton,'Value',0);
end

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
set(handles.DeleteNumEdit,'Enable','on');

% Update handles structure
guidata(hObject, handles);

function DeleteNumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DeleteNumEdit as text
%        str2double(get(hObject,'String')) returns contents of DeleteNumEdit as a double


% --- Executes during object creation, after setting all properties.
function DeleteNumEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DeleteNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function NewLog_Toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to NewLog_Toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.WorkDir);

[FileName,PathName,FilterIndex] = uiputfile('*.txt','Select directory and filename to save new dta log file');

if(isnumeric(FileName)==0)

    prompt = {'Enter the DEVICE ID for the current Experiment'};
    dlg_title = 'Device ID';
    num_lines = 1;
    def = {'SiDD???'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);

    if(isempty(answer)==0)
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
        set(handles.DeleteNumEdit,'Enable','on');
        set(handles.NewLoggingTogglebutton,'Enable','off');
        set(handles.SaveLoggingTogglebutton,'Enable','on');
        set(handles.NewLoggingTogglebutton,'Value',1.0);
        set(handles.SaveLoggingTogglebutton,'Value',0.0);
        
        set(handles.SavedLogItems_Listbox,'String',{...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>'});
    end
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function OpenLog_Toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OpenLog_Toolbar (see GCBO)
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
    
    AllData_nested = textscan(fileID,'%s','HeaderLines',3,'Delimiter','\r\n');
    AllData = AllData_nested{1};
    index1=[];
    for i=size(AllData,1):-1:1
        if(strcmp(AllData{i},'-----------------------------------------------')==1 && isempty(index1)==1)
            index1 = i;     
        elseif(strcmp(AllData{i},'-----------------------------------------------')==1 && isempty(index1)==0)
           index2 = i;
           break;
        end
    end
    count = 1;
    for i=index2+2:index1-3
        Line = AllData{i};
        m = strfind(Line,':');
        VarTable_labels(count, 1:4) = {strtrim(Line(1:m-1)), '' , '' , '' };
        count = count + 1;
    end    
    fclose(fileID);

    set(handles.DeviceText,'String',deviceInfo);
    set(handles.FilenameText,'String',FileName);
    set(handles.VarTable,'Data',VarTable_labels);
       
    set(handles.VarTable,'Enable','on');
    set(handles.NoteEdit,'Enable','on');
    set(handles.AddVarPushbutton,'Enable','on');
    set(handles.DeleteVarPushbutton,'Enable','on');
    set(handles.DeleteNumEdit,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Enable','off');
    set(handles.SaveLoggingTogglebutton,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Value',1.0);
    set(handles.SaveLoggingTogglebutton,'Value',0.0);
       
    set(handles.SavedLogItems_Listbox,'String',{...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>'});
    
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in SavedLogItems_Listbox.
function SavedLogItems_Listbox_Callback(hObject, eventdata, handles)
% hObject    handle to SavedLogItems_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SavedLogItems_Listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SavedLogItems_Listbox


% --- Executes during object creation, after setting all properties.
function SavedLogItems_Listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SavedLogItems_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function OpenLogTemplate_Toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OpenLogTemplate_Toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.TemplateDir);

[FileName,PathName,FilterIndex] = uigetfile('*.txt','Select template file to open');

if(isnumeric(FileName)==0)
    handles.TemplateDir = PathName;
    cd(handles.TemplateDir);
    
    fileID = fopen(FileName,'r');
    
    Data = textscan(fileID, '%s','Delimiter','\r\n');
    Template_Lines = Data{1};
    for i=2:length(Template_Lines)
        VarTable_labels(i-1,1:4) = {strtrim(cell2mat(Template_Lines(i))),'','',''}
    end
    set(handles.VarTable,'Data',VarTable_labels);
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);



% --------------------------------------------------------------------
function SaveLogTemplate_Toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to SaveLogTemplate_Toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.TemplateDir);

[FileName,PathName,FilterIndex] = uiputfile('*.txt','Select template filename and directory to save template');

if(isnumeric(FileName)==0)
    handles.TemplateDir = PathName;
    cd(handles.TemplateDir);
    
    VarTable = get(handles.VarTable,'Data');
    fileID = fopen(FileName,'w');
    fprintf(fileID,'%-42s\r\n',['>>>Date: ',datestr(today)]);
    
    for i=1:size(VarTable,1)
        VarNameLengths(i) = length(cell2mat(VarTable(i,1)));
    end
    
    for i = 1:size(VarTable,1)
        fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s\r\n'],cell2mat(VarTable(i,1)))
    end
end

cd(NowDir);

% Update handles structure
guidata(hObject, handles);


