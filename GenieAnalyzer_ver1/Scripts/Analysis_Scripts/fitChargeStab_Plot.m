function varargout = fitChargeStab_Plot(varargin)
% FITCHARGESTAB_PLOT MATLAB code for fitChargeStab_Plot.fig
%      FITCHARGESTAB_PLOT, by itself, creates a new FITCHARGESTAB_PLOT or raises the existing
%      singleton*.
%
%      H = FITCHARGESTAB_PLOT returns the handle to a new FITCHARGESTAB_PLOT or the handle to
%      the existing singleton*.
%
%      FITCHARGESTAB_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FITCHARGESTAB_PLOT.M with the given input arguments.
%
%      FITCHARGESTAB_PLOT('Property','Value',...) creates a new FITCHARGESTAB_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fitChargeStab_Plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fitChargeStab_Plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fitChargeStab_Plot

% Last Modified by GUIDE v2.5 27-Mar-2017 16:36:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fitChargeStab_Plot_OpeningFcn, ...
                   'gui_OutputFcn',  @fitChargeStab_Plot_OutputFcn, ...
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


% --- Executes just before fitChargeStab_Plot is made visible.
function fitChargeStab_Plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fitChargeStab_Plot (see VARARGIN)

% Choose default command line output for fitChargeStab_Plot
handles.output = hObject;

VplgX = varargin{1};
VplgY = varargin{2};
Current = varargin{3};
handles.Vbias = varargin{4};

%Sets the X and Y values for the Stability Diagram as the min and max 
%values from the X and Y rangesas default
set(handles.Pt1_X_StabDiag_Edit,'String',min(VplgX));
set(handles.Pt1_Y_StabDiag_Edit,'String',min(VplgY));
set(handles.Pt2_X_StabDiag_Edit,'String',max(VplgX));
set(handles.Pt2_Y_StabDiag_Edit,'String',max(VplgY));

%Range of X and Y
delta_VplgX = abs(max(VplgX)-min(VplgX));
delta_VplgY = abs(max(VplgY)-min(VplgY));

%Sets the X and Y values for the Bias Triangle ranges as 25% and 75% from
%the total Ranges in X and Y
set(handles.Pt1_X_BiasTrian_Edit,'String',min(VplgX)+delta_VplgX*0.25);
set(handles.Pt1_Y_BiasTrian_Edit,'String',min(VplgY)+delta_VplgY*0.25);
set(handles.Pt2_X_BiasTrian_Edit,'String',max(VplgX)-delta_VplgX*0.25);
set(handles.Pt2_Y_BiasTrian_Edit,'String',max(VplgY)-delta_VplgX*0.25);

%Lines for the Crop Stability Diagram
handles.line1_StabDiag.x = [min(VplgX),max(VplgX)];
handles.line1_StabDiag.y = min(VplgY)*ones(2,1);
handles.line2_StabDiag.x = [min(VplgX),max(VplgX)];
handles.line2_StabDiag.y = max(VplgY)*ones(2,1);
handles.line3_StabDiag.x = min(VplgX)*ones(2,1);
handles.line3_StabDiag.y = [min(VplgY),max(VplgY)];
handles.line4_StabDiag.x = max(VplgX)*ones(2,1);
handles.line4_StabDiag.y = [min(VplgY),max(VplgY)];

%Lines for the Crop Bias Triangles
handles.line1_BiasTriangle.x = [min(VplgX)+delta_VplgX*0.25,max(VplgX)-delta_VplgX*0.25];
handles.line1_BiasTriangle.y = (min(VplgY)+delta_VplgY*0.25)*ones(2,1);
handles.line2_BiasTriangle.x = [min(VplgX)+delta_VplgX*0.25,max(VplgX)-delta_VplgX*0.25];
handles.line2_BiasTriangle.y = (max(VplgY)-delta_VplgY*0.25)*ones(2,1);
handles.line3_BiasTriangle.x = (min(VplgX)+delta_VplgX*0.25)*ones(2,1);
handles.line3_BiasTriangle.y = [min(VplgY)+delta_VplgY*0.25,max(VplgY)-delta_VplgY*0.25];
handles.line4_BiasTriangle.x = (max(VplgX)-delta_VplgX*0.25)*ones(2,1);
handles.line4_BiasTriangle.y = [min(VplgY)+delta_VplgY*0.25,max(VplgY)-delta_VplgY*0.25];

%Points for the Bias Triangle Guesses
handles.Pt1_Guess_Coord.x = [];
handles.Pt1_Guess_Coord.y = [];
handles.Pt2_Guess_Coord.x = [];
handles.Pt2_Guess_Coord.y = [];
handles.Pt3_Guess_Coord.x = [];
handles.Pt3_Guess_Coord.y = [];
handles.Pt4_Guess_Coord.x = [];
handles.Pt4_Guess_Coord.y = [];

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
surf(VplgX,VplgY,Current,'EdgeAlpha',0);

