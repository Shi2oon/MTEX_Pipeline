% fro plotting a sepcific grain
function idGrain(grains,ebsd,id,Dir,named,lineSec)
% F = meanFilter;                 % define the meanFilter
% ebsd = smooth(ebsd,F);          % smooth the data
ebsd_id=ebsd(grains(id));

if isempty(ebsd_id.indexedPhasesId)==0
ipfKey=ipfColorKey(ebsd(ebsd_id.mineral));
color=ipfKey.orientation2color(ebsd_id.orientations);

plot(ebsd_id, color); hold on
plot(grains(id).boundary,'linewidth',2); hold off
Dir = fullfile(Dir,[named '.tif']);
box off;axis off
saveas(gcf,Dir); 

if lineSec~=0
plot(grains(id).boundary,'linewidth',2); hold on
plot(ebsd_id,ebsd_id.orientations)
line(lineSec(:,1),lineSec(:,2),'linewidth',2)
ebsd_line = spatialProfile(ebsd_id,lineSec);

close all % close previous plots
% misorientation angle to the first orientation on the line
plot(ebsd_line.y,...
  angle(ebsd_line(1).orientations,ebsd_line.orientations)/degree)

% misorientation gradient
hold all
plot(0.5*(ebsd_line.y(1:end-1)+ebsd_line.y(2:end)),...
angle(ebsd_line(1:end-1).orientations,ebsd_line(2:end).orientations)/degree)
hold off
xlabel('y');            ylabel('misorientation angle in degree')
legend('to reference orientation','orientation gradient')
Dir = fullfile(Dir,[named 'gradient.png']);
saveas(gcf,Dir); close all
end
end