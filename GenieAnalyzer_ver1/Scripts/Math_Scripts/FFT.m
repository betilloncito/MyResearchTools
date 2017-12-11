function varargout = FFT(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'Offset X:';
    DataTable{1,2} = 0;
    DataTable{2,1} = 'Scale X:';
    DataTable{2,2} = 1;
    DataTable{3,1} = 'Offset Y:';
    DataTable{3,2} = 0;
    DataTable{4,1} = 'Scale Y:';
    DataTable{4,2} = 1;
    DataTable{5,1} = 'Line Index:';
    DataTable{5,2} = 0;
    
    varargout = {DataTable};
else
            
    HandleAxes = varargin{1};
    Variables = varargin{2};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    deltaX = Variables(1);
    Gx = Variables(2);
    deltaY = Variables(3);
    Gy = Variables(4);
    LineIndex = Variables(5);    
    
    %Get data from figure: DO NOT EDIT THIS LINE---------------------------
    [XData,YData] = getDataFigure(HandleAxes,LineIndex);
    %----------------------------------------------------------------------
    
    for i=1:size(XData,2)
        x = XData{i};
        y = YData{i};
        Fs = 1/abs(x(1)-x(2));
        L = length(x);
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y
        Y = fft(y,NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        YY = 2*abs(Y(1:NFFT/2+1));

        XData_new{i} = f;
        YData_new{i} = YY;
    end
    
    %------------------STOP CODE HERE---------------------------------%
        
%     %Plotting Example
%     HandleFig = figure('WindowStyle','normal','Name','Data Plot');
%     plot(x,y);grid on;hold on;
%     xlabel(' ');ylabel(' ');title(' ');    
%     CustomizeFigures(HandleFig);
%     close(HandleFig);
%     Legend = {' '};
%     legend(Legend);    
%     hold off;
    
    %Do not edit this line
    varargout = {XData_new,YData_new};
end