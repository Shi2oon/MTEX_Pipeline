function IPFZXY(ebsd,xc,DirGB)
for i=1:length(ebsd.indexedPhasesId) % key
    ipfKey = ipfColorKey(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}));   
    plot(ipfKey,'figSize','small');
    DirSave = fullfile(DirGB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Key_' xc '.png']);               saveas(gcf,DirSave); 	
    DirSave = fullfile(DirGB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Key_' xc '.fig']);               saveas(gcf,DirSave);    close
%         plot(ipfKey,'complete')
% Dir.Save = fullfile(Dir.GB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
%' ' RawOrSmoothed ' Complete Key.png']);   saveas(gcf,Dir.Save); close all
end
%%
for i=1:length(ebsd.indexedPhasesId)
    %create the ipf sector/shape and color it
    oM = ipfHSVKey(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}));
    %define the direction of the ipf
    eval(sprintf('oM.inversePoleFigureDirection = %svector;',xc));
    %convert the ebsd map orientations to a color based on the IPF
    color = oM.orientation2color(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
    hold on;
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),color);
end
hold off; 
[StepSize] = CalcStepSize(ebsd);
title(['Step Size = ' num2str(StepSize) ' \mum']);
set(gcf,'position',[100,50,1200,950]);
mtexColorbar;                                       mtexColorbar;
DirSave = fullfile(DirGB,['EBSD_' xc '.png']);      saveas(gcf,DirSave);

