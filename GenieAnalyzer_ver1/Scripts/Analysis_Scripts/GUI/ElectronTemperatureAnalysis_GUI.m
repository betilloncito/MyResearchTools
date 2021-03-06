function varargout = ElectronTemperatureAnalysis_GUI(varargin)
% ELECTRONTEMPERATUREANALYSIS_GUI MATLAB code for ElectronTemperatureAnalysis_GUI.fig
%      ELECTRONTEMPERATUREANALYSIS_GUI, by itself, creates a new ELECTRONTEMPERATUREANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = ELECTRONTEMPERATUREANALYSIS_GUI returns the handle to a new ELECTRONTEMPERATUREANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      ELECTRONTEMPERATUREANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELECTRONTEMPERATUREANALYSIS_GUI.M with the given input arguments.
%
%      ELECTRONTEMPERATUREANALYSIS_GUI('Property','Value',...) creates a new ELECTRONTEMPERATUREANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ElectronTemperatureAnalysis_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ElectronTemperatureAnalysis_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ElectronTemperatureAnalysis_GUI

% Last Modified by GUIDE v2.5 05-May-2018 03:12:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ElectronTemperatureAnalysis_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ElectronTemperatureAnalysis_GUI_OutputFcn, ...
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


% --- Executes just before ElectronTemperatureAnalysis_GUI is made visible.
function ElectronTemperatureAnalysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ElectronTemperatureAnalysis_GUI (see VARARGIN)

% Choose default command line output for ElectronTemperatureAnalysis_GUI
handles.output = hObject;

%------------------------Do not Edit--------------------------------------%
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
%-------------------------------------------------------------------------%

handles.VarDataTable = [{'Counter Variable [Y-axis]:'},{'Dummy'}; {'Current:'},{'Current'};
    {'Gate:'},{'Vplg'}; {'Sens. DL (V/A):'},{1e-8}; {'Sens. Lockin (V):'},{200e-6}; {'Lock-In Vac (V):'},{0.05};
    {'Lock-In Volt Div.:'},{10000}; {'alpha (eV/V):'},{0.139}; {'Xmin:'},{2.0145}; {'Xmax'},{2.019}; 
    {'Pause:'},{0}; {'Gaussian Num:'},{1}];
set(handles.VariableListTable,'Data',handles.VarDataTable);
handles.PathName = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ElectronTemperatureAnalysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.electrontemperatureanalysis_figure);


% --- Outputs from this function are returned to the command line.
function varargout = ElectronTemperatureAnalysis_GUI_OutputFcn(hObject, eventdata, handles) 
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
INDEX = get(handles.FilesAvailableListbox,'Value')

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
name{1} = cell2mat(VarTable(2,2));    %name{1} = 'Current';
%GATE
name{2} = cell2mat(VarTable(3,2));   %    name{3} = 'Vtun';
%Counter
name{3} = cell2mat(VarTable(1,2));   %    name{3} = 'Vtun';
%TIME
name{4} = 'Time';

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
                            Counter_index = ii;
                        case 4
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
        
        %Extracting Data
                
        nx = size(MatrixData,1);
        ny = size(MatrixData,3);
        
        Current = MatrixData(:,I_index,:);
        Current = reshape(Current,nx,ny);
        handles.Current = (transpose(Current));
        
        size(Current)
        Vplg = MatrixData(:,Vtun_index,1);
        Vplg = reshape(Vplg,nx,1);
        handles.Vplg = Vplg;
        
        size(Vplg)
        
        Time = MatrixData(:,Time_index,:);
        Time = reshape(Time,nx,ny);
        handles.Time = (transpose(Time));
        
        size(Time)
        
        child = get(handles.axes1,'Children');delete(child);
        if(~isempty(Counter_index))
            CounterVar = MatrixData(1,Counter_index,:);
            CounterVar = reshape(CounterVar,ny,1);
            handles.CounterVar = CounterVar;
            
            size(CounterVar)
            
            %-----------------------------------------------------------------%
            surf(handles.Vplg,handles.CounterVar,handles.Current,'EdgeAlpha',0,'Parent',handles.axes1);
            XY_plane=[0 90];
            view(handles.axes1,2);
        else
            line(handles.Vplg,handles.Current,'Parent',handles.axes1,...
                'LineStyle','-','LineWidth',2);%,'Marker','o','MarkerSize',4,'MarkerFace','r','MarkerEdge','k');
            grid(handles.axes1,'on');
        end

