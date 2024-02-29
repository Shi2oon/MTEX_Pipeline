function SelectBox(CS,ebsd,pname,fname)
%% GRADIENT
clc;        close all;      warning off
pname = [pname '\' date ' Selection(s)'];             mkdir(pname);
ebsd  = fill(ebsd);
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',5*degree);

for i=1:length(ebsd.indexedPhasesId)
    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).mis2mean.angle./degree); 
    hold on
end
plot(grains.boundary);
set(gcf,'position',[500,100,950,700]);      colormap(jet(256));
mtexColorbar('title','Misorientation Angle^{o}')

%% define a sub region
counterss=1;        isDispOk = 'Y'; 
while isDispOk ~= 'N'
    uiwait(msgbox('Click two points on the box corners.','Select Corners','modal'));  
    [xdata{counterss}, ydata{counterss}] = ginput(2);     hold on;
    xmin = min(xdata{counterss});              xmax = max(xdata{counterss});
    ymin = min(ydata{counterss});              ymax = max(ydata{counterss});

    region = [xmin ymin xmax-xmin ymax-ymin];   % marke the sub region
    h = rectangle('position',region,'edgecolor','r','LineStyle','--','linewidth',2);
    
    opts.Interpreter = 'tex'; % Include the desired Default answer
    opts.Default     = 'Y';     % Use the TeX interpreter to format the question
    quest            = '(Y) Chose Another Bix, (C) Remove Previous Selection, (N) Done with Box Selection';
    isDispOk         = questdlg(quest,'Boundary Condition','Y','N','C', opts);    
    
    if isDispOk == 'Y' 
        % select EBSD data within region
        condition           = inpolygon(ebsd,region);  % select indices by polygon
        ebsdBox{counterss}  = ebsd(condition);  
        text(mean(xdata{counterss}),mean(ydata{counterss}),...
            num2str(counterss),'Color','red','FontSize',14)
        counterss           = counterss+1;
    elseif isDispOk == 'C' 
        delete(h)
    end 
end
DirSave   = fullfile(pname,' Selection(s).png');
saveas(gcf,DirSave);                    close all;           
counterss = counterss-1;
DirSave   = fullfile(pname,'Selection(s) Cordinate.mat');
Dirfile   = [erase(fname,'.ctf') '.mat'];
save(DirSave,'ebsdBox','counterss','pname','CS','xdata','ydata','Dirfile');

for i=1:i
    pnames = [pname '\Selction_0' num2str(i)];   % path to files
    fnames = [pnames '\Selction_0' num2str(i)];  % which files to be imported
    mkdir(pnames);
    [ebsd,cs,grains,MisGB,Misanglede,TwinedArea] = GBs(ebsdBox{i},[pnames '\'],ebsdBox{i}.CS); 
    PoleFigures(pnames,ebsdBox{i}.CSList,ebsd,grains);
    save([erase(fnames,'.ctf') '_EBSD.mat'],'ebsd','cs','grains'); close all
%     startEBSD(CS,ebsdBox{i},fnames,pnames,'Box',xdata{i},ydata{i},Dirfile);
end