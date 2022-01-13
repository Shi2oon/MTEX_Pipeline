% funciton to caclualte graidnet and misoreination angle
function [MisGB,Misanglede]=EBSDMisorenation(ebsd,grains,DirGB)
%% GRADIENT
if length(grains)~=1
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).mis2mean.angle./degree); 
    hold on
end
hold off; colormap(jet(256));
mtexColorbar('title','Misorientation Angle^{o}')
set(gcf,'position',[100,50,1200,950]);
Dir.Save = fullfile(DirGB,'Gradient.png'); saveas(gcf,Dir.Save); 
Dir.Save = fullfile(DirGB,'Gradient.fig'); saveas(gcf,Dir.Save);    close all

%% angle
for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations); hold on
    for ii=1:length(ebsd.indexedPhasesId)
        if ii >= i
            try
                plot(grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                    ,ebsd.mineralList{ebsd.indexedPhasesId(ii)}),...
                    grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                    ,ebsd.mineralList{ebsd.indexedPhasesId(ii)}).misorientation.angle./degree,'linewidth',3); 
                MisGB{i,ii} = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                                ,ebsd.mineralList{ebsd.indexedPhasesId(ii)});    
                Misanglede{i,ii} = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                                    ,ebsd.mineralList{ebsd.indexedPhasesId(ii)}).misorientation.angle./degree;
            catch
                MisGB{i,ii} = 0;     Misanglede{i,ii} = 0;
            end
        end
    end
end
hold off; colormap(jet(256));
mtexColorbar('title','Misorientation Angle^{o}','fontsize',20)
set(gcf,'position',[100,50,1200,950]);
Dir.Save=fullfile(DirGB,'GB misorientation.png'); saveas(gcf,Dir.Save); close all

%% angle
Spc = round(length(ebsd)*1e-4,0);
for i=1:length(ebsd.indexedPhasesId)
    for ii=1:length(ebsd.indexedPhasesId)
        if ii >= i
            try
                mp = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)},...
                                 ebsd.mineralList{ebsd.indexedPhasesId(ii)})...
                                 .misorientation.angle./degree;
                scatter(grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)},...
                       ebsd.mineralList{ebsd.indexedPhasesId(ii)}).midPoint(:,1),...
                        grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)},...
                       ebsd.mineralList{ebsd.indexedPhasesId(ii)}).midPoint(:,2),[],mp,'.');hold on
                a = mp(1:Spc:end); b = num2str(a); c = cellstr(b);
                if ~isempty(c)
                X = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)},...
                                 ebsd.mineralList{ebsd.indexedPhasesId(ii)}).midPoint(:,1);       
                             x = X(1:Spc:end); 
                Y = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)},...
                                 ebsd.mineralList{ebsd.indexedPhasesId(ii)}).midPoint(:,2);       
                             y = Y(1:Spc:end); 
                dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
                text(x+dx, y+dy, c);
                end
            end
        end
    end
end
hold off; colormap(jet(256));axis image
title('Misorientation Angle^{o}','fontsize',20)
set(gcf,'position',[100,50,1200,950]);
Dir.Save=fullfile(DirGB,'GB misorientation2.png'); saveas(gcf,Dir.Save); 
Dir.Save=fullfile(DirGB,'GB misorientation2.fig'); saveas(gcf,Dir.Save); close all

%% angle in hist
for i=1:length(ebsd.indexedPhasesId)
    for ii=1:length(ebsd.indexedPhasesId)
        if ii >= i
            gB = grains.boundary(ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                ,ebsd.mineralList{ebsd.indexedPhasesId(ii)});
            [xi,~]=size(gB);
            if xi~=0
                plotAngleDistribution(gB.misorientation);hold on
            end
        end
    end
end
%set(gcf,'position',[400,100,1400,750]); 
hold off; legend('location','northwest');
set(gcf,'position',[100,50,600,550]);
Dir.Save = fullfile(DirGB,'GB misorientation Hist.png'); saveas(gcf,Dir.Save); close all

else
    fprintf('there is no boundray to having a misorenation through FROM THE BEGINNING!\n');
    MisGB = 0;               Misanglede=0;              
end