function varargout = LeverArmExtraction_GUI(varargin)
% LEVERARMEXTRACTION_GUI MATLAB code for LeverArmExtraction_GUI.fig
%      LEVERARMEXTRACTION_GUI, by itself, creates a new LEVERARMEXTRACTION_GUI or raises the existing
%      singleton*.
%
%      H = LEVERARMEXTRACTION_GUI returns the handle to a new LEVERARMEXTRACTION_GUI or the handle to
%      the existing singleton*.
%
%      LEVERARMEXTRACTION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEVERARMEXTRACTION_GUI.M with the given input arguments.
%
%      LEVERARMEXTRACTION_GUI('Property','Value',...) creates a new LEVERARMEXTRACTION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LeverArmExtraction_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LeverArmExtraction_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LeverArmExtraction_GUI

% Last Modified by GUIDE v2.5 31-Mar-2019 18:53:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LeverArmExtraction_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LeverArmExtraction_GUI_OutputFcn, ...
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


% --- Executes just before LeverArmExtraction_GUI is made visible.
function LeverArmExtraction_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LeverArmExtraction_GUI (see VARARGIN)

% Choose default command line output for LeverArmExtraction_GUI
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

%Needs to re-edit
handles.VarDataTable = [{'Gate X:'},{'Vplg_L'};...
    {'Gate Y:'},{'Vacc_LT'};...
    {'Current:'},{'Current'};...
    {'Sensitivity [A/V]:'},{1e-8};...
    {'Peak Finding Axis X or Y:'},{'X'};...
    {'Sacling of Pk. Finding Axis:'},{100};...
    {'Smoothing Factor'},{2};...
    {'X limits [min, max]:'},{''};...
    {'Y limits [min, max]:'},{''};...
    {'Number of k-cluster [integer]:'},{13};...
    {'Number of Chosen Peaks [integer]'},{6};...
    {'Number of Division [integer]:'},{6}];
handles.FitDataParamTable = [{'Bound: Gamma (min, max) [Hz]:'},{'1,1e4'};...
    {'Bound: Te_max (Delta Vg) [min%, max%]:'},{'20,60'};...
    {'Bounds: mu_min & mu_max [min%, max%]'},{'10,90'}; {'empty:'},{''}];

set(handles.VariableListTable,'Data',handles.VarDataTable);
set(handles.FittingParamTable,'Data',handles.FitDataParamTable);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = LeverArmExtraction_GUI_OutputFcn(hObject, eventdata, handles) 
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


function ExtractPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;
chosenFile = get(handles.FilesChosenListbox,'Value');
INDEX = handles.ChosenFiles_indeces(chosenFile);

VarTable = get(handles.VariableListTable,'Data');
FitTable = get(handles.FittingParamTable,'Data');

%List the names used for the variables header
%V_GATE_X
name{1} = cell2mat(VarTable(1,2)); 
%V_GATE_Y
name{2} = cell2mat(VarTable(2,2));
%CURRENT
name{3} = cell2mat(VarTable(3,2));
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
                    VgateX_index = ii;
                case 2
                    VgateY_index = ii;
                case 3
                    Current_index = ii;
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

%Constant----------------------------------------------------------
kB = 8.6173303e-5;%eV/K

%Extracting User Input---------------------------------------------
%Initializes input parameters: Example
%       S = cell2mat(VarTable(5,2));
alpha = str2double(cell2mat(VarTable(5,2)));

n1 = size(MatrixData,1);%Osc time
n3 = size(MatrixData,3);%dummy
n4 = size(MatrixData,4);%Vgate

SweepingIndeces = cell2mat(handles.Received_GUI_Data.SweepVar_Index{INDEX});
Header = handles.Received_GUI_Data.Header_Vector{INDEX}{1};

%Extracting Variables in Data------------------------------------

%Current data
Current = squeeze(MatrixData(:,Current_index,:));

Header_untrimmed = cell2mat(Header(SweepingIndeces(1)));
n = strfind(Header_untrimmed,' (');

Header_trimmed = Header_untrimmed(1:n-1);
if(strcmp(name(1),Header_trimmed))
    %Vgate sweeping 1st
    VgateX = squeeze(MatrixData(:,VgateX_index,1));
    %Vgate sweeping 2nd
    VgateY = squeeze(MatrixData(1,VgateY_index,:));
    Current = Current';
else
    %Vgate sweeping 1st
    VgateY = squeeze(MatrixData(:,VgateY_index,1));
    %Vgate sweeping 2nd
    VgateX = squeeze(MatrixData(1,VgateX_index,:));
end
size(VgateX)
size(VgateY)
size(Current)
surf(VgateX,VgateY,Current,'EdgeColor','none','Parent',handles.axes1);
XY_plane = [0 90];view(handles.axes1, XY_plane);
% set(Handles.Axes1,'XLim',sort([VgateX(startX_index),XData(endX_index)],'ascend'));
% set(Handles.Axes1,'YLim',sort([VgateY(startY_index),YData(endY_index)],'ascend'));
%-----------------------------------------------------------------%