guidata(hObject, handles);

% --- Executes on button press in ApplyMathScriptPushbutton.
function ApplyMathScriptPushbutton_Callback(hObject, eventdata, handles)

filename = get(handles.MathScriptText,'String');
TableData = get(handles.VariableListTable,'Data');
UserInputVaribles = (TableData(:,2));

% x_label = get(handles.XaxisEdit,'String');
% y_label = get(handles.YaxisEdit,'String');

set(handles.ElectronTemperatureAnalysis_Figure,'CurrentAxes',handles.axes1);
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
    
    if(isempty(ZData))
        line(XData,YData,'Parent',handles.axes1);
    else        
        set(handles.ElectronTemperatureAnalysis_Figure,'CurrentAxes',handles.axes1);
        surf(XData,YData,ZData,'EdgeColor','none');
        XY_plane = [0 90];view(XY_plane);grid on;
        %     xlabel(x_label);ylabel(y_label);
        %     colormap_List = get(handles.ColorMapPopupmenu,'String');
        %     colormap_index = get(handles.ColorMapPopupmenu,'Value');
        %     colormap_choice = strtrim(cell2mat(colormap_List(colormap_index)));
        %     colormap(colormap_choice);
        
        %     set(handles.MaxValColorEdit,'String',max(max(ZData)));
        %     set(handles.MinValColorEdit,'String',min(min(ZData)));
    end
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

% --- Executes on button press in FindSplitPushbutton.
function FindSplitPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FindSplitPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.VarDataTable = get(handles.VariableListTable,'Data');

%Constants Physics
e = 1.60217662e-19; %C
h = 6.62607004e-34; %J*s
kB = 8.6173303e-5; %eV/K

child = get(handles.axes1,'Children');
X = get(child,'XData');
if(size(X,1)>1)
    X = X';
end
Y = get(child,'YData');
% if(size(X,1)>1)
%     X = X';
% end
Z = get(child,'ZData');

Iteration = 1;

VarTable = get(handles.VariableListTable,'Data');

Sens_preamp = cell2mat(VarTable(4,2));
Sens_lockin = cell2mat(VarTable(5,2));
LockIN_amp = cell2mat(VarTable(6,2));
LockIN_voltDiv = cell2mat(VarTable(7,2));

alpha = cell2mat(VarTable(8,2));

xmin = cell2mat(VarTable(9,2));
xmax = cell2mat(VarTable(10,2));

pauseOpt = cell2mat(VarTable(11,2));
GaussNum = cell2mat(VarTable(12,2));

if(isempty(Z))
    SweepNum=1;
else
    SweepNum = length(Y);
end
for i=1:SweepNum
    child_2 = get(handles.axes2,'Children');
    delete(child_2);
%     disp(['Current line',num2str(i)]);
    
    if(~isnan(xmin))
        for ii=1:length(X);
            if(ii<length(X))
                if(X(ii)<xmin && X(ii+1)>xmin)
                    index_xmin = ii;
                    break;
                end
                if(X(ii)>xmin && X(ii+1)<xmin)
                    index_xmin = ii;
                    break;
                end
            end
            if(X(ii)==xmin)
                index_xmin = ii;
            end
        end
    else
        index_xmin = find(X == min(X));
    end

    if(~isnan(xmax))
        for ii=1:length(X);
            if(ii<length(X))
                if(X(ii)<xmax && X(ii+1)>xmax)
                    index_xmax = ii;
                    break;
                end
                if(X(ii)>xmax && X(ii+1)<xmax)
                    index_xmax = ii;
                    break;
                end
            end
            if(X(ii)==xmax)
                index_xmax = ii;
            end
        end
    else
        index_xmax = find(X == max(X));
    end
            
    if(index_xmin<index_xmax)
        if(isempty(Z)) 
            sig = Y(1,index_xmin:index_xmax);
        else
            sig = Z(i,index_xmin:index_xmax);
        end
        Xcrop = X(index_xmin:index_xmax);
    else
        if(isempty(Z))
            sig = Y(1,index_xmax:index_xmin);
        else
            sig = Z(i,index_xmax:index_xmin);
        end
        Xcrop = X(index_xmax:index_xmin);
    end
%     sig = ReduceNoise(sig,3,Iteration,0);
    sig = sig';
    
