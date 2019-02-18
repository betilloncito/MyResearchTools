function varargout = ExpAnalysisLog(varargin)
% EXPANALYSISLOG MATLAB code for ExpAnalysisLog.fig
%      EXPANALYSISLOG, by itself, creates a new EXPANALYSISLOG or raises the existing
%      singleton*.
%
%      H = EXPANALYSISLOG returns the handle to a new EXPANALYSISLOG or the handle to
%      the existing singleton*.
%
%      EXPANALYSISLOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPANALYSISLOG.M with the given input arguments.
%
%      EXPANALYSISLOG('Property','Value',...) creates a new EXPANALYSISLOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExpAnalysisLog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExpAnalysisLog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExpAnalysisLog

% Last Modified by GUIDE v2.5 17-Feb-2019 03:38:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExpAnalysisLog_OpeningFcn, ...
                   'gui_OutputFcn',  @ExpAnalysisLog_OutputFcn, ...
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


% --- Executes just before ExpAnalysisLog is made visible.
function ExpAnalysisLog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExpAnalysisLog (see VARARGIN)

% Choose default command line output for ExpAnalysisLog
handles.output = hObject;
handles.WorkDir = cd;
handles.TemplateDir = cd;

cd('.\Icons');
openDir_image = imread('SelectFolder-icon.jpg');
openFile_image = imread('SelectFile-icon.jpg');
newFile_image = imread('NewFile-icon.jpg');
inDir_image = imread('InFolder-icon.jpg');
outDir_image = imread('OutFolder-icon.jpg');
AddVar_image = imread('Add-icon.jpg');
DeleteVar_image = imread('Delete-icon.jpg');
NewLogging_image = imread('letter-new-icon.jpg');
SaveLogging_image = imread('letter-saved-icon.jpg');
cd('..')
set(handles.OpenDirectoryPushbutton,'CData',openDir_image);
set(handles.InDirectoryPushbutton,'CData',inDir_image);
set(handles.OutDirectoryPushbutton,'CData',outDir_image);
set(handles.OpenFilePushbutton,'CData',openFile_image);
set(handles.NewFilePushbutton,'CData',newFile_image);
set(handles.AddVarPushbutton,'CData',AddVar_image);
set(handles.DeleteVarPushbutton,'CData',DeleteVar_image);
set(handles.NewLoggingTogglebutton,'CData',NewLogging_image);
set(handles.SaveLoggingTogglebutton,'CData',SaveLogging_image);

EntryList = [{'Select an Entry...'},{'Wafer Fabrication Description'},...
    {'Probe Station Measurement'},{'Annealing'},{'Wirebonding'},{'Storage'}];
set(handles.EntryListPopupmenu,'String',EntryList);
set(handles.EntryListPopupmenu,'Value',1);
set(handles.EntryListPopupmenu,'Enable','off');
set(handles.LogbookRadiobutton,'Value',1);
set(handles.LogbookRadiobutton,'Enable','off');
set(handles.ExperimentRadiobutton,'Enable','off');
set(handles.TodayEdit,'Enable','off');
set(handles.TodayCheckbox,'Enable','off');
set(handles.TodayCheckbox,'Value',1);
set(handles.TodayEdit,'String',datestr(today));
set(handles.VarTable,'Enable','off');
set(handles.AddVarPushbutton,'Enable','off');
set(handles.DeleteVarPushbutton,'Enable','off');
set(handles.DeleteNumEdit,'Enable','off');
set(handles.InDirectoryPushbutton,'Enable','off');
set(handles.OutDirectoryPushbutton,'Enable','off');
set(handles.OpenFilePushbutton,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExpAnalysisLog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ExpAnalysisLog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FolderContents_Listbox.
function FolderContents_Listbox_Callback(hObject, eventdata, handles)
% hObject    handle to FolderContents_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FolderContents_Listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FolderContents_Listbox


% --- Executes during object creation, after setting all properties.
function FolderContents_Listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FolderContents_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenDirectoryPushbutton.
function OpenDirectoryPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenDirectoryPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
folder_name = uigetdir(handles.WorkDir, 'Select directory and filename to save new dta log file');
if(folder_name~=0)
    cd(folder_name);
    handles.WorkDir = folder_name;
    
    List_folders = dir;
    List_folders_cell={};folder_FLAG=0;
    for i=1:size(List_folders,1)
        if(strcmp(List_folders(i).name,'.')==0 && ...
                strcmp(List_folders(i).name,'..')==0)
            List_folders_cell(i-2,1) = {List_folders(i).name};
            folder_FLAG(i) = ~any(strfind(List_folders(i).name,'.'))
        end
    end
    cd(NowDir);
    if(isempty(List_folders_cell)==0)
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',List_folders_cell);
    else
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',{''});
    end
    if(any(folder_FLAG))
        set(handles.InDirectoryPushbutton,'Enable','on');
    else
        set(handles.InDirectoryPushbutton,'Enable','off');
    end
    set(handles.RootDirText,'String',handles.WorkDir);
    set(handles.OutDirectoryPushbutton,'Enable','on');
    set(handles.OpenFilePushbutton,'Enable','on');
    set(handles.NewFilePushbutton,'Enable','on');
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in OutDirectoryPushbutton.
function OutDirectoryPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OutDirectoryPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.WorkDir);
cd('..')
handles.WorkDir = cd;

