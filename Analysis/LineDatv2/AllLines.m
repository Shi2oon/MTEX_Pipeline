clc; clear; close all; warning off
% addpath('P:\Abdo\GitHub\mtex-5.2.beta2');          
% startup_mtex;                   
addpath(genpath(pwd));   

% for i = 45:46
%     clearvars -except i;	clc;	close all;	warning off  
%     [pname,fname,ebsd,CS] = DSS_Data(i);
%     load([erase(fname,'.ctf') '.mat']);
%     [Maps]   = Save4xEBSD(pname,fname);
%     Maps.C4D = Stiffness;                   % computed stifness
%     save([erase(fname,'.ctf') '.mat']); 
%     for ii=1:3
%         PatchLines(pname,fname,ebsd,CS)
%     end
% end
% % for ii = 9:20
% %     [pname,fname,ebsd,CS] = TiAl_Data(ii);
% %     PatchLines(pname,fname,ebsd,CS)
% % end
for iii = 9:9
    for i=1:3
    [pname,fname,ebsd,CS] = Alex_Data(iii);
    PatchLines(pname,fname,ebsd,CS)
    end
end











