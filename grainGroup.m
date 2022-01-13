function grainGroup(fol,Twin,Parent,Adjacent,dic,phased)
% dic: direction 1 for X, 2 for Y, 3 for Z
% Twin: all the twin grain numbers
% grainGroup('P:\Abdo\EBSD Data\19-10-14_XEBSD_Grain no 9\19-10-14',[7 11 13 15 16],21,4,1,2)
clc;close
addpath([pwd '\Routine'])
[~,A] = fileparts(fol);
DirPoleF = fullfile(fileparts(fol),[A '_Grain' num2str(Twin(1))]); mkdir(DirPoleF)
load(fol,'ebsd','CS','grains')
setMTEXpref('xAxisDirection','east');
% setMTEXpref('yAxisDirection','south');
setMTEXpref('zAxisDirection','intoPlane');
xc = {'x','y','z'};
      
      %%

     plot(ebsd); hold on; plot(grains.boundary);                       
text(grains,num2str(grains.id));        
DirSave = fullfile(DirPoleF,'GB nos.tif'); saveas(gcf,DirSave);  close
%{
iX='z';    
plot(grains.boundary);                       
text(grains,num2str(grains.id));        
DirSave = fullfile(DirPoleF,'GB nos.tif'); saveas(gcf,DirSave);  close
      %%  
PsI    = calcKernel(ebsd(grains([Twin(1) Parent Adjacent])).orientations);
Psi    = calcKernel(grains([Twin(1) Parent Adjacent]).meanOrientation);
[hw]   = erroOPFe(DirPoleF,grains([Twin(1)]).CS,PsI,Psi);

for iV=[Twin(1) Parent Adjacent]
    if iV == Twin(1)
        odf{iV} = calcODF(ebsd(grains(Twin)).orientations,'kernel',hw);
      else
        odf{iV} = calcODF(ebsd(grains(iV)).orientations,'kernel',hw);
    end
    h = [Miller(1,1,0,odf{iV}.CS),Miller(1,0,0,odf{iV}.CS),...
             Miller(1,1,1,odf{iV}.CS),Miller(2,1,1,odf{iV}.CS)];
         
    plotPDF(odf{iV},h,'figSize','medium'); %,'antipodal','COMPLETE'
    CLim(gcm,'equal'); % set equal color range to all plots
    mtexColorbar 
    annotate([xvector,yvector],'label',{'X','Y'},'BackgroundColor','w');
     DirSave = fullfile(DirPoleF,['Grain ' num2str(iV) 'ODF.tif']); saveas(gcf,DirSave);  close 
end     
      %% angle
plotPDF(ebsd(grains(Twin(1))).orientations,h(1),...
        'points','all','antipodal','figSize','medium','grid','grid_res',10*degree); 
    DirSave = fullfile(DirPoleF,'Angles by 10.tif'); saveas(gcf,DirSave);  close

      %% parent Twin
   newMtexFigure('nrows',1,'ncols',length(h)); 
for iO=1:length(h)    
          nextAxis(1,iO)
    for iV= [Parent Twin(1)]
        if iV == Twin(1)
            oM = ipfHSVKey(ebsd(grains(Twin)));
            eval(sprintf('oM.inversePoleFigureDirection = %svector;',xc{iX}));
            color = oM.orientation2color(ebsd(grains(Twin)).orientations);
            plotPDF(ebsd(grains(Twin)).orientations,color,h(iO),...
                    'points','all','antipodal','figSize','medium');%,'grid','grid_res',5*degree); 
        else
        oM = ipfHSVKey(ebsd(grains(iV)));
        eval(sprintf('oM.inversePoleFigureDirection = %svector;',xc{iX}));
        color = oM.orientation2color(ebsd(grains(iV)).orientations);
        plotPDF(ebsd(grains(iV)).orientations,color,h(iO),...
                'points','all','antipodal','figSize','medium');%,'grid','grid_res',5*degree); 
        end
        hold on
    end             
    hold off
