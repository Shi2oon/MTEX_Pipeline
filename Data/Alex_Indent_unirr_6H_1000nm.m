%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3.081 3.081 15.117], 'X||a*', 'Y||b', 'Z||c*',...
  'mineral', 'Moissanite 6H', 'color', 'light blue')};

CS{2}.opt.type='hcp';       CS{2}.opt.hcptype='unkown';

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'P:\Abdo\EBSD Data\Alex xEBSD\unirr_6H_1000nm';

% which files to be imported
fname = [pname '\unirr_6H_1000nm.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

