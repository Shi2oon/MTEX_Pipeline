[~,id] = max(grains.GOS)
grain_selected = grains(id)
figure
plot(grain_selected.boundary,'linewidth',2)
hold on, plot(ebsd(grain_selected),ebsd(grain_selected).orientations)
 
% Vertical line segment
lineSec =  [18826   6438; 18826 10599];%x2=x1 && y2>y1
line(lineSec(:,1),lineSec(:,2),'linewidth',2)

%Plot ebsd line segment
ebsd_line = spatialProfile(ebsd,lineSec);
hold on
scatter(ebsd_line.prop.x,ebsd_line.prop.y)
hold off

% change starting/ end points (the line is the same)
lineSec_1=flipud(lineSec);
ebsd_line_1 = spatialProfile(ebsd,lineSec_1);
hold on
scatter(ebsd_line_1.prop.x,ebsd_line_1.prop.y)
hold off
