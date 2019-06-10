function [lineData,lengthslope]=LineMisorentation(ebsd,dir)
%% plot
close all
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',2.5*degree); 
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations); hold on
    gB = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ,ebsd.mineralList{ebsd.indexedPhasesId(i)});
    [xi,~]=size(gB);
    if xi~=0
    plot(gB,gB.misorientation.angle./degree,'linewidth',1); 
    end
end
set(gcf,'position',[500,100,950,700]); hold off; colormap(jet(256));

%% grap
[xdata, ydata] = ginput(2); hold on;
% Vertical line segment
lineSec =  [xdata(1)   ydata(1); xdata(2) ydata(2)];%x2=x1 && y2>y1
line(lineSec(:,1),lineSec(:,2),'linewidth',2,'LineStyle','--','Color','w'); hold off
Dir.Save = fullfile(dir,'lineddata.png'); saveas(gcf,Dir.Save); close all
 
%% find location in the data set
ebsd_line = spatialProfile(ebsd,lineSec);       % line esbd data
xplot=ebsd_line.prop.x;     yplot=ebsd_line.prop.y;
lineData=ebsd_line.rotations.angle./degree;

for i=1:length(xplot)
    lengthslope(i)=sqrt(abs(yplot(i)-yplot(1))^2+abs(xplot(i)-xplot(1))^2);
end

%% get data on the line
figure; plot(lengthslope,lineData); xlim([0 max(lengthslope)]);
xlabel('Distance along profile (\mum)'); ylabel('Realtive Misorientation^{o}');
title('Misorientaion Profile alone the line');