%Lines for the Crop Stability Diagram
line(handles.line1_StabDiag.x,handles.line1_StabDiag.y,max(max(Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);
line(handles.line2_StabDiag.x,handles.line2_StabDiag.y,max(max(Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);
line(handles.line3_StabDiag.x,handles.line3_StabDiag.y,max(max(Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);
line(handles.line4_StabDiag.x,handles.line4_StabDiag.y,max(max(Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);

% Set limits for surf plot for X and Y
set(handles.CropAxes,'Xlim',[min(VplgX),max(VplgX)]);
set(handles.CropAxes,'Ylim',[min(VplgY),max(VplgY)]);
xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

%Initialization Crop Options
set(handles.UpdateCoordPushbutton,'Enable','on');
set(handles.UpdateGuessCoordPushbutton,'Enable','off');
set(handles.CropStabDiagRadiobutton,'Value',1);
set(handles.Pt1_X_StabDiag_Edit,'Enable','on');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','on');
set(handles.Pt2_X_StabDiag_Edit,'Enable','on');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','on');
set(handles.Pt1_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','off');

set(handles.Pt1_X_Guess_Edit,'Enable','off');
set(handles.Pt1_Y_Guess_Edit,'Enable','off');
set(handles.Pt2_X_Guess_Edit,'Enable','off');
set(handles.Pt2_Y_Guess_Edit,'Enable','off');
set(handles.Pt3_X_Guess_Edit,'Enable','off');
set(handles.Pt3_Y_Guess_Edit,'Enable','off');
set(handles.Pt4_X_Guess_Edit,'Enable','off');
set(handles.Pt4_Y_Guess_Edit,'Enable','off');

%Sets global variables for the surf data so it can be access everywhere
handles.VplgX = VplgX;
handles.VplgY = VplgY;
handles.Current = Current;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fitChargeStab_Plot wait for user response (see UIRESUME)
% uiwait(handles.fitChargeStab_Plot_Figure);


% --- Outputs from this function are returned to the command line.
function varargout = fitChargeStab_Plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% delete(hObject);


% --- Executes on button press in UpdateCoordPushbutton.
function UpdateCoordPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateCoordPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% uiresume(handles.fitChargeStab_Plot_Figure);
dcm_obj = datacursormode(handles.fitChargeStab_Plot_Figure);
info_struct = getCursorInfo(dcm_obj);

%If data cursors are chosen, the coordinates are extracted
%Ensures that data cursors were chosen
if(~isempty(info_struct))
    %Ensure that only 2 data points were chosen
    if(length(info_struct)==2)
        
        pt1_pos = info_struct(1).Position;
        pt2_pos = info_struct(2).Position;
        %Figures out which are the min and max X coordinates
        if(pt1_pos(1,1) > pt2_pos(1,1))
            Pt_X_min = pt2_pos(1,1);
            Pt_X_max = pt1_pos(1,1);
        else
            Pt_X_min = pt1_pos(1,1);
            Pt_X_max = pt2_pos(1,1);
        end
        %Figures out which are the min and max Y coordinates
        if(pt1_pos(1,2) > pt2_pos(1,2))
            Pt_Y_min = pt2_pos(1,2);
            Pt_Y_max = pt1_pos(1,2);
        else
            Pt_Y_min = pt1_pos(1,2);
            Pt_Y_max = pt2_pos(1,2);
        end
    else
        msgbox('Only 1 data point was chosen. You must choose 2 data points');
    end
else
    if(get(handles.CropStabDiagRadiobutton,'Value'))
        %     msgbox('Two data points must be chosen in the data plot');
        pt1_pos(1,1) = str2double(get(handles.Pt1_X_StabDiag_Edit,'String'));
        pt1_pos(1,2) = str2double(get(handles.Pt1_Y_StabDiag_Edit,'String'));
        pt2_pos(1,1) = str2double(get(handles.Pt2_X_StabDiag_Edit,'String'));
        pt2_pos(1,2) = str2double(get(handles.Pt2_Y_StabDiag_Edit,'String'));
    else        
        pt1_pos(1,1) = str2double(get(handles.Pt1_X_BiasTrian_Edit,'String'));
        pt1_pos(1,2) = str2double(get(handles.Pt1_Y_BiasTrian_Edit,'String'));
        pt2_pos(1,1) = str2double(get(handles.Pt2_X_BiasTrian_Edit,'String'));
        pt2_pos(1,2) = str2double(get(handles.Pt2_Y_BiasTrian_Edit,'String'));
    end
    
    %Figures out which are the min and max X coordinates
    if(pt1_pos(1,1) > pt2_pos(1,1))
        Pt_X_min = pt2_pos(1,1);
        Pt_X_max = pt1_pos(1,1);
    else
        Pt_X_min = pt1_pos(1,1);
        Pt_X_max = pt2_pos(1,1);
    end
    %Figures out which are the min and max Y coordinates
    if(pt1_pos(1,2) > pt2_pos(1,2))
        Pt_Y_min = pt2_pos(1,2);
        Pt_Y_max = pt1_pos(1,2);
    else
        Pt_Y_min = pt1_pos(1,2);
        Pt_Y_max = pt2_pos(1,2);
    end
end

if(get(handles.CropStabDiagRadiobutton,'Value'))
    set(handles.Pt1_X_StabDiag_Edit,'String',Pt_X_min);
    set(handles.Pt1_Y_StabDiag_Edit,'String',Pt_Y_min);
    set(handles.Pt2_X_StabDiag_Edit,'String',Pt_X_max);
    set(handles.Pt2_Y_StabDiag_Edit,'String',Pt_Y_max);
    
    %Lines for the Crop Stability Diagram
    handles.line1_StabDiag.x = [Pt_X_min,Pt_X_max];
    handles.line1_StabDiag.y = Pt_Y_min*ones(2,1);
    handles.line2_StabDiag.x = [Pt_X_min,Pt_X_max];
    handles.line2_StabDiag.y = Pt_Y_max*ones(2,1);
    handles.line3_StabDiag.x = Pt_X_min*ones(2,1);
    handles.line3_StabDiag.y = [Pt_Y_min,Pt_Y_max];
    handles.line4_StabDiag.x = Pt_X_max*ones(2,1);
    handles.line4_StabDiag.y = [Pt_Y_min,Pt_Y_max];
    
    set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
    child = get(handles.CropAxes,'Children');
    delete(child);
    surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);
    
    %Lines for the Crop Stability Diagram
    line(handles.line1_StabDiag.x,handles.line1_StabDiag.y,max(max(handles.Current))*ones(2,1),...
        'Color','r','LineStyle',':','LineWidth',3);
    line(handles.line2_StabDiag.x,handles.line2_StabDiag.y,max(max(handles.Current))*ones(2,1),...
        'Color','r','LineStyle',':','LineWidth',3);
    line(handles.line3_StabDiag.x,handles.line3_StabDiag.y,max(max(handles.Current))*ones(2,1),...
        'Color','r','LineStyle',':','LineWidth',3);
    line(handles.line4_StabDiag.x,handles.line4_StabDiag.y,max(max(handles.Current))*ones(2,1),...
        'Color','r','LineStyle',':','LineWidth',3);
    
    set(handles.CropAxes,'Xlim',[min(handles.VplgX),max(handles.VplgX)]);
    set(handles.CropAxes,'Ylim',[min(handles.VplgY),max(handles.VplgY)]);
    
    xlabel('X-axis [V]');ylabel('Y-axis [V]');
    view([0 0 90]);
    
else
    set(handles.Pt1_X_BiasTrian_Edit,'String',Pt_X_min);
    set(handles.Pt1_Y_BiasTrian_Edit,'String',Pt_Y_min);
    set(handles.Pt2_X_BiasTrian_Edit,'String',Pt_X_max);
    set(handles.Pt2_Y_BiasTrian_Edit,'String',Pt_Y_max);
    
    %Lines for the Crop Stability Diagram
    handles.line1_BiasTriangle.x = [Pt_X_min,Pt_X_max];
    handles.line1_BiasTriangle.y = Pt_Y_min*ones(2,1);
    handles.line2_BiasTriangle.x = [Pt_X_min,Pt_X_max];
    handles.line2_BiasTriangle.y = Pt_Y_max*ones(2,1);
    handles.line3_BiasTriangle.x = Pt_X_min*ones(2,1);
    handles.line3_BiasTriangle.y = [Pt_Y_min,Pt_Y_max];
    handles.line4_BiasTriangle.x = Pt_X_max*ones(2,1);
    handles.line4_BiasTriangle.y = [Pt_Y_min,Pt_Y_max];
    
    set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
    child = get(handles.CropAxes,'Children');
    delete(child);
    surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);
    
    %Lines for the Crop Stability Diagram
    line(handles.line1_BiasTriangle.x,handles.line1_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
        'Color','g','LineStyle',':','LineWidth',3);
    line(handles.line2_BiasTriangle.x,handles.line2_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
        'Color','g','LineStyle',':','LineWidth',3);
    line(handles.line3_BiasTriangle.x,handles.line3_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
        'Color','g','LineStyle',':','LineWidth',3);
    line(handles.line4_BiasTriangle.x,handles.line4_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
        'Color','g','LineStyle',':','LineWidth',3);
    
    %     set(handles.CropAxes,'Xlim',[min(handles.VplgX),max(handles.VplgX)]);
    %     set(handles.CropAxes,'Ylim',[min(handles.VplgY),max(handles.VplgY)]);
    
    set(handles.CropAxes,'Xlim',[handles.line1_StabDiag.x]);
    set(handles.CropAxes,'Ylim',[handles.line3_StabDiag.y]);
    
    xlabel('X-axis [V]');ylabel('Y-axis [V]');
    view([0 0 90]);
end

% else
%     msgbox('No data points were chosen');

guidata(hObject, handles);

% --- Executes on button press in CropStabDiagRadiobutton.
function CropStabDiagRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to CropStabDiagRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
set(handles.UpdateCoordPushbutton,'Enable','on');
set(handles.UpdateGuessCoordPushbutton,'Enable','off');

set(handles.Pt1_X_StabDiag_Edit,'Enable','on');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','on');
set(handles.Pt2_X_StabDiag_Edit,'Enable','on');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','on');

set(handles.Pt1_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','off');

set(handles.Pt1_X_Guess_Edit,'Enable','off');
set(handles.Pt1_Y_Guess_Edit,'Enable','off');
set(handles.Pt2_X_Guess_Edit,'Enable','off');
set(handles.Pt2_Y_Guess_Edit,'Enable','off');
set(handles.Pt3_X_Guess_Edit,'Enable','off');
set(handles.Pt3_Y_Guess_Edit,'Enable','off');
set(handles.Pt4_X_Guess_Edit,'Enable','off');
set(handles.Pt4_Y_Guess_Edit,'Enable','off');

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

%Lines for the Crop Stability Diagram
line(handles.line1_StabDiag.x,handles.line1_StabDiag.y,max(max(handles.Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);
line(handles.line2_StabDiag.x,handles.line2_StabDiag.y,max(max(handles.Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);
line(handles.line3_StabDiag.x,handles.line3_StabDiag.y,max(max(handles.Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);
line(handles.line4_StabDiag.x,handles.line4_StabDiag.y,max(max(handles.Current))*ones(2,1),...
    'Color','r','LineStyle',':','LineWidth',3);

set(handles.CropAxes,'Xlim',[min(handles.VplgX),max(handles.VplgX)]);
set(handles.CropAxes,'Ylim',[min(handles.VplgY),max(handles.VplgY)]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes on button press in CropBiasTriangleRadiobutton.
function CropBiasTriangleRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to CropBiasTriangleRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.UpdateCoordPushbutton,'Enable','on');
set(handles.UpdateGuessCoordPushbutton,'Enable','off');

set(handles.Pt1_X_StabDiag_Edit,'Enable','off');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','off');
set(handles.Pt2_X_StabDiag_Edit,'Enable','off');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','off');

set(handles.Pt1_X_BiasTrian_Edit,'Enable','on');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','on');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','on');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','on');

set(handles.Pt1_X_Guess_Edit,'Enable','off');
set(handles.Pt1_Y_Guess_Edit,'Enable','off');
set(handles.Pt2_X_Guess_Edit,'Enable','off');
set(handles.Pt2_Y_Guess_Edit,'Enable','off');
set(handles.Pt3_X_Guess_Edit,'Enable','off');
set(handles.Pt3_Y_Guess_Edit,'Enable','off');
set(handles.Pt4_X_Guess_Edit,'Enable','off');
set(handles.Pt4_Y_Guess_Edit,'Enable','off');

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

%Lines for the Crop Stability Diagram
line(handles.line1_BiasTriangle.x,handles.line1_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
    'Color','g','LineStyle',':','LineWidth',3);
line(handles.line2_BiasTriangle.x,handles.line2_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
    'Color','g','LineStyle',':','LineWidth',3);
line(handles.line3_BiasTriangle.x,handles.line3_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
    'Color','g','LineStyle',':','LineWidth',3);
line(handles.line4_BiasTriangle.x,handles.line4_BiasTriangle.y,max(max(handles.Current))*ones(2,1),...
    'Color','g','LineStyle',':','LineWidth',3);

% set(handles.CropAxes,'Xlim',[min(handles.VplgX),max(handles.VplgX)]);
% set(handles.CropAxes,'Ylim',[min(handles.VplgY),max(handles.VplgY)]);

set(handles.CropAxes,'Xlim',[handles.line1_StabDiag.x]);
set(handles.CropAxes,'Ylim',[handles.line3_StabDiag.y]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes on button press in BeginFittingPushbutton.
function BeginFittingPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to BeginFittingPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

numTriX = str2double(get(handles.NumTri_X_Edit,'String'));
numTriY = str2double(get(handles.NumTri_Y_Edit,'String'));

if(~isnan(numTriX) && ~isnan(numTriX))
    %Searching for the indices of the X axis for the crop of Stability diagram
    index1=[];index2=[];
    for i=1:length(handles.VplgX)
        if((handles.VplgX(i)<handles.line1_StabDiag.x(1) && handles.VplgX(i+1)>handles.line1_StabDiag.x(1)) || ...
                handles.VplgX(i)>handles.line1_StabDiag.x(1) && handles.VplgX(i+1)<handles.line1_StabDiag.x(1) || ...
                handles.VplgX(i)==handles.line1_StabDiag.x(1))
            index1 = i;
            break;
        end
    end
    for i=1:length(handles.VplgX)
        if((handles.VplgX(i)<handles.line1_StabDiag.x(2) && handles.VplgX(i+1)>handles.line1_StabDiag.x(2)) || ...
                handles.VplgX(i)>handles.line1_StabDiag.x(2) && handles.VplgX(i+1)<handles.line1_StabDiag.x(2) || ...
                handles.VplgX(i)==handles.line1_StabDiag.x(2))
            index2 = i;
            break;
        end
    end
    if(index1>index2)
        temp = index1;
        index1 = index2;
        index2 = temp;
    end
    VplgX_StabDiag = handles.VplgX(index1:index2)';
    
    %Searching for the indices of the Y axis for the crop of Stability diagram
    index3=[];index4=[];
    for i=1:length(handles.VplgY)
        if((handles.VplgY(i)<handles.line3_StabDiag.y(1) && handles.VplgY(i+1)>handles.line3_StabDiag.y(1)) || ...
                handles.VplgY(i)>handles.line3_StabDiag.y(1) && handles.VplgY(i+1)<handles.line3_StabDiag.y(1) || ...
                handles.VplgY(i)==handles.line3_StabDiag.y(1))
            index3 = i;
            break;
        end
    end
    for i=1:length(handles.VplgX)
        if((handles.VplgY(i)<handles.line3_StabDiag.y(2) && handles.VplgY(i+1)>handles.line3_StabDiag.y(2)) || ...
                handles.VplgY(i)>handles.line3_StabDiag.y(2) && handles.VplgY(i+1)<handles.line3_StabDiag.y(2) || ...
                handles.VplgY(i)==handles.line3_StabDiag.y(2))
            index4 = i;
            break;
        end
    end
    if(index3>index4)
        temp = index3;
        index3 = index4;
        index4 = temp;
    end
    VplgY_StabDiag = handles.VplgY(index3:index4);
    
    %Current for the crop of Stability diagram
    % VplgX_StabDiag = kron(ones(length(VplgY_StabDiag_temp),1),VplgX_StabDiag_temp);
    % VplgY_StabDiag = kron(ones(1,length(VplgX_StabDiag_temp)),VplgY_StabDiag_temp);
    Current_StabDiag = handles.Current(index3:index4,index1:index2);
    % size(VplgX_StabDiag);
    % size(VplgY_StabDiag);
    % size(Current_StabDiag);
    
    
    %Searching for the indices of the X axis for the crop of Bias Triangles
    index1=[];index2=[];
    for i=1:length(handles.VplgX)
        if((handles.VplgX(i)<handles.line1_BiasTriangle.x(1) && handles.VplgX(i+1)>handles.line1_BiasTriangle.x(1)) || ...
                handles.VplgX(i)>handles.line1_BiasTriangle.x(1) && handles.VplgX(i+1)<handles.line1_BiasTriangle.x(1) || ...
                handles.VplgX(i)==handles.line1_BiasTriangle.x(1))
            index1 = i;
            break;
        end
    end
    for i=1:length(handles.VplgX)
        if((handles.VplgX(i)<handles.line1_BiasTriangle.x(2) && handles.VplgX(i+1)>handles.line1_BiasTriangle.x(2)) || ...
                handles.VplgX(i)>handles.line1_BiasTriangle.x(2) && handles.VplgX(i+1)<handles.line1_BiasTriangle.x(2) || ...
                handles.VplgX(i)==handles.line1_BiasTriangle.x(2))
            index2 = i;
            break;
        end
    end
    if(index1>index2)
        temp = index1;
        index1 = index2;
        index2 = temp;
    end
    VplgX_BiasTri_temp = handles.VplgX(index1:index2)';
    % VplgX_BiasTri = kron(ones(5,1),handles.VplgX(index1:index2)');
    
    %Searching for the indices of the Y axis for the crop of Bias Triangles
    index3=[];index4=[];
    for i=1:length(handles.VplgY)
        if((handles.VplgY(i)<handles.line3_BiasTriangle.y(1) && handles.VplgY(i+1)>handles.line3_BiasTriangle.y(1)) || ...
                handles.VplgY(i)>handles.line3_BiasTriangle.y(1) && handles.VplgY(i+1)<handles.line3_BiasTriangle.y(1) || ...
                handles.VplgY(i)==handles.line3_BiasTriangle.y(1))
            index3 = i;
            break;
        end
    end
    for i=1:length(handles.VplgX)
        if((handles.VplgY(i)<handles.line3_BiasTriangle.y(2) && handles.VplgY(i+1)>handles.line3_BiasTriangle.y(2)) || ...
                handles.VplgY(i)>handles.line3_BiasTriangle.y(2) && handles.VplgY(i+1)<handles.line3_BiasTriangle.y(2) || ...
                handles.VplgY(i)==handles.line3_BiasTriangle.y(2))
            index4 = i;
            break;
        end
    end
    if(index3>index4)
        temp = index3;
        index3 = index4;
        index4 = temp;
    end
    VplgY_BiasTri_temp = handles.VplgY(index3:index4);
    % VplgY_BiasTri = kron(ones(5,1),handles.VplgY(index3:index4));
    
    %Current for the crop of Bias Triangles
    VplgX_BiasTri = kron(ones(length(VplgY_BiasTri_temp),1),VplgX_BiasTri_temp);
    VplgY_BiasTri = kron(ones(1,length(VplgX_BiasTri_temp)),VplgY_BiasTri_temp);
    Current_BiasTri = handles.Current(index3:index4,index1:index2);
    
    % size(VplgX_StabDiag)
    % size(VplgY_StabDiag)
    % size(Current_StabDiag)
    %
    % size(VplgX_BiasTri)
    % size(VplgY_BiasTri)
    % size(Current_BiasTri)
    
    % figure(400);
    % surf(VplgX_StabDiag,VplgY_StabDiag,Current_StabDiag,'EdgeAlpha',0);
    % view([0 0 90]);
    %
    % figure(401);
    % surf(VplgX_BiasTri,VplgY_BiasTri,Current_BiasTri,'EdgeAlpha',0);
    % view([0 0 90]);
    
    %-------------------HERE WE CALL THE FITTING CODE-------------------------%
    
    %Inputs for the Fitting Code
    
    % Guesses for the Bias Triangle:
    % handles.Pt1_Guess_Coord.x
    % handles.Pt1_Guess_Coord.y
    % handles.Pt2_Guess_Coord.x
    % handles.Pt2_Guess_Coord.y
    % handles.Pt3_Guess_Coord.x
    % handles.Pt3_Guess_Coord.y
    % handles.Pt4_Guess_Coord.x
    % handles.Pt4_Guess_Coord.y
    
    %Points 1-3 are the vertices of the triangle and the fourth is the "peak"
    %of the second triangle
    
    init_pts = [handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,...
        handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,...
        handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,...
        handles.Pt4_Guess_Coord.x-handles.Pt3_Guess_Coord.x];
    
    %Data for the Stability Diagram
    %VplgX_StabDiag
    %VplgY_StabDiag
    %Current_StabDiag
    
    %Data for the Bias Triangles
    %VplgX_BiasTri
    %VplgY_BiasTri
    %Current_BiasTri
    
%     Dir = cd;
%     i = strfind(Dir,'\');
%     cd([Dir(1:i(end-1)),'Functions']);
    userOptions.fitChargeStability = 1;
    userOptions.biquadratic = 1; % We want to extract biquadratic parameters
    
    numTri = [numTriX, numTriY];
            
    if userOptions.fitChargeStability
        userOptions.verbose = 0;
        userOptions.fitTriangle = 1;

        threshBT = getCurrentThreshold(Current_BiasTri);
        threshMBT = getCurrentThreshold(Current_StabDiag);

        % Fit the bias triangle the user selected to fit
        triPts = fitBiasTriangle(VplgX_BiasTri, VplgY_BiasTri, Current_BiasTri, userOptions, init_pts, threshBT);

        userOptions.verbose = 0;
        
        % Now fit the rest of the charge stability region selected by the
        % user
        allTriPts = fitManyBiasTriangles(VplgX_StabDiag, VplgY_StabDiag, Current_StabDiag, triPts, numTri, threshMBT, userOptions)

    else
        % No fitting.. Just constructs charge stability based off of user
        % input
        allTriPts = calcChargeStability(VplgX_StabDiag,VplgY_StabDiag,numTri);
    end
    
    % Plot the fit
    figure;
    hold on;
    drawChargeStabilityData(VplgX_StabDiag, VplgY_StabDiag, Current_StabDiag);
%     [rows,~]=size(allTriPts);
%     for ii = 1:rows
%         drawBiasTriangle(allTriPts(ii,:),Current_StabDiag,'white');
%     end
%     drawManyBiasTriangles(allTriPts,numTri,Current_StabDiag)
    
    % Extract necessary deltaVg values
    dVgs = calcDeltaVgs(allTriPts,numTri);

    capacitances = extractCapacitances(dVgs, handles.Vbias);
    [Ec,radii] = findOtherQDParams(capacitances);
    
    if userOptions.biquadratic
        findBiquadraticParameters(Ec,radii,allTriPts);
    end
    
%     cd(Dir);
    
else
    msgbox('You must provide input for the number of triangles along X and Y to be fit') ;
end

guidata(hObject, handles);
% close(handles.fitChargeStab_Plot_Figure);



% --- Executes on button press in Point4BiasTriangleGuessRadiobutton.
function Point4BiasTriangleGuessRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to Point4BiasTriangleGuessRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.UpdateCoordPushbutton,'Enable','off');
set(handles.UpdateGuessCoordPushbutton,'Enable','on');

set(handles.Pt1_X_StabDiag_Edit,'Enable','off');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','off');
set(handles.Pt2_X_StabDiag_Edit,'Enable','off');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','off');

set(handles.Pt1_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','off');

set(handles.Pt1_X_Guess_Edit,'Enable','off');
set(handles.Pt1_Y_Guess_Edit,'Enable','off');
set(handles.Pt2_X_Guess_Edit,'Enable','off');
set(handles.Pt2_Y_Guess_Edit,'Enable','off');
set(handles.Pt3_X_Guess_Edit,'Enable','off');
set(handles.Pt3_Y_Guess_Edit,'Enable','off');
set(handles.Pt4_X_Guess_Edit,'Enable','on');
set(handles.Pt4_Y_Guess_Edit,'Enable','on');

Pt_X_Guess_Coord = str2double(get(handles.Pt4_X_Guess_Edit,'String'));
Pt_Y_Guess_Coord = str2double(get(handles.Pt4_Y_Guess_Edit,'String'));

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
    
    handles.Pt4_Guess_Coord.x = Pt_X_Guess_Coord;
    handles.Pt4_Guess_Coord.y = Pt_Y_Guess_Coord;           
    
    %Point for the Guess of Bias Triangle
    line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
        'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');
end
if(get(handles.Point1BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt1_Guess_Coord.x) && ~isempty(handles.Pt1_Guess_Coord.x))
        line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point2BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt2_Guess_Coord.x) && ~isempty(handles.Pt2_Guess_Coord.x))
        line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point3BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt3_Guess_Coord.x) && ~isempty(handles.Pt3_Guess_Coord.x))
        line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end

set(handles.CropAxes,'Xlim',[handles.line1_BiasTriangle.x]);
set(handles.CropAxes,'Ylim',[handles.line3_BiasTriangle.y]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes on button press in Point3BiasTriangleGuessRadiobutton.
function Point3BiasTriangleGuessRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to Point3BiasTriangleGuessRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.UpdateCoordPushbutton,'Enable','off');
set(handles.UpdateGuessCoordPushbutton,'Enable','on');

set(handles.Pt1_X_StabDiag_Edit,'Enable','off');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','off');
set(handles.Pt2_X_StabDiag_Edit,'Enable','off');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','off');

set(handles.Pt1_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','off');

set(handles.Pt1_X_Guess_Edit,'Enable','off');
set(handles.Pt1_Y_Guess_Edit,'Enable','off');
set(handles.Pt2_X_Guess_Edit,'Enable','off');
set(handles.Pt2_Y_Guess_Edit,'Enable','off');
set(handles.Pt3_X_Guess_Edit,'Enable','on');
set(handles.Pt3_Y_Guess_Edit,'Enable','on');
set(handles.Pt4_X_Guess_Edit,'Enable','off');
set(handles.Pt4_Y_Guess_Edit,'Enable','off');

Pt_X_Guess_Coord = str2double(get(handles.Pt3_X_Guess_Edit,'String'));
Pt_Y_Guess_Coord = str2double(get(handles.Pt3_Y_Guess_Edit,'String'));

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
    
    handles.Pt3_Guess_Coord.x = Pt_X_Guess_Coord;
    handles.Pt3_Guess_Coord.y = Pt_Y_Guess_Coord;            
    
    %Point for the Guess of Bias Triangle
    line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
        'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');    
end
if(get(handles.Point1BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt1_Guess_Coord.x) && ~isempty(handles.Pt1_Guess_Coord.x))
        line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point2BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt2_Guess_Coord.x) && ~isempty(handles.Pt2_Guess_Coord.x))
        line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point4BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt4_Guess_Coord.x) && ~isempty(handles.Pt4_Guess_Coord.x))
        line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end

set(handles.CropAxes,'Xlim',[handles.line1_BiasTriangle.x]);
set(handles.CropAxes,'Ylim',[handles.line3_BiasTriangle.y]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes on button press in Point2BiasTriangleGuessRadiobutton.
function Point2BiasTriangleGuessRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to Point2BiasTriangleGuessRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.UpdateCoordPushbutton,'Enable','off');
set(handles.UpdateGuessCoordPushbutton,'Enable','on');

set(handles.Pt1_X_StabDiag_Edit,'Enable','off');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','off');
set(handles.Pt2_X_StabDiag_Edit,'Enable','off');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','off');

set(handles.Pt1_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','off');

set(handles.Pt1_X_Guess_Edit,'Enable','off');
set(handles.Pt1_Y_Guess_Edit,'Enable','off');
set(handles.Pt2_X_Guess_Edit,'Enable','on');
set(handles.Pt2_Y_Guess_Edit,'Enable','on');
set(handles.Pt3_X_Guess_Edit,'Enable','off');
set(handles.Pt3_Y_Guess_Edit,'Enable','off');
set(handles.Pt4_X_Guess_Edit,'Enable','off');
set(handles.Pt4_Y_Guess_Edit,'Enable','off');

Pt_X_Guess_Coord = str2double(get(handles.Pt2_X_Guess_Edit,'String'));
Pt_Y_Guess_Coord = str2double(get(handles.Pt2_Y_Guess_Edit,'String'));

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
    
    handles.Pt2_Guess_Coord.x = Pt_X_Guess_Coord;
    handles.Pt2_Guess_Coord.y = Pt_Y_Guess_Coord;        
    
    %Point for the Guess of Bias Triangle
    line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
        'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');     
end
if(get(handles.Point1BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt1_Guess_Coord.x) && ~isempty(handles.Pt1_Guess_Coord.x))
        line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point3BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt3_Guess_Coord.x) && ~isempty(handles.Pt3_Guess_Coord.x))
        line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point4BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt4_Guess_Coord.x) && ~isempty(handles.Pt4_Guess_Coord.x))
        line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end

set(handles.CropAxes,'Xlim',[handles.line1_BiasTriangle.x]);
set(handles.CropAxes,'Ylim',[handles.line3_BiasTriangle.y]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes on button press in Point1BiasTriangleGuessRadiobutton.
function Point1BiasTriangleGuessRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to Point1BiasTriangleGuessRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.UpdateCoordPushbutton,'Enable','off');
set(handles.UpdateGuessCoordPushbutton,'Enable','on');

set(handles.Pt1_X_StabDiag_Edit,'Enable','off');
set(handles.Pt1_Y_StabDiag_Edit,'Enable','off');
set(handles.Pt2_X_StabDiag_Edit,'Enable','off');
set(handles.Pt2_Y_StabDiag_Edit,'Enable','off');

set(handles.Pt1_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt1_Y_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_X_BiasTrian_Edit,'Enable','off');
set(handles.Pt2_Y_BiasTrian_Edit,'Enable','off');

set(handles.Pt1_X_Guess_Edit,'Enable','on');
set(handles.Pt1_Y_Guess_Edit,'Enable','on');
set(handles.Pt2_X_Guess_Edit,'Enable','off');
set(handles.Pt2_Y_Guess_Edit,'Enable','off');
set(handles.Pt3_X_Guess_Edit,'Enable','off');
set(handles.Pt3_Y_Guess_Edit,'Enable','off');
set(handles.Pt4_X_Guess_Edit,'Enable','off');
set(handles.Pt4_Y_Guess_Edit,'Enable','off');

Pt_X_Guess_Coord = str2double(get(handles.Pt1_X_Guess_Edit,'String'));
Pt_Y_Guess_Coord = str2double(get(handles.Pt1_Y_Guess_Edit,'String'));

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
    
    handles.Pt1_Guess_Coord.x = Pt_X_Guess_Coord;
    handles.Pt1_Guess_Coord.y = Pt_Y_Guess_Coord;
       
    %Point for the Guess of Bias Triangle
    line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
        'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');
end
if(get(handles.Point2BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt2_Guess_Coord.x) && ~isempty(handles.Pt2_Guess_Coord.x))
        line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point3BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt3_Guess_Coord.x) && ~isempty(handles.Pt3_Guess_Coord.x))
        line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end
