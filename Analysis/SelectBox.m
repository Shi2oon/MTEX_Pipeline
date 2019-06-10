function SelectBox(CS,ebsd,pname)
%% GRADIENT
clc;        close all;      warning off
pname=[pname '\' date ' Selection(s)'];             mkdir(pname);
ebsd=fill(ebsd);
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
    title('Please select where you want the box');      mtexColorbar;
    mtexColorbar('title','Misorientation Angle^{o}');   
    [xdata, ydata] = ginput(2);     hold on;
    xmin = min(xdata);              xmax = max(xdata);
    ymin = min(ydata);              ymax = max(ydata);

    region = [xmin ymin xmax-xmin ymax-ymin];   % marke the sub region
    h = rectangle('position',region,'edgecolor','r','LineStyle','--','linewidth',2);
    fprintf('Is this the box that you want Y/N?:  ');
    isDisp = input('','s');
    
    if isDisp=='Y' || isDisp=='y'   
        % select EBSD data within region
        condition           = inpolygon(ebsd,region);  % select indices by polygon
        ebsdBox{counterss}  = ebsd(condition);  
        text(mean(xdata),mean(ydata),num2str(counterss),'Color','red','FontSize',14)
        counterss  = counterss+1;
    else
        delete(h)
    end 

    fprintf('Do you want to select another location Y/N?:  ');
    isDispOk = input('','s');
    if(isempty(isDispOk))
        isDispOk = 'N';
    end 
end
DirSave = fullfile(pname,' Selection(s).png');
saveas(gcf,DirSave);   close all;           counterss=counterss-1;
DirSave = fullfile(pname,'Selection(s) Cordinate.mat'); 
save(DirSave,'ebsdBox','counterss','pname','CS');

% for i=1:counterss
%     pnames = [pname '\Selction_0' num2str(i)];   % path to files
%     fnames = [pnames '\Selction_0' num2str(i)];  % which files to be imported
%     
%     startEBSD(CS,ebsdBox{i},fnames,pnames);
% end