%POINT FOR LOOP************************
% for INDEX_iter = 1:length(Iteration)
%     Iteration(INDEX_iter)
%     
%     %Smoothing Y-data in oscilloscope data (moving average)
%     % sliceNum = linspace(201,210,10);
%     % for i=1:size(handles.OscY,2)
%     %     i
%     %     if(any(sliceNum==i))
%     %         plotOpt = 1;
%     %     else
%     %         plotOpt = 0;
%     %     end
%     %     handles.OscY(:,i) = ReduceNoise_Thres(handles.OscY(:,i),GaussWin,Iteration,0.5,plotOpt);
%     % end
%     for i=1:size(OscY_org,2)
%         handles.OscY(:,i) = ReduceNoise(OscY_org(:,i),GaussWin,Iteration(INDEX_iter),0);
%     end
%     %Calculates the "effective" derivative (i.e. deltaY instead of deltaY/deltaX)
%     for i=1:size(handles.OscY,2)
%         difference(:,i) = abs(diff(handles.OscY(:,i)));
%     end
%     for i=1:size(difference,2)
%         [N,edges] = histcounts(difference(:,i),Hist_BinNumber);
%         %             for ii=1:length(edges)-1
%         %                xx(ii) = mean(edges(ii:ii+1));
%         %             end
%         %             child = get(handles.axes4,'Children');delete(child);
%         %             Hist_Obj = histogram(handles.axes4,difference(:,i),Hist_BinNumber);
%         N = ReduceNoise(N,Hist_smooth_numPts,Hist_smooth_Iter,0);
%         [val,ind] = max(N);
%         base(i) = mean(edges(ind:ind+1));
%         %             line([base,base],[0,val],'Parent',handles.axes4,'Marker','none',...
%         %                 'LineStyle','--','Color','g','LineWidth',4);
%         %             line(xx,N,'Parent',handles.axes4,'MarkerFaceColor','r','MarkerEdgeColor','k',...
%         %                 'Marker','o','LineStyle','--','Color','r');
%         
%         %             child = get(handles.axes1,'Children');delete(child);
%         %             line(linspace(1,length(difference(:,i)),length(difference(:,i))),difference(:,i),'Parent',handles.axes1,...
%         %                 'Marker','none','LineStyle','-','Color','k');
%         %             line([1,length(difference(:,i))],[base,base],'Parent',handles.axes1,...
%         %                 'Marker','none','LineStyle','--','Color','r');
%         amplitude(i) = max(difference(:,i)) - base(i);
%         
%     end
%        
%     child = get(handles.axes1,'Children');delete(child);
%     Hist_Obj = histogram(handles.axes1,amplitude,Hist_BinNumber);
%     Hist_freq_raw = Hist_Obj.Values;
%     Hist_Xval = Hist_Obj.BinEdges(1:end-1) + Hist_Obj.BinWidth/2;
%     Hist_freq = ReduceNoise(Hist_freq_raw,Hist_smooth_numPts,Hist_smooth_Iter,0);   
%     [pks,loc] = findpeaks(Hist_freq,'SortStr','descend');
%     lowerBound = Hist_Xval(loc(2));
%     Delta_amplitude_correct = Hist_Xval(loc(1))-lowerBound;
%     line(Hist_Xval,Hist_freq,'Parent',handles.axes1,...
%         'Marker','o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','k','LineStyle','--','Color','r');
%     line([Hist_Xval(loc(1)),Hist_Xval(loc(1))],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
%         'Marker','none','LineStyle','--','Color','b','LineWidth',2);
%     line([Hist_Xval(loc(2)),Hist_Xval(loc(2))],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
%         'Marker','none','LineStyle','--','Color','b','LineWidth',2);
%     grid(handles.axes1,'on');
%     
%     if(ThresInput_GaussFit_NumPts>0)
%         for j=1:2
%             Pts = ThresInput_GaussFit_NumPts;
%             if(loc(j)-Pts < 1)
%                 init = 1;
%                 Pts = loc(j)-1;
%             else
%                 init = loc(j)-Pts;
%             end
%             XX = Hist_Xval(init:loc(j)+Pts);
%             YY = Hist_freq(init:loc(j)+Pts)';
%             xo_gauss = Hist_Xval(loc(j));
%             vargauss_start = [0.1*peak2peak(Hist_Xval), pks(j)];
%             gauss_FUN = @(vargauss, xdata)vargauss(2)*exp(-(xdata - xo_gauss).^2/(2*vargauss(1)^2));
%             lb = [0.005*peak2peak(Hist_Xval)];
%             ub = [0.9*peak2peak(Hist_Xval)];
%             VARGAUSS(:,j) = lsqcurvefit(gauss_FUN, vargauss_start, XX, YY, lb, ub);
%             STD = VARGAUSS(1,j);
%             Thres_limit(j) = Hist_Xval(loc(j)) + 2*STD*(-1)^j;
%             Thres_percent(j) = abs(Thres_limit(j) - Hist_Xval(loc(2)))/Delta_amplitude_correct;
%             line(Hist_Xval,gauss_FUN(VARGAUSS(:,j),Hist_Xval),'Parent',handles.axes1,...
%                 'Marker','none','LineStyle',':','Color','c','LineWidth',3);
%             line([Thres_limit(j),Thres_limit(j)],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
%                 'Marker','none','LineStyle','-','Color','k','LineWidth',3);
%         end
%         ThresInput = [mean(Thres_percent),Thres_percent(1),Thres_percent(2)];
%         disp(['Threshold bounds: ',num2str(ThresInput(2)),', ',num2str(ThresInput(1)),', ',num2str(ThresInput(3))])
%     end
%     
%     for INDEX_thres = 1:length(ThresInput)
%         ThresInput(INDEX_thres)
%         Amp_Thres = lowerBound + Delta_amplitude_correct*ThresInput(INDEX_thres)
%         if(INDEX_thres == 1)
%             line([Amp_Thres,Amp_Thres],[0,max(Hist_freq_raw)],'Parent',handles.axes1,...
%                 'Marker','none','LineStyle','-','Color','g','LineWidth',3);
%         end
%         %         pause;
%         
%         if(INDEX_thres==1)
%             child = get(handles.axes3,'Children');
%             delete(child);
%             %         Hist_Obj = histogram(handles.axes3,difference,Hist_BinNumber);
%             line(handles.Vgate,amplitude,'Parent',handles.axes3,'Marker','o','LineStyle','none','Color','b');
%             line([handles.Vgate(1),handles.Vgate(end)],[Amp_Thres,Amp_Thres],'Parent',handles.axes3,...
%                 'Marker','none','LineStyle','--','Color','r');
%             title(['Threshold : ',num2str(ThresInput(INDEX_thres)*100),'%'],'Parent',handles.axes3)
%             grid(handles.axes3,'on');
%         end
%         
%         for i=1:size(difference,2)
%             
%             [pks,loc] = findpeaks(difference(:,i) - base(i));
%             Avg_Osc(i) = mean(handles.OscY(:,i));
%             
%             
%             ElectronCount = 0;
%             saved_OscY = []; saved_OscX = [];
%             saved_pk = []; saved_x = [];
%             for ii=1:length(pks)
%                 
%                 if( pks(ii) > Amp_Thres)
%                     ElectronCount = ElectronCount + 1;
%                     saved_OscY(ElectronCount) = handles.OscY(loc(ii),i);
%                     saved_OscX(ElectronCount) = handles.OscX(loc(ii),1);
%                     
%                     saved_pk(ElectronCount) = difference(loc(ii),i);
%                     saved_x(ElectronCount) = loc(ii);
%                 end
%                 
%             end
%             
%             if(Delay > 0 && INDEX_thres==1)
%                 child = get(handles.axes1,'Children');
%                 delete(child);
%                 line(linspace(1,length(difference(:,i)),length(difference(:,i))),difference(:,i),'Parent',handles.axes1,...
%                     'Marker','none','LineStyle','-','Color','k');
%                 line([1,length(difference(:,i))],[Amp_Thres,Amp_Thres],'Parent',handles.axes1,...
%                     'Marker','none','LineStyle','--','Color','r');
%                 if(ElectronCount>0)
%                     line(saved_x,saved_pk,'Parent',handles.axes1,'Marker','o','LineStyle','none','Color','g');
%                 end
%                 grid(handles.axes1,'on');
%                 
%                 child = get(handles.axes2,'Children');
%                 delete(child);
%                 line(handles.OscX,handles.OscY(:,i),'Parent',handles.axes2,'Marker','none','LineStyle','-','Color','k');
%                 if(ElectronCount>0)
%                     line(saved_OscX,saved_OscY,'Parent',handles.axes2,'Marker','o','LineStyle','none','Color','r');
%                 end
%                 grid(handles.axes2,'on');
%                 title({['Electron Counts: ',num2str(ElectronCount),'  Vg: ',num2str(handles.Vgate(i,1))],['Iteration: ',num2str(i)]},'Parent',handles.axes2)
%                 if(Delay==999)
%                     pause;
%                 else
%                     pause(Delay);
%                 end
%             end
%             
%             ElectronCountsPerSecond_final(i) = ElectronCount/(max(handles.OscX)-min(handles.OscX));
%             %     max(handles.OscX)-min(handles.OscX);
%             ElectronCount_final(i) = ElectronCount;
%         end
%         
%         %         cnt = 1;
%         for i=1:n4
%             
%             ElectronCountsPerSecond_final_cumul(i) = mean(ElectronCountsPerSecond_final((i-1)*n3+1:i*n3));
%             Avg_Osc_cumul(i) = mean(Avg_Osc((i-1)*n3+1:i*n3));
%             
%             %             if(i==1)
%             %                 ElectronCount_final_cumul(cnt) = ElectronCount_final(i);
%             %             elseif(handles.Vgate(i-1) == handles.Vgate(i))
%             %                 ElectronCount_final_cumul(cnt) = ElectronCount_final(i) + ElectronCount_final_cumul(cnt);
%             %             else
%             %                 cnt = cnt+1;
%             %                 ElectronCount_final_cumul(cnt) = ElectronCount_final(i);
%             %             end
%         end
%         
%         %fits: FERMI DIST.---------------------------------------------------------
%         %{
% %Renormalize the data to be fit
% if(Delay_Fermi>0)
% %     child = get(handles.axes1,'Children');delete(child);
% %     line(handles.Vgate_nonrepeat,Avg_Osc_cumul,'Parent',handles.axes1,'Marker','.','LineStyle','none','Color','b');
% %     grid(handles.axes1,'on');
% %     title(handles.axes1,'Average Occupansy vs. Vgate');
% %     pause(Delay_Fermi);
% end
% if(isnan(Fermi_Min))
%     Avg_Osc_cumul_norm = (Avg_Osc_cumul - min(Avg_Osc_cumul));
% else
%     Avg_Osc_cumul_norm = (Avg_Osc_cumul - Fermi_Min);
% end
% if(Delay_Fermi>0)
% %     child = get(handles.axes1,'Children');delete(child);
% %     line(handles.Vgate_nonrepeat,Avg_Osc_cumul_norm,'Parent',handles.axes1,'Marker','.','LineStyle','none','Color','b');
% %     grid(handles.axes1,'on');
% %     title(handles.axes1,'Average Occupancy - Min Value vs. Vgate');
% %     pause(Delay_Fermi);
% end
% if(isnan(Fermi_Max))
%     Avg_Osc_cumul_norm = Avg_Osc_cumul_norm/max(Avg_Osc_cumul_norm);
% else
%     Avg_Osc_cumul_norm = Avg_Osc_cumul_norm/Fermi_Max;
% end
% 
% if(FermiStart==1)
%     func = strcat('1/(exp(',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1)');
% else
%     func = strcat('1/(exp(-1*',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1)');
% end
% modelVariables = {'Te','mu'};
% fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
% 
% %         Here I define values for the starting "guess" for the fitting parameters
% Te_start  = 100e-3;
% [val, ind] = max(abs(diff(Avg_Osc_cumul_norm)));
% mu_start = handles.Vgate_nonrepeat(ind(1));
% 
% [myfit,gof] = fit(handles.Vgate_nonrepeat, Avg_Osc_cumul_norm', fmodel,...
%     'Start', [Te_start, mu_start],...
%     'TolFun',1e-45,'TolX',1e-45,'MaxFunEvals',1000,'MaxIter',1000);
% 
% %         The 3 lines below are used to estimate error bars on the values for the
% %         fitting parameters
% ci = confint(myfit,0.95);
% Te_fit_ebar = ci(:,1);
% mu_fit_ebar = ci(:,2);
% 
% %         vals contains the final values for the fitting parameters
% vals = coeffvalues(myfit);
% Te_fit = vals(1);mu_fit = vals(2);
% 
% % child = get(handles.axes1,'Children');
% % delete(child);
% % set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes1);
% % plot(myfit,handles.Vgate_nonrepeat,Avg_Osc_cumul_norm);
% % line([mu_start,mu_start], [min(Avg_Osc_cumul_norm),max(Avg_Osc_cumul_norm)],'Parent',handles.axes1,'Marker','none','LineStyle','--','Color','g');
% % %         line(handles.Vgate_nonrepeat,Avg_Osc_cumul,'Parent',handles.axes1,'Marker','o','LineStyle','none','Color','b');
% % grid(handles.axes1,'on');
% % title(handles.axes1, [{'N_{occupancy} vs. Vgate'},...
% %     {['Fit: T_e=',num2str(round(Te_fit*1000,1)),' (',num2str(round((Te_fit-Te_fit_ebar(1))*1000,1)),', ',num2str(round((Te_fit-Te_fit_ebar(2))*1000,1)),' [95% CI]) mK']},...
% %     {['mu=',num2str(mu_fit),' (',num2str(round((mu_fit-mu_fit_ebar(1)),6)),', ',num2str(round((mu_fit-mu_fit_ebar(2)),6)),' [95% CI]) V']}],...
% %     'FontSize',10);
% 
%         %}
%         %--------------------------------------------------------------------------
%         
%         %FITTING: Electron tunneling rate vs Gate voltage Curve ------------------------------------------
%         %Renormalize the data to be fit
%         % func = strcat('Gamma*(1/(exp(',num2str(alpha),'*(Vg - ',num2str(mu_fit),')/(',num2str(kB*Te_fit),')) + 1))',...
%         %     '*(1 - 1/(exp(',num2str(alpha),'*(Vg - ',num2str(mu_fit),')/(',num2str(kB*Te_fit),')) + 1))');
%         
%         lb_Te = (Te_DeltaVg_MIN_MAX(1)/100)*peak2peak(handles.Vgate)*alpha/(3*kB);
%         ub_Te = (Te_DeltaVg_MIN_MAX(2)/100)*peak2peak(handles.Vgate)*alpha/(3*kB);
%         
%         lb_mu = min(handles.Vgate) + mu_MIN_MAX_percent(1)*peak2peak(handles.Vgate)/100;
%         ub_mu = min(handles.Vgate) + mu_MIN_MAX_percent(2)*peak2peak(handles.Vgate)/100;
%         
%         lb = [Gamma_MIN_MAX(1), lb_Te, lb_mu];
%         ub = [Gamma_MIN_MAX(2), ub_Te, ub_mu];
%         
%         Gamma_start = mean(Gamma_MIN_MAX);
%         Te_start = (ub_Te-lb_Te)/2;
%         mu_start = handles.Vgate_nonrepeat(round(length(handles.Vgate_nonrepeat)/2));
%         
%         var_start = [Gamma_start, Te_start, mu_start];
%         FUN = @(var, xdata)var(1).*(1./(exp(alpha*(xdata - var(3))./(kB*var(2))) + 1)).*(1 - 1./(exp(alpha*(xdata - var(3))./(kB*var(2))) + 1));
%         
%         %     size(handles.Vgate)
%         %     size(ElectronCountsPerSecond_final)
%         
%         [VAR, resnorm, resid, exitflag, output, lambda, Jacob] = lsqcurvefit(FUN, var_start, handles.Vgate, ElectronCountsPerSecond_final', lb, ub);
%         ci = nlparci(VAR, resid, 'Jacobian', Jacob);
%         resnorm_stored(INDEX_iter, INDEX_thres) = resnorm;
%         VAR(1);
%         VAR(2);
%         VAR(3);
%         
%         newVAR = VAR;
%         % newVAR = [2, VAR(2:3)];
%         
%         %     fitamp_stored(INDEX_iter, INDEX_thres) = max(FUN(newVAR, handles.Vgate));
%         %     fitamp_stored(INDEX_iter, INDEX_thres) = peak2peak(FUN(newVAR, handles.Vgate));
%         %     fitamp_stored(INDEX_iter, INDEX_thres) = peak2peak(ElectronCountsPerSecond_final);
%         fitamp_stored(INDEX_iter, INDEX_thres) = VAR(1);%GAMMA
%         
%         if(INDEX_thres==1)
%             set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes2);
%             child = get(handles.axes2,'Children');delete(child);
%             line(handles.Vgate,ElectronCountsPerSecond_final,'LineStyle','none','Marker','o','MarkerFaceColor','b','MarkerFaceColor','k','MarkerSize',4);
%             line(handles.Vgate,FUN(newVAR, handles.Vgate),'LineStyle','-','Color','r','LineWidth',2,'Marker','none');
%             %         line(handles.Vgate_nonrepeat,ElectronCount_final_cumul,'Parent',handles.axes2,'Marker','o','LineStyle','none','Color','b');
%             grid(handles.axes2,'on');
%             title(handles.axes2, [{'<r_e> vs. Vgate'},...
%                 {['Fit: Gamma=',num2str(round(VAR(1),2)),' (',num2str(round((VAR(1)-ci(1,1)),2)),', ',num2str(round((VAR(1)-ci(1,2)),2)),' [95% CI]) Hz']},...
%                 {['Te =',num2str(VAR(2)*1000),'mK']}],...
%                 'FontSize',13);
%         end
%         %             pause
%     end
% end
% 
% % figure(100);
% %     line(V_sweep1_fit,Gamma_1,'Color','r');
% %     ax1 = gca; % current axes
% %     xlabel(ax1,'Vsweep1 [V]');
% %     ylabel(ax1,'\Gamma_1 [Hz]');
% %     ax1.XColor = 'r';
% %     ax1.YColor = 'r';
% %     
% %     ax1_pos = ax1.Position; % position of first axes
% %     ax2 = axes('Position',ax1_pos,...
% %         'XAxisLocation','top',...
% %         'YAxisLocation','right',...
% %         'Color','none');
% %     
% %     line(V_sweep2_fit,Gamma_2,'Parent',ax2,'Color','k');
% %     xlabel(ax2,'Vsweep2 [V]');
% %     ylabel(ax2,'\Gamma_2 [Hz]');
% %     grid on;
% 
% 
% child = get(handles.axes4,'Children');delete(child);
% if(INDEX_iter>1 && INDEX_thres>1)
%     for I=1:INDEX_thres
%         line(Iteration,fitamp_stored(:,I),'Parent',handles.axes4,'Marker','o','MarkerFaceColor','k','MarkerFaceColor','k','MarkerSize',4,'LineStyle','--','Color','k');           
%     end
%     set(handles.axes4,'YScale','linear');
%     grid(handles.axes4,'on');
% %     surf(Thres1, Iteration, fitamp_stored,'Parent',handles.axes4,'EdgeAlpha',0);
% %     view(handles.axes1, 2);
% else
%     if(INDEX_iter>1 && INDEX_thres==1)
%         line(Iteration,fitamp_stored,'Parent',handles.axes4,'Marker','o','MarkerFaceColor','k','MarkerFaceColor','k','MarkerSize',4,'LineStyle','--','Color','k');
%     elseif(INDEX_iter==1 && INDEX_thres>1)
%         line(ThresInput,fitamp_stored,'Parent',handles.axes4,'Marker','o','MarkerFaceColor','k','MarkerFaceColor','k','MarkerSize',4,'LineStyle','--','Color','k');
%     else
%          line(1,fitamp_stored,'Parent',handles.axes4,'Marker','o','MarkerFaceColor','k','MarkerFaceColor','k','MarkerSize',4,'LineStyle','--','Color','k');
%     end
%     set(handles.axes4,'YScale','linear');
%     grid(handles.axes4,'on');
% end
% 
% 
% % figure;axes1_sub=axes;
% % line(Thres1,resnorm_stored,'Parent',axes1_sub,'Marker','o','MarkerFaceColor','r','MarkerFaceColor','r','MarkerSize',4,'LineStyle','--','Color','r');
% % set(handles.axes1_sub,'YScale','linear');
% % grid(handles.axes1_sub,'on');
% 
% 
% 
%     
% % title(handles.axes1,'Average Occupansy vs. Vgate');
% 
% 
% %{
% 
% func = strcat('Gamma*(1/(exp(',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1))',...
%     '*(1 - 1/(exp(',num2str(alpha),'*(Vg - mu)/(',num2str(kB),'*Te)) + 1))');
% ModelVar_start = [Gamma_Guess, Te_start, mu_start];
% 
% modelVariables = {'Gamma', 'Te', 'mu'};
% fmodel = fittype(func, 'ind', {'Vg'}, 'coeff', modelVariables);
% 
% %         Here I define values for the starting "guess" for the fitting parameters
% %         ModelVar_start  = Gamma_Guess;
% 
% % [myfit,gof] = fit(handles.Vgate_nonrepeat, ElectronCountsPerSecond_final_cumul', fmodel,...
% %     'Start', ModelVar_start,...
% %     'TolFun',1e-45,'TolX',1e-45,'MaxFunEvals',1000,'MaxIter',1000);
% 
% [myfit,gof] = fit(handles.Vgate, ElectronCountsPerSecond_final', fmodel,...
%     'Start', ModelVar_start,...
%     'TolFun',1e-45,'TolX',1e-45,'MaxFunEvals',1000,'MaxIter',1000);
% 
% %         The 3 lines below are used to estimate error bars on the values for the
% %         fitting parameters
% ci = confint(myfit,0.95);
% Gamma_fit_ebar = ci(:,1);
% Te_fit_ebar = ci(:,2);
% mu_fit_ebar = ci(:,3);
% 
% %         vals contains the final values for the fitting parameters
% vals = coeffvalues(myfit);
% Gamma_fit = vals(1);
% Te_fit = vals(2);mu_fit = vals(3);
% 
% child = get(handles.axes2,'Children');
% delete(child);
% 
% set(handles.ElectronCounting_Figure,'CurrentAxes',handles.axes2);
% plot(myfit,handles.Vgate,ElectronCountsPerSecond_final);
% %         line(handles.Vgate_nonrepeat,ElectronCount_final_cumul,'Parent',handles.axes2,'Marker','o','LineStyle','none','Color','b');
% grid(handles.axes2,'on');
% title(handles.axes2, [{'<r_e> vs. Vgate'},...
%     {['Fit: Gamma=',num2str(round(Gamma_fit,1)),' (',num2str(round((Gamma_fit-Gamma_fit_ebar(1)),1)),', ',num2str(round((Gamma_fit-Gamma_fit_ebar(2)),1)),' [95% CI]) Hz']},...
%     {['Te =',num2str(Te_fit*1000),'mK']}],...
%     'FontSize',13);
% 
% figure;
% plot(handles.Vgate,ElectronCount_final);
% grid on;
% 
% %}
timelapsed = toc;
disp(['>>>DONE: ',num2str(timelapsed/60),'min <<<']);
guidata(hObject, handles);

