%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [2.9 2.9 2.9], 'mineral', 'Ferrite', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\ak13\OneDrive - National Physical Laboratory\Projects\40-G324482 BorgWarner\Cementite 3 samples\EBSD\Liberty';

% which files to be imported
fname = [pname '\liberity.osc'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','osc');

 [ebsd,CS,grains,MisGB,Misanglede,TwinedArea]=GBs(ebsd,erase(fname,'.osc'),CS);
 if length(CS)>1 && length(CS)<10
                if strcmpi(CS{1},'notIndexed')
                    notIndexed(ebsd,path);                      % raw output
                    [ebsdfilled,CS,grainsfilled]  = IndexAndFill(ebsd,CS);	% fill
                end
            else
                csa{1} = CS;    CS = csa;
            end
            ebsdfilled=fill(ebsdfilled,grainsfilled);
            ebsdfilled = ebsdfilled('indexed');
             [ebsdfilled,CSfilled,grainsfilled] = GBs(ebsdfilled,[path '\Smoothed'],CS); 
            ebsd2abaqus(ebsdfilled,fname)                         % Abaqus
            %}
save([erase(fname,'.ctf') '_EBSD.mat']);