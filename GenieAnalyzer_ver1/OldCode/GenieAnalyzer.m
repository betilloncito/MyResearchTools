function varargout = GenieAnalyzer(varargin)
% GENIEANALYZER MATLAB code for GenieAnalyzer.fig
%      GENIEANALYZER, by itself, creates a new GenieAnalyzer or raises the existing
%      singleton*.
%
%      H = GENIEANALYZER returns the handle to a new GENIEANALYZER or the handle to
%      the existing singleton*.
%
%      GENIEANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENIEANALYZER.M with the given input arguments.
%
%      GENIEANALYZER('Property','Value',...) creates a new GENIEANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GenieAnalyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GenieAnalyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GenieAnalyzer

% Last Modified by GUIDE v2.5 28-Sep-2016 10:05:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GenieAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @GenieAnalyzer_OutputFcn, ...
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


% --- Executes just before GenieAnalyzer is made visible.
function GenieAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GenieAnalyzer (see VARARGIN)

%Initializes the options for plotting: color, marker color, linestyle,
%marker, linewidth and markersize
set(handles.ColorPopupmenu,'String',{'r','b','k','g','c','m','y'});
handles.ColorRGB = {[1 0 0],[0 0 1],[0 0 0],[0 0.75 0],[0 1 1],[1 0 1],[1 0.75 0]};
set(handles.LineStylePopupmenu,'String',{'-','--',':','-.','none'});
set(handles.MarkerPopupmenu,'String',{'none','.','o','*','x','d','v','^','s'});
set(handles.MarkerColorPopupmenu,'String',{'r','b','k','g','c','m','y'});

%Sets buttons OFF as initialization
% set(handles.PlotDataPushbutton,'Enable','off');
% set(handles.Plot3D_SweepVarPopupmenu,'Enable','off');
% set(handles.Plot3D_ValuePopupmenu,'Enable','off')

%Resets Global variables used to store data X and data Y
handles.Waveforms.xData = [];
handles.Waveforms.yData = [];
handles.Stored_MatrixData = {};
handles.Stored_OrgMatrixData = {};
%Resets variable used to store the file path where the data was loaded
handles.FilePath = [];

set(handles.VariableListTable,'Data',[]);

% Choose default command line output for GenieAnalyzer
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GenieAnalyzer wait for user response (see UIRESUME)
% uiwait(handles.GenieAnalyzerFigure);


% --- Outputs from this function are returned to the command line.
function varargout = GenieAnalyzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Open button to open a file to extract data from
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
%Saves Current directory
NowDir = cd;

%If there is a path already stored, then go to that path directory
if(isempty(handles.FilePath)==0)
    cd(handles.FilePath);
end
%Opens dialogue window to allow user to select a file
[Filename, Path, Filterindex] = uigetfile('*', 'Choose a file');
%Check to see if the user selected a file successfully
if(Path~=0)
    handles.FilePath = Path;
    handles.Filename = Filename;
    set(handles.FilenameText,'String',Filename);
%     set(handles.HeaderText,'String',' '); Could be deleted if not used

    %Returns to Working Directory
    cd(NowDir);
    %Allows user to extract data
    set(handles.ExtractDataPushbutton,'Enable','on');
else
    %Returns to Working Directory
    cd(NowDir);
end
guidata(hObject, handles);

% Extract data from file
function ExtractDataPushbutton_Callback(hObject, eventdata, handles)
%Saves current directory
NowDir = cd;
%Resets Global variable
handles.Data = [];
%Gets filetype selected by user in the File Type popupmenu
FileType = get(handles.FileTypePopupmenu,'Value');

%Goes to directory where the Extraction Scripts are saved
%Extraction Scripts are scripts used to extract data from files depending
%on their file type
cd([NowDir,'\Scripts\ExtractData_Scripts'])
if(FileType==1 || FileType==2)
    %feval - executes script (name is string variable) given the filename, the
    %path where the file is stored and the file type. Outputs are the
    %headers of all variables and the variable data. 
    [Data,header] = feval('ExtractData_FileType_1_2',handles.Filename,handles.FilePath,FileType);
elseif(FileType==3)
    %TO DO: Need to fix script to be able to upload a file with 3-D scans Spanish
    %Aquis (.csv)
    [Data,header] = feval('ExtractData_FileType_3',handles.Filename,handles.FilePath,FileType);
end
%NOTE Should implement a way to catch an error during the extraction of
%data due to an erroneous selection of file type of another unknown error.
%In which case, the organize button should not be enabled and function
%should quit.

%Allows user to organize data
set(handles.OrganizePushbutton,'Enable','on');

%Returns to working directory
cd(NowDir);
%Saves extracted data in Global variable
handles.Data = Data;
handles.Header_Vector = header;
%Sets header from extracted header: this refers to the variables in file
set(handles.HeaderText,'String',cell2mat(header));

guidata(hObject, handles);


% --- Executes on button press in OpenWindowPushbutton.
function OpenWindowPushbutton_Callback(hObject, eventdata, handles)
set(0,'CurrentFigure',handles.GenieAnalyzerFigure);
set(0,'ShowHiddenHandles','on');
set(handles.GenieAnalyzerFigure,'CurrentAxes',handles.axes1);

axs_children = get(gca,'Children');
axs_line = findall(axs_children,'Type','Line');
axs_text = findall(axs_children,'Type','Text');
axs_surf = findall(axs_children,'Type','Surface');
ax = gca;
title_label = ax.Title.String;
x_label = ax.XLabel.String;
y_label = ax.YLabel.String;

if(isempty(axs_line)==0)
    CustomizeFigures(gcf,title_label,0);
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
    disp('hi')
    xdata = get(axs_surf,'XData');
    ydata = get(axs_surf,'YData');
    zdata = get(axs_surf,'ZData');
    EdgeColor = get(axs_surf,'EdgeColor');
    FaceAlpha = get(axs_surf,'FaceAlpha');
    CData = get(axs_surf,'CData');
    
    figure('WindowStyle','normal','Name','Data Plot');
    surf(xdata,ydata,zdata,'EdgeColor',EdgeColor,...
        'FaceAlpha',FaceAlpha,'CData',CData)
    
    XY_plane=[0 90];
    view(XY_plane);
    NumColors = 1000;
    colormap(jet(NumColors))
    handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
        str2double(get(handles.MaxValColorEdit,'String'))];
    caxis(handles.ColorAxis_Min_Max);
    title(title_label);xlabel(x_label);ylabel(y_label);

end
hold off;

guidata(hObject, handles);

% --- Executes on button press in OrganizePushbutton.
function OrganizePushbutton_Callback(hObject, eventdata, handles)
handles.MatrixData =  {};
Data = handles.Data.data;

%Extracts the indices entered by user and stores them in an array
IndicesStr = get(handles.SweepIndicesEdit,'String');
if(isempty(IndicesStr))
    msgbox(['Must enter indices for the sweep variables in Sweep Indices textbox ',...
    'to begin organization of data']);
