function varargout = NanonisFileMerger(varargin)
% NANONISFILEMERGER MATLAB code for NanonisFileMerger.fig
%      NANONISFILEMERGER, by itself, creates a new NANONISFILEMERGER or raises the existing
%      singleton*.
%
%      H = NANONISFILEMERGER returns the handle to a new NANONISFILEMERGER or the handle to
%      the existing singleton*.
%
%      NANONISFILEMERGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NANONISFILEMERGER.M with the given input arguments.
%
%      NANONISFILEMERGER('Property','Value',...) creates a new NANONISFILEMERGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NanonisFileMerger_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NanonisFileMerger_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NanonisFileMerger

% Last Modified by GUIDE v2.5 04-Mar-2018 07:45:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NanonisFileMerger_OpeningFcn, ...
                   'gui_OutputFcn',  @NanonisFileMerger_OutputFcn, ...
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


% --- Executes just before NanonisFileMerger is made visible.
function NanonisFileMerger_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NanonisFileMerger (see VARARGIN)

% Choose default command line output for VideoAnalysisExtraction
handles.output = hObject;
% nargin
% handles.Main = varargin{1};
% obtain handles using guidata with the caller's handle
% handles.mainhandles = guidata(handles.Main);

%directories path resets
handles.RootDirPath = [];
handles.SweepFilePath = [];

%Resets the variables used to store the data
handles.Data_Stored.data = {};
handles.Data_Stored.coordX = {};
handles.Data_Stored.coordY = {};
handles.Data_Stored.coordZ = {};
handles.Data_Stored.dim = [];
handles.Data_Stored.folder = {};
handles.Data_Stored.datacrop = {};

handles.legendEntry = {};
handles.NumOfColors = 0;

% Choose default command line output for NextNano_PlotWizard
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% uiwait(handles.mainhandles.SpanAcqPlotFigure);



% --- Outputs from this function are returned to the command line.
function varargout = NanonisFileMerger_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%--------------------------------------------------------------------------

function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Saves Current directory
NowDir = cd;

%If there is a path already stored, then go to that path directory
if(isempty(handles.RootDirPath)==0)
    cd(handles.RootDirPath);
else
    cd('../..');
end
%Opens dialogue window to allow user to select a file
RootDirPath = uigetdir('*', 'Choose a file');
%Check to see if the user selected a file successfully
if(RootDirPath~=0)    
    handles.RootDirPath = RootDirPath;
    %Displays the selected path on the GUI
    set(handles.RootDirectoryEdit,'String',handles.RootDirPath);
    
    cd(handles.RootDirPath);    
    %Erases all the list of folders
    handles.ChosenFiles = [];
    %Gets new set of files
    FolderContents = dir;
    for i=3:size(FolderContents,1)
        handles.ChosenFiles{i-2} = FolderContents(i).name;
    end
    set(handles.FileNamesListbox,'String',handles.ChosenFiles);
    
    %Returns to Working Directory
    cd(NowDir);
    %Allows user to extract folders
%     set(handles.ExtractSimFoldersPushbutton,'Enable','on');
    
else
    %Returns to Working Directory
    cd(NowDir);
end
guidata(hObject, handles);


function RootDirectoryEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RootDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in FileNamesListbox.
function FileNamesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FileNamesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in MergeFilesPushbutton.
function MergeFilesPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractSimFoldersPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%saves the durrent directory, sets the directory for Root of the folders
%and looks up its contents
NowDir = cd;

%list of folders and selected folder
selectedFiles = get(handles.FileNamesListbox,'String');

%Initialization of variables used later on
Time = [];      AcqData = [];    Vsweep = [];    Vstep1 = [];   Vstep2 = [];

