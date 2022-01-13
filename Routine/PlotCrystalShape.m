function PlotCrystalShape(ebsd,CS,grains,MisGB,Misanglede,sS, Dirpath)
%% plot crystal shape in the ebsd map
DirDef = fullfile(Dirpath,'Deformation');         mkdir(DirDef);
xx     = zeros(1,length(ebsd.indexedPhasesId));

for i=1:length(ebsd.indexedPhasesId)
    plot(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)})...
        ,grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).meanOrientation); hold on

    gB=grains(ebsd.mineralList{ebsd.indexedPhasesId(i)});
    
    isBig{i} = gB.grainSize > round(sum(grains.grainSize)*0.0001); % find the big ones   
    if sum(isBig{i})~=0
    [cS{i},xx(i)] = findShape(CS{i},i);
    if xx(i)==0
        plot(gB(isBig{i}),0.6 * cS{i},'FaceColor','light blue')
        plot(gB(isBig{i}),0.4 * cS{i},'FaceColor','none','linewidth',2)
        if length(gB)~=1
            for ii=1:length(ebsd.indexedPhasesId)
                if isempty(MisGB{i,ii})==0
                    plot(MisGB{i,ii},Misanglede{i,ii},'linewidth',2); 
                end
            end
        end
    end
  end
end
mtexColorbar('title','Misorientation Angle^{o}');      colormap(jet(256));  hold off;
DirSave = fullfile(DirDef,'Cystals ebsd.tif');        saveas(gcf,DirSave);

%%
[mp,gb]=SlipTransmission2(ebsd,sS);
for i=1:length(ebsd.indexedPhasesId)
    plot(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)})...
        ,grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}).meanOrientation); hold on

    gB=grains(ebsd.mineralList{ebsd.indexedPhasesId(i)});
    isBig{i} = gB.grainSize>(sum(gB.grainSize)/(length(gB.grainSize)))*.1; % find the big ones   
    
  if sum(isBig{i})~=0
    % crystal shape         plot(cS)
    [cS{i},xx(i)] = findShape(CS{i},i);
    if xx(i)==0
%         plot(gB(isBig{i}),0.6 * cS{i},'FaceColor','light blue')
        plot(gB(isBig{i}),0.4 * cS{i},'FaceColor','none','linewidth',2,'micronBar','off')
    end
  end
end
plot(gb,mp,'linewidth',3);      hold off;   colormap(jet(256));
%set(gcf,'position',[500,100,950,700]);  
setColorRange([0,1]);                          
mtexColorbar('title','Slip Transmission (m^, )','fontsize',20);
DirSave=fullfile(DirDef,'mP2.fig');             saveas(gcf,DirSave);       
DirSave=fullfile(DirDef,'mP2.tif');             saveas(gcf,DirSave);  close all

%%
for i=1:length(ebsd.indexedPhasesId)
    gB=grains(ebsd.mineralList{ebsd.indexedPhasesId(i)});
    isBig{i} = gB.grainSize>(sum(gB.grainSize)/(length(gB.grainSize)))*.1; % find the big ones   
    
  if sum(isBig{i})~=0
    % crystal shape         plot(cS)
    [cS{i},xx(i)] = findShape(CS{i},i);
    if xx(i)==0
%         plot(gB(isBig{i}),0.6 * cS{i},'FaceColor','light blue')
        plot(gB(isBig{i}),0.4 * cS{i},'FaceColor','none','linewidth',8,'micronBar','off')
        box off;        axis off
    DirSave = fullfile(DirDef,['Grain_' ebsd.mineralList{ebsd.indexedPhasesId(i)}  '_Crystal.png']); 
    saveas(gcf,DirSave); close all
    end
  end
end

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
                subplot(II,J,ii)
                % and on top of it in twinning orientation
                plot(gB(maxindex).meanOrientation * cS{i},'FaceAlpha',0.5);   hold on
                plot(gB(index(ii)).meanOrientation * cS{i},'FaceColor','r');  hold off
                view(45,20);    
                title(['Red Rotation = ' num2str(round(...
                        gB(index(ii)).meanOrientation.angle/degree)) '^{o}'])
                %mtexColorbar; mtexColorbar
                end
            end
    end
end
 %set(gcf,'position',[500,100,1450,800]); 
    mtexColorbar; mtexColorbar
%     DirSave=fullfile(Dir.Def,'Cystal ebsd.fig');        saveas(gcf,DirSave);
    DirSave=fullfile(DirDef,'Cystal ebsd.png');       saveas(gcf,DirSave); close all
  
else
    fprintf('there is no other grains to begin with.\n The grain with inside you the whole time.\n You are the grain!\n');
end