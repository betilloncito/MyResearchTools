%%-----------------------------------------------------------------------%%
%
%This work is licensed under the 
%Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
%To view a copy of this license, visit 
%http://creativecommons.org/licenses/by-nc-sa/3.0/ 
%or send a letter to Creative Commons,
%444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
%
%Created by: Eduardo Alberto Barrera Ramirez
%Last Edited: August 19th, 2011
%
%%-----------------------------------------------------------------------%%

function varargout = ReduceNoise(Initialsignal_noisy,GaussWin,Iteration,WaitBarOpt)

size(Initialsignal_noisy);


if(GaussWin>1)
    for i=1:Iteration
        Initialsignal_noisy = smooth(Initialsignal_noisy,GaussWin,'moving');
    end
    signal = Initialsignal_noisy';
else
    signal = Initialsignal_noisy';
end

size(signal);
% if(GaussWin>=4)
%     if(size(Initialsignal_noisy,1)>1)
%         Initialsignal_noisy = Initialsignal_noisy';
%     end
%     
%     if(WaitBarOpt==1)
%         WaitBar = waitbar(0,'Performing Smoothing, Please wait...');
%     end
%     % N = 20;
%     % Alpha = 40;
%     % w=gausswin(N,Alpha);
%     % n = linspace(-N/2,N/2,N);
%     
%     if(mod(GaussWin,2)==1)
%         N = GaussWin+1;
%     else
%         N =  GaussWin;
%     end
%     signal_noisy=Initialsignal_noisy;
%     
%     g = gausswin(N); % <-- this value determines the width of the smoothing window
%     g = g/sum(g);
%     signal_temp = conv(signal_noisy, g, 'same');
% %     figure(100)
% %     plot(Initialsignal_noisy);hold on;
%     for p = 1:N/2-1;
%         signal(p) = mean(signal_noisy(p:p+1));
% %         plot(signal(p),'*');grid on; hold on;
% %         pause;
%     end
%     signal = [signal,signal_temp(N/2:end-N/2)];
% %     plot(signal);grid on; hold on;
% %     pause;
%     for p = length(signal_noisy)-N/2:length(signal_noisy)-1;
%         signal = [signal,mean(signal_noisy(p:p+1))];
% %         plot(signal,'*');grid on; hold on;
% %         pause;
%     end
% %     pause;
%     % size(signal)
%     % size(signal_noisy)
%     if(WaitBarOpt==1)
%         waitbar(counter/NumIteration);
%     end
%     if(WaitBarOpt==1)
%         close(WaitBar)
%     end
% else
%     signal = Initialsignal_noisy';
% end

varargout = {signal'};