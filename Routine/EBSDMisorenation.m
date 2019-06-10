% funciton to caclualte graidnet and misoreination angle
function [MisGB,Misanglede]=EBSDMisorenation(ebsd,grains,DirGB)
%% GRADIENT
if length(grains)~=1
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).mis2mean.angle./degree); 
    hold on
end
set(gcf,'position',[500,100,950,700]);  hold off; colormap(jet(256));
mtexColorbar('title','Misorientation Angle^{o}')
Dir.Save = fullfile(DirGB,'Gradient.png'); saveas(gcf,Dir.Save); close all

%% angle
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations); hold on
    for ii=1:length(ebsd.indexedPhasesId)
        gB = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ,ebsd.mineralList{ebsd.indexedPhasesId(ii)});
        [xi,~]=size(gB);
        if xi~=0
            plot(gB,gB.misorientation.angle./degree,'linewidth',2); 
            MisGB{i,ii}=gB;    Misanglede{i,ii}=gB.misorientation.angle./degree;
        end
    end
end
hold off; colormap(jet(256));
mtexColorbar('title','Misorientation Angle^{o}')
Dir.Save=fullfile(DirGB,'GB misorientation.png'); saveas(gcf,Dir.Save); close all

%% angle in hist
for i=1:length(ebsd.indexedPhasesId)
    for j=1:length(ebsd.indexedPhasesId)
    gB = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ,ebsd.mineralList{ebsd.indexedPhasesId(j)});
    [xi,~]=size(gB);
    if xi~=0
        plotAngleDistribution(gB.misorientation);hold on
    end
    end
end
set(gcf,'position',[400,100,1400,750]); hold off; legend('location','northeast');
Dir.Save = fullfile(DirGB,'GB misorientation Hist.png'); saveas(gcf,Dir.Save); close all

else
    fprintf('there is no boundray to having a misorenation through FROM THE BEGINNING!\n');
    MisGB=0;               Misanglede=0;              
end