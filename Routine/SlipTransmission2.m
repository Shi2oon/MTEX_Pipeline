function [mp,gb,ebsdgb]=SlipTransmission2(ebsd,sS,Dir)
[grains, ebsd.grainId] = ebsd.calcGrains;
ebsd(grains(grains.grainSize < 50)) =[];
ebsdgb = fill(ebsd);        [grains, ebsdgb.grainId] = ebsdgb.calcGrains;

gb  = grains.boundary('indexed','indexed'); %list of orientations along the boundaries
id  = gb.ebsdId;            ebsdgb = ebsdgb(id);  %ebsd
phv = ebsdgb.phase;     % phases
sigma = stressTensor.uniaxial(vector3d.Z); % or use xvector

for i=1:length(ebsdgb.indexedPhasesId)
    % compute Schmid factor for all slip systems
    sFf{i} = sS{i}.SchmidFactor(inv(ebsdgb(ebsdgb.mineralList...
            {ebsdgb.indexedPhasesId(i)}).orientations) * sigma);
    [sFf{i},idf] = max(sFf{i},[],2);    % find the maximum Schmidt factor
    % rotate active slip system into specimen coordinates
    sS{i} = ebsdgb(ebsdgb.mineralList...
            {ebsdgb.indexedPhasesId(i)}).orientations .* sS{i}(idf);

    if length(ebsdgb.indexedPhasesId)~=1   
        sSphve(phv(:)==i,:) = sS{i};% and compute mprime
    else
        sSphve=sS{i};
    end
end

mp = mPrime(sSphve(1:length(sSphve)/2),sSphve(length(sSphve)/2+1:end)); % get m'

%% plot something
for i=1:length(ebsd.indexedPhasesId)
        plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
            ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
        hold on
end
plot(gb,mp,'linewidth',3);      hold off;   colormap(jet(256));
set(gcf,'position',[500,100,950,700]);  DirSave=fullfile(Dir,'mP.fig'); 
setColorRange([0,1]);                   saveas(gcf,DirSave);                
mtexColorbar('title','Slip Transmission (m^, )');     
DirSave=fullfile(Dir,'mP.png');             saveas(gcf,DirSave);  close all
