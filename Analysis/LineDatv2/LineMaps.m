function [LN] = LineMaps(Maps)
% [~,file,~] = fileparts(NAme);
% DirxEBSD   = [NAme '\' file '.mat'];         load(DirxEBSD,'Maps'); 
% DirDef     = [NAme '\' date '_Lines'];   	 mkdir(DirDef);   
close all;      

imagesc(Maps.X(1,:),Maps.Y(:,1),Maps.S13)  
set(gca,'YDir','normal');           axis equal; axis tight
pos = get(gcf,'position');          set(gcf,'position',[100 100 pos(3:4)*2]) 
xlabel('x[\mum]');                  ylabel('y[\mum]');
title('Please Select the line ahead of the strain concentrator ');
c = colorbar;                       colormap(jet(256)); %labelling   
set(gca,'CLim',[-1.5 1.5]);                 
% set(gca,'ColorScale','log');        
c.Label.String    = 'GPa';          title ('S_{13}');         legend; %labelling      	

[xdata, ydata] = ginput(2);        	hold on;
line([xdata(1) xdata(2)],[ydata(1) ydata(2)],'Color','k','LineStyle',...
    '-.','DisplayName','Data line','LineWidth',2);          hold off; 
DirSave = fullfile(Maps.SavingD, 'Lined Data.fig');      saveas(gcf,DirSave);    
DirSave = fullfile(Maps.SavingD, 'Lined Data.png');      saveas(gcf,DirSave);     
close all

%% find location in the data set
xLin       = Maps.X(1,:);               yLin     = Maps.Y(:,1);
[~, index] = min(abs(xLin-xdata(1)));       xdata(1) = xLin(index);
[~, index] = min(abs(xLin-xdata(2)));       xdata(2) = xLin(index);
[~, index] = min(abs(yLin-ydata(1)));       ydata(1) = yLin(index);
[~, index] = min(abs(yLin-ydata(2)));       ydata(2) = yLin(index);

% define y from x
slope = (ydata(2) - ydata(1))/(xdata(2) - xdata(1));
ystep = Maps.stepsize;                      xstep = Maps.stepsize;

%% correct for location to x and y in the origonal map 
if slope==inf
    yplot=ydata(1):ystep:ydata(2);
    for i=1:length(yplot)
        [~, index] = min(abs(yLin-yplot(i)));       yplot(i)   = yLin(index);
        xplot(i)   = xdata(2)-(ydata(2)-yplot(i))/slope;
        LN.X(i)    = xplot(i);    
        [~, index] = min(abs(xLin-xplot(i)));       xplot(i)   = xLin(index);
    end
else
    if xdata(1)>xdata(2);       xplot=xdata(1):-xstep:xdata(2);
    else        xplot=xdata(1):xstep:xdata(2);             end
    LN.X= xplot;
    for i=1:length(xplot)
        [~, index] = min(abs(xLin-xplot(i)));       xplot(i)   = xLin(index);
        if slope==0;    yplot(i) = ydata(2);
        else            yplot(i)   = ydata(2)-(xdata(2)-xplot(i))*slope;   end
        LN.Y(i)    = yplot(i); 
        [~, index] = min(abs(yLin-yplot(i)));       yplot(i)   = yLin(index);
    end
end

%% get data on the line
for i=1:length(yplot)
    [iy(i)]   = ind2sub(size(yLin),find(yLin==yplot(i)));
    [ix(i)]   = ind2sub(size(xLin),find(xLin==xplot(i)));
    LN.Tot(i) = abs((LN.Y(i)+LN.X(i))-(LN.Y(1)+LN.X(1)));
    
    LN.W12(i) = Maps.W12(iy(i),ix(i));   LN.W13(i) = Maps.W13(iy(i),ix(i));
    LN.W21(i) = Maps.W21(iy(i),ix(i));   LN.W23(i) = Maps.W23(iy(i),ix(i));   
    LN.W31(i) = Maps.W31(iy(i),ix(i));   LN.W32(i) = Maps.W32(iy(i),ix(i)); 
    
    LN.S11(i) = Maps.S11(iy(i),ix(i));   LN.S12(i) = Maps.S12(iy(i),ix(i));
    LN.S13(i) = Maps.S13(iy(i),ix(i));   LN.S22(i) = Maps.S22(iy(i),ix(i));
    LN.S23(i) = Maps.S23(iy(i),ix(i));   
    
    LN.GND(i) = Maps.GND(iy(i),ix(i));   
     
    LN.E11(i) = Maps.E11(iy(i),ix(i));   LN.E12(i) = Maps.E12(iy(i),ix(i));
    LN.E13(i) = Maps.E13(iy(i),ix(i));   LN.E22(i) = Maps.E22(iy(i),ix(i));
    LN.E23(i) = Maps.E23(iy(i),ix(i));   LN.E33(i) = Maps.E33(iy(i),ix(i));
end
LN.X        = xplot(:);                  LN.Y      = yplot(:);       
LN.stepsize = Maps.stepsize;             LN.Dir    = Maps.SavingD;
save([Maps.SavingD '\Line_Data.mat'],'LN');
