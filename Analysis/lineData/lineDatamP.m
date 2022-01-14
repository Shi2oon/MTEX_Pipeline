function lineDatamP(Dir)
close all;              gb   = Dir.mPgb;        mP   = Dir.mP;    
xstep=Dir.StepSize;     xLin = gb.x;            yLin = gb.y;
z=plot(gb,mP,'linewidth',2);            colormap(jet(256));
CX=z.XData;             % CX = unique(CX,'first');
CY=z.YData;             % CY = unique(CY,'first');
CZ=z.CData;

[xdata, ydata] = ginput(2); hold on;
line([xdata(1) xdata(2)],[ydata(1) ydata(2)],...
'Color','k','LineStyle','--','DisplayName','Data line','LineWidth',1); hold off
%Dir.Save = fullfile(dir,'lineddata.png'); saveas(gcf,Dir.Save); close all

%% find location in the data set
[~, index1] = min(abs(xLin-xdata(1)));  xdata(1)=xLin(index1);
[~, index2] = min(abs(xLin-xdata(2)));  xdata(2)=xLin(index2);
[~, indey1] = min(abs(yLin-ydata(1)));  ydata(1)=yLin(indey1);
[~, indey2] = min(abs(yLin-ydata(2)));  ydata(2)=yLin(indey2);

slope = (ydata(2) - ydata(1))/ (xdata(2) - xdata(1));
%figure; plot(gb,mP,'linewidth',2);  hold on;
if slope~=inf
   if       xdata(1)>xdata(2)                  
            xplot=xdata(1):-xstep:xdata(2);
   else
            xplot=xdata(1):xstep:xdata(2);     
   end
   
    for i=1:length(xplot)
        [~, index(i)] = min(abs(xLin-xplot(i)));   
        xplot(i) = xLin(index(i));
        yplot(i) = ydata(2)-(xdata(2)-xplot(i))*slope;
        [~, indey(i)] = min(abs(yLin-yplot(i)));   
        yplot(i) = yLin(indey(i));
        lengthslope(i) = sqrt(abs(yplot(i)-yplot(1))^2+abs(xplot(i)-xplot(1))^2);
        %plot(xplot(i),yplot(i),'r*') 
    end
%     index = [index(:);indey(:)];                 index = unique(index,'first'); 
%     xplot = unique(xplot,'first');               yplot = unique(yplot,'first'); 
%     lengthslope  = unique(lengthslope,'first');  indey = unique(indey,'first'); 
%     lengthy=max([length(yplot), length(xplot)]);
else
    fprintf('Do not plot a 90 degrees line \n');
end

%% get data on the line
for i=1:length(yplot)
    [indexy] = ind2sub(size(yLin),find(yLin==yplot(i)));
    [indexx] = ind2sub(size(xLin),find(xLin==xplot(i)));
    min(abs(indexy-indexx)); % closest
    lineData(i) = mP(indey(i));
end

%% find location in the data set
figure; plot(yplot,lineData); xlim([0 max(lengthslope)]);

plot(CX,CY)