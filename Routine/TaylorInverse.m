function TaylorInverse(mori,SF,Dir,name)
%         plot(mori,SF,'smooth','complete','upper')
% DirSave = fullfile(Dir,[name ' Ori IPF.fig']);
%         saveas(gcf,DirSave); close all
%         
        h=[Miller(1,1,0,mori.CS),Miller(1,1,1,mori.CS),...
            Miller(0,0,1,mori.CS)]; 
        plotPDF(mori,h,'smooth','complete','upper');
        % plotHKL(CS{i},'projection','eangle','upper','grid_res',...
        %     15*degree,'BackGroundColor','w');
        %CLim(gcm,'equal'); % set equal color range to all plots
        mtexColorbar 
DirSave = fullfile(Dir,[name 'Taylor Ori ODF.png']);
        saveas(gcf,DirSave); close all