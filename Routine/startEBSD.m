function [Dir]=startEBSD(CS,ebsd,fname,pname)
warning('off'); tic;
 
% Dir.path = fullfile(Dir.pname,Dir.name); mkdir(Dir.path);
Dir.path = pname;

%% MyMTEx
[grains,ebsd,Dir,MI,CS] = GBs(ebsd,Dir,CS);    % EBSD map and GB related
[ebsd,Dir] = PoleF(Dir,CS,ebsd,MI,grains,100); % (1/100*100%) = 1 from all points
[Dir] = PlotCrystalShape(ebsd,CS,grains,Dir);  % crystal in ebsd map
[Dir] = SchmidTaylorEBSD(CS,ebsd,Dir,grains);  % taylor calcuations
[Dir] = GndsCalc(Dir,CS,ebsd,grains);          % Gnds calculation

close all;   Dir.ebsd = ebsd;    Dir.CS = CS;   Dir.grains = grains;      
Dir.Save = [erase(fname,'.ctf') '.mat'];        save(Dir.Save,'Dir');

clc;    fprintf('file at %s \nwith %d measurement points took %.1f minutes\n',...
        Dir.path,length(ebsd),toc/60);