[xdata, ydata] = ginput(2); hold on;
% line([xdata(1) xdata(2)],[ydata(1) ydata(2)],...
% 'Color','w','LineStyle','--','DisplayName','Data line','LineWidth',3); hold off

% Vertical line segment
lineSec =  [xdata(1)   ydata(1); xdata(2) ydata(2)];%x2=x1 && y2>y1
line(lineSec(:,1),lineSec(:,2),'linewidth',2,'LineStyle','--','Color','w')

%Plot ebsd line segment
ebsd_line = spatialProfile(ebsd,lineSec);

%grains_line = spatialProfile(grains,lineSec); % no grain2d
scatter(ebsd_line.prop.x,ebsd_line.prop.y);     hold off

% change starting/ end points (the line is the same)
lineSec_1=flipud(lineSec);
ebsd_line_1 = spatialProfile(ebsd,lineSec_1);       hold on
scatter(ebsd_line_1.prop.x,ebsd_line_1.prop.y);     hold off

for i=1:length(ebsd_line.indexedPhasesId)
        plot(ebsd_line(ebsd_line.mineralList{ebsd_line.indexedPhasesId(i)}).orientations);
        hold on
end