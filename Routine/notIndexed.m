function notIndexed(ebsd,DirGB)
%% raw EBD
IPFZXY(ebsd,'z',DirGB)

%% not indexed EBSD
plot(ebsd,ebsd.prop.bc)
mtexColorMap white2black
mtexColorbar('Title','band contrast')
% and superpose maybe a phase i.e. the notIndexed phase
hold on  % this keeps the present figure axis
plot(ebsd('notIndexed'),'FaceColor',[1 0.2 0],'FaceAlpha',0.6)
hold off 
DirSave = fullfile(DirGB,'Not indexed.png'); 
saveas(gcf,DirSave); close all
