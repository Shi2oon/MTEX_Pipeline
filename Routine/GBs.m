%% Process
function [ebsd,CS,grains,MisGB,Misanglede,TwinedArea]=GBs(ebsd,Dirpath,CS)
clc; warning('off'); close;
DirGB = fullfile(Dirpath, 'EBSD Maps');       mkdir(DirGB);

%% when doing ferrite in  large map
% plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(2)}),...
%      ebsd(ebsd.mineralList{ebsd.indexedPhasesId(2)}).orientations);
% Dir.Save = fullfile(Dir.GB,' Ferrite GBed.tif'); 
% saveas(gcf,Dir.Save);                                         close

%% Grain boundries
 	close    
IPFZXY(ebsd,'x',DirGB); 	close
IPFZXY(ebsd,'y',DirGB);     close
IPFZXY(ebsd,'z',DirGB);
%% grain boundray
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',3*degree);
ebsd(grains(grains.grainSize<=20))   = []; % grains = smooth(grains,20);

%                     grains          = grains('indexed');       
%                     grains.boundary = grains.boundary('indexed');
%                     grains          = smooth(grains,5);
hold on;    plot(grains.boundary);     hold off
DirSave = fullfile(DirGB,'GBed.tif'); saveas(gcf,DirSave);  close
plot(grains.boundary);                       
text(grains,num2str(grains.id));        
DirSave = fullfile(DirGB,'GB and no.tif'); saveas(gcf,DirSave);  close

hist(grains);   
DirSave = fullfile(DirGB,'GB size.tif');       saveas(gcf,DirSave);
DirSave = fullfile(DirGB,'GB size.fig');       saveas(gcf,DirSave);    close
%{
for i=1:length(ebsd.indexedPhasesId) % key
    ipfKey = ipfColorKey(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}));   
    plot(ipfKey,'figSize','small');
    DirSave = fullfile(DirGB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Key.tif']);               saveas(gcf,DirSave); 	
    DirSave = fullfile(DirGB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Key.fig']);               saveas(gcf,DirSave);    close
%         plot(ipfKey,'complete')
% Dir.Save = fullfile(Dir.GB,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
%' ' RawOrSmoothed ' Complete Key.tif']);   saveas(gcf,Dir.Save); close
end
%}
%% misorienation
[MisGB,Misanglede] = EBSDMisorenation(ebsd,grains,DirGB);

%% plot a specific grain (max) with bold edges
% SrotedGrainsArea = sort(grains.area);   out = SrotedGrainsArea(end-1); %smal to big
% [id] = ind2sub(size(grains.area),find(grains.area==out));
[~,idx]=max(grains.area);                       % plot largest grain
idGrain(grains,ebsd,idx,DirGB,'biggest',0);close     % lineSec=[0 0,0 0];
[~,idG]=max(grains.GOS);                        % plot  largest grain orientation spread
idGrain(grains,ebsd,idG,DirGB,'Gradient',0);close    % lineSec=[0 0,0 0];

%% The average of the misorientation angles to the grain mean orientation is called grain orientation spread (GOS)
for i=1:length(ebsd.indexedPhasesId) % misorentation and area
    scatter(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).equivalentRadius*2,...
            grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).GOS./degree,...
            'displayName',ebsd.mineralList{ebsd.indexedPhasesId(i)}); hold on
end
legend;     hold off;   xlabel('Equivalent Diameter (\mum)');	ylabel('GOS^{o}')
DirSave = fullfile(DirGB,'Area to Angle.tif');    
saveas(gcf,DirSave);                                           close

% plot(grains,grains.aspectRatio);  CLim(gcm,[1 5]);     mtexColorbar
% scatter(grains.shapeFactor, grains.aspectRatio, 70*grains.area./max(grains.area))
plot(grains,grains.area);                                       hold on
plot(grains.boundary,'linecolor','red','linewidth',1.5);        hold off
mtexColorbar('title','Area (\mum^{2})','fontsize',20);
DirSave = fullfile(DirGB,'Area ratio.tif');     
saveas(gcf,DirSave);                                           close

%% KAM calculates the accumulated misorientation within the neighborhood
% of a selected pixel.
% kamvalues = KAM;
for iO=1:10
plot(ebsd,ebsd.KAM(ebsd,'threshold',2*degree,'order',iO)./degree);                                    colormap(jet(256));
mtexColorbar('title','Kernel Average Misorientation (KAM^{o})','fontsize',20); 
setColorRange([0,2.5]);                                           hold on; 
plot(grains.boundary);                                          hold off
title(['Window size = ' num2str(iO)]);
set(gcf,'position',[100,50,1382, 972]);
DirSave = fullfile(DirGB,['Kernel Average Misorientation (KAM)_' num2str(iO) '.tif']);
saveas(gcf,DirSave);                                           close
end

%% plot phases
plot(grains) % phases
DirSave = fullfile(DirGB,'Phase GB.tif');
saveas(gcf,DirSave);                                           close

%% bands and MAD
plot(ebsd,ebsd.mad);                                            hold on; 
plot(grains.boundary);                                          hold off
colormap gray