else
    IndicesStr = strtrim(IndicesStr);
    u = findstr(strtrim(IndicesStr),',');
    index_input = str2double(IndicesStr(1));
    for i=1:length(u)
        index_input = [index_input,str2double(IndicesStr(u(i)+1))];
    end
    
    %Figures out the correct order of the indices based on the change in the
    %sweep variables. It effectively determines the nesting order of the sweep
    %variables. Then it compares the correct order with the order given by user
    %and output a warning in case there is a difference
    index = index_input;
    index_temp = [];cnt=1;
    for i=1:size(Data,1)-1
        for p=1:length(index)
            if(Data(i,index(p))~=Data(i+1,index(p)))
                index_array(cnt) = index(p);
                cnt=cnt+1;
            else
                index_temp = [index_temp,index(p)];
            end
        end
        if(isempty(index_temp))
            break;
        end
        index = index_temp;
        index_temp=[];
    end
    if(any(index_input~=index_array))
        msgbox(['WARNING: User input for sweep indices was NOT in order of nested loops.',...
            'Correct ordered of nested loops has been detected']);
    end
    %Stores the sweep variable indices in a global var.
    handles.SweepVar_Index = index_array;
    
    %Determines the number of points swept for each sweep variable. It creates
    %a variable with the dimensions of sweeping. The first two dimensions are
    %the size of each matrix (row and col), where the rows corresponds to the
    %sweep size of the 1st sweep variable(nest loop 1) and the columns are the
    %number of variables recorded in total. The other dimensions are the size
    %of the other sweep variables.
    n = ones(1,length(index_array));
    for kk=1:length(index_array);
        for i=2:size(Data,1)
            if(i==2)
                startVal = Data(i-1,index_array(kk));
            end
            if(Data(i-1,index_array(kk)) ~= Data(i,index_array(kk)))
                if(startVal == Data(i,index_array(kk)))
                    break;
                end
                n(kk) = n(kk)+1;
            end
        end
    end
    nn = [n(1),size(Data,2),n(2:end)];
    %Stores the sweep variable size in a global var.
    handles.SweepVar_Size = nn;
    
    %Organizes the data in multidimensional array: the first two dimensions
    %correspond to (rows) the resolution of 1st sweep variable by (columns) the
    %number of variables recorded. The other dimensions correspond to the
    %resolution of each nested sweep variable in the correct nested order.
    if(length(index_array)>1)
        OrgData=ones(nn);
        L=nn(1)*nn(2);
        count=1;io=1;
        for i=2:size(Data,1)
            if(Data(i-1,index_array(2)) ~= Data(i,index_array(2)) || i==size(Data,1))
                if(i==size(Data,1))
                    i=i+1;
                end
                OrgData(L*(count-1)+1:L*count) = Data(io:i-1,:);
                count=count+1;
                io=i;
            end
        end
    else
        OrgData=Data;
    end
    %Stores organized data into global variable
    handles.OrgMatrixData = OrgData;
    handles.MatrixData = Data;
    %Sets values for each popupmenu to 1 to avoid having a popupmenu with a
    %value higher than the length of its String
    set(handles.X_VariablePlotPopupmenu,'Value',1);
    set(handles.Y_VariablePlotPopupmenu,'Value',1);
    set(handles.Z_VariablePlotPopupmenu,'Value',1);
    
    %If there is only 1 sweep variable the Z popupmenu is disable since there
    %is not enough data to plot a 2D scan
    if(length(index_array)==1)
        set(handles.Z_VariablePlotPopupmenu,'Enable','off');
    else
        %Determines the variable headers which are NOT sweep variables
        headerZ=[];
        for i=1:length(handles.Header_Vector)
            if(any(i==index_array)==0)
                headerZ = [headerZ,handles.Header_Vector(i)];
            end
        end
        set(handles.Z_VariablePlotPopupmenu,'String',headerZ);
    end
    
    %Sets the String for each popupmenu, where X and Y have all headers but Z
    %only has non sweep variables
    set(handles.X_VariablePlotPopupmenu,'String',handles.Header_Vector);
    set(handles.Y_VariablePlotPopupmenu,'String',handles.Header_Vector);
    
    

    %Enables buttons to plot and erase data. Also enables ability to open a
    %script and the popupmenus to select X, Y and Z variables
    set(handles.PlotDataPushbutton,'Enable','on');
    set(handles.DeleteFilesOrganizedPushbutton,'Enable','on');
    set(handles.X_VariablePlotPopupmenu,'Enable','on');
    set(handles.Y_VariablePlotPopupmenu,'Enable','on');
    
    %-------------------------------------------------------------------------%
    % if(isempty(get(handles.SweepIndicesEdit,'String'))==0 && isempty(get(handles.YEdit,'String')) ...
    %         && isempty(get(handles.ZEdit,'String')))
    %
    %     handles.MatrixData = handles.Data.data;
    %     X_index = str2double(get(handles.SweepIndicesEdit,'String'));
    %
    %     set(handles.X_VariablePlotPopupmenu,'Value',1);
    %     set(handles.Y_VariablePlotPopupmenu,'Value',1);
    %     set(handles.Z_VariablePlotPopupmenu,'Value',1);
    %
    %     set(handles.X_VariablePlotPopupmenu,'String',handles.Header_Vector(X_index))
    %     set(handles.Y_VariablePlotPopupmenu,'String',['none',handles.Header_Vector])
    %     set(handles.Z_VariablePlotPopupmenu,'Enable','off')
    %     set(handles.PlotDataPushbutton,'Enable','on');
    %
    % elseif(isempty(get(handles.SweepIndicesEdit,'String'))==0 && isempty(get(handles.YEdit,'String'))==0 ...
    %         && isempty(get(handles.ZEdit,'String')))
    %
    %     X_index = str2double(get(handles.SweepIndicesEdit,'String'));
    %     Y_index = str2double(get(handles.YEdit,'String'));
    %
    %     %Gets necessary voltages and current vectors using user indeces
    %     X = handles.Data.data(:,X_index);
    %     Y = handles.Data.data(:,Y_index);
    %
    %     DATA = handles.Data.data;
    %     io=1;
    %     for i=1:size(DATA,1)
    %         if(DATA(i,Y_index)~=DATA(i-1,Y_index))
    %             handles.MatrixData(:,:,1) = DATA(io:i,:);
    %             io=i+1;
    %         end
    %
    %     end
    %
    %     if(Y(1)==Y(2))
    %         handles.SweepVariable_2_index = Y_index;
    %         handles.SweepVariable_1_index = X_index;
    %         IndexStart = 1;
    %         %Determines start and end voltages for Vbias
    %         for k=2:length(X)
    %             if(X(k) == X(IndexStart))
    %                 sizeX = k-1;
    %                 break;
    %             end
    %         end
    %
    %         i=1;
    %         while(sizeX*i <= length(X))
    %             handles.MatrixData(i) = {handles.Data.data(1+sizeX*(i-1):sizeX*(i),:)};
    %             i = i+1;
    %         end
    %     else
    %         handles.SweepVariable_2_index = X_index;
    %         handles.SweepVariable_1_index = Y_index;
    %         IndexStart = 1;
    %         %Determines start and end voltages for Vbias
    %         for k=2:length(Y)
    %             if(Y(k) == Y(IndexStart))
    %                 sizeY = k-1;
    %                 break;
    %             end
    %         end
    %
    %         i=1;
    %         while(sizeY*i <= length(Y))
    %             handles.MatrixData(i) = {handles.Data.data(1+sizeY*(i-1):sizeY*(i),:)};
    %             i = i+1;
    %         end
    %     end
    %     SweepVar_header = [handles.Header_Vector(handles.SweepVariable_1_index),...
    %         handles.Header_Vector(handles.SweepVariable_2_index)];
    %     set(handles.X_VariablePlotPopupmenu,'String',SweepVar_header);
    %     set(handles.Y_VariablePlotPopupmenu,'String',['none';handles.Header_Vector']);
    %     set(handles.Z_VariablePlotPopupmenu,'String',['none';handles.Header_Vector']);
    %     set(handles.PlotDataPushbutton,'Enable','on');
    % end
    % length(handles.Stored_MatrixData)
    %-------------------------------------------------------------------------%
    
    %Stores organized data into a cell where other organized data from other
    %files can be stored and be accessed by a script.
    handles.Stored_OrgMatrixData(1,length(handles.Stored_OrgMatrixData)+1) = {handles.OrgMatrixData};
    handles.Stored_MatrixData(1,length(handles.Stored_MatrixData)+1) = {handles.MatrixData};
    
    %Adds filename to popupmenu with organized files
    filename = get(handles.FilenameText,'String');
    List = get(handles.ListFilesOrganizedPopupmenu,'String');
    if(size(List,1)==1)
        if(strcmp('No Data',List))
            set(handles.ListFilesOrganizedPopupmenu,'String',filename)
        else
            List = {List};
            List(size(List,1)+1,1) = {filename};
            set(handles.ListFilesOrganizedPopupmenu,'String',List);
        end
    else
        List(size(List,1)+1,1) = {filename};
        set(handles.ListFilesOrganizedPopupmenu,'String',List);
    end
end

guidata(hObject, handles);


% --- Executes on button press in DeleteFilesOrganizedPushbutton.
function DeleteFilesOrganizedPushbutton_Callback(hObject, eventdata, handles)
%Deletes all stored organized data from all files
handles.Stored_OrgMatrixData = {};
handles.Stored_MatrixData = {};
%Resets list of organized files to none
set(handles.ListFilesOrganizedPopupmenu,'String','No Data');
set(handles.ListFilesOrganizedPopupmenu,'Value',1);
%Plotting is not allowed since there is no data to plot
set(handles.PlotDataPushbutton,'Enable','off');
set(handles.DeleteFilesOrganizedPushbutton,'Enable','off');
set(handles.ApplyAnalysisScriptPushbutton,'Enable','off');

set(handles.X_VariablePlotPopupmenu,'Value',1);
set(handles.Y_VariablePlotPopupmenu,'Value',1);
set(handles.Z_VariablePlotPopupmenu,'Value',1);
set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
set(handles.Plot3D_ValuePopupmenu,'Value',1);
set(handles.X_VariablePlotPopupmenu,'String',' ');
set(handles.Y_VariablePlotPopupmenu,'String',' ');
set(handles.Z_VariablePlotPopupmenu,'String',' ');
set(handles.Plot3D_SweepVarPopupmenu,'String',' ');
set(handles.Plot3D_ValuePopupmenu,'String',' ');

set(handles.X_VariablePlotPopupmenu,'Enable','off');
set(handles.Y_VariablePlotPopupmenu,'Enable','off');
set(handles.Z_VariablePlotPopupmenu,'Enable','off');
set(handles.Plot3D_SweepVarPopupmenu,'Enable','off');
set(handles.Plot3D_ValuePopupmenu,'Enable','off');

guidata(hObject, handles);


% --- Executes on button press in ApplyAnalysisScriptPushbutton.
function ApplyAnalysisScriptPushbutton_Callback(hObject, eventdata, handles)
filename = get(handles.AnalysisScriptText,'String');
TableData = get(handles.VariableListTable,'Data');
UserInputVaribles = cell2mat(TableData(:,2));

%Saves Main directory
NowDir = cd;
cd([NowDir,'\Scripts\Analysis_Scripts']);
%Applies a script which was uploaded given the filename of the script and
%the global variable with the organized data from all files opened
[a] = feval(filename(1:end-2),handles.Stored_OrgMatrixData,UserInputVaribles);
%returns to Main directory
cd(NowDir)

guidata(hObject, handles);

% --- Executes on button press in OpenAnalysisScriptPushbutton.
function OpenAnalysisScriptPushbutton_Callback(hObject, eventdata, handles)
%Saves Current directory
NowDir = cd;
cd([NowDir,'\Scripts\Analysis_Scripts']);

%Opens dialogue window to allow user to select a script file
[handles.ScriptFilename, handles.ScriptPath, Filterindex] = uigetfile('*.m', 'Choose a file');
if(handles.ScriptPath~=0)
    set(handles.ApplyAnalysisScriptPushbutton,'Enable','on');
    set(handles.AnalysisScriptText,'String',handles.ScriptFilename);
end
%Used for setting up the necessary variables the user needs to input for
%analysis: it's like a dummy call to the function which initializes the
%variable table
[handles.VariableTableInfo] = feval(handles.ScriptFilename(1:end-2));
set(handles.VariableListTable,'Data',handles.VariableTableInfo);

%returns to Main directory
cd(NowDir)

guidata(hObject, handles);

% --- Executes on button press in PlotDataPushbutton.
function PlotDataPushbutton_Callback(hObject, eventdata, handles)
%Gets the index for the file whose data we want to plot
file_index = get(handles.ListFilesOrganizedPopupmenu,'Value');
%Uploads the data for the selected file
OrgMatrixData = handles.Stored_OrgMatrixData{file_index};
MatrixData = handles.Stored_MatrixData{file_index};

%Saves all the parameters selected by user to plot: color, marker, etc.
color = cell2mat(handles.ColorRGB(get(handles.ColorPopupmenu,'Value')));
LineStyleOpts = get(handles.LineStylePopupmenu,'String');
linestyle = cell2mat(LineStyleOpts(get(handles.LineStylePopupmenu,'Value')));
MarkerOpts = get(handles.MarkerPopupmenu,'String');
marker = cell2mat(MarkerOpts(get(handles.MarkerPopupmenu,'Value')));
markercolor = cell2mat(handles.ColorRGB(get(handles.MarkerColorPopupmenu,'Value')));
linewidth = str2double(get(handles.LineWidthEdit,'String'));
markersize = str2double(get(handles.MarkerSizeEdit,'String'));
XY_plane=[0 90];
NumColors = 1000;
x_label = get(handles.XaxisEdit,'String');
y_label = get(handles.YaxisEdit,'String');

%Gets the value for the x, y and Z popupmenu to select plot variables
nX = get(handles.X_VariablePlotPopupmenu,'Value');
nY = get(handles.Y_VariablePlotPopupmenu,'Value');
nZ = get(handles.Z_VariablePlotPopupmenu,'Value');
%Gets the String for the x, y and Z popupmenu to select plot variables
StringX = get(handles.X_VariablePlotPopupmenu,'String');
StringY = get(handles.Y_VariablePlotPopupmenu,'String');
StringZ = get(handles.Z_VariablePlotPopupmenu,'String');

%Determines the index for each selected variable in the X, Y and Z
%popupmenus
for i=1:length(handles.Header_Vector)
    if(strcmp(StringX(nX),handles.Header_Vector(i)))
        NumVarPlot_X = i;
    end
    if(strcmp(StringY(nY),handles.Header_Vector(i)))
        NumVarPlot_Y = i;
    end
    if(isempty(StringZ)==0)
        if(strcmp(StringZ(nZ),handles.Header_Vector(i)))
            NumVarPlot_Z = i;
        end
    end
end

%if the user selected a variable for Z then it means X and Y are sweep 
%variables and are not equal. This is checked by the if statements in the
%callback functions of X_VariablePlotPopupmenu and Y_VariablePlotPopupmenu 
Plot_OK=0;
if(strcmp(get(handles.Z_VariablePlotPopupmenu,'Enable'),'on')==1)
    Plot_OK = 1;
    
%Checks that Y is not a sweep variable in case Z is not being used. This
%means that if a simple 2D plot is to be plotted, then X can be either a
%sweep or nonsweep variable but Y is forced to be nonsweep to continue
else
    if(any(NumVarPlot_Y==handles.SweepVar_Index)==0 || NumVarPlot_X==1)
        Plot_OK = 1;
    else
        msgbox('For a 2D plot, Y must be a non-sweep variable')
    end
end

%Proceeds if the selected variable for X, Y and Z are correct
if(Plot_OK==1)
    %Deletes the curves in axes if the AutoDelete checkbox was selected
    if(get(handles.AutoDeleteCheckbox,'Value'))
        child = get(handles.axes1,'Children');delete(child);
        set(handles.DataListPopupmenu,'String','No Data');
    end
    %A 2D plot: since Z_VariablePlotPopupmenu is disabled it means the user
    %does not want to plot a 3D plot
    if(strcmp(get(handles.Z_VariablePlotPopupmenu,'Enable'),'off')==1)
        %Checks if the chosen X variable is a sweep variable or if it is
        %the first variable which is time.
        %This may be not general enough since we assume the first variable
        %is time always
        if(any(NumVarPlot_X==handles.SweepVar_Index)==0 || NumVarPlot_X==handles.SweepVar_Index(1))
            %If the X variable is not a sweep variable or if it is "time"
            %then we plot X and Y for every sweep of sweep variable 1
            set(handles.GenieAnalyzerFigure,'CurrentAxes',handles.axes1);
            for i=1:handles.SweepVar_Size(1):size(MatrixData,1)
                Xdata = MatrixData(i:i+handles.SweepVar_Size(1)-1,NumVarPlot_X);
                Ydata = MatrixData(i:i+handles.SweepVar_Size(1)-1,NumVarPlot_Y);                                   
                line(Xdata,Ydata,'Color',color,'LineStyle',linestyle,'LineWidth',linewidth,...
                    'Marker',marker,'MarkerEdgeColor','k','MarkerFaceColor',markercolor,...
                    'MarkerSize',markersize);                
            end
            xlabel(x_label);ylabel(y_label);grid on;
        else
            %If the X variable is a sweep variable then we need to
            %carefully select the correct data.
            %Calculates the factor by which we need to loop over the data
            %to correctly extract the data to plot. i.e. For the sweep 
            %variable i, factor is equal to the multiplication of the sizes
            %of sweep variables i-1. i-2,...1
            factor=1;            
            %loops over the organizes sweep variable size vector
            for i=1:length(handles.SweepVar_Index)
                %if the X variable is not the current sweep variable then
                %include the size of the current sweep variable in the
                %multiplication calculation for factor
                if(NumVarPlot_X~=handles.SweepVar_Index(i))
                    factor = handles.SweepVar_Size(i)*factor;
                %if X variable is equal to the current sweep variable then
                %stop
                else
                    break;
                end
            end
                        
            for k=1:factor
                Xdata = [];Ydata = [];
                for i=k:factor:size(MatrixData,1)
                    Xdata = [Xdata,MatrixData(i,NumVarPlot_X)];
                    Ydata = [Ydata,MatrixData(i,NumVarPlot_Y)];
                end                
                set(handles.GenieAnalyzerFigure,'CurrentAxes',handles.axes1);
                line(Xdata,Ydata,'Color',color,'LineStyle',linestyle,'LineWidth',linewidth,...
                    'Marker',marker,'MarkerEdgeColor','k','MarkerFaceColor',markercolor,...
                    'MarkerSize',markersize);
                xlabel(x_label);ylabel(y_label);grid on;
            end
        end
    
        %User selected to plot a 3D plot
    else
%         FirstNest_SweepVar=[];
%         for i=1:length(handles.SweepVar_Index)
%             if(handles.SweepVar_Index(i)==NumVarPlot_X || handles.SweepVar_Index(i)==NumVarPlot_Y)
%                 if(isempty(FirstNest_SweepVar))
%                     FirstNest_SweepVar = handles.SweepVar_Index(i);
%                     
%                 else
%                     SecondNest_SweepVar = handles.SweepVar_Index(i);
%                     
%                     break;
%                 end
%             end            
%         end

        if(strcmp(get(handles.Plot3D_SweepVarPopupmenu,'Enable'),'on')==1)
            Plot3D_Variables_String = get(handles.Plot3D_SweepVarPopupmenu,'String');
            for j=1:length(Plot3D_Variables_String)
                for jj=1:length(handles.Header_Vector)
                    if(strcmp(Plot3D_Variables_String(j),handles.Header_Vector(jj)))
                        Plot3D_Variables_INDEX(j) = jj;
                    end
                end
            end
        else
            Plot3D_Variables_INDEX=[];
        end

        NumVarPlot_X_Size=[];NumVarPlot_Y_Size=[];
        SweepVar_Size = [handles.SweepVar_Size(1),handles.SweepVar_Size(3:end)];
        
        for i=1:length(handles.SweepVar_Index)
            if(NumVarPlot_X==handles.SweepVar_Index(i))
                NumVarPlot_X_Size = SweepVar_Size(i);
            elseif(NumVarPlot_Y==handles.SweepVar_Index(i))
                NumVarPlot_Y_Size = SweepVar_Size(i);
            end
            if(isempty(NumVarPlot_X_Size)+isempty(NumVarPlot_Y_Size)==0)
                break
            end            
        end

        cntX=0;cntY=0;
        for i=1:size(MatrixData,1)
            FilterCond=1;
            for ii=1:length(Plot3D_Variables_INDEX)                
                ValueList = handles.Plot3D_ValuePopupmenu_values{ii};
                ChosenValue = ValueList(handles.Plot3D_ValuePopupmenu_index(ii));
                if(MatrixData(i,Plot3D_Variables_INDEX(ii)) ~= ChosenValue)
                    FilterCond = 0;
                    break;                    
                end                
            end
            if(FilterCond==1)
        
                if(cntX==0 && cntY==0)                    
                    cntX = cntX+1;
                    cntY = cntY+1;
                    Xdata(cntX) = MatrixData(i,NumVarPlot_X);
                    Ydata(cntY) = MatrixData(i,NumVarPlot_Y);
                else
                    if(Xdata(cntX) ~= MatrixData(i,NumVarPlot_X) &&...
                            Ydata(cntY) ~= MatrixData(i,NumVarPlot_Y))
                        if(NumVarPlot_X_Size==cntX)
                            
                            cntX = 1;
                            cntY = cntY+1;
                        else
                            cntX = cntX+1;
                            cntY = 1;
                        end                        
                        Xdata(cntX) = MatrixData(i,NumVarPlot_X);
                        Ydata(cntY) = MatrixData(i,NumVarPlot_Y);
                    else
                        if(Xdata(cntX) ~= MatrixData(i,NumVarPlot_X))
                            if(NumVarPlot_X_Size==cntX)
                                cntX = 1;                      
                            else
                                cntX = cntX+1;                             
                            end                            
                            Xdata(cntX) = MatrixData(i,NumVarPlot_X);
                        else
                            if(NumVarPlot_Y_Size==cntY)
                                cntY = 1;                           
                            else
                                cntY = cntY+1;                               
                            end               
                            Ydata(cntY) = MatrixData(i,NumVarPlot_Y);
                        end
                    end
                end
                Zdata(cntY,cntX) = MatrixData(i,NumVarPlot_Z);
            end
        end

        set(handles.GenieAnalyzerFigure,'CurrentAxes',handles.axes1);
        surf(Xdata,Ydata,Zdata,'EdgeColor','none');
        view(XY_plane);grid on;
        xlabel(x_label);ylabel(y_label);
        
        if(isempty(get(handles.MaxValColorEdit,'String'))==1 || ...
                isempty(get(handles.MinValColorEdit,'String'))==1 ||...
                isnan(str2double(get(handles.MaxValColorEdit,'String')))==1 || ...
                isnan(str2double(get(handles.MinValColorEdit,'String')))==1)
            
            caxis([min(min(Zdata)),max(max(Zdata))])
            set(handles.MaxValColorEdit,'String',max(max(Zdata)));
            set(handles.MinValColorEdit,'String',min(min(Zdata)));
        else
            handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
                str2double(get(handles.MaxValColorEdit,'String'))];
            caxis(handles.ColorAxis_Min_Max);
        end
    end
    set(handles.DeletePushbutton,'Enable','on');
end

% MatrixData()

% pause;
% 
% SweepVar_Index = [handles.SweepVariable_1_index,handles.SweepVariable_2_index];
% 
% NumVarPlot_X = SweepVar_Index(get(handles.X_VariablePlotPopupmenu,'Value'));
% NumVarPlot_Y = get(handles.Y_VariablePlotPopupmenu,'Value')-1;
% NumVarPlot_Z = get(handles.Z_VariablePlotPopupmenu,'Value')-1;
% 
% if(NumVarPlot_Y~=0 && NumVarPlot_Z==0)
%     
%     if(iscell(handles.MatrixData)==0)
%         X = handles.MatrixData(:,NumVarPlot_X);
%         Y = handles.MatrixData(:,NumVarPlot_Y);                
%     else
%         SizeMatrix = size(handles.MatrixData);
%         X = [];Y = [];
%         for i=1:SizeMatrix(2)
%             MatrixData_temp = cell2mat(handles.MatrixData(i));
%             X = [X;MatrixData_temp(:,NumVarPlot_X)];
%             Y = [Y;MatrixData_temp(:,NumVarPlot_Y)];
%         end
%     end
%     
%     set(handles.GenieAnalyzerFigure,'CurrentAxes',handles.axes1);
%     line(X,Y,'Color',color,'LineStyle',linestyle,'LineWidth',linewidth,...
%         'Marker',marker,'MarkerEdgeColor','k','MarkerFaceColor',markercolor,...
%         'MarkerSize',markersize);
%     grid on;
%     xlabel(x_label);ylabel(y_label);
%     
%     filename = get(handles.FilenameText,'String');
%     List = get(handles.DataListPopupmenu,'String');
%     if(size(List,1)==1)
%         if(strcmp('No Data',List))
%             set(handles.DataListPopupmenu,'String',filename)
%         else
%             List = {List};
%             List(size(List,1)+1,1) = {filename};
%             set(handles.DataListPopupmenu,'String',List);
%         end
%     else
%         List(size(List,1)+1,1) = {filename};
%         set(handles.DataListPopupmenu,'String',List);
%     end
%     
% %     X_index = str2double(get(handles.SweepIndicesEdit,'String'));
% %     Y_index = str2double(get(handles.YEdit,'String'));
% %     
% %     %Gets necessary voltages and current vectors using user indeces
% %     handles.X = handles.Data.data(:,X_index);
% %     handles.Y = handles.Data.data(:,Y_index);
%     
% %     handles.Waveforms.xData{1,size(handles.Waveforms.xData,2)+1} = {handles.X};
% %     handles.Waveforms.yData{1,size(handles.Waveforms.yData,2)+1} = {handles.Y};
% end
% 
% if(NumVarPlot_Y~=0 && NumVarPlot_Z~=0)
% 
%     if(iscell(handles.MatrixData)==0)
%         msgbox('Data is made up of a 1-D scan therefore a 3D plot is not possible')
%     else
%         if(NumVarPlot_Y==SweepVar_Index(1) || NumVarPlot_Y==SweepVar_Index(2) && ...
%                 NumVarPlot_Y~=NumVarPlot_X)
%         
%             SizeMatrix = size(handles.MatrixData);
%             sweep2 = [];           
%             for i=1:SizeMatrix(2)
%                 MatrixData_temp = cell2mat(handles.MatrixData(i));
%                 if(i==1)
%                     sweep1 = MatrixData_temp(:,handles.SweepVariable_1_index);
%                 end
%                 sweep2 = [sweep2;MatrixData_temp(1,handles.SweepVariable_2_index)];
%                 Z(i,:) = MatrixData_temp(:,NumVarPlot_Z);
% %                 pause;
%             end
% 
%             if(NumVarPlot_Y==handles.SweepVariable_1_index)
%                 Z = Z';
%                 X = sweep2;
%                 Y = sweep1;
%             else
%                 X = sweep1;
%                 Y = sweep2;                
%             end            
% %             
% %             figure(12);
% %             surf(X,Y,Z,'EdgeColor','none');
%             
%             set(handles.GenieAnalyzerFigure,'CurrentAxes',handles.axes1);
%             surf(X,Y,Z,'EdgeColor','none');
%             view(XY_plane);grid on;
%             xlabel(x_label);ylabel(y_label);
%             if(isempty(get(handles.MaxValColorEdit,'String'))==1 || ...
%                     isempty(get(handles.MinValColorEdit,'String'))==1)
%                 caxis([min(min(Z)),max(max(Z))])
%                 set(handles.MaxValColorEdit,'String',max(max(Z)));
%                 set(handles.MinValColorEdit,'String',min(min(Z)));
%             else
%                 handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
%                     str2double(get(handles.MaxValColorEdit,'String'))];
%                 caxis(handles.ColorAxis_Min_Max);
%             end
% %             colormap(jet(NumColors))
%             
%         else
%             msgbox('X and Y variables must be Sweep Variables and different');
% %             break;
%         end        
%     end
%     
% %     Z_index = str2double(get(handles.ZEdit,'String'));
% %     X_index = str2double(get(handles.SweepIndicesEdit,'String'));
% %     Y_index = str2double(get(handles.YEdit,'String'));
% %     
% %     %Gets necessary voltages and current vectors using user indeces
% %     X = handles.Data.data(:,X_index);
% %     Y = handles.Data.data(:,Y_index);
% %     Z = handles.Data.data(:,Z_index);
% %     
% %     IndexStart_Analysis = 1;
% %     %Determines start and end voltages for Vbias
% %     X_start = X(IndexStart_Analysis);
% %     Analysis_Index = 0;
% % %     ErrorCatching = 1;
% %     for k=2:length(X)
% %         if(X(k) == X_start)
% % %             ErrorCatching = 0;
% %             X_end = X(k-1);
% %             break;
% %         end
% %     end
% % %     if(ErrorCatching==1)
% % %         msgbox('X, Y and Z parameters are INVALID. Please correct these values');
% % %     end
% %     
% %     %Loops through Vbias to select data for constant Vg
% %     %Initialization
% %     counter = 0;
% %     for Main_Index=IndexStart_Analysis+1:length(X)
% %         %Finds end Vbias: a set of data for constant Vg
% %         if(X(Main_Index) == X_end)
% %             counter=counter+1;%counts number of data sets for constant Vg
% %             
% %             %Saves Vbias, Id and Vg into temp variables
% %             %Id(Vg,Vbias) -> (rows,columns)
% %             Z_Stored(counter,:) = Z(IndexStart_Analysis:Main_Index);
% %             
% %             if(Main_Index==length(X))
% %                 X_Stored = X(IndexStart_Analysis:Main_Index);
% %             end
% %             Y_Stored(counter,1) = mean(Y(IndexStart_Analysis:Main_Index));
% %             
% %             IndexStart_Analysis = Main_Index+1;
% %         end
% %     end
% %     
% %     % for oo=1:length(Y_Stored)
% %     %     for o=1:length(Z_Stored)-1
% %     %         DerY(oo,o) = (Z_Stored(oo,o)-Z_Stored(oo,o+1))/(X_Stored(o)-X_Stored(o+1));
% %     %         DerX(o) = mean([X_Stored(o),X_Stored(o+1)]);
% %     %     end
% %     % end
% %     % Z_Stored = DerY;
% %     % X_Stored = DerX;
% %     
% %     handles.Z = log(abs(Z_Stored));
% %     handles.Z = Z_Stored;
% %     
% %     handles.X = X_Stored;
% %     handles.Y = Y_Stored;
%     
%     % set(handles.V_StartText,'String',V_start);
%     % set(handles.V_EndText,'String',V_end);
%     % set(handles.TotalDataSetText,'String',Analysis_Index);
%     
%     
% end

guidata(hObject, handles);


% --- Executes on button press in OpenScriptPushbutton.
function OpenScriptPushbutton_Callback(hObject, eventdata, handles)
[handles.ScriptFilename, handles.ScriptPath, Filterindex] = uigetfile('*.m', 'Choose a file');
if(handles.ScriptPath~=0)
    set(handles.ApplyPushbutton,'Enable','on');
%     NowDir = cd;
%     cd(Path);
%     handles.Data = [];
%     handles.Data = importdata(Filename);
% %     handles.Data.data
%     cd(NowDir);
%     set(handles.FilenameText,'String',Filename);
    %     TableData1 = get(handles.Table1,'Data');
    %     if(isempty(TableData1)==0)
    %         set(handles.Table1,'Data',TableData1(:,1));
    %     end
    %     set(handles.Table2,'Data',handles.Headers);
    set(handles.ScriptText,'String',handles.ScriptFilename);
end
guidata(hObject, handles);

% --- Executes on button press in ApplyPushbutton.
function ApplyPushbutton_Callback(hObject, eventdata, handles)
NowDir = cd;
cd(handles.ScriptPath);
% data = ;
% disp(handles.ScriptFilename(1:end-2))
feval(handles.ScriptFilename(1:end-2),handles.Waveforms);
cd(NowDir);

guidata(hObject, handles);

% --- Executes on button press in NewVarPushbutton.
function NewVarPushbutton_Callback(hObject, eventdata, handles)
newRow = {' ',' '};
oldData = get(handles.VariableListTable,'Data');
newData = [oldData; newRow];
set(handles.VariableListTable,'Data',newData);
guidata(hObject, handles);

% --- Executes on button press in DeleteVarPushbutton.
function DeleteVarPushbutton_Callback(hObject, eventdata, handles)
oldData = get(handles.VariableListTable,'Data');
newData = oldData(1:end-1,:);
set(handles.VariableListTable,'Data',newData);
guidata(hObject, handles);

% --- Executes on button press in DeletePushbutton.
function DeletePushbutton_Callback(hObject, eventdata, handles)
child = get(handles.axes1,'Children');
delete(child);
handles.Waveforms.xData = [];
handles.Waveforms.yData = [];
set(handles.DataListPopupmenu,'String','No Data');
% set(handles.DeletePushbutton,'Enable','off');
guidata(hObject, handles);

% --- Executes on selection change in Z_VariablePlotPopupmenu.
function Z_VariablePlotPopupmenu_Callback(hObject, eventdata, handles)
set(handles.MaxValColorEdit,'String',' ');
set(handles.MinValColorEdit,'String',' ');

guidata(hObject, handles);

% --- Executes on selection change in X_VariablePlotPopupmenu.
function X_VariablePlotPopupmenu_Callback(hObject, eventdata, handles)
%Gets the index for the file whose data we want to plot
file_index = get(handles.ListFilesOrganizedPopupmenu,'Value');
%Uploads the data for the selected file
MatrixData = handles.Stored_MatrixData{file_index};

SweepVar_Size = [handles.SweepVar_Size(1),handles.SweepVar_Size(3:end)];
handles.Plot3D_ValuePopupmenu_values = {};
handles.Plot3D_ValuePopupmenu_index = [];

set(handles.MaxValColorEdit,'String',' ');
set(handles.MinValColorEdit,'String',' ');

%Gets the value for the x, y and Z popupmenu to select plot variables
nX = get(handles.X_VariablePlotPopupmenu,'Value');
nY = get(handles.Y_VariablePlotPopupmenu,'Value');

%-------------------------------------------------------------------------%
%May be unneccesary since nX is already guaranteed to be the correct index
%Gets the String for the x, y and Z popupmenu to select plot variables
StringX = get(handles.X_VariablePlotPopupmenu,'String');
StringY = get(handles.Y_VariablePlotPopupmenu,'String');

%Determines the index for each selected variable in the X, Y and Z
%popupmenus
for i=1:length(handles.Header_Vector)
    if(strcmp(StringX(nX),handles.Header_Vector(i)))
        NumVarPlot_X = i;
    end
    if(strcmp(StringY(nY),handles.Header_Vector(i)))
        NumVarPlot_Y = i;
    end
end
%-------------------------------------------------------------------------%

%if nZ is not 1 it means the user selected a variable for Z which means X
%and Y must be sweep variables and not equal. We check that this is the case

if(NumVarPlot_X~=NumVarPlot_Y)
    condition = any(NumVarPlot_X==handles.SweepVar_Index)*any(NumVarPlot_Y==handles.SweepVar_Index);
    if(condition==1)
        set(handles.Z_VariablePlotPopupmenu,'Enable','on');        
        set(handles.Z_VariablePlotPopupmenu,'Value',1);
        
        cnt = 1;
        for i=1:length(handles.SweepVar_Index)
            if(handles.SweepVar_Index(i)~=NumVarPlot_X && handles.SweepVar_Index(i)~=NumVarPlot_Y)
                header_3DPlotsVariable(cnt) = handles.Header_Vector(handles.SweepVar_Index(i));                
                index = handles.SweepVar_Index(i);
         
                h=0;
                for ii=2:size(MatrixData,1)
                    if(MatrixData(ii-1,index)~=MatrixData(ii,index))
                        h=h+1;
                        SweepVar_Values(h) = MatrixData(ii-1,handles.SweepVar_Index(i)); 
                    elseif(ii==size(MatrixData,1) && h<SweepVar_Size(i))
                        h=h+1;
                        SweepVar_Values(h) = MatrixData(ii-1,handles.SweepVar_Index(i));
                    end
                    if(h==SweepVar_Size(i))
                       break; 
                    end
                end
                handles.Plot3D_ValuePopupmenu_values{cnt} = SweepVar_Values;   
                handles.Plot3D_ValuePopupmenu_index(cnt) = 1;
                SweepVar_Values=[];
                cnt = cnt+1;
            end
        end
        if(isempty(handles.Plot3D_ValuePopupmenu_index)==0)
            set(handles.Plot3D_SweepVarPopupmenu,'Enable','on');
            set(handles.Plot3D_ValuePopupmenu,'Enable','on')
            set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
            set(handles.Plot3D_ValuePopupmenu,'Value',1)
            
            set(handles.Plot3D_SweepVarPopupmenu,'String',header_3DPlotsVariable);
            set(handles.Plot3D_ValuePopupmenu,'String',handles.Plot3D_ValuePopupmenu_values{1});
        end
    else
        set(handles.Z_VariablePlotPopupmenu,'Value',1);
        set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
        set(handles.Plot3D_ValuePopupmenu,'Value',1)
        set(handles.Z_VariablePlotPopupmenu,'Enable','off');
        set(handles.Plot3D_SweepVarPopupmenu,'Enable','off');
        set(handles.Plot3D_ValuePopupmenu,'Enable','off')        
        set(handles.Plot3D_SweepVarPopupmenu,'String',' ');        
        set(handles.Plot3D_ValuePopupmenu,'String',' ');  
    end
else
    set(handles.Z_VariablePlotPopupmenu,'Value',1);
    set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
    set(handles.Plot3D_ValuePopupmenu,'Value',1)
    set(handles.Z_VariablePlotPopupmenu,'Enable','off');
    set(handles.Plot3D_SweepVarPopupmenu,'Enable','off');
    set(handles.Plot3D_ValuePopupmenu,'Enable','off')
    set(handles.Plot3D_SweepVarPopupmenu,'String',' ');
    set(handles.Plot3D_ValuePopupmenu,'String',' ');
end

guidata(hObject, handles);

% --- Executes on selection change in Y_VariablePlotPopupmenu.
function Y_VariablePlotPopupmenu_Callback(hObject, eventdata, handles)
%Gets the index for the file whose data we want to plot
file_index = get(handles.ListFilesOrganizedPopupmenu,'Value');
%Uploads the data for the selected file
MatrixData = handles.Stored_MatrixData{file_index};

SweepVar_Size = [handles.SweepVar_Size(1),handles.SweepVar_Size(3:end)];
handles.Plot3D_ValuePopupmenu_values = {};
handles.Plot3D_ValuePopupmenu_index = [];

set(handles.MaxValColorEdit,'String',' ');
set(handles.MinValColorEdit,'String',' ');

%Gets the value for the x, y and Z popupmenu to select plot variables
nX = get(handles.X_VariablePlotPopupmenu,'Value');
nY = get(handles.Y_VariablePlotPopupmenu,'Value');

%-------------------------------------------------------------------------%
%May be unneccesary since nX is already guaranteed to be the correct index
%Gets the String for the x, y and Z popupmenu to select plot variables
StringX = get(handles.X_VariablePlotPopupmenu,'String');
StringY = get(handles.Y_VariablePlotPopupmenu,'String');

%Determines the index for each selected variable in the X, Y and Z
%popupmenus
for i=1:length(handles.Header_Vector)
    if(strcmp(StringX(nX),handles.Header_Vector(i)))
        NumVarPlot_X = i;
    end
    if(strcmp(StringY(nY),handles.Header_Vector(i)))
        NumVarPlot_Y = i;
    end
end
%-------------------------------------------------------------------------%

%if nZ is not 1 it means the user selected a variable for Z which means X
%and Y must be sweep variables and not equal. We check that this is the case

if(NumVarPlot_X~=NumVarPlot_Y)
    condition = any(NumVarPlot_X==handles.SweepVar_Index)*any(NumVarPlot_Y==handles.SweepVar_Index);
    if(condition==1)
        set(handles.Z_VariablePlotPopupmenu,'Enable','on');        
        set(handles.Z_VariablePlotPopupmenu,'Value',1);
        
        cnt = 1;
        for i=1:length(handles.SweepVar_Index)
            if(handles.SweepVar_Index(i)~=NumVarPlot_X && handles.SweepVar_Index(i)~=NumVarPlot_Y)
                header_3DPlotsVariable(cnt) = handles.Header_Vector(handles.SweepVar_Index(i));                
                index = handles.SweepVar_Index(i);
         
                h=0;
                for ii=2:size(MatrixData,1)
                    if(MatrixData(ii-1,index)~=MatrixData(ii,index))
                        h=h+1;
                        SweepVar_Values(h) = MatrixData(ii-1,handles.SweepVar_Index(i)); 
                    elseif(ii==size(MatrixData,1) && h<SweepVar_Size(i))
                        h=h+1;
                        SweepVar_Values(h) = MatrixData(ii-1,handles.SweepVar_Index(i));
                    end
                    if(h==SweepVar_Size(i))
                       break; 
                    end
                end
                handles.Plot3D_ValuePopupmenu_values{cnt} = SweepVar_Values;   
                handles.Plot3D_ValuePopupmenu_index(cnt) = 1;
                SweepVar_Values=[];
                cnt = cnt+1;
            end
        end
        if(isempty(handles.Plot3D_ValuePopupmenu_index)==0)
            set(handles.Plot3D_SweepVarPopupmenu,'Enable','on');
            set(handles.Plot3D_ValuePopupmenu,'Enable','on')
            set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
            set(handles.Plot3D_ValuePopupmenu,'Value',1)
            
            set(handles.Plot3D_SweepVarPopupmenu,'String',header_3DPlotsVariable);
            set(handles.Plot3D_ValuePopupmenu,'String',handles.Plot3D_ValuePopupmenu_values{1});
        end
    else
        set(handles.Z_VariablePlotPopupmenu,'Value',1);
        set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
        set(handles.Plot3D_ValuePopupmenu,'Value',1)
        set(handles.Z_VariablePlotPopupmenu,'Enable','off');
        set(handles.Plot3D_SweepVarPopupmenu,'Enable','off');
        set(handles.Plot3D_ValuePopupmenu,'Enable','off')        
        set(handles.Plot3D_SweepVarPopupmenu,'String',' ');        
        set(handles.Plot3D_ValuePopupmenu,'String',' ');  
    end
else
    set(handles.Z_VariablePlotPopupmenu,'Value',1);
    set(handles.Plot3D_SweepVarPopupmenu,'Value',1);
    set(handles.Plot3D_ValuePopupmenu,'Value',1)
    set(handles.Z_VariablePlotPopupmenu,'Enable','off');
    set(handles.Plot3D_SweepVarPopupmenu,'Enable','off');
    set(handles.Plot3D_ValuePopupmenu,'Enable','off')
    set(handles.Plot3D_SweepVarPopupmenu,'String',' ');
    set(handles.Plot3D_ValuePopupmenu,'String',' ');
end

guidata(hObject, handles);

% --- Executes on selection change in Plot3D_SweepVarPopupmenu.
function Plot3D_SweepVarPopupmenu_Callback(hObject, eventdata, handles)
nVar = get(handles.Plot3D_SweepVarPopupmenu,'Value');
index = handles.Plot3D_ValuePopupmenu_index(nVar);

handles.Plot3D_ValuePopupmenu_values{nVar}

set(handles.Plot3D_ValuePopupmenu,'String',handles.Plot3D_ValuePopupmenu_values{nVar});
set(handles.Plot3D_ValuePopupmenu,'Value',index);

guidata(hObject, handles);

% --- Executes on selection change in Plot3D_ValuePopupmenu.
function Plot3D_ValuePopupmenu_Callback(hObject, eventdata, handles)
n = get(handles.Plot3D_SweepVarPopupmenu,'Value');
index = get(handles.Plot3D_ValuePopupmenu,'Value');
handles.Plot3D_ValuePopupmenu_index(n) = index;
guidata(hObject, handles);


%-------------------------------------------------------------------------%
%------------------------------END----------------------------------------%
%-------------------------------------------------------------------------%


function MaxValColorEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxValColorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function MinValColorEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MinValColorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function SweepIndicesEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SweepIndicesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function YEdit_Callback(hObject, eventdata, handles)
% hObject    handle to YEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function ZEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ZEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------%

% --- Executes during object creation, after setting all properties.
function ZEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function MaxValColorEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxValColorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function MinValColorEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinValColorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function YEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function SweepIndicesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SweepIndicesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ColorPopupmenu.
function ColorPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to ColorPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorPopupmenu


% --- Executes during object creation, after setting all properties.
function ColorPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColorPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LineStylePopupmenu.
function LineStylePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to LineStylePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LineStylePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LineStylePopupmenu


% --- Executes during object creation, after setting all properties.
function LineStylePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LineStylePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LineWidthEdit.
function LineWidthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to LineWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LineWidthEdit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LineWidthEdit


% --- Executes during object creation, after setting all properties.
function LineWidthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LineWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MarkerPopupmenu.
function MarkerPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to MarkerPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MarkerPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MarkerPopupmenu


% --- Executes during object creation, after setting all properties.
function MarkerPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MarkerPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MarkerColorPopupmenu.
function MarkerColorPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to MarkerColorPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MarkerColorPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MarkerColorPopupmenu


% --- Executes during object creation, after setting all properties.
function MarkerColorPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MarkerColorPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MarkerSizeEdit.
function MarkerSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MarkerSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MarkerSizeEdit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MarkerSizeEdit


% --- Executes during object creation, after setting all properties.
function MarkerSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MarkerSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TitleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TitleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TitleEdit as text
%        str2double(get(hObject,'String')) returns contents of TitleEdit as a double


% --- Executes during object creation, after setting all properties.
function TitleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TitleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XaxisEdit_Callback(hObject, eventdata, handles)
% hObject    handle to XaxisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XaxisEdit as text
%        str2double(get(hObject,'String')) returns contents of XaxisEdit as a double


% --- Executes during object creation, after setting all properties.
function XaxisEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XaxisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YaxisEdit_Callback(hObject, eventdata, handles)
% hObject    handle to YaxisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YaxisEdit as text
%        str2double(get(hObject,'String')) returns contents of YaxisEdit as a double


% --- Executes during object creation, after setting all properties.
function YaxisEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YaxisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function DataListPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataListPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Data2SizeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Data2SizeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function ScriptEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ScriptText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ScriptText as text
%        str2double(get(hObject,'String')) returns contents of ScriptText as a double


% --- Executes during object creation, after setting all properties.
function ScriptText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScriptText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
     


% --- Executes on selection change in DataListPopupmenu.
function DataListPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to DataListPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DataListPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataListPopupmenu


% --- Executes on selection change in FileTypePopupmenu.
function FileTypePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileTypePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileTypePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileTypePopupmenu


% --- Executes during object creation, after setting all properties.
function FileTypePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileTypePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function X_VariablePlotPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_VariablePlotPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Y_VariablePlotPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_VariablePlotPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Z_VariablePlotPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z_VariablePlotPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ListFilesOrganizedPopupmenu.
function ListFilesOrganizedPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to ListFilesOrganizedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ListFilesOrganizedPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListFilesOrganizedPopupmenu


% --- Executes during object creation, after setting all properties.
function ListFilesOrganizedPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListFilesOrganizedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AutoDeleteCheckbox.
function AutoDeleteCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AutoDeleteCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoDeleteCheckbox



% --- Executes during object creation, after setting all properties.
function Plot3D_SweepVarPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plot3D_SweepVarPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Plot3D_ValuePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plot3D_ValuePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