% --- Executes on button press in AnalysisPushbutton.
function AnalysisPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VarTable = get(handles.VariableListTable,'Data');

%---------------------START CODE HERE---------------------------------%
% Access the data for the file number INDEX by using the variable
% MatrixData. The index for each variable are given above

%Initializes input parameters: Example
Labels_X = cell2mat(VarTable(1,2));
Labels_Y = cell2mat(VarTable(2,2));

Sens = cell2mat(VarTable(4,2));
PeakFindingAxis = cell2mat(VarTable(5,2));
Scaling_PeakFindingAxes = cell2mat(VarTable(6,2));
Iteration = cell2mat(VarTable(7,2));
LimitsX = cell2mat(VarTable(8,2));
LimitsY = cell2mat(VarTable(9,2));
kcluster_num = cell2mat(VarTable(10,2));
ChosenPks_num = cell2mat(VarTable(11,2));
kclustering_sections = cell2mat(VarTable(12,2));

%Get data from figure: DO NOT EDIT THIS LINE---------------------------
% axs_children = get(HandleAxes,'Children');
% axs_surf = findall(axs_children,'Type','Surface');
% if(isempty(axs_surf)==0)
[XData,YData,ZData] = getDataFigure(handles.axes1);
ZData = ZData*Sens;

axis_Number_Size = 6;
title_Size = 6;
axis_label_Size = 6;

