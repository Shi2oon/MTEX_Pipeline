% a function to upload selction and choose a specific one (iV) to analyis or all
% for them
function [iv]=ifShitFailedEnterSelectAddress(DirSave,iv)
clc; close all; warning off;
DirSave = fullfile(DirSave,'Selection(s) Cordinate.mat'); 
load(DirSave); 

if (exist('iv', 'var'))==0
    for iv=1:counterss
        pnames = [pname  '\Selction_0' num2str(iv)];   % path to files
        fnames = [pnames '\Selction_0' num2str(iv)];   % which files to be imported
        mkdir(pnames);
        startEBSD(CS,ebsdBox{iv},fnames,pnames,'Box',xdata{iv},ydata{iv},Dirfile);
    end
else
    pnames = [pname  '\Selction_0' num2str(iv)];   % path to files
    fnames = [pnames '\Selction_0' num2str(iv)];   % which files to be imported
    mkdir(pnames);
    startEBSD(CS,ebsdBox{iv},fnames,pnames,'Box',xdata{iv},ydata{iv},Dirfile);
end