%sets the directory to the chosen folder where the files are located
cd(handles.RootDirPath);
h=waitbar(0,'Extracting and Organizing data from files... Please wait');
for INDEX = 1:length(selectedFiles)
    %selects a file
    filename = cell2mat(selectedFiles(INDEX));
    
    %alternative way to open file_data
    fid = fopen(filename);
    data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);
    fclose(fid);
    
    D = data{1,1};
    %Determines the names for the sweep channel and step channels 1 and 2
    flagerror.No3DScan = 0;
    for i=1:length(D)
        str = D{i,1};
        strSearch_SweepCH = strfind(str,'3D Sweeper>Sweep channel: Channel');
        strSearch_StepCH1 = strfind(str,'3D Sweeper>Step channel 1: Channel');
        strSearch_StepCH2 = strfind(str,'3D Sweeper>Step channel 2: Channel');
        str_STOP = strfind(str,'{DATA]');
        
        if(~isempty(str_STOP))
            break;
        end
        
        if(~isempty(strSearch_SweepCH))
            SweepCH_str = strtrim(str(strSearch_SweepCH+34:end));
            if(strcmp(SweepCH_str,'- no signal -'))
                flagerror.No3DScan = 1;
                break;
            end
        end
        if(~isempty(strSearch_StepCH1))
            StepCH1_str = strtrim(str(strSearch_StepCH1+34:end));
            if(strcmp(StepCH1_str,'- no signal -'))
                flagerror.No3DScan = 1;
                break;
            end
        end
        if(~isempty(strSearch_StepCH2))
            StepCH2_str = strtrim(str(strSearch_StepCH2+34:end));
            if(strcmp(StepCH2_str,'- no signal -'))
                flagerror.No3DScan = 1;
                break;
            end
        end
    end
    
    %if this is the first file to be analyzed, then the names for the sweep
    %and step channels are saved for future comparison with other files
    if(INDEX==1)
        Saved.SweepCH_str = SweepCH_str;
        Saved.StepCH1_str = StepCH1_str;
        Saved.StepCH2_str = StepCH2_str;
    end
    
    %Compares the current file sweep and step channels with the saved sweep
    %and step channels to ensure all files belong to a common experiment
    %run. (Only meanignful after having gone throught the 1st file)
    flagerror.IncompatibleFiles = 0;
    if( ~strcmp(SweepCH_str,Saved.SweepCH_str) && ~strcmp(StepCH1_str,Saved.StepCH1_str) && ...
            ~strcmp(StepCH2_str,Saved.StepCH2_str) )
        flagerror.IncompatibleFiles = 1;
    end
    
    %If any flag error came up this will terminate the loop so the user can
    %diagnose what is wrong with the selected files
    if(flagerror.No3DScan==1 || flagerror.IncompatibleFiles==1)
        msgbox(['Selected files are not compatible and do not have the same sweep and step channels',...
            'File: ',filename,' likely does not belong to rest of file set']);
        break;
    end
    
    %If no error flags, then:
    %Loops over the file to extract the name of the sweep and step channels
    %and the start, stop, number of points of the step channel. Loop breaks
    %as soon as the line "3D Sweeper>Acquired channels" is reached.
    for i=1:length(D)
        %Extracts the lines in the file with important info about the sweep
        %and step channel
        str = D{i,1};
        strSweepName = strfind(str,'Sweep channel: Name');
        strStep1Name = strfind(str,'Step channel 1: Name');
        strStep2Name = strfind(str,'Step channel 2 (host): Name');
        strStep2Value = strfind(str,'Step channel 2 (host): Level');
        strStep1Start = strfind(str,'Step channel 1: Start');
        strStep1Stop = strfind(str,'Step channel 1: Stop');
        strStep1NumPts = strfind(str,'Step channel 1: Points');
        strArqcName = strfind(str,'Acquire channels');
        %this string determines when to stop looking in the file
        str_STOP = strfind(str,'3D Sweeper>Acquired channels');
        
        %Once we reached the stop point we save the important params to
        %variables.
        if(isempty(str_STOP))
            
            if(~isempty(strSweepName))
                SweepCH_Name = strtrim(str(strSweepName+19:end));
            end
            if(~isempty(strStep1Name))
                StepCH1_Name = strtrim(str(strStep1Name+20:end));
            end
            if(~isempty(strStep2Name))
                StepCH2_Name = strtrim(str(strStep2Name+27:end));
            end
            if(~isempty(strStep2Value))
                StepCH2_Value = strtrim(str(strStep2Value+28:end));
            end
            if(~isempty(strStep1Start))
                StepCH1_start = str2double(strtrim(str(strStep1Start+21:end)));
            end
            if(~isempty(strStep1Stop))
                StepCH1_stop = str2double(strtrim(str(strStep1Stop+20:end)));
            end
            if(~isempty(strStep1NumPts))
                StepCH1_pts = str2double(strtrim(str(strStep1NumPts+22:end)));
            end
            if(~isempty(strArqcName))
                AcquiredCH_Name = strtrim(str(strArqcName+16:end));
            end
        else
            break;
        end
    end
    
    %Loops over the file to find the "DATA" flag which lets you know after
    %which line the data will begin
    for i=1:length(D)
        str = D{i,1};
        if(strcmp(str,'[DATA]'))
            index = i;
            break;
        end
    end
    %The vector for the Step 1 channel is determined based on the start,
    %end points and the number of data pts
    Vstep1_temp = linspace(StepCH1_start,StepCH1_stop,StepCH1_pts);
    
    %The acquire and sweep channels are extracted from the file (line by
    %line) in a matrix form
    cnt = 1;
    for i=index+2:length(D)
        temp = str2double(strsplit(D{i,1},'\t'));
        AcqData_temp(cnt,:) = temp(2:end);
        Vsweep_temp(cnt,1) = temp(1);
        cnt = cnt+1;
    end
    %The extracted data for the acquire and sweep channels is reorganized
    %so that each is a single vector. The step 1 and step 2 channels are
    %also organized in a consistent manner along side the acquire and sweep
    %channels. 
    for i=1:size(AcqData_temp,2)
        AcqData = [AcqData;AcqData_temp(:,i)];
        Vsweep = [Vsweep;Vsweep_temp(:,1)];
        Vstep1 = [Vstep1;Vstep1_temp(i)*ones(size(AcqData_temp,1),1)];
        Vstep2 = [Vstep2;str2double(StepCH2_Value)*ones(size(AcqData_temp,1),1)];
    end
    waitbar(INDEX/length(selectedFiles));
