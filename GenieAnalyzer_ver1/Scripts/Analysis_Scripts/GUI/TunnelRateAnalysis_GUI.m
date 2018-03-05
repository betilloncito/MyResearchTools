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

% Last Modified by GUIDE v2.5 05-Mar-2018 01:47:29

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TunnelRateAnalysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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


% --- Executes on button press in DeleteAllPushbutton.
function DeleteAllPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteAllPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in AddPushbutton.
function AddPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DeletePushbutton.
function DeletePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to DeletePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.Received_GUI_Data.NowDir);
% Hint: delete(hObject) closes the figure
delete(hObject);

