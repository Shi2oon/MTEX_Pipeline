function [slope,GrainEluer,CS_Trace,TraceEuler] = simplePlot(ebsd,CS)
close all
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',5*degree); 
grains = grains('indexed');       grains.boundary = grains.boundary('indexed');
grains = smooth(grains,5);  

for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).mis2mean.angle./degree); 
    hold on
end
colormap(jet(256));         plot(grains.boundary);
fprintf('What do you want to trace, a slip band (S) or a twin (T)?:   ');
select = input('','s');
    
title('Draw a Box on the Parent Grain');    mtexColorbar; mtexColorbar;
[xdata, ydata] = ginput(1);                 hold on;
plot(xdata,ydata,'pr','MarkerFaceColor','w')
ebsd_grain = ebsd(grains(xdata,xdata));
GrainEluer = mean(ebsd_grain.orientations);
[CS_Trace] = findCS(CS,ebsd_line); 

if select == 'T' || select == 't'
title('Draw a Box on the Twin');    mtexColorbar; mtexColorbar;
[xdata, ydata] = ginput(1);         hold on;
plot(xdata,ydata,'or','MarkerFaceColor','w')
ebsd_twin = ebsd(grains(xdata,xdata));
TraceEuler = mean(ebsd_twin.orientations);

elseif select == 'S'|| select == 's'
title('Draw a Line on the Trace (mentain inclinity!)');    mtexColorbar; mtexColorbar;
[xdata, ydata] = ginput(2); hold on;
lineSec =  [xdata(1)   ydata(1); xdata(2) ydata(2)];%x2=x1 && y2>y1
line(lineSec(:,1),lineSec(:,2),'linewidth',2,'LineStyle','--','Color','w')
ebsd_Trace = spatialProfile(ebsd,lineSec);   %Plot ebsd line segment
TraceEuler = mean(ebsd_Trace.orientations);
slope = (ydata(2) - ydata(1))/ (xdata(2) - xdata(1)); % next pin a point on the tiff image
end