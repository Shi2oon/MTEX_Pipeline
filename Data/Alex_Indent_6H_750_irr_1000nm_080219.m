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
pname = 'P:\Abdo\EBSD Data\Alex xEBSD\6H_750_irr_1000nm_8-2-19';

% which files to be imported
fname = [pname '\6H_750_irr_1000nm_8-2-19.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

