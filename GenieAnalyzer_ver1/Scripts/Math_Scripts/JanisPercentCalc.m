function varargout = JanisPercentCalc(varargin)
%Code will apply a simple offset (add and substract) and scaling factor
%(multiply and divide) the data for each curve plotted on the axis

%-------------------------------------------------------------------------%
%Dummy call to function: it's purpose is to output the variables that the
%function requires so that the user can give the input values for these
%variables before cliking "analyse"
if(nargin==0)
    DataTable{1,1} = 'He level: (in)';
    DataTable{1,2} = 0;
    
    varargout = {DataTable};
else
            
    Variables = varargin{1};
    
    %---------------------START CODE HERE---------------------------------%
    % Access the data for the file number INDEX by using the variable
    % MatrixData. The index for each variable are given above    
    
    %Initializes input parameters: Example
    He_level = cell2mat(Variables(1));
    n = 17/6.75;
    total = mean([6.7,5.2])*0.9*n^2 + 4.9*6.7*n^2 + 6.75*5.2*n^2;
    
    if(He_level <= 17)
        level = He_level*5.2*n;
        
    elseif(He_level <= (17+0.9*n))        
        base2 = (1.5/0.9)*(He_level-17)/n;
        level = 6.75*5.2*n^2 + mean([base2,5.2])*n*(He_level-17);
    
    elseif(He_level<=33)        
        (He_level-(17+0.9*n))
        level = 6.75*5.2*n^2 + mean([6.7,5.2])*0.9*n^2 + (He_level-(17+0.9*n))*6.7*n;
    
    else
        msgbox('Level is above the maximum value of 33in');
        level = 0;
    end
    Percent = level/total;
    
    varargout = {Percent*100};
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
end