% caxis([0 max(ebsd.mad)])
mtexColorbar('title','Mean Angular Deviation (MAD^{o})','fontsize',20)
DirSave = fullfile(DirGB,'Mean Angular Deviation (MAD).tif'); 
saveas(gcf,DirSave);                                           close
%{
%histogram(ebsd.mad); hist(ebsd.mad);
histfit(ebsd.mad,40)
pd = fitdist(ebsd.mad,'Normal');
%set(gcf,'position',[400,100,900,800]);
title(['Fitting \mu = ' num2str(pd.mu) ' and \Sigma = ' num2str(pd.sigma)]);
xlabel('Mean Angular Deviation (MAD^{o})');     ylabel('Realtive Occurrence');
DirSave = fullfile(DirGB,'Mean Angular Deviation (MAD) hist.tif'); 
saveas(gcf,DirSave);                                           close
%}
plot(ebsd,ebsd.bands);                                          hold on;
plot(grains.boundary);                                          hold off
colormap gray
% caxis([0 max(ebsd.bands)])
mtexColorbar('title','Level of Indexing Quality','fontsize',20)
DirSave = fullfile(DirGB,'Level of Indexing Quality.tif');
saveas(gcf,DirSave);                                           close

plot(ebsd,ebsd.bc);                                          hold on;
plot(grains.boundary);                                          hold off
colormap gray
% caxis([0 max(ebsd.bc)])
mtexColorbar('title','BC','fontsize',20)
DirSave = fullfile(DirGB,'BC.tif');
saveas(gcf,DirSave);                                           close

plot(ebsd,ebsd.bs);                                          hold on;
plot(grains.boundary);                                          hold off
colormap gray
caxis([0 max(ebsd.bs)])
mtexColorbar('title','BS','fontsize',20)
DirSave = fullfile(DirGB,'BS.tif');
saveas(gcf,DirSave);                                           close

%% Twinning
plot(grains.boundary);          hold on
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
    
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
        AngleTwin     = max(gB.misorientation.angle./degree)*0.75;
        isTwinning    = angle(gB.misorientation)>AngleTwin*degree;
        twinBoundary  = gB(isTwinning);
        plot(twinBoundary,'linecolor','w','linewidth',2)
        twinId        = unique(gB(isTwinning).grainId);
        TwinedArea(i) = sum(area(grains(twinId)))/sum(area(grains))*100;
    else
        TwinedArea(i) = 0;
        twinBoundary  = 0;
    end
end

if xi~=0
    plot(twinBoundary,'linecolor','w','linewidth',2,'displayName','twin boundary')
    hold off;   DirSave = fullfile(DirGB,'Twins.tif');    saveas(gcf,DirSave); 
end
close
TwinedArea=round(100-sum(TwinedArea),3);

%% compute the grain reference orientation deviation
grod = ebsd.calcGROD(grains);
% plot the misorientation angle of the GROD
plot(ebsd,grod.angle./degree,'micronbar','off')
mtexColorbar('title','misorientation angle to meanorientation in degree')
mtexColorMap LaboTeX

% overlay grain and subgrain boundaries
hold on
plot(grains.boundary,'lineWidth',1)
for i=1:length(ebsd.indexedPhasesId) % key
plot(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).innerBoundary,...
    'edgeAlpha',grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).innerBoundary.misorientation.angle/(5*degree))
end
hold off
DirSave = fullfile(DirGB,'GROD.tif'); saveas(gcf,DirSave);   close

%%
axCrystal = grod.axis;
plot(axCrystal,'contourf','fundamentalRegion','antipodal','figSize','small')
mtexColorbar('title','distribution of misorientation axes in mrd')
DirSave = fullfile(DirGB,'GROD_IPF.tif'); saveas(gcf,DirSave);   close

%% Grain Orientation Spread (GOS)
GOS = grainMean(ebsd, grod.angle);
plot(grains, GOS ./ degree)
mtexColorbar('title','GOS in degree')
DirSave = fullfile(DirGB,'GOS.tif'); saveas(gcf,DirSave);   close

%% compute the color from the misorientation axis
% The misorientation axis in crystal coordinates can be related to active 
% slipsystems. See: V. Tong, E. Wielewski, B. Britton
axCrystal = grod.axis;hold on;
for i=1:length(ebsd.indexedPhasesId) % key
    colorKey = HSVDirectionKey(ebsd.CSList{ebsd.indexedPhasesId(i)},'antipodal');
    color = colorKey.direction2color(axCrystal);
    alpha = min(grod.angle/degree/7.5,1);
    plot(ebsd,color,...
        'micronbar','on','faceAlpha',alpha,'figSize','large')
end
hold on;plot(grains.boundary,'lineWidth',2);
for i=1:length(ebsd.indexedPhasesId) % key
plot(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).innerBoundary,...
    'edgeAlpha',grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).innerBoundary.misorientation.angle/(5*degree))
end
hold off
DirSave = fullfile(DirGB,'GOS_2.tif'); saveas(gcf,DirSave);   close

