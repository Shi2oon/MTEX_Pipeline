function [mp,gb]=SlipTransmission2(ebsd,sS,Dir)
[ebsd] = fill(ebsd);      
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',2*degree);
ebsd(grains(grains.grainSize<=50))   = []; 
                    grains          = grains('indexed');       
                    grains.boundary = grains.boundary('indexed');
                    grains          = smooth(grains,5);
gb  = grains.boundary('indexed','indexed'); %list of orientations along the boundaries
if ~isempty(gb)
id  = gb.ebsdId;            ebsdgb = ebsd(id);  %ebsd
phv = ebsdgb.phase;     % phases
sigma = stressTensor.uniaxial(xvector); % or use xvector


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

if phv>1
if mod(length(sSphve),2)==1
   mp = mPrime(sSphve(1:round(length(sSphve)/2)),sSphve(round(length(sSphve)/2):end)); % get m' 
else
    mp = mPrime(sSphve(1:round(length(sSphve)/2)),sSphve(round(length(sSphve)/2)+1:end)); % get m' 
end

else
    id = gb.grainId;
    mp = mPrime(sSphve(id(:,1)),sSphve(id(:,2)));
end
% plot something
plot(grains);                   hold on
plot(gb,mp,'linewidth',3);      hold off
colormap(jet(256));

%set(gcf,'position',[500,100,950,700]);  
setColorRange([0,1]);                          
mtexColorbar('title','Slip Transmission (m^, )','fontsize',20);
DirSave=fullfile(Dir,'mP.fig');             saveas(gcf,DirSave);       
DirSave=fullfile(Dir,'mP.png');             saveas(gcf,DirSave);  close all

if exist('Dir','var')
%% plot something
for i=1:length(ebsd.indexedPhasesId)
        plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
            ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
        hold on
end
plot(gb,mp,'linewidth',3);      hold off;   colormap(jet(256));
%set(gcf,'position',[500,100,950,700]);  
setColorRange([0,1]);                          
mtexColorbar('title','Slip Transmission (m^, )','fontsize',20);
DirSave=fullfile(Dir,'mP.fig');             saveas(gcf,DirSave);       
DirSave=fullfile(Dir,'mP.png');             saveas(gcf,DirSave);  close all

%%
Spc = 20;
scatter(gb.midPoint(:,1),gb.midPoint(:,2),[],mp,'.'); 
a = mp(1:Spc:end); b = num2str(a); c = cellstr(b);
if ~isempty(c)
    X = gb.midPoint(:,1);       x = X(1:Spc:end); 
    Y = gb.midPoint(:,2);       y = Y(1:Spc:end); 
    dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
    text(x+dx, y+dy, c);
end
    set(gcf,'position',[200,50,1700,920]); axis tight; axis image
DirSave=fullfile(Dir,'mP_2.fig');             saveas(gcf,DirSave);       
DirSave=fullfile(Dir,'mP_2.png');             saveas(gcf,DirSave);  close all
end
else
    fprintf ('There is one grain!!!');
    mp = [];    gb = [];    ebsd = [];
end
