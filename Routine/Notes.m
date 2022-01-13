% Notes
% documentation will change next month
% mtwx/issues >> bug tracker
% help command-I-do-not-understand .. the ebsd community is working better
% to organise itself bla ba bla ... astroebsd/mtex rid of commmerical indexing 
% ask about EDXD data ODFs + hcp + m'

% grain2d
% Bingham, kent, texture modelling, hexagonal matrix/grid support
% x y coordinate convention need to defined  == is it argus map
% crystal symmetry .. 
% mtex github update commoand

import_wizard('EBSD')
%rientation * crystal direction = specimen direction
plotPDF(ebsd('q').orientations,hs) %better tahn ods

%%
oM   = ipfHSVKey(ebsd('q').CS);
refv = oM.inversePoleFigureDirection;
col  = oM.orientation2color(ebsd('q').orientations);
plot(ebsd('q'),col)
nextAxis
plotIPDF(ebsd('q').orientations,col,refv,'MarkerSize',2) % how to but the legend as a picture
nextAxis
plotPDF(ebsd('q').orientations,col,hs(1:2))
%C:\Users\scro3511\Downloads\MTEX EBSD 5.2\demo\EBSD2019_workshops_ mtex\upload\intro

%%
pattern1=flipud(double(imread('tif'))); 