surf_Plotted = 0;
% else
%     msgbox('Data plotted is not a 2D surface. Lever-arm extraction will not work','Error','error');
%     Data_2D_ERROR = 1;
% end
%----------------------------------------------------------------------
%Executes only if the plotted data is 2D
% if(Data_2D_ERROR == 0)
nx=strfind(LimitsX,',');
if(~isempty(nx))
    Min_X = str2double(LimitsX(1:nx-1));
    Max_X = str2double(LimitsX(nx+1:end));
    [val, Min_X_index] = min(abs(XData - Min_X));
    [val, Max_X_index] = min(abs(XData - Max_X));
    if(Min_X_index < Max_X_index)
        startX_index = Min_X_index
        endX_index = Max_X_index
    else
        startX_index = Max_X_index
        endX_index = Min_X_index
    end
else
    startX_index = 1;
    endX_index = length(XData);
end
ny=strfind(LimitsY,',');
if(~isempty(ny))
    Min_Y = str2double(LimitsY(1:ny-1));
    Max_Y = str2double(LimitsY(ny+1:end));
    [val, Min_Y_index] = min(abs(YData - Min_Y));
    [val, Max_Y_index] = min(abs(YData - Max_Y));
    if(Min_Y_index < Max_Y_index)
        startY_index = Min_Y_index;
        endY_index = Max_Y_index;
    else
        startY_index = Max_Y_index;
        endY_index = Min_Y_index;
    end