end
annotate([xvector,yvector],'label',{'X','Y'},'BackgroundColor','w');
DirSave = fullfile(DirPoleF,['Parent Twin PF in ' xc{iX} '_' num2str(iV)...
    '.tif']); saveas(gcf,DirSave); close

      %% parent Adjacent
   newMtexFigure('nrows',1,'ncols',length(h)); 
for iO=1:length(h)    
          nextAxis(1,iO)
    for iV= [Parent Adjacent]
        oM = ipfHSVKey(ebsd(grains(iV)));
        eval(sprintf('oM.inversePoleFigureDirection = %svector;',xc{iX}));
        color = oM.orientation2color(ebsd(grains(iV)).orientations);
        plotPDF(ebsd(grains(iV)).orientations,color,h(iO),...
            'points','all','antipodal','figSize','medium');%,'grid','grid_res',5*degree); 
        hold on
    end             
    hold off
end
annotate([xvector,yvector],'label',{'X','Y'},'BackgroundColor','w');
DirSave = fullfile(DirPoleF,['Parent Adjacent PF in ' xc{iX} '_' num2str(iV)...
    '.tif']); saveas(gcf,DirSave); close
%}
 %% 
 if ~exist('phased','var'); phased =2; end
for iV=unique([Twin Parent Adjacent])
    
 oM = ipfHSVKey(ebsd(grains(iV)));
%define the direction of the ipf
oM.inversePoleFigureDirection = zvector;
%convert the ebsd map orientations to a color based on the IPF
color = oM.orientation2color(ebsd(grains(iV)).orientations);
 plot(ebsd(grains(iV)),color./color,'micronBar','off');hold on
cs = grains(iV).CSList(grains(iV).phaseId);
    cS = crystalShape.cube(cs{1});
    scaling = 1000;
    plot(mean(ebsd(grains(iV)).orientations) * cS * scaling,'FaceColor','none','linewidth',10); 
    box off;axis off; 
    saveas(gcf,fullfile(DirPoleF,['Grain shape ' num2str(iV) '.tif']));close
end
%%
for iV=unique([Twin Parent Adjacent])
    if iV == Twin(1)
       idGrain(grains,ebsd,Twin,DirPoleF,['Grain ebsd ' num2str(iV)],0);
       plot(grains(Twin).boundary,'linewidth',5);box off;axis off
      else
        idGrain(grains,ebsd,iV,DirPoleF,['Grain ebsd ' num2str(iV)],0);
        plot(grains(iV).boundary,'linewidth',5); box off;axis off
    end
    saveas(gcf,fullfile(DirPoleF,['GB ' num2str(iV) '.tif']));close
end
      
%%      
for iV=unique([Twin Parent])
 oM = ipfHSVKey(ebsd(grains(iV)));
%define the direction of the ipf
oM.inversePoleFigureDirection = zvector;
%convert the ebsd map orientations to a color based on the IPF
color = oM.orientation2color(ebsd(grains(iV)).orientations);
plot(ebsd(grains(iV)),color);
 plot(ebsd(grains(iV)),color./color,'micronBar','off');hold on
cs = grains(iV).CSList(grains(iV).phaseId);
    cS = crystalShape.cube(cs{1});
    scaling = 1000;
    if iV == Twin(1)
        plot(mean(ebsd(grains(iV)).orientations)*cS*scaling,'FaceColor','none','linewidth',10,'edgeColor','r');
    else
        plot(mean(ebsd(grains(iV)).orientations)*cS*scaling,'FaceColor','none','linewidth',10); 
    end
    box off;axis off; hold on
