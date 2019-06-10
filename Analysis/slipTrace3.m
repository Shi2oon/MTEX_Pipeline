function [TRACE] = slipTrace3(imgfile,ebsd,CS)
% a program for trace analysis, just make sure that the SEM image is name
% similar to the ctf file
% [TRACE] = slipTrace3([erase(fname,'.ctf') '.png'],ebsd,CS)

close all; clc; warning off
%Read in ebsd file and calculate grains
if sum(CS{1}=='notIndexed')==10 
    [ebsd,CS,grains] = IndexAndFill(ebsd,CS); % fill
end
imageSEM          = imread(imgfile);
%imgfile           = imgfile(1:end-4);
[filepath,name,~] = fileparts(imgfile);
imgfile           = fullfile(filepath, name);

COUNTERS = 0;          answer = 'Y'; 
while answer == 'Y'
    %Display plot of grains and have user select the one that their SEM image is located in.
    COUNTERS     = COUNTERS+1;
    for i=1:length(ebsd.indexedPhasesId)
        plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
            ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}).orientations);
        hold on
    end
    plot(grains.boundary); hold off
    uiwait(msgbox('Click on the grain that is being indented to get crystal orientation.   Make sure SEM image and EBSD map are oriented the same way!','choose grain','modal'));
    g{COUNTERS} = ginput(1);              close all;
    
    % SEM image
    imshow(imageSEM);
    uiwait(msgbox('Click two points on a single slip trace.','Select Corners','modal'));
    c1{COUNTERS} = ginput(1);
    c2{COUNTERS} = ginput(1);   
    hold on; plot([c1{COUNTERS}(1),c2{COUNTERS}(1)],[c1{COUNTERS}(2),c2{COUNTERS}(2)],...
        'Color','r','LineStyle','-','LineWidth',2); hold off
    
    opts.Interpreter = 'tex'; % Include the desired Default answer
    opts.Default     = 'Y';     % Use the TeX interpreter to format the question
    quest            = '(Y) Chose Another Single Slip trace, (C) Remove Previous Selection, (N) Done with Trace Selection';
    answer           = questdlg(quest,'Boundary Condition','Y','N','C', opts);
    close all;
    if answer=='C'
        COUNTERS=COUNTERS-1;
        answer='Y';
    end
end

for iv=1:COUNTERS
    line      = normalize(vector3d(c2{iv}(1)-c1{iv}(1),c2{iv}(2)-c1{iv}(2),0));
    grain     = grains(grains.findByLocation(g{iv}));
    ori       = grain.meanOrientation;
    [CStrace] = findCS(CS,ebsd(grain)); % find corrspond CS
    [~,sS]    = decideDS(CStrace,0.3);     % find slip system
    sSlocal   = grain.meanOrientation * sS;

    %transform line formed by the slip trace into crystal coordinate system
    line    = Miller(ori*line,grain.CS);
    sigma   = stressTensor.uniaxial(vector3d.Z);
    %tau    = sS.SchmidFactor(line);
    SF      = sSlocal.SchmidFactor(sigma); %plot(SF)
    sS.CRSS = abs(SF);
    %[SFMax,~] = max(abs(SF),[],2);% take the maxium allong the rows
    %plot(grain,SFMax,'micronba r','off','linewidth',2);  hold on;    legend off
    for i=1:length(sSlocal)
        quiver(grain,sS(i).trace,'autoScaleFactor',abs(SF(i))) % 'color','k',
        %,'displayName','Burgers vector')
        %quiver(grain,sSlocal(i).b,'color','r','autoScaleFactor',1)
        %,'displayName','slip plane trace')
        index(i) = abs(sS(i).trace-line);
        hold on;
    end
    quiver(grain,line,'autoScaleFactor',max(abs(SF)),'color','k'); hold off
    saveas(gcf,[imgfile,' traces.fig']); close all

    count=0; 
    for i=1:length(sSlocal)
        if index(i) <= min(index)+(max(index)-min(index))/max(index)*0.1 %5% tolerance
            count            = count+1;
            indexed(count,1) = i;
            indexed(count,2) = abs(SF(i));
        end
    end
    [row,~]   = find (indexed==max(indexed(:,2)));
    TRACE{iv} = sS(indexed(row,1));
    clear -vars index indexed
end

imshow(imageSEM);
for iv=1:COUNTERS
    hold on; 
    plot([c1{iv}(1),c2{iv}(1)],[c1{iv}(2),c2{iv}(2)],...
        'Color','r','LineStyle','-','LineWidth',2); 
    ht = text(min(c2{iv}(1),c1{iv}(1)),(c2{iv}(2)+c1{iv}(2))/2,['[' ...
         num2str(round(TRACE{iv}.b.u)) num2str(round(TRACE{iv}.b.v)) ...
         num2str(round(TRACE{iv}.b.w)) '] (' ...
         num2str(round(TRACE{iv}.n.h)) num2str(round(TRACE{iv}.n.k)) ...
         num2str(round(TRACE{iv}.n.l)) ')' ],'Color','b');
%     iclinity = acos((c2{iv}(2) - c1{iv}(2))/sqrt((c2{iv}(2) - ...
%                c1{iv}(2))^2+(c2{iv}(1) - c1{iv}(1))^2));
%     slope = (c2{iv}(2) - c1{iv}(2))/ (c2{iv}(1) - c1{iv}(1));
%     if slope < 1;   set(ht,'Rotation',iclinity*180/pi)
%     else;           set(ht,'Rotation',iclinity*180/pi+90);     end
    set(ht,'FontSize',16)
end
hold off;  

% tight plot
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

saveas(gcf,[imgfile, ' traced.png']); close all % save