if(get(handles.Point4BiasTriangleGuessCheckbox,'Value'))
    if(~isempty(handles.Pt4_Guess_Coord.x) && ~isempty(handles.Pt4_Guess_Coord.x))
        line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
            'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
    end
end

set(handles.CropAxes,'Xlim',[handles.line1_BiasTriangle.x]);
set(handles.CropAxes,'Ylim',[handles.line3_BiasTriangle.y]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes on button press in UpdateGuessCoordPushbutton.
function UpdateGuessCoordPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateGuessCoordPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dcm_obj = datacursormode(handles.fitChargeStab_Plot_Figure);
info_struct = getCursorInfo(dcm_obj);

%If data cursors are chosen, the coordinates are extracted
%Ensures that data cursors were chosen
if(~isempty(info_struct))
    %Ensure that only 1 data points was chosen
    if(length(info_struct)==1)        
        pt_pos = info_struct(1).Position;                
        Pt_X_Guess_Coord = pt_pos(1,1);
        Pt_Y_Guess_Coord = pt_pos(1,2);                              
        
        if(get(handles.Point1BiasTriangleGuessRadiobutton,'Value'))
            set(handles.Pt1_X_Guess_Edit,'String',Pt_X_Guess_Coord);
            set(handles.Pt1_Y_Guess_Edit,'String',Pt_Y_Guess_Coord);
        elseif(get(handles.Point2BiasTriangleGuessRadiobutton,'Value'))
            set(handles.Pt2_X_Guess_Edit,'String',Pt_X_Guess_Coord);
            set(handles.Pt2_Y_Guess_Edit,'String',Pt_Y_Guess_Coord);
        elseif(get(handles.Point3BiasTriangleGuessRadiobutton,'Value'))
            set(handles.Pt3_X_Guess_Edit,'String',Pt_X_Guess_Coord);
            set(handles.Pt3_Y_Guess_Edit,'String',Pt_Y_Guess_Coord);
        elseif(get(handles.Point4BiasTriangleGuessRadiobutton,'Value'))
            set(handles.Pt4_X_Guess_Edit,'String',Pt_X_Guess_Coord);
            set(handles.Pt4_Y_Guess_Edit,'String',Pt_Y_Guess_Coord);
        end
        
    else
        msgbox('More than 1 data point were chosen. You must choose only 1 data point');
    end
else
    if(get(handles.Point1BiasTriangleGuessRadiobutton,'Value'))                
        Pt_X_Guess_Coord = str2double(get(handles.Pt1_X_Guess_Edit,'String'));
        Pt_Y_Guess_Coord = str2double(get(handles.Pt1_Y_Guess_Edit,'String'));        
    elseif(get(handles.Point2BiasTriangleGuessRadiobutton,'Value'))        
        Pt_X_Guess_Coord = str2double(get(handles.Pt2_X_Guess_Edit,'String'));
        Pt_Y_Guess_Coord = str2double(get(handles.Pt2_Y_Guess_Edit,'String'));
    elseif(get(handles.Point3BiasTriangleGuessRadiobutton,'Value'))
        Pt_X_Guess_Coord = str2double(get(handles.Pt3_X_Guess_Edit,'String'));
        Pt_Y_Guess_Coord = str2double(get(handles.Pt3_Y_Guess_Edit,'String'));
    elseif(get(handles.Point4BiasTriangleGuessRadiobutton,'Value'))
        Pt_X_Guess_Coord = str2double(get(handles.Pt4_X_Guess_Edit,'String'));
        Pt_Y_Guess_Coord = str2double(get(handles.Pt4_Y_Guess_Edit,'String'));        
    end
end

set(handles.fitChargeStab_Plot_Figure,'CurrentAxes',handles.CropAxes);
child = get(handles.CropAxes,'Children');
delete(child);
surf(handles.VplgX,handles.VplgY,handles.Current,'EdgeAlpha',0);

if(get(handles.Point1BiasTriangleGuessRadiobutton,'Value'))
    if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
        handles.Pt1_Guess_Coord.x = Pt_X_Guess_Coord;
        handles.Pt1_Guess_Coord.y = Pt_Y_Guess_Coord;
        line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current)),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');
    end
    if(get(handles.Point2BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt2_Guess_Coord.x) && ~isempty(handles.Pt2_Guess_Coord.x))
            line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point3BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt3_Guess_Coord.x) && ~isempty(handles.Pt3_Guess_Coord.x))
            line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point4BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt4_Guess_Coord.x) && ~isempty(handles.Pt4_Guess_Coord.x))
            line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
