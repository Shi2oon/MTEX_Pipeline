%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [2.866 2.866 2.866], 'mineral', 'Ferrite', 'color', 'light blue'),...
  crystalSymmetry('m-3m', [3.66 3.66 3.66], 'mineral', 'Austenite', 'color', 'light red')};

CS{2}.opt.type='bcc';
CS{3}.opt.type='fcc';

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'P:\Abdo\EBSD Data\19-03-10';

% which files to be imported
fname = [pname '\19-03-10.ctf'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

