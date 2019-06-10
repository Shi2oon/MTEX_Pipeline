function [xLin,yLin,zlin]=notImage(h)
h=imread(h);

if strlength(class(h))==16 %matlab.ui.Figure
[xLin,yLin,zlin]=fig2image;

elseif strlength(class(h))==5 %uint8
    xLin=h.XData;           yLin=h.YData;           zlin=h.CData;

elseif strlength(class(h))==31 %matlab.graphics.primitive.Image
    xLin=h.XData;           yLin=h.YData;           zlin=h.CData;
    
else
    fprintf('Only already opened images (use gcf to get h) or images address') 
end