elseif(get(handles.Point2BiasTriangleGuessRadiobutton,'Value'))
    if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
        handles.Pt2_Guess_Coord.x = Pt_X_Guess_Coord;
        handles.Pt2_Guess_Coord.y = Pt_Y_Guess_Coord;        
        line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current)),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');
    end
    if(get(handles.Point1BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt1_Guess_Coord.x) && ~isempty(handles.Pt1_Guess_Coord.x))
            line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point3BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt3_Guess_Coord.x) && ~isempty(handles.Pt3_Guess_Coord.x))
            line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point4BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt4_Guess_Coord.x) && ~isempty(handles.Pt4_Guess_Coord.x))
            line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
elseif(get(handles.Point3BiasTriangleGuessRadiobutton,'Value'))
    if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
        handles.Pt3_Guess_Coord.x = Pt_X_Guess_Coord;
        handles.Pt3_Guess_Coord.y = Pt_Y_Guess_Coord;
        line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current)),...
            'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');
    end 
    if(get(handles.Point1BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt1_Guess_Coord.x) && ~isempty(handles.Pt1_Guess_Coord.x))
            line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point2BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt2_Guess_Coord.x) && ~isempty(handles.Pt2_Guess_Coord.x))
            line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point4BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt4_Guess_Coord.x) && ~isempty(handles.Pt4_Guess_Coord.x))
            line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
