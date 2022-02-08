% Check the location of hte axes
function [hw,odf,ODFerror]=PoleFigures(Dirpath,CS,ebsd,grains)
clc; warning('off'); close all;

DirPoleF=fullfile(Dirpath,'Pole Figures');  mkdir(DirPoleF);

setMTEXpref('defaultColorMap',WhiteJetColorMap)
for i=1:length(ebsd.indexedPhasesId)
    
    % Orientation Density Functions (ODF)
    % gives	the	density	of	grains	having	 a	particular	orientation
    %odf = calcODF(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
    
    %MTEX includes an automatic halfwidth selection algorithm
    PsI    = calcKernel(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
    Psi    = calcKernel(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).meanOrientation);
    [hw]   = erroOPFe(DirPoleF,CS{i},PsI,Psi);
    odf{i} = calcODF(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations,'kernel',hw);
    h      = [Miller(1,1,0,odf{i}.CS),Miller(1,1,1,odf{i}.CS),Miller(0,0,1,odf{i}.CS),Miller(1,1,2,odf{i}.CS)]; %,...
    %Miller(2,1,1,odf{i}.CS)];
    % h=[Miller(2,1,1,odf{i}.CS),Miller(2,0,0,odf{i}.CS),Miller(1,1,0,odf{i}.CS)];
    % with symmetry included
    % h=[Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS),...
    %     Miller(0,1,0,odf.CS),Miller(0,1,1,odf.CS),Miller(0,0,1,odf.CS),...
    %     Miller(1,0,1,odf.CS),Miller(2,0,0,odf.CS),Miller(2,1,1,odf.CS)];
    
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)} ' ODF.txt']);
    export(odf{i},DirSave,'interface','VPSC')
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)} '_ODF.MTEX']);
    export(odf{i},DirSave,'generic','Bunge','resolution',5*degree)
    
    odf_model = unimodalODF(calcModes(odf{i}),'kernel',hw);
    ODFerror  = calcError(odf_model,odf{i}); ODFerror=round(ODFerror,3);
    center    = calcModes(odf_model);
    f = figure('visible','off');
    plotPDF(odf_model,h,'figSize','medium'); %,'antipodal','COMPLETE'
    %annotate(center,'marker','s','MarkerFaceColor','black')
    mtexColorbar
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ' Model ODF.png']); saveas(f,DirSave); close
    f = figure('visible','off');
    plotPDF(odf{i},h,'figSize','medium'); %,'antipodal','COMPLETE'
    %annotate(center,'marker','s','MarkerFaceColor','black')
    %plotPDF(odf{i},h,'grid','grid_res',15*degree,'antipodal','resolution',2*degree);
    %plotPDF(odf{i},h,'contourf','antipodal','resolution',2*degree) %contour plot
    %plotSection(odf,'phi2','sections',9) %To get 10° intervals (alt+space+M)
    
    %CLim(gcm,'equal'); % set equal color range to all plots
    mtexColorbar
    %annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},'BackgroundColor','w');
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ' ODF.tif']); saveas(f,DirSave);close
    
    % plotPDF(odf{i},h,'3d')
    % Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    %     ' 3D ODF.fig']); saveas(gcf,Dir.Save); close all
    
    %% IPDF
    %     plotIPDF(odf,[xvector,yvector,zvector],'antipodal','figSize','medium');
    %     title('X Y and Z');
    for ii=1:length(h)
        C(ii)=vector3d(h.h(ii),h.k(ii),h.l(ii));
    end
    f = figure('visible','off');
    plotIPDF(odf{i},C,'antipodal','figSize','medium'); %CLim(gcm,'equal');
    mtexColorbar;       mtexColorbar;       mtexColorbar;
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ' IPF.png']); saveas(f,DirSave);
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
        ' IPF.fig']); saveas(f,DirSave);close all
    
    %Discrete PFs legend
    EBSD = ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)});
    [GRAINS,EBSD.grainId,EBSD.mis2mean] = calcGrains(EBSD,'angle',2*degree);
    xc = {'x','y','z'};
    for iX=3
        newMtexFigure('nrows',1,'ncols',length(h));
        set(gcf,'visible','off');
        for iK=1:length(h)
            nextAxis(1,iK)
            for iV=1:length(GRAINS)
                oM = ipfHSVKey(EBSD(GRAINS(iV)));
                %define the direction of the ipf
                eval(sprintf('oM.inversePoleFigureDirection = %svector;',xc{iX}));
                %convert the ebsd map orientations to a color based on the IPF
                color = oM.orientation2color(EBSD(GRAINS(iV)).orientations);
                %     color = oM.orientation2color(GRAINS(iV).meanOrientation);
                plotPDF(EBSD(GRAINS(iV)).orientations,color,h(iK),...
                    'points','all','antipodal','figSize','big');
                hold on
            end
            hold off;
        end
        saveas(gcf,fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Discrete PF ' xc{iX} '_' num2str(iK) '.fig']));
        saveas(gcf,fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Discrete PF ' xc{iX} '_' num2str(iK) '.tif'])); close
    end
    %
    for iX=3
        newMtexFigure('nrows',1,'ncols',length(h));
        set(gcf,'visible','off');
        for iK=1:length(h)
            nextAxis(1,iK)
            for iV=1:length(GRAINS)
                oM = ipfHSVKey(EBSD(GRAINS(iV)));
                %define the direction of the ipf
                eval(sprintf('oM.inversePoleFigureDirection = %svector;',xc{iX}));
                %convert the ebsd map orientations to a color based on the IPF
                color = oM.orientation2color(EBSD(GRAINS(iV)).orientations);
                %     color = oM.orientation2color(GRAINS(iV).meanOrientation);
                plotIPDF(EBSD(GRAINS(iV)).orientations,color,h(iK),...
                    'points','all','antipodal','figSize','big')
            end
        end
        DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Discrete IPF ' xc{iX} '_' num2str(iK) '.tif']);saveas(gcf,DirSave);
        DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
            ' Discrete IPF ' xc{iX} '_' num2str(iK) '.fig']);saveas(gcf,DirSave);close
    end
    %}
    % texture analysis ???
    %     TextureIndex = round(textureindex(odf{i}),3);
    %     Entropy      = round(entropy(odf{i}),3);
    
    %% Plotting symmetry
    plotHKL(CS{i},'projection','edist','upper','grid_res',...
        15*degree,'BackGroundColor','w');               hold on
    plotPDF(odf_model,h(3),'grid','grid_res','antipodal');
    plotHKL(CS{i},'projection','edist','upper','grid_res',...
        15*degree,'BackGroundColor','w');               hold off
    %annotate(center,'marker','s','MarkerFaceColor','black')
    % title(['001 w/ phi1 = ' num2str(center.phi1) ' .. Phi = ' num2str(center.Phi)...
    %     ' .. phi2 = ' num2str(center.phi2)]);
    title(['\{001\} w/ Angle = ' num2str(round(orientation.byEuler(center.phi1,center.Phi,...
        center.phi2,CS{i}).angle./degree),3) '^{o}']);
    
    DirSave = fullfile(DirPoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)} ...
        ' Symmetry.png']);  saveas(gcf,DirSave);   close all
    
end
end