end
close(h);
%An artificial time vector is made. THis is necessary now but could be
%removed. This needs a deep look at the code used to organize or extract
%data from files
Time = linspace(0,100,length(AcqData))';

%Final data to be saved to a txt file
header = ['Time(arb.),',SweepCH_Name,',',StepCH1_Name,',',StepCH2_Name,',',AcquiredCH_Name];
Data = [Time';Vsweep';Vstep1';Vstep2';AcqData'];

%THis is the filename used to save the data
LastFile = cell2mat(selectedFiles(end));
FirstFile = cell2mat(selectedFiles(1));
k = strfind(LastFile,'_');
filenameSave = [FirstFile(1:end-4),'-',LastFile(k+1:end-4),'.txt'];

%Save the data to file
fid = fopen(filenameSave, 'w'); 
fprintf(fid, '%s\n', header);
formatSpec = '%d, %d, %d, %d, %d\n';
fprintf(fid, formatSpec, Data);

fclose('all');

cd(NowDir);

guidata(hObject, handles);

% --- Executes on button press in DeletePushbutton.
function DeletePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DeletePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%list of folders and selected folder
ListFolders = get(handles.FileNamesListbox,'String');
selectedFolder = get(handles.FileNamesListbox,'Value');

%deletes selected folder and ensures that the Value is set properly to
%avoid issues with List object rendering
ListFolders(selectedFolder) = [];
set(handles.FileNamesListbox,'String',ListFolders)
if(selectedFolder > length(ListFolders))
    set(handles.FileNamesListbox,'Value',selectedFolder-1)
end
if(isempty(ListFolders))
    set(handles.DeletePushbutton,'Enable','off');
end

guidata(hObject, handles);

% --- Executes on button press in ClearPushbutton.
function ClearPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Erases all the list of folders
handles.ChosenFiles = [];
set(handles.FileNamesListbox,'String',handles.ChosenFiles)
set(handles.FileNamesListbox,'Value',1)
set(handles.DeletePushbutton,'Enable','off');
set(handles.ClearPushbutton,'Enable','off');

% set(0,'CurrentFigure',handles.Figure_PlotWizard);
% set(0,'ShowHiddenHandles','on');
% set(handles.Figure_PlotWizard,'CurrentAxes',handles.axes1);
% legend('off');

guidata(hObject, handles);

%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function RootDirectoryEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RootDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function FileNamesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileNamesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when NanonisFileMergerFigure is resized.
function NanonisFileMergerFigure_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to NanonisFileMergerFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close NanonisFileMergerFigure.
function NanonisFileMergerFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to NanonisFileMergerFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% uiresume(handles.SpanishAcqFig);
% uiresume(handles.SpanishAcqFig);
uiresume(handles.mainhandles.SpanAcqPlotFigure);

% Hint: delete(hObject) closes the figure
delete(hObject);
