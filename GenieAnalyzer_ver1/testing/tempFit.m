function tempFit

global I_fit
global I_sim
global V_fit
global edgeConst;

child = get(gca,'Children');
V = get(child,'XData');
I = abs(get(child,'YData'));

% figure;plot(V,I)
% pause

% if(lever==0)
%     prompt = {'Lever:'};
%     dlg_title = 'Lever';
%     num_lines = 1;
%     def = {num2str(0.058)};
%     answer = inputdlg(prompt,dlg_title,num_lines,def);
%     
%     lever = answer(1);
% end
lever = 0.082;
lever = 0.056;

options = optimset('Display','iter','MaxFunEvals',10000,'MaxIter',200,'TolFun',1e-8);

V = lever*V;
figure(100);
plot(V,I,'b-');hold on;

END = 30;INIT = 1;
while(1)
    %                 plot(V,I,'b-');hold on;
    
    prompt = {'Start:','End:','Rise(1) or Fall(0) Edge :'};
    dlg_title = 'Fit Range';
    num_lines = 1;
    def = {num2str(INIT),num2str(END),num2str(1)};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
    if(~isempty(answer))
        edgeConst =  str2double(answer(3));
        init = str2double(answer(1));
        fin = str2double(answer(2));
        END = fin;
        INIT = init;
        
        I_fit = I(init:fin);
        V_fit = V(init:fin);
        figure(100);
        plot(V_fit,I_fit,'r*');
        
        Fitchoice = questdlg('Would you like to change the range?','Fitting Option','Yes','No','Yes');
        Vo = V_fit(round(length(V_fit)/2));
        T = 300e-3;
        Amp = 1;
        if(strcmp(Fitchoice,'No'))
            while(1)
                I_fit = I_fit - min(I_fit);
                I_fit = I_fit/max(I_fit);
                
                par = [T,Vo,Amp];
                
                lb = [0.01,Vo*0.75,0.8];
                ub = [10,Vo*1.25,1];
                Opt_par = fmincon(@FidCalc,par,[],[],[],[],lb,ub,[],options);
                
                Constant_T = Opt_par(1);
                Constant_Vo = Opt_par(2);
                Constant_Amp = Opt_par(3);
                
                figure(105);
                plot(V_fit,I_fit,'r*');hold on;
                plot(V_fit,I_sim,'b--');hold off;
                title(['Lattice Temp = ',num2str(Constant_T),' and Vo = ',num2str(Constant_Vo)])
                pause;
                
                prompt = {'Temperature:','Vo:','Amplitude: '};
                dlg_title = 'Fit Range';
                num_lines = 1;
                def = {num2str(Constant_T),num2str(Constant_Vo),num2str(Constant_Amp)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                
                if(~isempty(answer))
                    T = str2double(answer(1));
                    Vo = str2double(answer(2));
                    Amp = str2double(answer(3));
                else
                    
                    T = Constant_T;
                    Vo = Constant_Vo;
                    Amp = Constant_Amp;
                    
                    while(1)
                        par = [T,Vo,Amp];
                        FunEval(par)
                        prompt = {'Temperature:','Vo:','Amplitude:'};
                        dlg_title = 'Fit Range';
                        num_lines = 1;
                        def = {num2str(T),num2str(Vo),num2str(Amp)};
                        answer = inputdlg(prompt,dlg_title,num_lines,def);
                        
                        if(isempty(answer))
                            break;
                        else
                            T = str2double(answer(1));
                            Vo = str2double(answer(2));
                            Amp = str2double(answer(3));
                            
                            figure(105);
                            plot(V_fit,I_fit,'r*');hold on;
                            plot(V_fit,I_sim,'b--');hold off;
                            title(['Lattice Temp = ',num2str(Constant_T),' and Vo = ',num2str(Constant_Vo),...
                                ' and Amp = ',num2str(Constant_Amp)])
                            %                                         pause;
                        end
                        %                                     if()
                        
                    end
                    
                    break;
                    
                end
            end
            
            figure(100);
            hold off;
            break;
        else
            figure(100);
            hold off;
            plot(V,I,'b-');hold on;
        end
        
        %                     pause;
        %                     hold off;
    else
        hold off;
        break;
    end
    
    %                 else
    %                     break;
    %                 end
    
end
end
%         end


function fidelity = FidCalc(par)
global I_fit;
global I_sim;
global V_fit;
global edgeConst;

e = 1.602e-19;
h = 6.626e-34;
kB = 1.38e-23;

T = par(1);
Vo = par(2);
Amp = par(3);

I_sim = Amp*abs(1*edgeConst - 1./(exp(e*(V_fit-Vo)/(kB*T)) + 1));

size(I_sim)
size(I_fit)

diffSquares = sum((I_sim-I_fit).^2);

fidelity = diffSquares*1e5
pause(0.01);
end

function out = FunEval(par)
global I_fit;
global I_sim;
global V_fit;
global edgeConst;

e = 1.602e-19;
h = 6.626e-34;
kB = 1.38e-23;

T = par(1);
Vo = par(2);
Amp = par(3);

I_sim = Amp*abs(1*edgeConst - 1./(exp(e*(V_fit-Vo)/(kB*T)) + 1));

% diffSquares = sum((I_sim-I_fit).^2);

out = 1;
pause(0.01);
end