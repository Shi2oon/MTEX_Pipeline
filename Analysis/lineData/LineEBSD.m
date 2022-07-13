function [lineData,lengthslope,ebsd_line]=LineEBSD(ebsd,dir)
%% plot
close all
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',5*degree); 
ebsd(grains(grains.grainSize<=20))   = []; 
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',5*degree);
%                     grains          = grains('indexed');       
%                     grains.boundary = grains.boundary('indexed');
%                     grains          = smooth(grains,5);
hold on;    plot(grains.boundary);     hold off

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
line(lineSec(:,1),lineSec(:,2),'linewidth',2,'LineStyle',':','Color','k'); hold off
saveas(gcf,[dir '.png']); close 
 
%% find location in the data set
ebsd_line = spatialProfile(ebsd,lineSec);       % line esbd data
xplot=ebsd_line.prop.x;     yplot=ebsd_line.prop.y;
lineData=ebsd_line.rotations.angle./degree;

lengthslope=sqrt((ebsd_line{2}.prop.x-min(ebsd_line{2}.prop.x)).^2 ...
    + (ebsd_line{2}.prop.y-min(ebsd_line{2}.prop.y)).^2);

save([dir '.mat'],'lineData','lengthslope','ebsd_line')