end
saveas(gcf,fullfile(DirPoleF,['Grain no all.tif']));close
%}
%%
% try 
    load([fol '_XEBSD'], 'Grain_Map_stress_sample','Map_EBSD_MTEX','GrainID_Setup',...
                         'GrainData','GND','Data_InputMap','MicroscopeData'); 
    Map_EBSD_MTEX = Map_EBSD_MTEX('indexed');
    %create the grains
    [gra,Map_EBSD_MTEX.grainId,Map_EBSD_MTEX.mis2mean]=...
    calcGrains(Map_EBSD_MTEX,'angle',GrainID_Setup.mis_tol*degree);

    %clean up the grain size - using the minimum threshold
    gra2=gra(gra.grainSize > GrainID_Setup.GrainID_minsize);
    num_grains=size(gra2,1);
    if length(GrainData.GrainPts) == num_grains
        plot(gra2.boundary);                       
        text(gra2,num2str(gra2.id));        
        [XEB] = input('number of [Twin, Parent, Adjacent]? ');
        for iv=1:3
            XEB(iv)=find(gra2.id==XEB(iv));
        end
        DirSave = fullfile(DirPoleF,'xEBSD Grains.tif'); saveas(gcf,DirSave);  close
    end
    count=1;
    for i=[Twin(1) Parent Adjacent]
        rot_sample{i} = Map_EBSD_MTEX(sub2ind([MicroscopeData.NROWS,...
             MicroscopeData.NCOLS],GrainData.RefPoint.prop.yi...
             (XEB(count)),GrainData.RefPoint.prop.xi(XEB(count))))...
             .orientations;%.matrix;
         count=1+count;
    end
% catch err
%     display(err.message);
% end

%%
count=0;
for iV=unique([Twin Parent Adjacent])
    for dic=[1 3]%1:length(xc)
        if exist('XEB','var') && dic==1
            count=count+1;
            ST = squeeze(Grain_Map_stress_sample(:,:,XEB(count),1,1));
            ST(ST==0)=NaN;
            GNDs = GND.total;   
%             ST = MoreOutNaN(ST,Data_InputMap.XStep);
%             for iO=1:2
%                 ST(ST>nanmean(ST(:)))=NaN; 
                GNDs(isnan(ST))=NaN;
%                 GNDs(GNDs>nanmean(GNDs(:)))=NaN;   
%                 ST(isnan(GNDs))=NaN;
%             end
            for i=1:3; for j=1:3;   GN(:,:,i,j) = GNDs;     end;    end
            ST = squeeze(Grain_Map_stress_sample(:,:,XEB(count),:,:));
            ST(ST==0)=NaN;
            X = Data_InputMap.XSample;     X(isnan(ST(:,:,1,1)))=NaN;
            Y = Data_InputMap.YSample;     Y(isnan(ST(:,:,1,1)))=NaN;
            subplot(1,2,1); contourf(X,Y,ST(:,:,1,1));
            try xlim([min(X(:)) max(X(:))]);    ylim([min(Y(:)) max(Y(:))]);   end
            title('\sigma_{11,Ori.}'); caxis([-1.5 1.5]); axis image; box off
            ST(isnan(GN))=NaN;
            X = Data_InputMap.XSample;     X(isnan(ST(:,:,1,1)))=NaN;
            Y = Data_InputMap.YSample;     Y(isnan(ST(:,:,1,1)))=NaN;
            subplot(1,2,2); contourf(X,Y,ST(:,:,1,1)); 
            try xlim([min(X(:)) max(X(:))]);    ylim([min(Y(:)) max(Y(:))]);   end
            title('E11_{Cor.}'); caxis([-5e-3 5e-3]); axis image; box off
            set(gcf,'position',[60,50,1000,920]); 
            ylabel('Y [\mum]'); xlabel('X [\mum]')
            saveas(gcf,[DirPoleF '\' num2str(iV) '_Ori & Cor.tif']);  close
            %%
            % I keep using the three criteria: 1) Identify twin based on 
            % normal projection on x-y plane 2) Schmid factor 3) 
            % Reorientation of the crystal
            SlipTraces(ebsd(grains(iV)),grains(iV),...
                [DirPoleF '\' num2str(iV)],xc{dic},rot_sample{iV},ST);
            clear ST GNDs GN
        end
        SlipTraces(ebsd(grains(iV)),grains(iV),[DirPoleF '\' num2str(iV)],xc{dic});
    end
end
end