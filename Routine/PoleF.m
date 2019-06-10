% Check the location of hte axes
function [ebsd,Dir]=PoleF(Dir,CS,ebsd,MI,grains,plotingpercent)
clc; warning('off'); close all;

if length(grains.id)>3000
Dir.PoleF=fullfile(Dir.path,'Pole Figures');  mkdir(Dir.PoleF);

setMTEXpref('defaultColorMap',WhiteJetColorMap) 

for i=1:length(ebsd.indexedPhasesId)

% Orientation Density Functions (ODF)
% gives	the	density	of	grains	having	 a	particular	orientation
%odf = calcODF(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);

%MTEX includes an automatic halfwidth selection algorithm
PsI    = calcKernel(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
Psi    = calcKernel(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).meanOrientation);
[hw]   = erroOPFe(Dir.PoleF,CS{i},PsI,Psi);
odf{i} = calcODF(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations,'kernel',hw);
 
h=[Miller(1,1,0,odf{i}.CS),Miller(1,1,1,odf{i}.CS),Miller(0,0,1,odf{i}.CS)]; %,...
%Miller(2,1,1,odf{i}.CS)]; 
% h=[Miller(2,1,1,odf{i}.CS),Miller(2,0,0,odf{i}.CS),Miller(1,1,0,odf{i}.CS)];
% with symmetry included
% h=[Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS),...
%     Miller(0,1,0,odf.CS),Miller(0,1,1,odf.CS),Miller(0,0,1,odf.CS),...
%     Miller(1,0,1,odf.CS),Miller(2,0,0,odf.CS),Miller(2,1,1,odf.CS)]; 
    
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)} ' ODF.txt']);
export(odf{i},Dir.Save,'interface','VPSC')
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)} '_ODF.MTEX']);
export(odf{i},Dir.Save,'generic','Bunge','resolution',5*degree)

odf_model    = unimodalODF(calcModes(odf{i}),'kernel',hw);
Dir.ODFerror = calcError(odf_model,odf{i}); Dir.ODFerror=round(Dir.ODFerror,3);
center = calcModes(odf_model);

plotPDF(odf_model,h,'figSize','medium'); %,'antipodal','COMPLETE'
%annotate(center,'marker','s','MarkerFaceColor','black')
mtexColorbar 	
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    ' Model ODF.png']); saveas(gcf,Dir.Save); close all

plotPDF(odf{i},h,'figSize','medium'); %,'antipodal','COMPLETE'
%annotate(center,'marker','s','MarkerFaceColor','black')
%plotPDF(odf,h,'grid','grid_res',15*degree,'antipodal','resolution',2*degree);
%plotPDF(odf,h,'contourf','antipodal','resolution',2*degree) %contour plot
%plotSection(odf,'phi2','sections',9) %To get 10° intervals (alt+space+M)

%CLim(gcm,'equal'); % set equal color range to all plots
mtexColorbar 
%annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},'BackgroundColor','w');	
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    ' ODF.png']); saveas(gcf,Dir.Save);
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    ' ODF.fig']); saveas(gcf,Dir.Save); close all

% plotPDF(odf{i},h,'3d')
% Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
%     ' 3D ODF.fig']); saveas(gcf,Dir.Save); close all

% IPDF
% plotIPDF(odf,[xvector,yvector,zvector],'antipodal','figSize','medium');
for ii=1:length(h)
    C(ii)=vector3d(h.h(ii),h.k(ii),h.l(ii));
end
plotIPDF(odf{i},C,'antipodal','figSize','medium'); %CLim(gcm,'equal');
mtexColorbar;
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    ' IPF.png']); saveas(gcf,Dir.Save); close all

%Discrete PFs legend
Bo=round(length(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations)...
    /plotingpercent);
plotPDF(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations,h,...
    'points',Bo,'antipodal'); 
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    ' Discrete PF.png']);
saveas(gcf,Dir.Save); close all

% texture analysis
Dir.textureindex=textureindex(odf{i});Dir.entropy=entropy(odf{i});
Dir.textureindex=round(Dir.textureindex,3);
Dir.entropy=round(Dir.entropy,3);

%% Plotting symmetry
plotHKL(CS{i},'projection','eangle','upper','grid_res',...
    15*degree,'BackGroundColor','w');hold on
plotPDF(odf_model,h(3),'grid','grid_res','antipodal'); 
plotHKL(CS{i},'projection','eangle','upper','grid_res',...
    15*degree,'BackGroundColor','w'); hold off
%annotate(center,'marker','s','MarkerFaceColor','black')
% title(['001 w/ phi1 = ' num2str(center.phi1) ' .. Phi = ' num2str(center.Phi)...
%     ' .. phi2 = ' num2str(center.phi2)]);
title(['\{001\} w/ Angle = ' num2str(round(orientation.byEuler(center.phi1,center.Phi,...
    center.phi2,CS{i}).angle./degree),3) '^{o}']);

Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)} ...
    ' Symmetry.png']);  saveas(gcf,Dir.Save);   close all 
Dir.odf{i}=odf{i};      Dir.hw=hw;              Dir.odfcenter=center;

end
[Dir]=StiffnessEBSD(Dir,CS,ebsd); % calculate Stifness (compare)
else
fprintf('\n\n No Pole Figures will be calculated and plotted .. \n');
fprintf('because there is no enough grains to do that\n\n');
end