else
    startY_index = 1;
    endY_index = length(YData);
end

% HandleAxes = CustomizeFigures;
Cluster_X = {};Cluster_Y = {};
Cluster_X_FULL = {};
Cluster_Y_FULL = {};
UserContinue = 'Yes';
if(strcmp(PeakFindingAxis,'X'))
    Delta = floor(length(YData(startY_index:endY_index))/kclustering_sections);
    ITER = 1;
    
    while(ITER <= kclustering_sections && strcmp(UserContinue,'Yes')==1)
        Peaks_z = {};Peaks_y = {};Peaks_x = {};
        for i=startY_index+Delta*(ITER-1):startY_index+Delta*(ITER)
            tempZ = ZData(i,startX_index:endX_index);
            tempX = XData(startX_index:endX_index);
            ZData_smooth = ReduceNoise(tempZ,3,Iteration,0);
            
            [pks,loc] = findpeaks(ZData_smooth);
            Peaks_x = [Peaks_x; {tempX(loc)}];
            Peaks_y = [Peaks_y; {YData(i)/Scaling_PeakFindingAxes*ones(1,length(tempX(loc)))}];
            Peaks_z = [Peaks_z; {tempZ(loc)}];
        end
        colNum_max = max(cellfun(@numel,Peaks_x));
        Padded_X = -999*ones(size(Peaks_x,1),colNum_max);
        Padded_Y = -999*ones(size(Peaks_x,1),colNum_max);
        for j=1:size(Peaks_x,1)
            rowx = Peaks_x{j};
            rowy = Peaks_y{j};
            Padded_X(j,1:length(rowx)) = rowx;
            Padded_Y(j,1:length(rowy)) = rowy;
        end
        Padded_X_vec = reshape(Padded_X,[numel(Padded_X),1]);
        Padded_Y_vec = reshape(Padded_Y,[numel(Padded_Y),1]);
        Peaks_x_vec = Padded_X_vec(Padded_X_vec ~= -999);
        Peaks_y_vec = Padded_Y_vec(Padded_Y_vec ~= -999);
        
        if(surf_Plotted == 0)
            surf(XData,YData,ZData,'EdgeColor','none','Parent',handles.axes1);
            XY_plane = [0 90];view(handles.axes1, XY_plane);
            set(handles.axes1,'XLim',sort([XData(startX_index),XData(endX_index)],'ascend'));
            set(handles.axes1,'YLim',sort([YData(startY_index),YData(endY_index)],'ascend'));
            xlabel(handles.axes1, Labels_X);ylabel(handles.axes1, Labels_Y);
            surf_Plotted = 1;
        end
        idx = kmeans([Peaks_x_vec,Peaks_y_vec],kcluster_num);
        color_set = varycolor(kcluster_num);
        
        if(isempty(Cluster_X))
            cnt=1;
            for i=1:kcluster_num
                temp_Cluster_X = Peaks_x_vec(idx==i);
                temp_Cluster_Y = Peaks_y_vec(idx==i);
                line(temp_Cluster_X,temp_Cluster_Y*Scaling_PeakFindingAxes,...
                    max(max(ZData))*ones(1,length(temp_Cluster_X)),...
                    'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                    'MarkerFaceColor','none','Parent',handles.axes1);
                pause;
                cnt = cnt+1;
            end
            UserContinue = questdlg('Contiue?','Input','Yes','No','Yes');
            
            if(strcmp(UserContinue,'Yes'))
                for i=1:kcluster_num
                    X_pos(i) = mean(Peaks_x_vec(idx==i));
                end
                X_pos_sorted = sort(X_pos,'ascend');
                n = ceil(length(X_pos_sorted)/2)-floor(ChosenPks_num/2);
                nn = ceil(length(X_pos_sorted)/2)+(ChosenPks_num-floor(ChosenPks_num/2)-1);
                Chosen_X_pos_sorted = X_pos_sorted(n:nn);
                
                for i=1:length(Chosen_X_pos_sorted)
                    for ii=1:kcluster_num
                        if(Chosen_X_pos_sorted(i) == X_pos(ii))
                            Cluster_X{i,ITER} = Peaks_x_vec(idx==ii);
                            Cluster_Y{i,ITER} = Peaks_y_vec(idx==ii);
                            Cluster_X_FULL{i} = Peaks_x_vec(idx==ii);
                            Cluster_Y_FULL{i} = Peaks_y_vec(idx==ii);
                            line(Cluster_X{i,ITER},Cluster_Y{i,ITER}*Scaling_PeakFindingAxes,...
                                max(max(ZData))*ones(1,length(Cluster_X{i,ITER})),...
                                'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                                'MarkerFaceColor',color_set(i,:),'Parent',handles.axes1);
                            pause;
                            break;
                        end
                    end
                end
            end
            
        elseif(~isempty(Cluster_X))
            cnt=1;
            for i=1:kcluster_num
                temp_Cluster_X = Peaks_x_vec(idx==i);
                temp_Cluster_Y = Peaks_y_vec(idx==i);
                line(temp_Cluster_X,temp_Cluster_Y*Scaling_PeakFindingAxes,...
                    max(max(ZData))*ones(1,length(temp_Cluster_X)),...
                    'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                    'MarkerFaceColor','none','Parent',handles.axes1);
                pause;
                cnt = cnt+1;
            end
            UserContinue = questdlg('Contiue?','Input','Yes','No','Yes');
            if(strcmp(UserContinue,'Yes'))
                for ii=1:size(Cluster_Y,1)
                    for i=1:kcluster_num
                        vec_x = Peaks_x_vec(idx==i);
                        vec_y = Peaks_y_vec(idx==i);
                        
                        if(length(vec_y) > length(Cluster_Y{ii,ITER-1}))
                            PadVecY = -999*ones(length(vec_y),1);
                            PadVecX = -999*ones(length(vec_x),1);
                            PadVecY(1:length(Cluster_Y{ii,ITER-1}),1) = Cluster_Y{ii,ITER-1};
                            PadVecX(1:length(Cluster_X{ii,ITER-1}),1) = Cluster_X{ii,ITER-1};
                            Cluster_match = intersect([PadVecX,PadVecY], [vec_x,vec_y],'rows');
                            
                        elseif(length(vec_y) < length(Cluster_Y{ii,ITER-1}))
                            PadVecY = -999*ones(length(Cluster_Y{ii,ITER-1}),1);
                            PadVecX = -999*ones(length(Cluster_X{ii,ITER-1}),1);
                            PadVecY(1:length(vec_y),1) = vec_y;
                            PadVecX(1:length(vec_x),1) = vec_x;
                            Cluster_match = intersect([PadVecX,PadVecY],[Cluster_X{ii,ITER-1},Cluster_Y{ii,ITER-1}],'rows');
                            
                        else
                            Cluster_match = intersect([vec_x,vec_y],[Cluster_X{ii,ITER-1},Cluster_Y{ii,ITER-1}],'rows');
                        end
                        
                        if(~isempty(Cluster_match))
                            Cluster_X{ii,ITER} = vec_x;
                            Cluster_Y{ii,ITER} = vec_y;
                            Cluster_X_FULL{ii} = [Cluster_X_FULL{ii};Cluster_X{ii,ITER}];
                            Cluster_Y_FULL{ii} = [Cluster_Y_FULL{ii};Cluster_Y{ii,ITER}];
                            line(Cluster_X{ii,ITER},Cluster_Y{ii,ITER}*Scaling_PeakFindingAxes,...
                                max(max(ZData))*ones(1,length(Cluster_X{ii,ITER})),...
                                'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
                                'MarkerFaceColor',color_set(ii,:),'Parent',handles.axes1);
                            pause;
                        end
                    end
                end
            end
        end
        
        set(handles.axes1,'FontSize',axis_Number_Size);
        %             title(HandleAxes, title_label,'FontSize',title_Size);
        xlabel(handles.axes1, Labels_X,'fontsize',axis_label_Size);
        ylabel(handles.axes1, Labels_Y,'fontsize',axis_label_Size);
        
        ITER = ITER + 1;
    end
elseif(strcmp(PeakFindingAxis,'Y'))
    Peaks_z = {};Peaks_y = {};Peaks_x = {};
    for i=startX_index:endX_index
        tempZ = ZData(startY_index:endY_index,i);
        tempY = YData(startY_index:endY_index);
        ZData_smooth = ReduceNoise(tempZ,3,Iteration,0);
        
        [pks,loc] = findpeaks(ZData_smooth);
        Peaks_y = [Peaks_y; {tempY(loc)}];
        Peaks_x = [Peaks_x; {XData(i)*ones(1,length(tempY(loc)))}];
        Peaks_z = [Peaks_z; {tempZ(loc)}];
    end
    colNum_max = max(cellfun(@numel,Peaks_y));
    Padded_X = -999*ones(size(Peaks_y,1),colNum_max);
    Padded_Y = -999*ones(size(Peaks_y,1),colNum_max);
    for j=1:size(Peaks_y,1)
        rowx = Peaks_x{j};
        rowy = Peaks_y{j};
        Padded_X(j,1:length(rowx)) = rowx;
        Padded_Y(j,1:length(rowy)) = rowy;
    end
    
    Padded_X_vec = reshape(Padded_X,[numel(Padded_X),1]);
    Padded_Y_vec = reshape(Padded_Y,[numel(Padded_Y),1]);
    %
    %             Padded_X_vec = reshape(Padded_X',[numel(Padded_X),1]);
    %             Padded_Y_vec = reshape(Padded_Y',[numel(Padded_Y),1]);
    
    Peaks_x_vec = Padded_X_vec(Padded_X_vec ~= -999)
    Peaks_y_vec = Padded_Y_vec(Padded_Y_vec ~= -999)
    
    surf(XData,YData,ZData,'EdgeColor','none','Parent',handles.axes1);
    XY_plane = [0 90];view(handles.axes1, XY_plane);
    xlabel(handles.axes1, Labels_X.String);ylabel(handles.axes1, Labels_Y.String);
    %             line(Peaks_x,Peaks_y,max(max(ZData))*ones(1,length(Peaks_x)),...
    %                 'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
    %                 'MarkerFaceColor','r','Parent',HandleAxes);
    
    idx = kmeans([Peaks_x_vec,Peaks_y_vec],kcluster_num);
    color_set = varycolor(kcluster_num);
    for i=1:kcluster_num
        Cluster_X{i} = Peaks_x_vec(idx==i);
        Cluster_Y{i} = Peaks_y_vec(idx==i);
        line(Cluster_X{i},Cluster_Y{i},max(max(ZData))*ones(1,length(Cluster_X{i})),...
            'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
            'MarkerFaceColor',color_set(i,:),'Parent',handles.axes1);
    end
    
    set(handles.axes1,'FontSize',axis_Number_Size);
    %             title(HandleAxes, title_label,'FontSize',title_Size);
    xlabel(handles.axes1, Labels_X,'fontsize',axis_label_Size);
    ylabel(handles.axes1, Labels_Y,'fontsize',axis_label_Size);
    
    %             line(XData,ZData(1,:),'Color','b','LineStyle','-','Parent',HandleAxes);
    %             line(XData,ZData_smooth,'Color','r','Parent',HandleAxes);
    %             line(Peaks_x,Peaks_y,'LineStyle','none','Marker','o','Parent',HandleAxes);
    
else
    msgbox('Invalid axis to find peaks. Enter either X or Y','Error','error');
end

if(isempty(Cluster_X_FULL)==0 && strcmp(UserContinue,'Yes')==1)
    child = get(handles.axes1,'Children');delete(child);
    handles.XData = XData;
    handles.YData = YData;
    handles.ZData = ZData;
    handles.Cluster_X_FULL = Cluster_X_FULL;
    handles.Cluster_Y_FULL = Cluster_Y_FULL;
    handles.Scaling_PeakFindingAxes  = Scaling_PeakFindingAxes;
    
    surf(XData,YData,ZData,'EdgeColor','none','Parent',handles.axes1);
    XY_plane = [0 90];view(handles.axes1, XY_plane);
    set(handles.axes1,'XLim',sort([XData(startX_index),XData(endX_index)],'ascend'));
    set(handles.axes1,'YLim',sort([YData(startY_index),YData(endY_index)],'ascend'));
    set(handles.axes1,'FontSize',axis_Number_Size);
    %             title(HandleAxes, title_label,'FontSize',title_Size);
    xlabel(handles.axes1, Labels_X,'fontsize',axis_label_Size);
    ylabel(handles.axes1, Labels_Y,'fontsize',axis_label_Size);
    
    handles.color_set = varycolor(length(Cluster_X_FULL));
    for cnt=1:length(Cluster_X_FULL)
        coeff = polyfit(Cluster_X_FULL{cnt},Cluster_Y_FULL{cnt}*Scaling_PeakFindingAxes,1);
        slope(cnt) = coeff(1);%y_inter(cnt) = coeff(2);
    end
    slope_avg = mean(slope);
    
    for cnt=1:length(Cluster_X_FULL)
        X_line = Cluster_X_FULL{cnt};
        Y_line = Cluster_Y_FULL{cnt};
        sizeMidpt = round(length(Y_line));
        y_inter(cnt) = Y_line(sizeMidpt)*Scaling_PeakFindingAxes - slope_avg*X_line(sizeMidpt);
        
        line(Cluster_X_FULL{cnt},Cluster_Y_FULL{cnt}*Scaling_PeakFindingAxes,...
            max(max(ZData))*ones(1,length(Cluster_X_FULL{cnt})),...
            'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
            'MarkerFaceColor',color_set(cnt,:),'MarkerSize',2,...
            'Parent',handles.axes1);
        line([X_line(1),X_line(end)],slope_avg*[X_line(1),X_line(end)]+y_inter(cnt),...
            max(max(ZData))*ones(1,2),'LineStyle','-','Color','r',...
            'LineWidth',3,'Parent',handles.axes1);
        pause;
    end
    
    leverArm_Y = mean(diff(y_inter))
    leverArm_X = mean(diff(-y_inter./slope_avg))
    
    title_str = [{['Lever-Arm (GateX): ',num2str(leverArm_X),' [V/e]']},...
        {['Lever-Arm (GateY): ',num2str(leverArm_Y),' [V/e]']},...
        {['Lever-Arm Ratio (X/Y): ',num2str(leverArm_X/leverArm_Y)]}]

    title(handles.axes1, title_str,'FontSize',title_Size);
end

%------------------STOP CODE HERE---------------------------------%

guidata(hObject, handles);


% --- Executes on button press in LeverArmPushbutton.
function LeverArmPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LeverArmPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
child = get(handles.axes1,'Children');delete(child);
axis_Number_Size = 10;
title_Size = 10;
axis_label_Size = 10;

surf(handles.XData,handles.YData,handles.ZData,'EdgeColor','none','Parent',handles.axes1);
XY_plane = [0 90];view(handles.axes1, XY_plane);
set(handles.axes1,'XLim',get(handles.axes1,'XLim'));
set(handles.axes1,'YLim',get(handles.axes1,'YLim'));
% xlabel(handles.axes1, Labels_X,'fontsize',axis_label_Size);
% ylabel(handles.axes1, Labels_Y,'fontsize',axis_label_Size);

for cnt=1:length(handles.Cluster_X_FULL)
    coeff = polyfit(handles.Cluster_X_FULL{cnt},handles.Cluster_Y_FULL{cnt}*handles.Scaling_PeakFindingAxes,1);
    slope(cnt) = coeff(1);%y_inter(cnt) = coeff(2);
end
slope_avg = mean(slope);

for cnt=1:length(handles.Cluster_X_FULL)
    X_line = handles.Cluster_X_FULL{cnt};
    Y_line = handles.Cluster_Y_FULL{cnt};
    sizeMidpt = round(length(Y_line));
    y_inter(cnt) = Y_line(sizeMidpt)*handles.Scaling_PeakFindingAxes - slope_avg*X_line(sizeMidpt);
    
    line(handles.Cluster_X_FULL{cnt},handles.Cluster_Y_FULL{cnt}*handles.Scaling_PeakFindingAxes,...
        max(max(handles.ZData))*ones(1,length(handles.Cluster_X_FULL{cnt})),...
        'LineStyle','none','Marker','o','MarkerEdgeColor','k',...
        'MarkerFaceColor',handles.color_set(cnt,:),'MarkerSize',2,...
        'Parent',handles.axes1);
    line([X_line(1),X_line(end)],slope_avg*[X_line(1),X_line(end)]+y_inter(cnt),...
        max(max(handles.ZData))*ones(1,2),'LineStyle','-','Color','r',...
        'LineWidth',3,'Parent',handles.axes1);
    pause;
end

leverArm_Y = mean(diff(y_inter))
leverArm_X = mean(diff(-y_inter./slope_avg))

title_str = [{['Lever-Arm (GateX): ',num2str(leverArm_X),' [V/e]']},...
    {['Lever-Arm (GateY): ',num2str(leverArm_Y),' [V/e]']},...
    {['Lever-Arm Ratio (X/Y): ',num2str(leverArm_X/leverArm_Y)]}]

title(handles.axes1, title_str,'FontSize',title_Size);

guidata(hObject, handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

% --- Executes on selection change in FilesChosenListbox.
function FilesChosenListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FilesChosenListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chosenFile = get(handles.FilesChosenListbox,'Value');
str = get(handles.FilesChosenListbox,'String');
if(~isempty(str(chosenFile)))
    INDEX = handles.ChosenFiles_indeces(chosenFile);
    Header = handles.Received_GUI_Data.Header_Vector{INDEX};
    
    cell2mat(handles.Received_GUI_Data.SweepVar_Index{INDEX})
    
    set(handles.HeaderText,'String',cell2mat(Header{1}));
end
guidata(hObject, handles);

% --- Executes on button press in ApplyMathScriptPushbutton.
function ApplyMathScriptPushbutton_Callback(hObject, eventdata, handles)

if(get(handles.AxesNum1Radiobutton,'Value'))
    axesHandle = handles.axes1;
elseif(get(handles.AxesNum2Radiobutton,'Value'))
    axesHandle = handles.axes2;
elseif(get(handles.AxesNum3Radiobutton,'Value'))
    axesHandle = handles.axes3;
end

filename = get(handles.MathScriptText,'String');
TableData = get(handles.VariableListTable,'Data');
UserInputVaribles = (TableData(:,2));

% x_label = get(handles.XaxisEdit,'String');
% y_label = get(handles.YaxisEdit,'String');

set(handles.ElectronCounting_Figure,'CurrentAxes',axesHandle);
axs_children = get(axesHandle,'Children');
axs_line_unflipped = findall(axs_children,'Type','Line');
axs_surf = findall(axs_children,'Type','Surface');

%Saves Main directory
NowDir = cd;
cd(handles.ScriptPath_Math);
%Applies a script which was uploaded given the filename of the script and
%the global variable with the organized data from all files opened

if(isempty(axs_surf)==0)
    [XData,YData,ZData] = feval(filename(1:end-2),axesHandle,UserInputVaribles);
elseif(isempty(axs_line_unflipped)==0)
    [XData_unflipped,YData_unflipped] = feval(filename(1:end-2),axesHandle,UserInputVaribles);
    XData = fliplr(XData_unflipped);
    YData = fliplr(YData_unflipped);
else
    [answer] = feval(filename(1:end-2),UserInputVaribles);    
end
%returns to Main directory
cd(NowDir);

if(isempty(axs_surf)==0)
    delete(axs_children);
    
    set(handles.ElectronCounting_Figure,'CurrentAxes',axesHandle);
    surf(XData,YData,ZData,'EdgeColor','none');
    XY_plane = [0 90];view(XY_plane);grid on;
    
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
        line(XData{k},YData{k},'Color',plot_color{k},'LineStyle',linestyle{k},'LineWidth',linewidth{k},...
            'Marker',marker{k},'MarkerEdgeColor',markeredgecolor{k},'MarkerFaceColor',markerfacecolor{k},...
            'MarkerSize',markersize{k});
%         pause;
    end    
else
    set(handles.MathResultText,'String',[num2str(answer),'%']);
end

guidata(hObject, handles);

% --- Executes on button press in OpenMathScriptPushbutton.
function OpenMathScriptPushbutton_Callback(hObject, eventdata, handles)
%Saves Current directory
NowDir = cd;
n = findstr(NowDir,'\Scripts\')
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
cd(NowDir);
guidata(hObject, handles);

% --- Executes on button press in SaveParamPushbutton.
function SaveParamPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveParamPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.VarDataTable = get(handles.VariableListTable,'Data');
guidata(hObject, handles);

% --- Executes on button press in ExtractionSetupPushbutton.
function ExtractionSetupPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractionSetupPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.VariableListTable,'Data',handles.VarDataTable);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in OpenFigureWindowPushbutton.
function OpenFigureWindowPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFigureWindowPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(0,'CurrentFigure',handles.LeverArmExtraction_Figure);
set(0,'ShowHiddenHandles','on');

if(get(handles.AxesNum1Radiobutton,'Value')==1)
    set(handles.LeverArmExtraction_Figure,'CurrentAxes',handles.axes1);
    
elseif(get(handles.AxesNum2Radiobutton,'Value')==1)
    set(handles.LeverArmExtraction_Figure,'CurrentAxes',handles.axes2);

elseif(get(handles.AxesNum3Radiobutton,'Value')==1)
    set(handles.LeverArmExtraction_Figure,'CurrentAxes',handles.axes3);

elseif(get(handles.AxesNum4Radiobutton,'Value')==1)
    set(handles.LeverArmExtraction_Figure,'CurrentAxes',handles.axes4);
end

axs_children = get(gca,'Children');
axs_line = findall(axs_children,'Type','Line');
axs_text = findall(axs_children,'Type','Text');
axs_surf = findall(axs_children,'Type','Surface');
axs_hist = findall(axs_children,'Type','Histogram');

ax = gca;
title_label = ax.Title.String;
x_label = ax.XLabel.String;
y_label = ax.YLabel.String;

if(isempty(axs_line)==0)
%     CustomizeFigures(gcf,title_label,0);
    CustomizeFigures(gcf);
    xlabel(x_label);ylabel(y_label);
end

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

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

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
%----------------------------Close Function------------------------------
%--------------------------------------------------------------------------

% --- Executes when user attempts to close LeverArmExtraction_Figure.
function LeverArmExtraction_Figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to LeverArmExtraction_Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.Received_GUI_Data.NowDir);
% Hint: delete(hObject) closes the figure
delete(hObject);
