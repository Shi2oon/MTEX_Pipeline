function [Dir]=StiffnessEBSD(Dir,CS,ebsd)
close all
Dir.Def=fullfile(Dir.path,'Deformation');  mkdir(Dir.Def);

setMTEXpref('defaultColorMap',WhiteJetColorMap) 

for i=1:length(ebsd.indexedPhasesId)
%% Glaucophane elastic stiffness (Cij) Tensor in GPa Bezacier, L., Reynard,
% B., Bass, J.D., Wang, J., and Mainprice, D. (2010) Elasticity of glaucophane
% and seismic properties of high-pressure low-temperature oceanic rocks in 
% subduction zones. Tectonophysics, 494, 201-210.

% define the tensor coefficients
MGlaucophane =....
  [[122.28   45.69   37.24   0.00   2.35   0.00];...
  [  45.69  231.50   74.91   0.00  -4.78   0.00];...
  [  37.24   74.91  254.57   0.00 -23.74   0.00];...
  [   0.00    0.00    0.00  79.67   0.00   8.89];...
  [   2.35   -4.78  -23.74   0.00  52.82   0.00];...
  [   0.00    0.00    0.00   8.89   0.00  51.24]];
% define the reference frame
csGlaucophane = crystalSymmetry(CS{i}.pointGroup,'mineral',CS{i}.mineral);
% define the tensor
CGlaucophane = stiffnessTensor(MGlaucophane,csGlaucophane);

%% Epidote elastic stiffness (Cij) Tensor in GPa Aleksandrov, K.S., Alchikov,
% U.V., Belikov, B.P., Zaslavskii, B.I. and Krupnyi, A.I.: 1974 'Velocities
% of elastic waves in minerals at atmospheric pressure and increasing the 
% precision of elastic constants by means of EVM (in Russian)', Izv. Acad. 
% Sci. USSR, Geol. Ser.10, 15-24.

% define the tensor coefficients
MEpidote =....
  [[211.50    65.60    43.20     0.00     -6.50     0.00];...
  [  65.60   239.00    43.60     0.00    -10.40     0.00];...
  [  43.20    43.60   202.10     0.00    -20.00     0.00];...
  [   0.00     0.00     0.00    39.10      0.00    -2.30];...
  [  -6.50   -10.40   -20.00     0.00     43.40     0.00];...
  [   0.00     0.00     0.00    -2.30      0.00    79.50]];
% define the reference frame
csEpidote= crystalSymmetry(CS{i}.pointGroup,'mineral',CS{i}.mineral);

%% define the tensor
CEpidote = stiffnessTensor(MEpidote,csEpidote);
ebsdStiff=ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)});

%The Voigt, Reuss, and Hill averages for all phases are computed by
odfEpidote=calcODF(ebsdStiff.orientations,Dir.hw);
[CVoigt,CReuss,CHill]=calcTensor(odfEpidote,CGlaucophane,CEpidote);
Dir.StiffnessT{i}=(CVoigt+CReuss+CHill)/3;

h=[Miller(1,1,0,odfEpidote.CS),Miller(1,1,1,odfEpidote.CS),...
    Miller(0,0,1,odfEpidote.CS)]; 
plotPDF(odfEpidote,h); %,'antipodal','COMPLETE'
%CLim(gcm,'equal'); % set equal color range to all plots
mtexColorbar 
Dir.Save = fullfile(Dir.PoleF,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
    ' Stiffness.png']);
saveas(gcf,Dir.Save); close all
end