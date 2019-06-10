clear; clc; close all;              
addpath('C:\Users\Abdul Mohammed\Documents\GitHub\mtex');          
startup_mtex;                 addpath([pwd '\Analysis\lineData']);
addpath([pwd '\Routine']);    addpath([pwd '\Analysis']);      addpath([pwd '\Data']);  
%import_wizard('EBSD')              AnnotateR2p4

for i=24:25
    clc;    clearvars -except i variable
    [pname,fname,ebsd,CS] = AllData(i);         % Data List
%     SelectBox(CS,ebsd,pname);                   % for an intersitng area
    [Dir]         =   startEBSD(CS,ebsd,fname,pname);     % Script for EBSD Data
% addpath('C:\Users\scro3511\Documents\GitHub');
%     xEBSD_MTEx
end

% for i=24:25       
%     clc;    clearvars -except i variable
%     [pname,fname,ebsd,CS] = AllData(i);
%     
%      DirSave    =  fullfile(pname,'24-May-2019 Selection(s)');   
%      [iv]       =  ifShitFailedEnterSelectAddress(DirSave);    % DirSave is the selction dir 
% %     [Dir]      =  startEBSD(CS,ebsd,fname,pname);             % Script for EBSD Data
% 
% %     Dir.Save   =  [erase(fname,'.ctf') '.mat'];               load(Dir.Save);
% %     Dir.xEBSD  =  [erase(fname,'.ctf') '_XEBSD.mat'];         load(Dir.xEBSD);           
% end