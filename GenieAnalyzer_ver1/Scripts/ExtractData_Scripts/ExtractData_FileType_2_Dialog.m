function varargout = ExtractData_FileType_2_Dialog(varargin)
% EXTRACTDATA_FILETYPE_2_DIALOG MATLAB code for ExtractData_FileType_2_Dialog.fig
%      EXTRACTDATA_FILETYPE_2_DIALOG, by itself, creates a new EXTRACTDATA_FILETYPE_2_DIALOG or raises the existing
%      singleton*.
%
%      H = EXTRACTDATA_FILETYPE_2_DIALOG returns the handle to a new EXTRACTDATA_FILETYPE_2_DIALOG or the handle to
%      the existing singleton*.
%
%      EXTRACTDATA_FILETYPE_2_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXTRACTDATA_FILETYPE_2_DIALOG.M with the given input arguments.
%
%      EXTRACTDATA_FILETYPE_2_DIALOG('Property','Value',...) creates a new EXTRACTDATA_FILETYPE_2_DIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExtractData_FileType_2_Dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExtractData_FileType_2_Dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExtractData_FileType_2_Dialog

% Last Modified by GUIDE v2.5 26-Apr-2016 00:30:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExtractData_FileType_2_Dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @ExtractData_FileType_2_Dialog_OutputFcn, ...
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


% --- Executes just before ExtractData_FileType_2_Dialog is made visible.
function ExtractData_FileType_2_Dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExtractData_FileType_2_Dialog (see VARARGIN)
temp = varargin{1};
set(handles.popupmenu1,'String',temp);
set(handles.popupmenu2,'String',temp);
% Choose default command line output for ExtractData_FileType_2_Dialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExtractData_FileType_2_Dialog wait for user response (see UIRESUME)
uiwait(handles.Figure_ExtractData_FileType_2);


% --- Outputs from this function are returned to the command line.
function varargout = ExtractData_FileType_2_Dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(handles.popupmenu1,'Value')
handles.output.out1 = get(handles.popupmenu1,'Value');
handles.output.out2 = get(handles.popupmenu2,'Value');
% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
close(gcf)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close Figure_ExtractData_FileType_2.
function Figure_ExtractData_FileType_2_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Figure_ExtractData_FileType_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.Figure_ExtractData_FileType_2);

% delete(hObject);
guidata(hObject, handles);
