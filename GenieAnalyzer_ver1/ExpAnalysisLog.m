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

% Last Modified by GUIDE v2.5 26-Mar-2019 13:02:04

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

%Loads all the button icons jpg and saves the images
cd('.\Icons');
openDir_image = imread('SelectFolder-icon.jpg');
HomeDir_image = imread('HomeFolder-icon.jpg');
openFile_image = imread('SelectFile-icon.jpg');
newFile_image = imread('NewFile-icon.jpg');
inDir_image = imread('InFolder-icon.jpg');
outDir_image = imread('OutFolder-icon.jpg');
AddVar_image = imread('Add-icon.jpg');
DeleteVar_image = imread('Delete-icon.jpg');
NewLogging_image = imread('letter-new-icon.jpg');
SaveLogging_image = imread('letter-saved-icon.jpg');
cd('..')

%Initializes the images for all the buttons
set(handles.OpenDirectoryPushbutton,'CData',openDir_image);
set(handles.OpenHomeDirectoryPushbutton,'CData',HomeDir_image);
set(handles.InDirectoryPushbutton,'CData',inDir_image);
set(handles.OutDirectoryPushbutton,'CData',outDir_image);
set(handles.OpenFilePushbutton,'CData',openFile_image);
set(handles.NewFilePushbutton,'CData',newFile_image);
set(handles.AddVarPushbutton,'CData',AddVar_image);
set(handles.DeleteVarPushbutton,'CData',DeleteVar_image);
set(handles.NewLoggingTogglebutton,'CData',NewLogging_image);
set(handles.SaveLoggingTogglebutton,'CData',SaveLogging_image);

%Initialization of uicontrols and global variables
set(handles.OverwriteCheckbox,'Value',0);
set(handles.OverwriteCheckbox,'Enable','off');
set(handles.FileViewerText,'HorizontalAlignment','left');
set(handles.SaveLoggingTogglebutton,'Enable','off');
set(handles.SavedLogItems_Listbox,'String',{...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>',...
    '<HTML><FONT color="gray">empty</Font></html>'});
EntryList = [{'Select an Entry...'},{'Wafer Fabrication Description'},...
    {'Probe Station Measurement'},{'Annealing'},{'Wirebonding'},{'Storage'},{'Miscellaneous'}];
handles.EntryList_choice = 1;
set(handles.EntryListPopupmenu,'Value',handles.EntryList_choice);
set(handles.EntryListPopupmenu,'String',EntryList);
set(handles.EntryListPopupmenu,'Value',1);
set(handles.EntryListPopupmenu,'Enable','off');
set(handles.HeaderCheckbox,'Enable','off');
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
set(handles.SavedLogItems_Listbox,'Enable','on');

%Reset the table to be empty and have only 2 columns
set(handles.VarTable,'Data',{'',''});
set(handles.VarTable,'ColumnEditable',[true true true true]);
set(handles.VarTable,'ColumnName',{'<empty>'; '<empty>'});
set(handles.VarTable,'ColumnWidth',{130 280});
set(handles.VarTable,'ColumnFormat',{'char','char'});
set(handles.VarTable,'RowName','numbered');

%Global variables
handles.VarTable_ColumnFormat.SampleStatusRecord = {'char',{'Currently Testing', 'Defective (Useless)',...
                    'Defective (Useful)', 'Good Device'},'char',{'None', '77K', '4K', 'Janis', 'Fridge'}};
handles.FileTypeList = {'Experiment Data', 'Experiment Analysis', 'Logbook (Wafer)', 'Logbook (Marker)',...
    'Sample Status Record'};
handles.FileType_Headings = {'****************EXPERIMENT-DATA****************',...
                '**************EXPERIMENT-ANALYSIS**************',...
                '*****************LOGBOOK-WAFER*****************',...
                '****************LOGBOOK-MARKERS****************',...
                '**************SAMPLE-STATUS-RECORD*************'};

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

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in OpenHomeDirectoryPushbutton.
function OpenHomeDirectoryPushbutton_Callback(hObject, eventdata, handles)

%Saves working directory
NowDir = cd;
%Possible Drive labels for SeaGate hard drive. Add more labels is needed
HomeDriveLabels = [{'D'};{'E'};{'F'}];
FolderFound = 0;%flag
%Searches to see if the hard drive is connected
for i=1:length(HomeDriveLabels)
    %Home directory. Location of the folder within the hard drive is hard
    %coded. Need to edit the folder location accordingly
    handles.HOME_folder_name = [cell2mat(HomeDriveLabels(i)),':\Waterloo - SeaGate\Spintronics Research\Quantum Dots\TestedDevices\SiDots\JEOL-devices'];
    if(exist(handles.HOME_folder_name,'dir')==7)
        FolderFound =  1;
        break;
    end
end
%Executes if the seagate hard drive was found
if(FolderFound==1)
    cd(handles.HOME_folder_name);
    handles.WorkDir = handles.HOME_folder_name;
    handles.TemplateDir = handles.HOME_folder_name;
    
    List_folders = dir;
    List_folders_cell={};folder_FLAG=0;
    %Extracts the contents of the home directory
    for i=1:size(List_folders,1)
        if(strcmp(List_folders(i).name,'.')==0 && ...
                strcmp(List_folders(i).name,'..')==0)
            List_folders_cell(i-2,1) = {List_folders(i).name};
            folder_FLAG(i) = ~any(strfind(List_folders(i).name,'.'));
        end
    end
    cd(NowDir);
    
    %Displays the home directory contents in the FolderContents_Listbox 
    if(isempty(List_folders_cell)==0)
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',List_folders_cell);
    else
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',{''});
    end
    
    %Enables the In directory button if there are any folders in the home
    %directory
    if(any(folder_FLAG))
        set(handles.InDirectoryPushbutton,'Enable','on');
    else
        set(handles.InDirectoryPushbutton,'Enable','off');
    end
    set(handles.RootDirText,'String',handles.WorkDir);
    set(handles.OutDirectoryPushbutton,'Enable','on');
    set(handles.OpenFilePushbutton,'Enable','on');
    set(handles.NewFilePushbutton,'Enable','on');
