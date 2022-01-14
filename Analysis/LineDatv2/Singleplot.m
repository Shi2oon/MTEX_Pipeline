%% single plot
function Singleplot(x,y,ti,label,fSize,SavDir)
    close all
    set(0,'defaultAxesFontSize',fSize)
%     f1 = fit(x(:),y(:),'exp2','normalize','on');
%     plot(f1,x,y);                  	hold on;
    plot(x,y,'ok','MarkerSize',fSize/2,'MarkerFaceColor',[0 0 1])
    hold off;                       title(ti); 
    xlabel('Distance [\mum]');            ylabel(label); 
    legend  off
    set(gcf,'position',[600,100,1150,750]);  
    DirSave = [SavDir '.fig'];      saveas(gcf,DirSave);    
    DirSave = [SavDir '.png'];      saveas(gcf,DirSave);     close all
end