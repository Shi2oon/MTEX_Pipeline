function [Dir]=PlotCrystalShape(ebsd,CS,grains,Dir)
%% plot crystal shape in the ebsd map
Dir.Def=fullfile(Dir.path,'Deformation');  mkdir(Dir.Def);

for i=1:length(ebsd.indexedPhasesId)
    plot(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)})...
        ,grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).meanOrientation); hold on

    gB=grains(ebsd.mineralList{ebsd.indexedPhasesId(i)});
    isBig{i} = gB.grainSize>(sum(gB.grainSize)/(length(gB.grainSize)))*.1; % find the big ones   
    
  if sum(isBig{i})~=0
    % crystal shape         plot(cS)
    if sum(strfind(CS{i}.opt.type,'bcc'))~=0 || sum(strfind(CS{i}.opt.type,'fcc'))~=0
        cS{i} = crystalShape.cube(CS{i});
    elseif sum(strfind(CS{i}.opt.type,'hex'))~=0
        cS{i} = crystalShape.hex(CS{i});
    elseif sum(strfind(CS{i}.opt.type,'apatite'))~=0 
        cS{i} = crystalShape.apatite;   plot(cS)
    elseif sum(strfind(CS{i}.opt.type,'quartz'))~=0
        cS{i} = crystalShape.quartz;
    elseif sum(strfind(CS{i}.opt.type,'topaz'))~=0 
        cS{i} = crystalShape.topaz;
    elseif sum(strfind(CS{i}.opt.type,'garnet'))~=0 
        cS{i} = crystalShape.garnet;
    elseif sum(strfind(CS{i}.opt.type,'olivine'))~=0 
        cS{i} = crystalShape.olivine;
    end
    
  plot(gB(isBig{i}),0.6 * cS{i},'FaceColor','light blue')
   if length(gB)~=1
    for ii=1:length(ebsd.indexedPhasesId)
        plot(Dir.MisGB{i,ii},Dir.Misanglede{i,ii},'linewidth',2); 
    end
   end
  end
end
mtexColorbar('title','Misorientation Angle^{o}');   colormap(jet(256));  hold off;
DirSave=fullfile(Dir.Def,'Cystal ebsd.png');        saveas(gcf,DirSave); close all
Dir.CrystalS=cS;

%% Plot Crystal orienation with others
if length(gB)~=1
for i=1:length(ebsd.indexedPhasesId)
    if sum(isBig{i})<13
        gB = grains(ebsd.mineralList{ebsd.indexedPhasesId(i)});   
        sortGrain = sort(gB.grainSize); % sorting grains from small to large
        count = 0;                number = 0;
        for ii=1:sum(isBig{i})
            count = count+1;
            if length(sortGrain) ~= count
                [~, maxindex] = min(abs(gB.grainSize-sortGrain(end))); % grain with max size
                [~, indexx]   = min(abs(gB.grainSize-sortGrain(end-count)));
                if (gB(maxindex).meanOrientation.angle/degree -...
                    gB(indexx).meanOrientation.angle/degree)>5
                    number = number+1;
                    index(number) = indexx;
                end
            end
        end
            if number~=0
                %newMtexFigure('nrows',II,'ncols',J);%nextAxis(ii,j)
                [II,J]=decideSubPlot(number); %decide suplots
                for ii=1:number
                    for ii=1:number
                subplot(II,J,ii)
                % and on top of it in twinning orientation
                plot(gB(maxindex).meanOrientation * cS{i},'FaceAlpha',0.5);   hold on
                plot(gB(index(ii)).meanOrientation * cS{i},'FaceColor','r');  hold off
                view(45,20);    
                title(['Mean Rotation = ' num2str(round(...
                        gB(index(ii)).meanOrientation.angle/degree)) '^{o}'])
                %mtexColorbar; mtexColorbar
                    end
                end
            end
    end
end
 set(gcf,'position',[500,100,1450,800]); mtexColorbar; mtexColorbar
 DirSave=fullfile(Dir.Def,'Cystal ebsd.fig');        saveas(gcf,DirSave);
  DirSave=fullfile(Dir.Def,'Cystal ebsd.png');       saveas(gcf,DirSave); close all
  
else
    fprintf('there is no other grains FROM THE BEGINNING!\n');
end