else
    msgbox('HOME folder was not found! Seagate Hard Drive is not connected.', 'Error','error');
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in OpenDirectoryPushbutton.
function OpenDirectoryPushbutton_Callback(hObject, eventdata, handles)

%Asks user for a directory to open
NowDir = cd;
folder_name = uigetdir(handles.WorkDir, 'Select directory and filename to save new dta log file');

%Executes if the user chose a directory
if(folder_name~=0)
    cd(folder_name);
    handles.WorkDir = folder_name;
    
    %Extracts the contents of the chosen directory
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
    
    %Displays the chosen directory contents in the FolderContents_Listbox
    if(isempty(List_folders_cell)==0)
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',List_folders_cell);
    else
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',{''});
    end
    %Enables the In directory button if there are any folders in the home
    %directory
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

%Moves out of the current directory
NowDir = cd;
cd(handles.WorkDir);
cd('..')
handles.WorkDir = cd;

%Extracts the contents of the new directory
List_folders = dir;
List_folders_cell={};
for i=1:size(List_folders,1)
    if(strcmp(List_folders(i).name,'.')==0 && ...
            strcmp(List_folders(i).name,'..')==0)
        List_folders_cell(i-2,1) = {List_folders(i).name};
    end
end
cd(NowDir);

%Displays the chosen directory contents in the FolderContents_Listbox
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

