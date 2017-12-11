function varargout = ECOSORB_AttenuCalc(Waveforms)
%Calculates the attenuation due to the application of ECOSORB
XData = Waveforms.xData;
YData = Waveforms.yData;

if(size(XData,2)<=2)
    x1 = cell2mat(XData{1,1});
    y1 = cell2mat(YData{1,1})
    x2 = cell2mat(XData{1,2});
    y2 = cell2mat(YData{1,2})
    
    if(length(x1)~=length(x2))
        msgbox('Waveforms to substract are not the same size','ERROR','error');
    else
%         Pow1 = 10.^(y1/10)
%         Pow2 = 10.^(y2/10)
%         
%         attenu = 10*log10(Pow2-Pow1);
        attenu = y2-y1;
        figure(99);
        plot(x1,attenu);grid on;
        varargout = {attenu};
    end
else
    msgbox('Size of waveforms is invalid. Only two waveforms must be used','ERROR','error')    
end
