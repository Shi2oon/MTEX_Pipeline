function PatchLines(fname)
% check if vraible exist
fprintf('\n%s\n',fileparts(fname));
% load([erase(fname,'.ctf') '_XEBSD.mat'],'Maps');
addpath('P:\Abdo\GitHub\MyEBSD\Analysis\LineDatv2\Get Data')
[Maps,~] = GetGrainData([erase(fname,'.ctf') '_XEBSD.mat'],'Line_Profile'); 

%then proceed
[LN]   = LineMaps(Maps);
Xplot(LN,25)
end

