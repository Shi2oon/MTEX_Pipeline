%% Process
function [grains,ebsd,Dir,MI,CS]=GBs(ebsd,Dir,CS)
clc; warning('off'); close all;
Dir.GB = fullfile(Dir.path,'EBSD Maps');  mkdir(Dir.GB);


%% Raw EBSD
[Dir.StepSize]=notIndexed(ebsd,Dir.GB); %raw output
if sum(CS{1}=='notIndexed')==10 
    [ebsd,CS,grains]=IndexAndFill(ebsd,CS); % fill
end 

%% when doing ferrite in  large map
% plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(2)}),...
%      ebsd(ebsd.mineralList{ebsd.indexedPhasesId(2)}).orientations);
% Dir.Save = fullfile(Dir.GB,' Ferrite GBed.png'); saveas(gcf,Dir.Save); close all

%% Grain boundries
for i=1:length(ebsd.indexedPhasesId)
        plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
            ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
        hold on
end
set(gcf,'position',[500,50,1250,900])
% grain boundray
% [grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',5*degree); 
% ebsd(grains(grains.grainSize<=5)) = [];
% grains=grains('indexed');       grains.boundary=grains.boundary('indexed');
% grains = smooth(grains,5);      
plot(grains.boundary); hold off

title(['Step Size = ' num2str(Dir.StepSize) ' \mum']);
mtexColorbar; mtexColorbar;
Dir.Save = fullfile(Dir.GB,' GBed.png'); saveas(gcf,Dir.Save); close all

hist(grains);   Dir.Save = fullfile(Dir.GB,' GB size.png');
                saveas(gcf,Dir.Save); close all

for i=1:length(ebsd.indexedPhasesId) % key
    ipfKey = ipfColorKey(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}));   
    plot(ipfKey,'figSize','small');
    Dir.Save = fullfile(Dir.GB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Key.png']);   saveas(gcf,Dir.Save); close all
%         plot(ipfKey,'complete')
% Dir.Save = fullfile(Dir.GB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
%' ' RawOrSmoothed ' Complete Key.png']);   saveas(gcf,Dir.Save); close all
end

%% misorienation
[Dir.MisGB,Dir.Misanglede]=EBSDMisorenation(ebsd,grains,Dir.GB);

%% plot a specific grain (max) with bold edges
% SrotedGrainsArea = sort(grains.area);   out = SrotedGrainsArea(end-1); %smal to big
% [id] = ind2sub(size(grains.area),find(grains.area==out));
[~,idx]=max(grains.area); %plot largest grain
idGrain(grains,ebsd,idx,Dir.GB,'biggest',0) %lineSec=[0 0,0 0];
[~,idG]=max(grains.GOS); %plot  largest grain orientation spread
idGrain(grains,ebsd,idG,Dir.GB,'Gradient',0) %lineSec=[0 0,0 0];

for i=1:length(ebsd.indexedPhasesId) % misorentation and area
scatter(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).equivalentRadius*2,...
    grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).GOS./degree,...
    'displayName',ebsd.mineralList{ebsd.indexedPhasesId(i)}); hold on
end
legend; hold off;   xlabel('Equivalent Diameter (\mum)');    ylabel('GOS^{o}')
Dir.Save=fullfile(Dir.GB,'Area to Angle.png'); saveas(gcf,Dir.Save); close all

% plot(grains,grains.aspectRatio);  CLim(gcm,[1 5]);     mtexColorbar
% scatter(grains.shapeFactor, grains.aspectRatio, 70*grains.area./max(grains.area))
plot(grains,grains.area);   hold on
plot(grains.boundary,'linecolor','red','linewidth',1.5);    hold off
mtexColorbar('title','Area (\mum^{2})');
Dir.Save=fullfile(Dir.GB,'Area ratio.png');     saveas(gcf,Dir.Save);   close all

%% KAM calculates the accumulated misorientation within the neighborhood
% of a selected pixel.
kamvalues = KAM(ebsd,'threshold',5*degree);
plot(ebsd,ebsd.KAM./degree);            colormap(jet(256));
mtexColorbar('title','Kernel Average Misorientation (KAM^{o})'); setColorRange([0,2]);
hold on; plot(grains.boundary); hold off
Dir.Save = fullfile(Dir.GB,'Kernel Average Misorientation (KAM).png');
saveas(gcf,Dir.Save); close all

%% plot phases
plot(grains) % phases
Dir.Save = fullfile(Dir.GB,' Phase GB.png');
saveas(gcf,Dir.Save); close all

%% bands and MAD
plot(ebsd,ebsd.mad)
hold on; plot(grains.boundary); hold off
mtexColorbar('title','Mean Angular Deviation (MAD^{o})')
Dir.Save = fullfile(Dir.GB,'Mean Angular Deviation (MAD).png'); 
saveas(gcf,Dir.Save); close all

%histogram(ebsd.mad); hist(ebsd.mad);
histfit(ebsd.mad,40)
pd = fitdist(ebsd.mad,'Normal');
set(gcf,'position',[400,100,900,800]);
title(['Fitting \mu = ' num2str(pd.mu) ' and \Sigma = ' num2str(pd.sigma)]);
xlabel('Mean Angular Deviation (MAD^{o})');     ylabel('Realtive Occurrence');
Dir.Save = fullfile(Dir.GB,'Mean Angular Deviation (MAD) hist.png'); 
saveas(gcf,Dir.Save); close all

plot(ebsd,ebsd.bands)
hold on; plot(grains.boundary); hold off
mtexColorbar('title','Level of Indexing Quality')
Dir.Save = fullfile(Dir.GB,'Level of Indexing Quality.png');
saveas(gcf,Dir.Save); close all

%% Twinning
[MI]=MIslipPlane(CS,ebsd); % slip planes
plot(grains.boundary);    hold on
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
    eval(sprintf('h=MI.h%d;',i));
    
    gB = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)},...
        ebsd.mineralList{ebsd.indexedPhasesId(i)});
%     mori = orientation('map',Miller(1,0,0,CS{i}),Miller(1,1,0,CS{i}),...
%             Miller(1,1,1,CS{i}),Miller(1,-1,1,CS{i})); %Dunno orientation 
%     round(mori.axis);   RotationalAngle(count)=mori.angle/degree;
%     fprintf('Rotation angle of %.2f for %s\n',RotationalAngle(count),...
%       ebsd.mineralList{ebsd.indexedPhasesId(i)});
%     isTwinning = angle(gB.misorientation,mori) < 5*degree; 
    [xi,~]=size(gB);
    if xi~=0
    AngleTwin=max(gB.misorientation.angle./degree)*0.75;
    isTwinning = angle(gB.misorientation)>AngleTwin*degree;
    twinBoundary = gB(isTwinning);
    
    plot(twinBoundary,'linecolor','w','linewidth',2)
    
    twinId = unique(gB(isTwinning).grainId);
    TwinedArea(i)= sum(area(grains(twinId)))/sum(area(grains))*100;
    else
        TwinedArea(i)=0;
        twinBoundary=0;
    end
end

if xi~=0
plot(twinBoundary,'linecolor','w','linewidth',2,'displayName','twin boundary')
hold off;   Dir.Save = fullfile(Dir.GB,'Twins.png');    saveas(gcf,Dir.Save); 
end
close all
Dir.TwinedArea=100-sum(TwinedArea);
Dir.TwinedArea=round(Dir.TwinedArea,3);
