%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3.076 3.076 5.048], 'X||a*', 'Y||b', 'Z||c*',...
  'mineral', 'Moissanite', 'color', 'light blue'),...
  crystalSymmetry('m-3m', [5.448 5.448 5.448], 'mineral', 'Silicon',...
  'color', 'light green'),...
  crystalSymmetry('m-3m', [4.358 4.358 4.358], 'mineral', 'Silicon carbide',...
  'color', 'light red')};

CS{2}.opt.type='hcp';       CS{2}.opt.hcptype='unkown';
CS{3}.opt.type='fcc';
CS{4}.opt.type='fcc';

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'P:\Abdo\EBSD Data\Alex xEBSD\REFEL_3_3_60';

% which files to be imported
fname = [pname '\REFEL_3_3_60.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

