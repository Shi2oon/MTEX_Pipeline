%% Import Script for EBSD Data
close all; clear; clc
warning('off')
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  crystalSymmetry('m-3m', [3.307 3.307 3.307], 'mineral', 'Titanium-beta', 'color', 'light green'),...
  crystalSymmetry('6/mmm', [2.95 2.95 4.686], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Titanium', 'color', 'light red')};

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
Dir.pname = 'P:\Abdo\EBSD Data\Magazzeni Data';

% which files to be imported
Dir.fname = [Dir.pname '\zface.ctf'];
%Dir.fname = [Dir.pname '\zface2.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(Dir.fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

%% Identify the Systems!!
    % This are systems of hkl
for i=1:length(CS)
    h = {... %{111} {200} {220} or Why?
            Miller(1,0,0,CS{i}),... %{100}
            Miller(1,1,0,CS{i}),... %{110}
            Miller(1,1,1,CS{i}),... %{111}
                                };
     eval(sprintf('MI.h%d=h;',i));
end

%% MyMTEx
Dir.path = fullfile(Dir.pname,'Analysis'); mkdir(Dir.path);
[grains,ebsd,MyData]=GBs(ebsd,CS,Dir,'Raw',MI);
[ebsd,MyData]=PoleF(Dir,CS,ebsd,'Raw',MI,MyData);
close all

%% correct ebsd maps
Ebsd=ebsd;
Ebsd(grains(grains.grainSize<=5)) = []; % remove very small grains
[grainscorrected,Ebsd,NoData]=GBs(Ebsd,CS,Dir,'Smoothed',MI);
[Ebsd,NoData]=PoleF(Dir,CS,Ebsd,'Smoothed',MI,NoData);
