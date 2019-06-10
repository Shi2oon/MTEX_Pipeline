function [StepSize]=notIndexed(ebsd,DirGB)
%% raw EBD
for i=1:length(ebsd.indexedPhasesId)
        plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
            ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
        hold on
end
set(gcf,'position',[500,100,950,700]); hold off; [StepSize]=CalcStepSize(ebsd);
title(['Step Size = ' num2str(StepSize) ' \mum']); 
mtexColorbar; mtexColorbar;
Dir.Save = fullfile(DirGB,' raw EBSD.png');  saveas(gcf,Dir.Save); close all

%% not indexed EBSD
plot(ebsd,ebsd.prop.bc)
mtexColorMap white2black
mtexColorbar('Title','band contrast')
% and superpose maybe a phase i.e. the notIndexed phase
hold on  % this keeps the present figure axis
plot(ebsd('notIndexed'),'FaceColor',[1 0.2 0],'FaceAlpha',0.6)
hold off 
Dir.Save = fullfile(DirGB,'Not indexed.png'); saveas(gcf,Dir.Save); close all