elseif(get(handles.Point4BiasTriangleGuessRadiobutton,'Value'))
    if(~isnan(Pt_X_Guess_Coord) && ~isnan(Pt_Y_Guess_Coord))
        handles.Pt4_Guess_Coord.x = Pt_X_Guess_Coord;
        handles.Pt4_Guess_Coord.y = Pt_Y_Guess_Coord;
        line(handles.Pt4_Guess_Coord.x,handles.Pt4_Guess_Coord.y,max(max(handles.Current)),...
            'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','c','MarkerEdgeColor','k');
    end
    if(get(handles.Point1BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt1_Guess_Coord.x) && ~isempty(handles.Pt1_Guess_Coord.x))
            line(handles.Pt1_Guess_Coord.x,handles.Pt1_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point2BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt2_Guess_Coord.x) && ~isempty(handles.Pt2_Guess_Coord.x))
            line(handles.Pt2_Guess_Coord.x,handles.Pt2_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
    if(get(handles.Point3BiasTriangleGuessCheckbox,'Value'))
        if(~isempty(handles.Pt3_Guess_Coord.x) && ~isempty(handles.Pt3_Guess_Coord.x))
            line(handles.Pt3_Guess_Coord.x,handles.Pt3_Guess_Coord.y,max(max(handles.Current))*ones(2,1),...
                'LineStyle','none','Marker','^','MarkerSize',5,'MarkerFaceColor','m','MarkerEdgeColor','k');
        end
    end
end

set(handles.CropAxes,'Xlim',[handles.line1_BiasTriangle.x]);
set(handles.CropAxes,'Ylim',[handles.line3_BiasTriangle.y]);

xlabel('X-axis [V]');ylabel('Y-axis [V]');
view([0 0 90]);

guidata(hObject, handles);

% --- Executes when user attempts to close fitChargeStab_Plot_Figure.
function fitChargeStab_Plot_Figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fitChargeStab_Plot_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
Dir = cd;
i = strfind(Dir,'\');

MainDir = Dir(1:i(end-1)-1);
cd(MainDir);
% close(handles.fitChargeStab_Plot_Figure);

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes on button press in Point4BiasTriangleGuessCheckbox.
function Point4BiasTriangleGuessCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Point4BiasTriangleGuessCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Point3BiasTriangleGuessCheckbox.
function Point3BiasTriangleGuessCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Point3BiasTriangleGuessCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Point2BiasTriangleGuessCheckbox.
function Point2BiasTriangleGuessCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Point2BiasTriangleGuessCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Point1BiasTriangleGuessCheckbox.
function Point1BiasTriangleGuessCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to Point1BiasTriangleGuessCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function Pt1_X_StabDiag_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt1_X_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt1_X_StabDiag_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt1_X_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt2_X_StabDiag_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt2_X_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt2_X_StabDiag_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt2_X_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt1_Y_StabDiag_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt1_Y_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt1_Y_StabDiag_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt1_Y_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt2_Y_StabDiag_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt2_Y_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt2_Y_StabDiag_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt2_Y_StabDiag_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt1_X_BiasTrian_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt1_X_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt1_X_BiasTrian_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt1_X_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt2_X_BiasTrian_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt2_X_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt2_X_BiasTrian_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt2_X_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt1_Y_BiasTrian_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt1_Y_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt1_Y_BiasTrian_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt1_Y_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt2_Y_BiasTrian_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt2_Y_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Pt2_Y_BiasTrian_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt2_Y_BiasTrian_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt1_X_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt1_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt1_X_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt1_X_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt1_X_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt1_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt2_X_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt2_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt2_X_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt2_X_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt2_X_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt2_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt1_Y_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt1_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt1_Y_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt1_Y_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt1_Y_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt1_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt2_Y_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt2_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt2_Y_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt2_Y_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt2_Y_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt2_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt3_X_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt3_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt3_X_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt3_X_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt3_X_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt3_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt3_Y_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt3_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt3_Y_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt3_Y_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt3_Y_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt3_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt4_X_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt4_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt4_X_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt4_X_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt4_X_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt4_X_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pt4_Y_Guess_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pt4_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pt4_Y_Guess_Edit as text
%        str2double(get(hObject,'String')) returns contents of Pt4_Y_Guess_Edit as a double

% --- Executes during object creation, after setting all properties.
function Pt4_Y_Guess_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pt4_Y_Guess_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTri_X_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to NumTri_X_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTri_X_Edit as text
%        str2double(get(hObject,'String')) returns contents of NumTri_X_Edit as a double


% --- Executes during object creation, after setting all properties.
function NumTri_X_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTri_X_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTri_Y_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to NumTri_Y_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTri_Y_Edit as text
%        str2double(get(hObject,'String')) returns contents of NumTri_Y_Edit as a double


% --- Executes during object creation, after setting all properties.
function NumTri_Y_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTri_Y_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
