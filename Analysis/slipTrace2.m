[slope,GrainEluer,CS_Trace,TraceEuler] = simplePlot(ebsd);
[~,sS]  = decideDS(CS_Trace,0.3); 
t = trace(sS);
plot(t)
 

A       = imread([erase(fname, '.ctf'),'.png']);        imshow(A)
title('Draw a Line on the Trace (mentain inclinity!)');
[xdata, ydata] = ginput(2); hold on;
ydata(2)       = ydata(1)+(slope*(xdata(2) - xdata(1)));

line([xdata(1) xdata(2)],[ydata(1) ydata(2)],...
'Color','r','LineStyle','--','DisplayName','Data line','LineWidth',2); hold off

% next pin a point on the tiff image
% B = imread(DirSave);
% C = imfuse(A,B,'blend','Scaling','joint');          imshow(C)
