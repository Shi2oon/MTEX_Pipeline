function SlipTransmission(ebsd,sSGrains,Dir,grains)
% for simplicity restrict phases and fill
phv = ebsd.phase;% phases
% list of orientations along the boundaries
gb  = grains.boundary('indexed','indexed'); 

for i=1:length(ebsd.indexedPhasesId)
%% distribute local slip system at corresponding positions
% and compute mprime
sSS(phv(:)==i,:) = sSGrains{i};
end
% get m'
mp = mPrime(sSS(1:length(sSS)/2),sSS(length(sSS)/2+1:end));

%% ploting
plot(grains); hold on
plot(gb,mp,'linewidth',3); hold off
mtexColorbar('title','Slip Transmission (m^, )')
mtexColorMap white2black
DirSave=fullfile(Dir,[grains.mineralList{grains.indexedPhasesId(i)}...
    ' mP.png']); saveas(gcf,DirSave); close all