NowDir = cd;
%Extracts the chosen folder by the user
Listbox_Folders = get(handles.FolderContents_Listbox,'String');
Listbox_Value = get(handles.FolderContents_Listbox,'Value');
Listbox_Selection = Listbox_Folders(Listbox_Value);
cd(handles.WorkDir);
%Determines if the chosen directory is a folder
exist(['.\',cell2mat(Listbox_Selection)],'dir')
%Executes if the chosen directory is a folder
if(exist(['.\',cell2mat(Listbox_Selection)],'dir'))
    cd(['.\',cell2mat(Listbox_Selection)])
    handles.WorkDir = cd;
    
    %Extracts the contents of the new directory
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
    
    %Displays the chosen directory contents in the FolderContents_Listbox
    if(isempty(List_folders_cell)==0)
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',List_folders_cell);
    else
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',{''});
    end
    
    %Enables the In directory button if there are any folders in the home
    %directory
    if(any(folder_FLAG))
        set(handles.InDirectoryPushbutton,'Enable','on');
    else
        set(handles.InDirectoryPushbutton,'Enable','off');
    end
    set(handles.RootDirText,'String',handles.WorkDir);
else
    msgbox('A file was selected, you must select a folder to open.', 'Error','error');
    cd(NowDir);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in AddVarPushbutton.
function AddVarPushbutton_Callback(hObject, eventdata, handles)

%Determines the number of columns
table = get(handles.VarTable,'Data');
colNum = size(table,2);

%Choses the correct rwo to add based on the number of columns
if(colNum==2)
    newRow = [{'NewVar'},{''}];
elseif(colNum==4)
    newRow = [{'NewVar'},{''},{''},{''}];
end
%The row number chosen by user
numRow = str2double(get(handles.DeleteNumEdit,'String'));
%Determines how to add a row depending on whether the user provided a row
%number and if so it adds the row in its correct location
if(~isnan(numRow) && numRow<size(table,1))
    if(numRow>1 && numRow<size(table,1))
        newtable = [table(1:numRow-1,:); newRow; table(numRow:end,:)];
    elseif(numRow == 1)
        newtable = [newRow; table(1:end,:)];
    end
else
    newtable = [table;newRow];
end
set(handles.VarTable,'Data',newtable);
    
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DeleteVarPushbutton.
function DeleteVarPushbutton_Callback(hObject, eventdata, handles)

table = get(handles.VarTable,'Data');
%The row number chosen by user
numRow = str2double(get(handles.DeleteNumEdit,'String'));
%Determines how to delete a row depending on whether the user provided a row
%number and if so it deletes the row in its correct location
if(~isnan(numRow) && numRow<=size(table,1))
    if(numRow>1 && numRow<size(table,1))
        newtable = [table(1:numRow-1,:); table(numRow+1:end,:)];
    elseif(numRow == 1)
        newtable = table(2:end,:);
    elseif(numRow == size(table,1))
        newtable = table(1:numRow-1,:);
    end
    set(handles.VarTable,'Data',newtable);
%In case the user row number is higher than the number of rows
elseif(numRow>size(table,1))
    msgbox('Row number to be deleted is too HIGH', 'Error','error');
%If the user did not specify a row number to delete then it deletes the last    
else
    numRow = size(table,1);
    newtable = table(1:numRow-1,:);
    set(handles.VarTable,'Data',newtable);
end
% Update handles structure
guidata(hObject, handles);

function DeleteNumEdit_Callback(hObject, eventdata, handles)

function CommentEdit_Callback(hObject, eventdata, handles)

% --- Executes on button press in OpenFilePushbutton.
function OpenFilePushbutton_Callback(hObject, eventdata, handles)
Listbox_Folders = get(handles.FolderContents_Listbox,'String');
Listbox_Value = get(handles.FolderContents_Listbox,'Value');
Listbox_Selection = Listbox_Folders(Listbox_Value);
%Determines whether the chosen item is a file 
file_FLAG = any(strfind(cell2mat(Listbox_Selection),'.'));
FileType_ERROR = 0;
%Exceutes if the chosen item was a file
if(file_FLAG)
    %directory for the chosen file
    handles.FileDir = [handles.WorkDir,'\',Listbox_Selection];        
    NowDir = cd;
    cd(handles.WorkDir)
    %Opens the chosen file and saves the data into "Data"
    fileID = fopen(cell2mat(Listbox_Selection),'r');    
    Data = textscan(fileID, '%s','Delimiter','\r\n');%cell  
    fclose(fileID);%close file ID
    Template_Lines = Data{1};%Turns the data into a non-cell
    %Displays the contents of the FileViewerText field
    set(handles.FileViewerText,'String',Template_Lines);
    set(handles.FileViewerText,'Value',1);%Always sets to 1 to avoid errors
    %headings that determines which type of file is opened
    experimentData_FileType = strcmp(Template_Lines(1),handles.FileType_Headings(1));
    experimentAnalysis_FileType = strcmp(Template_Lines(1),handles.FileType_Headings(2));
    logbookWafer_FileType = strcmp(Template_Lines(1),handles.FileType_Headings(3));
    logbookMarker_FileType = strcmp(Template_Lines(1),handles.FileType_Headings(4));
    SampleStatus_FileType = strcmp(Template_Lines(1),handles.FileType_Headings(5));

    %Makes sure that the chosen file has the only '3'  correct headings
    if(experimentData_FileType==1 || experimentAnalysis_FileType==1 || logbookWafer_FileType==1 || logbookMarker_FileType==1 || SampleStatus_FileType==1)
        %Executes if the heading is 'Experiment Data'
        if(experimentData_FileType==1)
            set(handles.FileTypeText,'String',handles.FileTypeList(1));
            set(handles.EntryListPopupmenu,'Value',1);
            set(handles.EntryListPopupmenu,'Enable','off');
            set(handles.HeaderCheckbox,'Enable','off');
            set(handles.OverwriteCheckbox,'Enable','on');
            set(handles.OverwriteCheckbox,'Value',0);
            %settings for the table
            set(handles.VarTable,'Data',{'','','',''});
            set(handles.VarTable,'ColumnEditable',[true true true true]);
            set(handles.VarTable,'ColumnName',{'Variable Name'; 'Start'; 'End'; 'Num. Pts'});
            set(handles.VarTable,'ColumnWidth',{130 95 95 95});
            set(handles.VarTable,'ColumnFormat',{'char','char','char','char'});
            set(handles.VarTable,'RowName','numbered');
            
            %Executes if the heading is Experiment Analysis
        elseif(experimentAnalysis_FileType==1)
            set(handles.FileTypeText,'String',handles.FileTypeList(2));
            EntryList = [{'Select an Entry...'},{'77k Dipper'},{'4k Dipper'},{'Janis'},...
                {'Dilution Fridge'}];
            set(handles.EntryListPopupmenu,'String',EntryList);
            set(handles.EntryListPopupmenu,'Value',1);
            set(handles.EntryListPopupmenu,'Enable','on');
            set(handles.HeaderCheckbox,'Enable','on');
            set(handles.OverwriteCheckbox,'Enable','on');
            set(handles.OverwriteCheckbox,'Value',0);
            %settings for the table
            set(handles.VarTable,'Data',{'',''});
            set(handles.VarTable,'ColumnEditable',[true true]);
            set(handles.VarTable,'ColumnName',{'Variable Name'; 'Value'});
            set(handles.VarTable,'ColumnWidth',{150 260});
            set(handles.VarTable,'ColumnFormat',{'char','char'});
            set(handles.VarTable,'RowName','numbered');
            
            %Executes if the heading is Logbook
        elseif(logbookWafer_FileType==1 || logbookMarker_FileType==1)
            if(logbookWafer_FileType==1)
                set(handles.FileTypeText,'String',handles.FileTypeList(3));
            elseif(logbookMarker_FileType==1)
                set(handles.FileTypeText,'String',handles.FileTypeList(4));
            end
            EntryList = [{'Select an Entry...'},{'Wafer Fabrication Description'},...
                {'Probe Station Measurement'},{'Annealing'},{'Wirebonding'},{'Storage'},...
                {'Miscellaneous'},{'77k Dipper'},{'4k Dipper'},{'Janis'},...
                {'Dilution Fridge'}];
            set(handles.EntryListPopupmenu,'String',EntryList);
            set(handles.EntryListPopupmenu,'Value',1);
            set(handles.EntryListPopupmenu,'Enable','on');
            set(handles.HeaderCheckbox,'Enable','on');
            set(handles.OverwriteCheckbox,'Enable','on');
            set(handles.OverwriteCheckbox,'Value',0);
            %settings for the table
            set(handles.VarTable,'Data',{'',''});
            set(handles.VarTable,'ColumnEditable',[true true]);
            set(handles.VarTable,'ColumnName',{'Variable Name'; 'Value'});
            set(handles.VarTable,'ColumnWidth',{130 280});
            set(handles.VarTable,'ColumnFormat',{'char','char'});
            set(handles.VarTable,'RowName','numbered');
        %Executes if the heading is Sample Status Record
        elseif(SampleStatus_FileType==1)
            set(handles.FileTypeText,'String',handles.FileTypeList(5));       
            set(handles.EntryListPopupmenu,'Value',1);
            set(handles.EntryListPopupmenu,'Enable','off');
            set(handles.HeaderCheckbox,'Enable','off');
            set(handles.OverwriteCheckbox,'Enable','on');
            set(handles.OverwriteCheckbox,'Value',1);
            %settings for the table
            set(handles.VarTable,'Data',{'','','',''});
            set(handles.VarTable,'ColumnName',{'Marker Label'; 'Status'; 'Exp. Completed'; 'Next Exp.'});
            set(handles.VarTable,'ColumnEditable',[true true true true]);
            set(handles.VarTable,'ColumnWidth',{95 120 135 75});
            set(handles.VarTable,'ColumnFormat',handles.VarTable_ColumnFormat.SampleStatusRecord);
            set(handles.VarTable,'RowName','numbered');
        end
        %Executes only of the file to open is an Experiment or Sample Status
        if(experimentData_FileType==1 || SampleStatus_FileType==1)
            %Searches through the file and finds lines that separates the
            %entries, i.e. '------'
            cnt=1;
            for i=1:size(Template_Lines,1)
                line_str = cell2mat(Template_Lines(i));
                if(any(line_str=='-'))%if the line contains '-'
                    dashLine_FLAG = 1;
                    length(line_str)
                    for ii=1:length(line_str)
                        %searches to see if there are any non '-' entries in the
                        %line. If so we reject that line
                        if(any(line_str(ii)~='-'))
                            dashLine_FLAG = 0;
                            break;
                        end
                    end
                    %Saves all the indices for the '----' lines
                    if(dashLine_FLAG==1)
                        DashLine_INDEX(cnt) = i;
                        cnt = cnt+1;
                    end
                end
            end
            %displays the contents of the last entry in the file in the table
            cnt = 1;
            for i=DashLine_INDEX(end-1)+2:DashLine_INDEX(end)-1
                Line = cell2mat(Template_Lines(i));
                if(strcmp(Line,'{COMMENTS}'))
                    comment = cell2mat(Template_Lines(i+1));
                    set(handles.CommentEdit,'String',comment);
                    break;
                end
                if(any(strfind(Line,'{')))
                    VarTable_labels(cnt,1:4) = {strtrim(Line),'','',''};
                    cnt=cnt+1;
                else
                    m = strfind(Line,':');
                    n = strfind(Line,',');
                    VarTable_labels(cnt,1:4) = {strtrim(Line(1:m(1)-1)),strtrim(Line(m(1)+1:n(1)-1)),...
                        strtrim(Line(n(1)+1:n(2)-1)),strtrim(Line(n(2)+1:end))};
                    cnt = cnt+1;
                end
            end
            set(handles.VarTable,'Data',VarTable_labels);
        end
        set(handles.ExperimentLabelText,'String','N/A');
        %Populates the Wafer, Design, Marker and Experiment fields
        for i=1:length(Template_Lines)
            Line = cell2mat(Template_Lines(i));
            if(any(strfind(Line,':')))
                label = strtrim(Line(1:strfind(Line,':')-1));
                value = strtrim(Line(strfind(Line,':')+1:end));
                switch label
                    case 'Wafer'
                        set(handles.WaferLabelText,'String',value);
                    case 'Design'
                        set(handles.DesignLabelText,'String',value);
                    case 'Marker'
                        set(handles.MarkerLabelText,'String',value);                        
                    case 'Experiment'
                        set(handles.ExperimentLabelText,'String',value);
                end
            end
        end
        
    else
        msgbox('File selected is INVALID. Choose a correct .txt file', 'Error','error');
        FileType_ERROR = 1;
    end
    cd(NowDir)
    %Executes if the open file does not have the correct headings
    if(~FileType_ERROR)
        set(handles.VarTable,'Enable','on');
        set(handles.CommentEdit,'Enable','on');
        set(handles.AddVarPushbutton,'Enable','on');
        set(handles.DeleteVarPushbutton,'Enable','on');
        set(handles.DeleteNumEdit,'Enable','on');
        set(handles.NewLoggingTogglebutton,'Enable','off');
        set(handles.SaveLoggingTogglebutton,'Enable','on');
        set(handles.NewLoggingTogglebutton,'Value',1.0);
        set(handles.SaveLoggingTogglebutton,'Value',0.0);
        set(handles.TodayCheckbox,'Enable','on');
        
        set(handles.FilenameText,'String',Listbox_Selection);
        
        set(handles.SavedLogItems_Listbox,'String',{...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>',...
            '<HTML><FONT color="gray">empty</Font></html>'});
    end
else
    msgbox('Select a file NOT a folder', 'Error','error');    
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in NewFilePushbutton.
function NewFilePushbutton_Callback(hObject, eventdata, handles)
NowDir = cd;
cd(handles.WorkDir);

%Asks user to choose a type of file
[FileTypeChoice, ItemChosen_FLAG] = listdlg('PromptString','Select a type of file:',...
                'SelectionMode','single',...
                'ListString',handles.FileTypeList);
%If user makes a choise it executes
if(ItemChosen_FLAG==1)    
%     FileType = handles.FileTypeList(FileTypeChoice); DELETE
    %Based on the chosen file type, it chooses which type of user dialogue
    %questions to ask the user
    if(FileTypeChoice==1)%Experiment Data
        prompt = {'Experiment ID:','Wafer ID:', 'Design ID:','Marker ID:'};
        dlg_title = 'Enter ID for Experiment';
        num_lines = 1;
        def = {'77K Dipper','W','SiDD','M'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
    elseif(FileTypeChoice==2)%Experiment Analysis
        prompt = {'Wafer ID:', 'Design ID:','Marker ID:','Log started on:'};
        dlg_title = 'Enter ID for Experiment';
        num_lines = 1;
        def = {'W','SiDD','M',datestr(today)};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
    elseif(FileTypeChoice==3)%Logbook (wafer)
        prompt = {'Wafer ID:', 'Design(s) ID(s):','Log started on:'};
        dlg_title = 'Enter ID for WAFER';
        num_lines = 1;
        def = {'W','SiDD',datestr(today)};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
    elseif(FileTypeChoice==4)%Logbook (Marker)
        prompt = {'Wafer ID:', 'Design ID:','Marker ID:','Taken from QNC on:'};
        dlg_title = 'Enter IDs for sample';
        num_lines = 1;
        def = {'W','SiDD','M',datestr(today)};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
    elseif(FileTypeChoice==5)%Sample Status Record
        prompt = {'Wafer ID:', 'Design(s) ID(s):','Log started on:'};
        dlg_title = 'Enter ID for Sample Status Record';
        num_lines = 1;
        def = {'W','SiDD',datestr(today)};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
    end
    %Executes if the user has given all the answers
    if(~isempty(answer))
        %Determines how to populate the wafer, design, marker, etc. fields
        %based on the file type
        if(FileTypeChoice==1)%Experiment Data
            handles.ExperimentID = answer{1};
            handles.WaferID = answer{2};
            handles.DesignID = answer{3};
            handles.MarkerID = answer{4};
            handles.UserDate = 'N/A';
        elseif(FileTypeChoice==2)%Experiment Analysis
            handles.ExperimentID = 'N/A';
            handles.WaferID = answer{1};
            handles.DesignID = answer{2};
            handles.MarkerID = answer{3};
            handles.UserDate = answer{3};
        elseif(FileTypeChoice==3)%Logbook (wafer)
            handles.ExperimentID = 'N/A';
            handles.WaferID = answer{1};
            handles.DesignID = answer{2};
            handles.MarkerID = 'N/A';
            handles.UserDate = answer{3};
        elseif(FileTypeChoice==4)%Logbook (marker)
            handles.ExperimentID = 'N/A';
            handles.WaferID = answer{1};
            handles.DesignID = answer{2};
            handles.MarkerID = answer{3};
            handles.UserDate = answer{4};
        elseif(FileTypeChoice==5)%Sample Status Record
            handles.ExperimentID = 'N/A';
            handles.WaferID = answer{1};
            handles.DesignID = answer{2};
            handles.MarkerID = 'N/A';
            handles.UserDate = answer{3};
        end
        %Populates the fields
        set(handles.WaferLabelText,'String',handles.WaferID);
        set(handles.DesignLabelText,'String',handles.DesignID);
        set(handles.MarkerLabelText,'String',handles.MarkerID);
        set(handles.ExperimentLabelText,'String',handles.ExperimentID);
        %Determines how to properly label the filename
        if(FileTypeChoice==1)%Experiment Data
            default_filename = [handles.DesignID,'-',handles.MarkerID,'_',...
                handles.ExperimentID,'_',datestr(today),'_DataLog.txt'];
        elseif(FileTypeChoice==2)%Experiment Analysis
            default_filename = [handles.DesignID,'-',handles.MarkerID,...
                '_Analysis.txt'];
        elseif(FileTypeChoice==3)%Logbook (wafer)
            default_filename = [handles.WaferID,'_LOGBOOK.txt'];
        elseif(FileTypeChoice==4)%Logbook (marker)
            default_filename = [handles.DesignID,'-',handles.MarkerID,'_LOGBOOK.txt'];
        elseif(FileTypeChoice==5)%Sample Status Record
            default_filename = [handles.WaferID,'_Status-Record.txt'];
        end
        [FileName,PathName,FilterIndex] = uiputfile('*.txt','Select directory and filename to save new log file',default_filename);
        %If the filename is given then it executes
        if(isnumeric(FileName)==0)
            set(handles.FilenameText,'String',FileName);
            %Opens the chosen file to write
            handles.WorkDir = PathName;
            cd(handles.WorkDir);
            fileID = fopen(FileName,'w');
            %Based on the file type chosen for the new file, it writes the
            %correct heading and sets the table to the correct size
            fprintf(fileID,'%s\r\n',cell2mat(handles.FileType_Headings(FileTypeChoice)));
            if(FileTypeChoice==1)
                set(handles.EntryListPopupmenu,'Value',1);
                set(handles.EntryListPopupmenu,'Enable','off');
                set(handles.HeaderCheckbox,'Enable','off');
                set(handles.OverwriteCheckbox,'Enable','on');
                set(handles.OverwriteCheckbox,'Value',0);
                
                set(handles.VarTable,'Data',{'','','',''});
                set(handles.VarTable,'ColumnName',{'Variable Name'; 'Start'; 'End'; 'Num. Pts'});
                set(handles.VarTable,'ColumnEditable',[true true true true]);
                set(handles.VarTable,'ColumnWidth',{130 95 95 95});
                set(handles.VarTable,'ColumnFormat',{'char','char','char','char'});
                set(handles.VarTable,'RowName','numbered');
                
            elseif(FileTypeChoice==2)
%                 fprintf(fileID,'%s\r\n',handles.FileType_Headings(FileTypeChoice));
                EntryList = [{'Select an Entry...'},{'77k Dipper'},{'4k Dipper'},{'Janis'},...
                    {'Dilution Fridge'}];
                set(handles.EntryListPopupmenu,'String',EntryList);
                set(handles.EntryListPopupmenu,'Value',1);
                set(handles.EntryListPopupmenu,'Enable','on');
                set(handles.HeaderCheckbox,'Enable','on');
                set(handles.OverwriteCheckbox,'Enable','on');
                set(handles.OverwriteCheckbox,'Value',0);
                
                set(handles.VarTable,'Data',{'',''});
                set(handles.VarTable,'ColumnEditable',[true true]);
                set(handles.VarTable,'ColumnName',{'Variable Name'; 'Value'});
                set(handles.VarTable,'ColumnWidth',{150 260});
                set(handles.VarTable,'ColumnFormat',{'char','char'});
                set(handles.VarTable,'RowName','numbered');
              
            elseif(FileTypeChoice==3 || FileTypeChoice==4)
%                 if(FileTypeChoice==3)
%                     fprintf(fileID,'%s\r\n',handles.FileType_Headings(FileTypeChoice));
%                 elseif(FileTypeChoice==4)
%                     fprintf(fileID,'%s\r\n',handles.FileType_Headings(FileTypeChoice));
%                 end
                EntryList = [{'Select an Entry...'},{'Wafer Fabrication Description'},...
                    {'Probe Station Measurement'},{'Annealing'},{'Wirebonding'},{'Storage'},...
                    {'Miscellaneous'},{'77k Dipper'},{'4k Dipper'},{'Janis'},...
                    {'Dilution Fridge'}];
                set(handles.EntryListPopupmenu,'String',EntryList);
                set(handles.EntryListPopupmenu,'Value',1);
                set(handles.EntryListPopupmenu,'Enable','on');
                set(handles.HeaderCheckbox,'Enable','on');                
                set(handles.OverwriteCheckbox,'Enable','on');
                set(handles.OverwriteCheckbox,'Value',0);
                
                set(handles.VarTable,'Data',{'',''});
                set(handles.VarTable,'ColumnEditable',[true true]);
                set(handles.VarTable,'ColumnName',{'Variable Name'; 'Value'});
                set(handles.VarTable,'ColumnWidth',{130 280});
                set(handles.VarTable,'ColumnFormat',{'char','char'});
                set(handles.VarTable,'RowName','numbered');
                
            elseif(FileTypeChoice==5)
%                 fprintf(fileID,'%s\r\n',handles.FileType_Headings(FileTypeChoice));
                set(handles.EntryListPopupmenu,'Value',1);
                set(handles.EntryListPopupmenu,'Enable','off');
                set(handles.HeaderCheckbox,'Enable','off');
                set(handles.OverwriteCheckbox,'Enable','on');
                set(handles.OverwriteCheckbox,'Value',1);
                
                set(handles.VarTable,'Data',{'','','',''});
                set(handles.VarTable,'ColumnName',{'Marker Label'; 'Status'; 'Exp. Completed'; 'Next Exp.'});
                set(handles.VarTable,'ColumnEditable',[true true true true]);
                set(handles.VarTable,'ColumnWidth',{95 120 135 75});
                set(handles.VarTable,'ColumnFormat',handles.VarTable_ColumnFormat.SampleStatusRecord);
                set(handles.VarTable,'RowName','numbered');
            end
            %Writes the data for wafer, design, marker, etc.
            set(handles.FileTypeText,'String',handles.FileTypeList(FileTypeChoice));
            fprintf(fileID,'%-17s : ','Wafer');fprintf(fileID,'%1s\r\n', handles.WaferID);
            fprintf(fileID,'%-17s : ','Design');fprintf(fileID,'%1s\r\n', handles.DesignID);
            fprintf(fileID,'%-17s : ','Marker');fprintf(fileID,'%1s\r\n', handles.MarkerID);            
            if(FileTypeChoice==1)
                fprintf(fileID,'%-17s : ','Experiment');fprintf(fileID,'%1s\r\n', handles.ExperimentID);
            elseif(FileTypeChoice==3 || FileTypeChoice==4)
                fprintf(fileID,'%-17s : ','Taken from QNC on');fprintf(fileID,'%1s\r\n', handles.UserDate);
            elseif(FileTypeChoice==4 || FileTypeChoice==2)
                fprintf(fileID,'%-17s : ','Record started on');fprintf(fileID,'%1s\r\n', handles.UserDate);
            end
            fprintf(fileID,'%s\r\n','***********************************************');
            fprintf(fileID,'%s\r\n','');
            fprintf(fileID,'%s\r\n','-----------------------------------------------');
            fclose(fileID);
            %Determines the contents of the current folder to repopulates
            %the folder list
            List_folders = dir;
            List_folders_cell={};
            for i=1:size(List_folders,1)
                if(strcmp(List_folders(i).name,'.')==0 && ...
                        strcmp(List_folders(i).name,'..')==0)
                    List_folders_cell(i-2,1) = {List_folders(i).name};
                end
            end
            cd(NowDir);
            %Populates folder list
            if(isempty(List_folders_cell)==0)
                set(handles.FolderContents_Listbox,'Value',1);
                set(handles.FolderContents_Listbox,'String',List_folders_cell);
            else
                set(handles.FolderContents_Listbox,'Value',1);
                set(handles.FolderContents_Listbox,'String',{''});
            end
            
            set(handles.VarTable,'Enable','on');
            set(handles.CommentEdit,'Enable','on');
            set(handles.AddVarPushbutton,'Enable','on');
            set(handles.DeleteVarPushbutton,'Enable','on');
            set(handles.DeleteNumEdit,'Enable','on');
            set(handles.NewLoggingTogglebutton,'Enable','off');
            set(handles.SaveLoggingTogglebutton,'Enable','on');
            set(handles.NewLoggingTogglebutton,'Value',1.0);
            set(handles.SaveLoggingTogglebutton,'Value',0.0);
            
            set(handles.TodayCheckbox,'Enable','on');
            
            set(handles.SavedLogItems_Listbox,'String',{...
                '<HTML><FONT color="gray">empty</Font></html>',...
                '<HTML><FONT color="gray">empty</Font></html>',...
                '<HTML><FONT color="gray">empty</Font></html>',...
                '<HTML><FONT color="gray">empty</Font></html>',...
                '<HTML><FONT color="gray">empty</Font></html>'});
        end
    end
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in NewLoggingTogglebutton.
function NewLoggingTogglebutton_Callback(hObject, eventdata, handles)

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
FileName = get(handles.FilenameText,'String');
NowDir = cd;
cd(handles.WorkDir);
%Stores all the variables from the table
VarTable = get(handles.VarTable,'Data');
VarNames_ERROR = 0;
Entry_ERROR = 0;
%Loops over all the variables from the table
for i=1:size(VarTable,1)
    VarName = cell2mat(VarTable(i,1));
    m = any(strfind(VarName,':'));
    n = strcmp(VarName,'-----------------------------------------------');
    %Makes sure that the variables name does not contain ':' or '----'
    if(m==1 || n==1)
        VarNames_ERROR = 1;
        break;
    end
    VarNameLengths(i) = length(cell2mat(VarTable(i,1)));
    for j=2:size(VarTable,2)
        Value_Lengths(j) = length(cell2mat(VarTable(i,j)));
    end
    max_Value_Lengths(i) = max(Value_Lengths);%determines the maximum size for the variabels names
    %Stores the first variable name to be used for the keeping track of
    %entries saved in the log file
    if(i==1)
       FirstEntry_ID = cell2mat(VarTable(i,2));
    end
end
Comment = get(handles.CommentEdit,'String');
%Executes only if the variable names do not contain ':' or '----'
if(VarNames_ERROR == 0)
    %Choose the correct header
    if(strcmp(get(handles.FileTypeText,'String'),'Logbook')==1 && get(handles.HeaderCheckbox,'Value')==1)
        switch get(handles.EntryListPopupmenu,'Value')-1
            case 0
                msgbox('Select an Entry type under Log Options', 'Error','error');
                set(handles.SaveLoggingTogglebutton,'Value',0);
                Entry_ERROR = 1;
            case 1
                header = '*********Wafer Fabrication Description*********';
            case 2
                header = '***********Probe Station Measurement***********';
            case 3
                header = '*******************Annealing*******************';
            case 4
                header = '******************Wirebonding******************';
            case 5
                header = '********************Storage********************';
            case 6
                header = '*****************Miscellaneous*****************';
            case 7
                header = '******************77k Dipper*******************';
            case 8
                header = '*******************4k Dipper*******************';
            case 9
                header = '*********************Janis*********************';
            otherwise
                header = '****************Dilution Fridge****************';
        end
    end
    
    if(~Entry_ERROR)
        if(~ischar(FileName))
            FileName_char = cell2mat(FileName);
        else
            FileName_char = FileName;
        end
        %Makes a temporary copy of the file, in case there is any issue and
        %the data is lost
        ind = strfind(FileName_char,'.');
        backup_dir = [handles.HOME_folder_name,'\BACKUP\Temporary\'];
        copyfile(FileName_char,[backup_dir,FileName_char(1:ind-1),'_temp',FileName_char(ind:end)]);
        
        %Executes in the overwrite option is chosen
        if(get(handles.OverwriteCheckbox,'Value'))
            %opens file to read
            fileID = fopen(FileName_char,'r');
            Data = textscan(fileID, '%s','Delimiter','\r\n');
            DataLines = Data{1};
            cnt = 1;
            %Searches for the '----' lines which define the bounds for file
            %entries
            for i=1:size(DataLines,1)
                DataLines(i)
                line_str = cell2mat(DataLines(i));
                if(any(line_str=='-'))
                    dashLine_FLAG = 1;
                    length(line_str)
                    for ii=1:length(line_str)
                        if(any(line_str(ii)~='-'))
                            dashLine_FLAG = 0;
                            break;
                        end
                    end
                    if(dashLine_FLAG==1)
                        DashLine_INDEX(cnt) = i;
                        cnt = cnt+1;
                    end
                end
            end
            fclose(fileID);%close file ID
            %Reopens file to overwrite in the file except for the last entry
            fileID = fopen(FileName_char,'w');
            FileType = get(handles.FileTypeText,'String');
            if(length(DashLine_INDEX)>1)
                if(strcmp(FileType,'Logbook')==1)
                    StartAppend_Index = DashLine_INDEX(end-2);
                elseif(strcmp(FileType,'Experiment')==1 || strcmp(FileType,'Sample Status Record')==1)
                    StartAppend_Index = DashLine_INDEX(end-1);
                end
            else
                StartAppend_Index = DashLine_INDEX(end);
            end
            %Loops over all the contents of the file to rewrite them except
            %for the last entry
            for i=1:StartAppend_Index
                fprintf(fileID,'%s\r\n', cell2mat(DataLines(i)));
            end
            fclose(fileID);%close file ID
        end

        %Reopends file but only to append (not overwrite)
        fileID = fopen(FileName_char,'a+');   
        if(strcmp(get(handles.FileTypeText,'String'),'Logbook')==1 && get(handles.HeaderCheckbox,'Value')==1)
            fprintf(fileID,'%s\r\n',header);
            fprintf(fileID,'%s\r\n','-----------------------------------------------');
        end
        fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s : '], '>>>Date');
        fprintf(fileID,'%1s\r\n', get(handles.TodayEdit,'String'));
        %Loops over all the variables and properly writes the data into the
        %file
        colNum = size(VarTable,2);
        for i = 1:size(VarTable,1)
            if(~isempty(cell2mat(VarTable(i,1))))          
                if(any(strfind(cell2mat(VarTable(i,1)),'{')))
                    fprintf(fileID,'%s\r\n', cell2mat(VarTable(i,1)));
                else
                    fprintf(fileID,['%-',num2str(max(VarNameLengths)),'s : '], cell2mat(VarTable(i,1)));
                    if(colNum==2)
                        fprintf(fileID,'%1s\r\n', cell2mat(VarTable(i,2)));
                    else
                        for ii=2:colNum
                            if(ii==colNum)                                
                                fprintf(fileID,['%',num2str(max(max_Value_Lengths)),'s\r\n'], cell2mat(VarTable(i,ii)));
                            else
                                fprintf(fileID,['%',num2str(max(max_Value_Lengths)),'s,'], cell2mat(VarTable(i,ii)));
                            end
                        end
                    end
                end
            end
        end
        %Includes the comment if not emtpy
        if(~isempty(Comment))
            fprintf(fileID,'%s\r\n','{COMMENTS}');
            fprintf(fileID,'%s\r\n', Comment);
        end
        fprintf(fileID,'%s\r\n','-----------------------------------------------');
        fclose(fileID);%close file ID
        %Reopens file to read contents afer appending the current entry and
        %be able to refresh the FileViewerText
        fileID = fopen(FileName_char,'r');
        Data = textscan(fileID, '%s','Delimiter','\r\n');
        fclose(fileID);
        set(handles.FileViewerText,'String',Data{1});
        set(handles.FileViewerText,'Value',1);
        
        set(handles.NewLoggingTogglebutton,'Value',0.0);
        set(handles.SaveLoggingTogglebutton,'Value',1.0);
        set(handles.NewLoggingTogglebutton,'Enable','on');
        set(handles.SaveLoggingTogglebutton,'Enable','off');
        
        set(handles.VarTable,'Enable','off');
        set(handles.CommentEdit,'Enable','off');
        set(handles.AddVarPushbutton,'Enable','off');
        set(handles.DeleteVarPushbutton,'Enable','off');
        set(handles.DeleteNumEdit,'Enable','off');
        %Refreshes the file list to keep track of saved loggings
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
        New_list{1} = ['<HTML><FONT color="white">',FirstEntry_ID,'</Font></html>'];
        set(handles.SavedLogItems_Listbox,'String',New_list);
        
    end
else
    msgbox('Do NOT use : in Variable Names. Do NOT use - (repeatedly) in Variable Names.', 'Error','error');
    set(handles.SaveLoggingTogglebutton,'Value',0);
end

cd(NowDir);

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in EntryListPopupmenu.
function EntryListPopupmenu_Callback(hObject, eventdata, handles)

if(get(handles.HeaderCheckbox,'Value')==1)
    handles.EntryList_choice = get(handles.EntryListPopupmenu,'Value');
else
    if(handles.EntryList_choice ~= get(handles.EntryListPopupmenu,'Value'))
       set(handles.HeaderCheckbox,'Value',1);
       msgbox('The "Include Header" option was enabled.', 'Warning','warn');
    end
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in TodayCheckbox.
function TodayCheckbox_Callback(hObject, eventdata, handles)
if(get(handles.TodayCheckbox,'Value'))
    set(handles.TodayEdit,'Enable','off');
    set(handles.TodayEdit,'String',datestr(today));
else
    set(handles.TodayEdit,'Enable','on');
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function NewTemplate_Toolbar_ClickedCallback(hObject, eventdata, handles)

set(handles.VarTable,'Enable','on');
set(handles.AddVarPushbutton,'Enable','on');
set(handles.DeleteVarPushbutton,'Enable','on');
set(handles.DeleteNumEdit,'Enable','on');

set(handles.CommentEdit,'Enable','off');
set(handles.NewLoggingTogglebutton,'Enable','off');
set(handles.SaveLoggingTogglebutton,'Enable','off');
set(handles.NewLoggingTogglebutton,'Value',1.0);
set(handles.SaveLoggingTogglebutton,'Value',0.0);

set(handles.EntryListPopupmenu,'Enable','off');
set(handles.TodayCheckbox,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function OpenTemplate_Toolbar_ClickedCallback(hObject, eventdata, handles)
NowDir = cd;
cd(handles.TemplateDir);

[FileName,PathName,FilterIndex] = uigetfile('*.txt','Select template file to open');
%If user chooses a file template
if(isnumeric(FileName)==0)
    handles.TemplateDir = PathName;
    cd(handles.TemplateDir);
    %determines the number of columns
    table = get(handles.VarTable,'Data');
    colNum = size(table,2);
    %opens file to read contents
    fileID = fopen(FileName,'r');
    %Reads contents
    Data = textscan(fileID, '%s','Delimiter','\r\n');
    fclose(fileID);
    Template_Lines = Data{1};
    %Populates table with template contents
    for i=1:length(Template_Lines)
        Line = cell2mat(Template_Lines(i));
        if(strcmp(Line,'{COMMENTS}'))
            comment = cell2mat(Template_Lines(i+1));
            set(handles.CommentEdit,'String',comment);
            break;
        end
        if(any(strfind(Line,'{')))           
            if(colNum==2)
                VarTable_labels(i,1:2) = {strtrim(Line),''};
            else
                VarTable_labels(i,1:4) = {strtrim(Line),'','',''};            
            end
        else
            m = strfind(Line,':');
            if(colNum==2)
                VarTable_labels(i,1:2) = {strtrim(Line(1:m(1)-1)),strtrim(Line(m+1:end))};
            else
                VarTable_labels(i,1:4) = {strtrim(Line(1:m(1)-1)),strtrim(Line(m+1:end)),'',''};
            end
        end
    end
    set(handles.VarTable,'Data',VarTable_labels);
    
    set(handles.VarTable,'Enable','on');
    set(handles.AddVarPushbutton,'Enable','on');
    set(handles.DeleteVarPushbutton,'Enable','on');
    set(handles.DeleteNumEdit,'Enable','on');  
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
        end
    end
    Comment = get(handles.CommentEdit,'String');
    if(~isempty(Comment))
        fprintf(fileID,'%s\r\n','{COMMENTS}');
        fprintf(fileID,'%s\r\n', Comment);
    end
    fclose(fileID);
end
cd(NowDir);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in BackUpPushbutton.
function BackUpPushbutton_Callback(hObject, eventdata, handles)
%Asks user for a directory to open
NowDir = cd;
folder_name = uigetdir(handles.WorkDir, 'Select directory and filename to save new dta log file');

%Executes if the user chose a directory
if(folder_name~=0)
    cd(folder_name);
    handles.WorkDir = folder_name;
    
    %Extracts the contents of the chosen directory
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
    
    %Displays the chosen directory contents in the FolderContents_Listbox
    if(isempty(List_folders_cell)==0)
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',List_folders_cell);
    else
        set(handles.FolderContents_Listbox,'Value',1);
        set(handles.FolderContents_Listbox,'String',{''});
    end
    %Enables the In directory button if there are any folders in the home
    %directory
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

% --- Executes on selection change in SavedLogItems_Listbox.
function SavedLogItems_Listbox_Callback(hObject, eventdata, handles)
% hObject    handle to SavedLogItems_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.SavedLogItems_Listbox,'Value',1);
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




% --- Executes on button press in HeaderCheckbox.
function HeaderCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to HeaderCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HeaderCheckbox

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


% --- Executes during object creation, after setting all properties.
function FileViewerSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileViewerSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in FileViewerText.
function FileViewerText_Callback(hObject, eventdata, handles)
% hObject    handle to FileViewerText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileViewerText contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileViewerText


% --- Executes during object creation, after setting all properties.
function FileViewerText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileViewerText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose('all');
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in OverwriteCheckbox.
function OverwriteCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OverwriteCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OverwriteCheckbox