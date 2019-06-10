%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [3.66 3.66 3.66], 'mineral', 'Austenite', 'color', 'light blue'),...
  crystalSymmetry('m-3m', [2.866 2.866 2.866], 'mineral', 'Ferrite', 'color', 'light green'),...
  crystalSymmetry('m-3m', [2.866 2.866 2.866], 'mineral', 'Iron', 'color', 'light red')};

CS{2}.opt.type='fcc';
CS{3}.opt.type='bcc';
CS{4}.opt.type='bcc';

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'P:\Abdo\EBSD Data\18-12-15';

% which files to be imported
fname = [pname '\18-12-15.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