%     %Simple peak search----------------------------------------------------
%     height = abs(max(sig)-min(sig));
%     %     sig_noiseless = ReduceNoise(sig,3,Iteration,0);
%     [peaks,loc] = findpeaks(sig);
%     cnt=1;pk_x = [];pk_y = [];
%     for j=1:length(loc)
%         sig(loc(j))
%         if(sig(loc(j)) > mag_per*height)
%             pk_x(cnt) = Xcrop(loc(j));
%             pk_y(cnt) = sig(loc(j));
%             cnt = cnt+1
%         end
%     end
%     %--------------------------------------------------------------------

    %Gaussian Fit----------------------------------------------------------
    
    %Calculate correct value for G  
    if(~isnan(Sens_lockin))
        sig_I = (sig/10)*Sens_lockin*Sens_preamp;
        sig_G = sig_I/(LockIN_amp/LockIN_voltDiv);     
    end

    %code to add points to sig---------------------------------------------
%     temp_sig_fit = [];
%     temp_Xcrop = [];
%     for j=1:length(sig_fit)-1
%         numpts = round(sig_fit(j+1)*100);
%               
%         if(numpts<50)
%             numpts=2;
%         end
%         
%         if(numpts>2)
%             slope = diff(sig_fit(j:j+1))/diff(Xcrop(j:j+1));
%             y_int = sig_fit(j) - slope*Xcrop(j);
%             
%             newPts_Xcrop = linspace(Xcrop(j),Xcrop(j+1),numpts);
%             if(j==length(sig_fit)-1)
%                 newPts_sig_fit = slope*newPts_Xcrop + y_int;
%                 temp_Xcrop = [temp_Xcrop, newPts_Xcrop];
%             else
%                 newPts_sig_fit = slope*newPts_Xcrop(1:end-1) + y_int;
%                 temp_Xcrop = [temp_Xcrop, newPts_Xcrop(1:end-1)];
%             end
%             temp_sig_fit = [temp_sig_fit, newPts_sig_fit];
%             
%         else
%             if(j==length(sig_fit)-1)
%                 temp_Xcrop = [temp_Xcrop, Xcrop(j:j+1)];
%                 temp_sig_fit = [temp_sig_fit, sig_fit(j:j+1)'];
%             else
%                 temp_Xcrop = [temp_Xcrop, Xcrop(j)];
%                 temp_sig_fit = [temp_sig_fit, sig_fit(j)];
%             end
%         end
%     end
%     sig_fit = temp_sig_fit';
%     Xcrop = temp_Xcrop;
    %----------------------------------------------------------------------
    
%     sig_fit = sig_G/(2*e^2/h);
    sig_fit = sig;
    
    func = strcat(num2str(1/(2*kB)),'*C2*cosh((',num2str(alpha),'*(Vg - Vo))/(2*',num2str(kB),'*T))^(-2)/T');
    modelVariables = {'T','C2','Vo'};
    fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
    
    %{
%  ConvLorenz(Gamma, T, C2, Vo, alpha, Vg)
 modelVariables = {'Gamma', 'T','C2','Vo'};
 fmodel = fittype('ConvLorenz(Gamma, T, C2, Vo, ',num2str(alpha),', Vg)', 'ind', {'Vg'}, 'coeff', modelVariables);
 size(Vg)
 size(G)
    %}
    
    T_start  = 100e-3;
    C2_start = 2*max(sig_fit)*kB*T_start;
    Vo_start = Xcrop(sig_fit==max(sig_fit)); %V
    
    [myfit_G,gof] = fit(Xcrop', sig_fit, fmodel,...
        'Start', [T_start, C2_start, Vo_start],...
        'TolFun',1e-45,'TolX',1e-45,'MaxFunEvals',1000,'MaxIter',1000);
    ci = confint(myfit_G,0.95);
    T_fit_ebar = ci(:,1)
    C2_fit_ebar = ci(:,2)
    
    vals = coeffvalues(myfit_G);
    T_fit = vals(1);C2_fit = vals(2);Vo_fit = vals(3);

    % figure(300);
    child = get(handles.axes2,'Children');delete(child);
    set(handles.ElectronTemperatureAnalysis_Figure,'CurrentAxes',handles.axes2);
    plot(myfit_G,Xcrop,sig_fit);
    title(['Counter: ',num2str(Y(i))])
    if(i<SweepNum)
        legend off;
    end
    grid on;legend off;
    xlabel('Vg [V]');ylabel('G [2e^2/h]')
    title([{['Fit: T_e=',num2str(round(T_fit*1000,1)),' (',num2str(round((T_fit-T_fit_ebar(1))*1000,1)),', ',num2str(round((T_fit-T_fit_ebar(2))*1000,1)),' [95% CI]) mK']},...
        {['C2=',num2str(C2_fit),' and Vo=',num2str(Vo_fit),'V']}],...
        'FontSize',10);

% plot(myfit,Xcrop,sig_fit);grid on;
% plot(Xcrop,sig_fit);hold on;

% figure(302);

    %----------------------------------------------------------------------
      
%     line(Xcrop,sig_fit,'Parent',handles.axes2,'LineStyle','-','Color','blue');
%     line(pk_x,pk_y,'Parent',handles.axes2,'LineStyle','none','Color','red','Marker','o');
%     grid on;
    
    if(pauseOpt>0)
        pause(pauseOpt);
    end
end

% child = get(handles.axes3,'Children');delete(child);
% if(GaussNum>1) 
%     line(Y,Separation,'Parent',handles.axes3,'LineStyle','--','Color','k','Marker','o');
% else
%     line(Y,PeakPos,'Parent',handles.axes3,'LineStyle','--','Color','k','Marker','o');
% end
% figure(231);plot(sep);grid on;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in OpenFigureWindowPushbutton.
function OpenFigureWindowPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFigureWindowPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(0,'CurrentFigure',handles.ElectronTemperatureAnalysis_Figure);
set(0,'ShowHiddenHandles','on');

if(get(handles.AxesNum1Radiobutton,'Value')==1)
    set(handles.ElectronTemperatureAnalysis_Figure,'CurrentAxes',handles.axes1);
    
elseif(get(handles.AxesNum2Radiobutton,'Value')==1)
    set(handles.ElectronTemperatureAnalysis_Figure,'CurrentAxes',handles.axes2);

elseif(get(handles.AxesNum3Radiobutton,'Value')==1)
    set(handles.ElectronTemperatureAnalysis_Figure,'CurrentAxes',handles.axes3);
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
    FaceAlpha = get(axs_surf,'FaceAlpha');
    CData = get(axs_surf,'CData');
    
    figure('WindowStyle','normal','Name','Data Plot');
    surf(xdata,ydata,zdata,'EdgeColor',EdgeColor,...
        'FaceAlpha',FaceAlpha,'CData',CData)

    xlabel(x_label);ylabel(y_label);
    
    CustomizeFigures(gcf);

    XY_plane=[0 90];
    view(XY_plane);
    NumColors = 1000;
    colormap_List = get(handles.ColorMapPopupmenu,'String');
    colormap_index = get(handles.ColorMapPopupmenu,'Value');
    colormap_choice = strtrim(cell2mat(colormap_List(colormap_index)));
    colormap(colormap_choice);
    handles.ColorAxis_Min_Max = [str2double(get(handles.MinValColorEdit,'String')),...
        str2double(get(handles.MaxValColorEdit,'String'))];
    caxis(handles.ColorAxis_Min_Max);

end
hold off;

guidata(hObject, handles);

function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NowDir = cd;
if(~isempty(handles.PathName))
   cd(handles.PathName);
end
[FileName,handles.PathName] = uigetfile('*.fig','Select the MATLAB figure file');
cd(handles.PathName);
FigHandle = openfig(FileName,'invisible');
cd(NowDir);

axes_handle = get(FigHandle,'Children');

line_child = findobj(axes_handle,'Type','line');
surf_child = findobj(axes_handle,'Type','surf');

if(~isempty(surf_child))
    X = get(surf_child,'XData');
    Y = get(surf_child,'YData');
    Z = get(surf_child,'ZData');
    surf(X,Y,Z,'Parent',handles.axes1,'EdgeAlpha',0);
    view(handles.axes1,2);
elseif(~isempty(line_child))
    for index = 1:length(line_child)        
        X = get(line_child(index),'XData');
        Y = get(line_child(index),'YData');
        
        line(X,Y,'Parent',handles.axes1)
    end    
end

guidata(hObject, handles);


%--------------------------------------------------------------------------

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


% --- Executes when ElectronTemperatureAnalysis_Figure is resized.
function ElectronTemperatureAnalysis_Figure_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to ElectronTemperatureAnalysis_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close ElectronTemperatureAnalysis_Figure.
function ElectronTemperatureAnalysis_Figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ElectronTemperatureAnalysis_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.Received_GUI_Data.NowDir);
% Hint: delete(hObject) closes the Figure
delete(hObject);


% --------------------------------------------------------------------