List_folders = dir;
List_folders_cell={};
for i=1:size(List_folders,1)
    if(strcmp(List_folders(i).name,'.')==0 && ...
            strcmp(List_folders(i).name,'..')==0)
        List_folders_cell(i-2,1) = {List_folders(i).name};
    end
end
cd(NowDir);
if(isempty(List_folders_cell)==0)
    set(handles.FolderContents_Listbox,'Value',1);
    set(handles.FolderContents_Listbox,'String',List_folders_cell);
else
    set(handles.FolderContents_Listbox,'Value',1);
    set(handles.FolderContents_Listbox,'String',{''});    
end
set(handles.RootDirText,'String',handles.WorkDir);
set(handles.InDirectoryPushbutton,'Enable','on');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in InDirectoryPushbutton.
function InDirectoryPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to InDirectoryPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.WorkDir);
Listbox_Folders = get(handles.FolderContents_Listbox,'String');
Listbox_Value = get(handles.FolderContents_Listbox,'Value');
Listbox_Selection = Listbox_Folders(Listbox_Value)
cd(['.\',cell2mat(Listbox_Selection)])
handles.WorkDir = cd;

List_folders = dir;
List_folders_cell={};folder_FLAG=0;
for i=1:size(List_folders,1)
    if(strcmp(List_folders(i).name,'.')==0 && ...
            strcmp(List_folders(i).name,'..')==0)
        List_folders_cell(i-2,1) = {List_folders(i).name};
        folder_FLAG(i) = ~any(strfind(List_folders(i).name,'.'));
    end
end
cd(NowDir);
if(isempty(List_folders_cell)==0)
    set(handles.FolderContents_Listbox,'Value',1);
    set(handles.FolderContents_Listbox,'String',List_folders_cell);
else
    set(handles.FolderContents_Listbox,'Value',1);
    set(handles.FolderContents_Listbox,'String',{''});    
end
if(any(folder_FLAG))
    set(handles.InDirectoryPushbutton,'Enable','on');
else
    set(handles.InDirectoryPushbutton,'Enable','off');
end
set(handles.RootDirText,'String',handles.WorkDir);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in AddVarPushbutton.
function AddVarPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddVarPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table = get(handles.VarTable,'Data');
newRow = [{'NewVar'},{''}];

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
if(~isnan(numRow))
    if(numRow>1 && numRow<size(table,1))
        newtable = [table(1:numRow-1,:); table(numRow+1:end,:)];
    elseif(numRow == 1)
        newtable = table(2:end,:);
    elseif(numRow == size(table,1))
        newtable = table(1:numRow-1,:);
    end
    set(handles.VarTable,'Data',newtable);
else
    msgbox('Enter a row number to delete', 'Error','error');
end
% Update handles structure
guidata(hObject, handles);

function DeleteNumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function CommentEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CommentEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in OpenFilePushbutton.
function OpenFilePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFilePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Listbox_Folders = get(handles.FolderContents_Listbox,'String');
Listbox_Value = get(handles.FolderContents_Listbox,'Value');
Listbox_Selection = Listbox_Folders(Listbox_Value);

file_FLAG = any(strfind(cell2mat(Listbox_Selection),'.'));
if(file_FLAG)
    handles.FileDir = [handles.WorkDir,'\',Listbox_Selection];
    set(handles.FilenameText,'String',Listbox_Selection);
    
    set(handles.VarTable,'Enable','on');
    set(handles.CommentEdit,'Enable','on');
    set(handles.AddVarPushbutton,'Enable','on');
    set(handles.DeleteVarPushbutton,'Enable','on');
    set(handles.DeleteNumEdit,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Enable','off');
    set(handles.SaveLoggingTogglebutton,'Enable','on');
    set(handles.NewLoggingTogglebutton,'Value',1.0);
    set(handles.SaveLoggingTogglebutton,'Value',0.0);
    
    set(handles.LogbookRadiobutton,'Enable','on');
    set(handles.ExperimentRadiobutton,'Enable','on');
    set(handles.EntryListPopupmenu,'Enable','on');
    set(handles.TodayCheckbox,'Enable','on');
else
    msgbox('Select a file NOT a folder', 'Error','error');    
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in NewFilePushbutton.
function NewFilePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to NewFilePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NowDir = cd;
cd(handles.WorkDir);

[FileName,PathName,FilterIndex] = uiputfile('*.txt','Select directory and filename to save new log file');

if(isnumeric(FileName)==0)
    prompt = {'Wafer ID:', 'Design ID:','DEVICE ID:','Taken from QNC on:'};
    dlg_title = 'Enter IDs for sample';
    num_lines = 1;
    def = {'W','SiDD','M',datestr(today)};
    answer = inputdlg(prompt,dlg_title,num_lines,def);

    if(isempty(answer)==0)
        handles.WaferID = answer{1};
        handles.DesignID = answer{2};
        handles.MarkerID = answer{3};
        handles.DateQNC2RAC = answer{4};
        set(handles.WaferLabelText,'String',handles.WaferID);
        set(handles.DesignLabelText,'String',handles.DesignID);
        set(handles.MarkerLabelText,'String',handles.MarkerID);
        set(handles.FilenameText,'String',FileName);
        
        handles.WorkDir = PathName;
        cd(handles.WorkDir);
        fileID = fopen(FileName,'w');
        fprintf(fileID,'%-42s\r\n','********************LOGBOOK********************');
        fprintf(fileID,'%-17s : ','Wafer');fprintf(fileID,'%1s\r\n', handles.WaferID);
        fprintf(fileID,'%-17s : ','Design');fprintf(fileID,'%1s\r\n', handles.DesignID);
        fprintf(fileID,'%-17s : ','Marker');fprintf(fileID,'%1s\r\n', handles.MarkerID);
        fprintf(fileID,'%-17s : ','Taken from QNC on');fprintf(fileID,'%1s\r\n', handles.DateQNC2RAC);
        fprintf(fileID,'%-42s\r\n','***********************************************');
        fprintf(fileID,'%-42s\r\n','');
        fprintf(fileID,'%-42s\r\n','-----------------------------------------------');
        fclose(fileID);
        cd(NowDir);

        set(handles.VarTable,'Enable','on');
        set(handles.CommentEdit,'Enable','on');
        set(handles.AddVarPushbutton,'Enable','on');
        set(handles.DeleteVarPushbutton,'Enable','on');
        set(handles.DeleteNumEdit,'Enable','on');
        set(handles.NewLoggingTogglebutton,'Enable','off');
        set(handles.SaveLoggingTogglebutton,'Enable','on');
        set(handles.NewLoggingTogglebutton,'Value',1.0);
        set(handles.SaveLoggingTogglebutton,'Value',0.0);
        
        set(handles.LogbookRadiobutton,'Enable','on');
        set(handles.ExperimentRadiobutton,'Enable','on');
        set(handles.EntryListPopupmenu,'Enable','on');
        set(handles.TodayCheckbox,'Enable','on');
    end
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
set(handles.CommentEdit,'Enable','on');
set(handles.AddVarPushbutton,'Enable','on');
set(handles.DeleteVarPushbutton,'Enable','on');
set(handles.DeleteNumEdit,'Enable','on');

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
Comment = get(handles.CommentEdit,'String');

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
        fprintf(fileID,'%10s\r\n', cell2mat(VarTable(i,2)));
    end
    if(~isempty(Comment))
        fprintf(fileID,'%-42s\r\n','>>>Notes:');
        fprintf(fileID,'%-42s\r\n', Comment);
    end
    fprintf(fileID,'%-42s\r\n','-----------------------------------------------');
    fclose(fileID);
    
    set(handles.NewLoggingTogglebutton,'Value',0.0);
    set(handles.SaveLoggingTogglebutton,'Value',1.0);
    set(handles.NewLoggingTogglebutton,'Enable','on');
    set(handles.SaveLoggingTogglebutton,'Enable','off');
    
    set(handles.VarTable,'Enable','off');
    set(handles.CommentEdit,'Enable','off');
    set(handles.AddVarPushbutton,'Enable','off');
    set(handles.DeleteVarPushbutton,'Enable','off');
    set(handles.DeleteNumEdit,'Enable','off');
    
%     SavedLogItems_list = get(handles.SavedLogItems_Listbox,'String');
%     for i=1:length(SavedLogItems_list)-1
%         long_Entry = SavedLogItems_list{i};
%         m = strfind(long_Entry,'>');
%         n = strfind(long_Entry,'<');
%         entry = long_Entry(m(2)+1:n(3)-1);
%         if(strcmp(entry,'empty'))
%             New_list{i+1} = ['<HTML><FONT color="gray">',entry,'</Font></html>'];
%         else
%             New_list{i+1} = ['<HTML><FONT color="black">',entry,'</Font></html>'];
%         end
%     end
        
%     New_list{1} = ['<HTML><FONT color="red">',FirstEntry_ID,'</Font></html>'];
%     set(handles.SavedLogItems_Listbox,'String',New_list);
else
    msgbox('Do NOT use : in Variable Names. Do NOT use - (repeatedly) in Variable Names.', 'Error','error');
    set(handles.SaveLoggingTogglebutton,'Value',0);
end

cd(NowDir);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ExperimentRadiobutton.
function ExperimentRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExperimentRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EntryList = [{'Select an Entry...'},{'77k Dipper'},{'4k Dipper'},{'Janis'},...
    {'Dilution Fridge'}];
set(handles.EntryListPopupmenu,'String',EntryList);
set(handles.EntryListPopupmenu,'Value',1);
set(handles.EntryListPopupmenu,'Enable','on');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in LogbookRadiobutton.
function LogbookRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to LogbookRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EntryList = [{'Select an Entry...'},{'Wafer Fabrication Description'},...
    {'Probe Station Measurement'},{'Annealing'},{'Wirebonding'},{'Storage'}];
set(handles.EntryListPopupmenu,'String',EntryList);
set(handles.EntryListPopupmenu,'Value',1);
set(handles.EntryListPopupmenu,'Enable','on');

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in EntryListPopupmenu.
function EntryListPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EntryListPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in TodayCheckbox.
function TodayCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to TodayCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.TodayCheckbox,'Value'))
    set(handles.TodayEdit,'Enable','off');
    set(handles.TodayEdit,'String',datestr(today));
else
    set(handles.TodayEdit,'Enable','on');
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function OpenTemplate_Toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OpenTemplate_Toolbar (see GCBO)
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
    for i=1:length(Template_Lines)
        Line = cell2mat(Template_Lines(i));
        if(any(strfind(Line,'{')))
            VarTable_labels(i,1:2) = {strtrim(Line),''};
        else
            m = strfind(Line,':');
            VarTable_labels(i,1:2) = {strtrim(Line(1:m-1)),strtrim(Line(m+1:end))};
        end
    end
    set(handles.VarTable,'Data',VarTable_labels);
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function SaveTemplate_Toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to SaveTemplate_Toolbar (see GCBO)
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
    
    for i=1:size(VarTable,1)
        VarNameLengths(i) = length(cell2mat(VarTable(i,1)));
    end
    for i = 1:size(VarTable,1)
        if(any(strfind(cell2mat(VarTable(i,1)),'{')))
            fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s\r\n'], cell2mat(VarTable(i,1)));
        else
            fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s : '], cell2mat(VarTable(i,1)));
            fprintf(fileID,'%1s\r\n', cell2mat(VarTable(i,2)));
            %         fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s\r\n'],cell2mat(VarTable(i,1)))
        end
    end
end

cd(NowDir);

% Update handles structure
guidata(hObject, handles);

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

% --- Executes during object creation, after setting all properties.
function TodayEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TodayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function EntryListPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EntryListPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TodayEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TodayEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TodayEdit as text
%        str2double(get(hObject,'String')) returns contents of TodayEdit as a double

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

% --- Executes during object creation, after setting all properties.
function CommentEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CommentEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
