function Kplot(Xum,SGPa,ti,label,fSize,SavDir)
try
    close all
    set(0,'defaultAxesFontSize',fSize)
    [Fa, gof] = createFit1(Xum, SGPa); 
    h = plot(Fa); hold on
    plot(Xum,SGPa,'ok','MarkerSize',fSize/2,'MarkerFaceColor',[0 0 1]);
    set(h,'LineWidth',3); hold off
    title({[ti ' :: K = ' num2str(round(Fa.K,3)) ' ± ' ...
        num2str(round(Fa.K*(1-gof.adjrsquare),3)) ' MPa\surdm'];...
        ['f(X) = ' num2str(round(Fa.A,3)) ' + ' num2str(round(Fa.K,3))...
        '/\surd(X + ' num2str(round(Fa.B,3)) ')']}); 
    xlabel('Distance [\mum]');            ylabel(label); 
    legend  off
    set(gcf,'position',[600,100,1150,750]);  
    DirSave = [SavDir 'K.fig'];      saveas(gcf,DirSave);    
    DirSave = [SavDir 'K.png'];      saveas(gcf,DirSave);     close all
catch err
    fprintf('\nDo it manually\n\n');
end
end
