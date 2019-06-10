% fuction to get the infromtion a long a line in an image, the function
% takes the address of the image or the image if it's opened in the current
% view (use gcf for that)
function [lineData,yplot,xplot]=LineImageData(address)
zx=gca; 
if zx.XLim(1)==0 && zx.XLim(2)==1
    close all; [xLin,yLin,zlin]=notImage(address);
else
    if strlength(class(address))==16 %matlab.ui.Figure
        if ~isempty(findobj(address,'Type','Image'))
            h=findobj(address,'Type','Image'); %close all; 
            [xLin,yLin,zlin]=fig2image(h);
        else
            h=address.Children;
        end
        
    elseif strlength(class(address))==5 %uint8
        h=imagesc(address);
        xLin=h.XData;           yLin=h.YData;           zlin=h.CData;

    elseif strlength(class(address))==31 %matlab.graphics.primitive.Image
        h=address.Children;
        xLin=h.XData;           yLin=h.YData;           zlin=h.CData; 
    end    
end

input('\nZoom in and out to get the location, then press enter when you are done\n');
shg
[xdata, ydata] = ginput(2); hold on;
line([xdata(1) xdata(2)],[ydata(1) ydata(2)],...
'Color','k','LineStyle','--','DisplayName','Data line','LineWidth',3); hold off
 
% find location in the data set
[~, index] = min(abs(xLin-xdata(1)));  xdata(1)=xLin(index);
[~, index] = min(abs(xLin-xdata(2)));  xdata(2)=xLin(index);
[~, index] = min(abs(yLin-ydata(1)));  ydata(1)=yLin(index);
[~, index] = min(abs(yLin-ydata(2)));  ydata(2)=yLin(index);

% define y from x
slope = (ydata(2) - ydata(1))/ (xdata(2) - xdata(1));

if slope==inf
    if ydata(1)>ydata(2); ystep=yLin(1)-yLin(2);
    else; ystep=yLin(2)-yLin(1); end
    
% correct for location to x and y in the origonal map      
    yplot=ydata(1):ystep:ydata(2);
    for i=1:length(yplot)
        [~, index] = min(abs(yLin-yplot(i)));  yplot(i)=yLin(index);
        xplot(i)=xdata(2)-(ydata(2)-yplot(i))/slope;
        [~, index] = min(abs(xLin-xplot(i)));
        xplot(i)=xLin(index);
    end

else
    if xdata(1)>xdata(2); xstep=xLin(1)-xLin(2);
    else; xstep=xLin(2)-xLin(1); end
    
% correct for location of x and y in the origonal map    
    xplot=xdata(1):xstep:xdata(2);
    for i=1:length(xplot)
        [~, index] = min(abs(xLin-xplot(i)));  xplot(i)=xLin(index);
        yplot(i)=ydata(2)-(xdata(2)-xplot(i))*slope;
        [~, index] = min(abs(yLin-yplot(i)));
        yplot(i)=yLin(index);
    end
end

%% get data on the line
for i=1:length(yplot)
    [indexy(i)] = ind2sub(size(yLin),find(yLin==yplot(i)));
    [indexx(i)] = ind2sub(size(xLin),find(xLin==xplot(i)));
    lineData(i) = zlin(indexy(i),indexx(i));
end