function [C]=StiffnessEBSD(ebsd)
% a code to calculate stifness matrix for each grain
% you will need MTEX
% there os an example included .. feel free to run it and to compare the
% results to 'What is the Young’s Modulus of Silicon?', equation 8
% https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5430873
% ref. http://web.mit.edu/16.20/homepage/3_Constitutive/Constitutive_files/module_3_with_solutions.pdf
close all; warning off

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',2*degree);
ebsd(grains(grains.grainSize<=10))   = []; 
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',2*degree);

for iGrain=1:length(grains)
% define the reference frame
if strcmpi(grains(iGrain).CSList{1},'notIndexed')
    CS = grains(iGrain).CSList{2};
else
    CS = grains(iGrain).CSList{1};
end

csGlaucophane = crystalSymmetry(CS.pointGroup,'mineral',CS.mineral);
% getting the stifness values, make sure the name is consistent with the
% function
stiffvalues   = lStiffness(CS.mineral);%in GPa
% define the tensor
CGlaucophane = stiffnessTensor(stiffvalues,csGlaucophane);
C{iGrain}.E  = CGlaucophane.YoungsModulus(vector3d.X);
C{iGrain}.nu = CGlaucophane.PoissonRatio(vector3d.X,vector3d.Z); % in plane
C{iGrain}.G  = CGlaucophane.shearModulus(vector3d.X,vector3d.Y); %in-plane shear
% plotSection(CGlaucophane.PoissonRatio(vector3d.Z),vector3d.Z,'color','interp','linewidth',5)
% mtexColorbar

% %MTEX includes an automatic halfwidth selection algorithm for pecris
% deLaValeePoussinKernel cacluations 
    PsI    = calcKernel(ebsd(grains(iGrain)).orientations); % using all points
    Psi    = calcKernel(grains(iGrain).meanOrientation);     % grain averaged
    [hw]   = erroOPFe(CS,PsI,Psi);          % evulate error and pick hw
    title(['Grain ' num2str(iGrain)]);
%The Voigt, Reuss, and Hill averages for all phases are computed by
odfEpidote = calcODF(ebsd(grains(iGrain)).orientations,hw);

% detail of these methods can be found here
% Voight:
% Reuss: https://doi.org/10.1002/zamm.19290090104
% Hill (average voight and Reuss): https://doi.org/10.1088/0370-1298/65/5/307
[C{iGrain}.Voigt,C{iGrain}.Reuss,C{iGrain}.Hill]=...
    calcTensor(odfEpidote,CGlaucophane);
C{iGrain}.T =(C{iGrain}.Voigt+C{iGrain}.Reuss+C{iGrain}.Hill)/3;
                
% h=[Miller(1,1,0,odfEpidote.CS),Miller(1,1,1,odfEpidote.CS),...
%     Miller(0,0,1,odfEpidote.CS)]; 
% plotPDF(odfEpidote,h); %,'antipodal','COMPLETE'
% CLim(gcm,'equal'); % set equal color range to all plots
% mtexColorbar 

C{iGrain}.R = grains(iGrain).meanOrientation.matrix;
C{iGrain}.xEBSD = xEBSDV3(C{iGrain}.R,stiffvalues);%in GPa
C{iGrain}.Korsunsky = Korsunsky_StiffnessRot(C{iGrain}.R,stiffvalues);%in GPa
C{iGrain}.Dunne = Dunne_StiffnessRot(C{iGrain}.R,stiffvalues);%in GPa
end
end

%%
function DA=xEBSDV3(R,L)
% Lengthscale-dependent, elastically anisotropic, physically-based hcp crystal 
% plasticity: Application to cold-dwell fatigue in Ti alloys
% FPE Dunne, D Rugg, A Walker - International Journal of Plasticity, 2007

%DA acts on
%xx yy zz xy xz yz 
% 
% CEAngs=cos(EAngs);
% SEAngs=sin(EAngs);
% R=[CEAngs(1)*CEAngs(3) - CEAngs(2)*SEAngs(1)*SEAngs(3), CEAngs(3)*SEAngs(1) + CEAngs(1)*CEAngs(2)*SEAngs(3), SEAngs(2)*SEAngs(3)
%     - CEAngs(1)*SEAngs(3) - CEAngs(2)*CEAngs(3)*SEAngs(1), CEAngs(1)*CEAngs(2)*CEAngs(3) - SEAngs(1)*SEAngs(3), CEAngs(3)*SEAngs(2);
%     SEAngs(1)*SEAngs(2), -CEAngs(1)*SEAngs(2), CEAngs(2)];

TsA=[...
     R(1,1)^2,   R(1,2)^2,   R(1,3)^2,         2*R(1,1)*R(1,2),         2*R(1,1)*R(1,3),         2*R(1,2)*R(1,3);
     R(2,1)^2,   R(2,2)^2,   R(2,3)^2,         2*R(2,1)*R(2,2),         2*R(2,1)*R(2,3),         2*R(2,2)*R(2,3);
     R(3,1)^2,   R(3,2)^2,   R(3,3)^2,         2*R(3,1)*R(3,2),         2*R(3,1)*R(3,3),         2*R(3,2)*R(3,3);
     R(1,1)*R(2,1), R(1,2)*R(2,2), R(1,3)*R(2,3), R(1,1)*R(2,2) + R(1,2)*R(2,1), R(1,1)*R(2,3) + R(1,3)*R(2,1), R(1,2)*R(2,3) + R(1,3)*R(2,2);
     R(1,1)*R(3,1), R(1,2)*R(3,2), R(1,3)*R(3,3), R(1,1)*R(3,2) + R(1,2)*R(3,1), R(1,1)*R(3,3) + R(1,3)*R(3,1), R(1,2)*R(3,3) + R(1,3)*R(3,2);     
     R(2,1)*R(3,1), R(2,2)*R(3,2), R(2,3)*R(3,3), R(2,1)*R(3,2) + R(2,2)*R(3,1), R(2,1)*R(3,3) + R(2,3)*R(3,1), R(2,2)*R(3,3) + R(2,3)*R(3,2);];
 
TeA=[...
     R(1,1)^2,   R(1,2)^2,   R(1,3)^2,         R(1,1)*R(1,2),         R(1,1)*R(1,3),         R(1,2)*R(1,3);
     R(2,1)^2,   R(2,2)^2,   R(2,3)^2,         R(2,1)*R(2,2),         R(2,1)*R(2,3),         R(2,2)*R(2,3);
     R(3,1)^2,   R(3,2)^2,   R(3,3)^2,         R(3,1)*R(3,2),         R(3,1)*R(3,3),         R(3,2)*R(3,3);
     2*R(1,1)*R(2,1), 2*R(1,2)*R(2,2), 2*R(1,3)*R(2,3), R(1,1)*R(2,2) + R(1,2)*R(2,1), R(1,1)*R(2,3) + R(1,3)*R(2,1), R(1,2)*R(2,3) + R(1,3)*R(2,2);
     2*R(1,1)*R(3,1), 2*R(1,2)*R(3,2), 2*R(1,3)*R(3,3), R(1,1)*R(3,2) + R(1,2)*R(3,1), R(1,1)*R(3,3) + R(1,3)*R(3,1), R(1,2)*R(3,3) + R(1,3)*R(3,2);     
     2*R(2,1)*R(3,1), 2*R(2,2)*R(3,2), 2*R(2,3)*R(3,3), R(2,1)*R(3,2) + R(2,2)*R(3,1), R(2,1)*R(3,3) + R(2,3)*R(3,1), R(2,2)*R(3,3) + R(2,3)*R(3,2);];
%%
 DA=inv(TsA)*L*TeA;
end

function DA=Korsunsky_StiffnessRot(R,L)
%% Salvati, E., Sui, T. and Korsunsky, A.M., 2016.
% Uncertainty quantification of residual stress evaluation by the FIB-DIC
% ring-core method due to elastic anisotropy effects.
% International Journal of Solids and Structures, 87, pp.61-69. 
R11 = R(1,1);   R12 = R(1,2);   R13 = R(1,3);
R21 = R(2,1);   R22 = R(2,2);   R23 = R(2,3);
R31 = R(3,1);   R32 = R(3,2);   R33 = R(3,3);
TsA = [R11^2,   R21^2,   R31^2,         2*R21*R31,         2*R11*R31,         2*R11*R21 
       R12^2,   R22^2,   R32^2,         2*R22*R32,         2*R12*R32,         2*R12*R22 
       R13^2,   R23^2,   R33^2,         2*R23*R33,         2*R13*R33,         2*R13*R23 
       R12*R13, R22*R23, R32*R33, R22*R33 + R23*R32, R12*R33 + R13*R32, R12*R23 + R13*R22 
       R11*R13, R21*R23, R31*R33, R21*R33 + R23*R31, R11*R33 + R13*R31, R11*R23 + R13*R21 
       R11*R12, R21*R22, R31*R32, R21*R32 + R22*R31, R11*R32 + R12*R31, R11*R22 + R12*R21];
        
TeA = [R11^2,     R21^2,     R31^2,           R21*R31,           R11*R31,           R11*R21
       R12^2,     R22^2,     R32^2,           R22*R32,           R12*R32,           R12*R22
       R13^2,     R23^2,     R33^2,           R23*R33,           R13*R33,           R13*R23
       2*R12*R13, 2*R22*R23, 2*R32*R33, R22*R33 + R23*R32, R12*R33 + R13*R32, R12*R23 + R13*R22
       2*R11*R13, 2*R21*R23, 2*R31*R33, R21*R33 + R23*R31, R11*R33 + R13*R31, R11*R23 + R13*R21
       2*R11*R12, 2*R21*R22, 2*R31*R32, R21*R32 + R22*R31, R11*R32 + R12*R31, R11*R22 + R12*R21];
 DA=inv(TsA)*L*TeA;
end

function DA=Dunne_StiffnessRot(R,L)
%% Salvati, E., Sui, T. and Korsunsky, A.M., 2016.
% Uncertainty quantification of residual stress evaluation by the FIB-DIC
% ring-core method due to elastic anisotropy effects.
% International Journal of Solids and Structures, 87, pp.61-69. 
R11 = R(1,1);   R12 = R(1,2);   R13 = R(1,3);
R21 = R(2,1);   R22 = R(2,2);   R23 = R(2,3);
R31 = R(3,1);   R32 = R(3,2);   R33 = R(3,3);
TsA = [   R11^2,   R21^2,   R31^2,         2*R11*R21,         2*R21*R31,         2*R31*R11 
          R12^2,   R22^2,   R32^2,         2*R12*R22,         2*R22*R32,         2*R32*R12 
          R13^2,   R23^2,   R33^2,         2*R13*R23,         2*R23*R33,         2*R33*R13 
          R11*R12, R21*R22, R31*R32, R11*R22 + R12*R21, R21*R32 + R22*R31, R31*R12 + R32*R11 
          R12*R13, R22*R23, R32*R33, R23*R12 + R13*R22, R22*R33 + R23*R32, R32*R13 + R33*R12 
          R13*R11, R23*R21, R33*R31, R13*R21 + R11*R23, R23*R31 + R21*R33, R33*R11 + R31*R13];
        
TeA = [R11^2,     R21^2,     R31^2,           R11*R31,           R21*R31,           R31*R11
       R12^2,     R22^2,     R32^2,           R12*R32,           R22*R32,           R32*R12
       R13^2,     R23^2,     R33^2,           R13*R33,           R23*R33,           R33*R13
       2*R11*R12, 2*R21*R22, 2*R31*R32, R11*R22 + R12*R21, R21*R32 + R22*R31, R31*R12 + R32*R11
       2*R12*R13, 2*R22*R23, 2*R32*R33, R23*R12 + R13*R22, R22*R33 + R23*R32, R32*R13 + R33*R12
       2*R13*R11, 2*R23*R21, 2*R33*R31, R13*R21 + R11*R23, R23*R31 + R21*R33, R33*R11 + R31*R13];
 DA=inv(TsA)*L*TeA;
end

function [value]=erroOPFe(CS,PsI,Psi)
modelODF = fibreODF(Miller(1,1,1,crystalSymmetry(CS.lattice)),xvector);
ori=calcOrientations(modelODF,10000);
hw = 1:20; % you can change this for higher percision

e = zeros(size(hw));
for i = 1:length(hw)
  odf = calcODF(ori,'halfwidth',hw(i)*degree,'silent');
  e(i)= calcError(modelODF, odf);
end

  odf = calcODF(ori,'halfwidth',Psi.halfwidth,'silent');
  psIErr= calcError(modelODF, odf);
  odf = calcODF(ori,'halfwidth',PsI.halfwidth,'silent');
  psiErr= calcError(modelODF, odf);

  figure
plot(hw,e,'--ob','DisplayName','Estimated'); hold on
xlabel('halfwidth, \Theta (Degrees)')
ylabel('Esimation Error (%)')
legend('location','southeast'); 
set(gcf,'position',[500,200,1000,750])
line([Psi.halfwidth*180/pi Psi.halfwidth*180/pi],[0 psIErr],...
            'Color','r','LineStyle','--','HandleVisibility','off')
line([0 Psi.halfwidth*180/pi],[psIErr psIErr],...
            'Color','r','LineStyle','--','DisplayName','Grains')
line([PsI.halfwidth*180/pi PsI.halfwidth*180/pi],[0 psiErr],...
            'Color','k','LineStyle','--','HandleVisibility','off')
line([0 PsI.halfwidth*180/pi],[psiErr psiErr],...
            'Color','k','LineStyle','--','DisplayName','EBSD')
        hold off     
[fj]=ind2sub(size(e),find(e==min(e)));
HW=hw(fj);
%optimum half width value
if abs(HW-Psi.halfwidth*180/pi)<abs(HW-PsI.halfwidth*180/pi)
    value=Psi; 
else
    value=PsI; 
end
end

function [stiffvalues] = lStiffness(materials)
%New code for stiffness matrices - CMM 2019. Gives the correct stiffness matrix for the phases. Most data either from xebsdv2,
%or from crosscourt materials.txt (probably Simons and Wagg).
phasestiffness(1).name='Silver';
phasestiffness(1).stiff=[123.99,93.67,	93.67,	0,  0,	0;
    93.67,	123.99,	93.67,  0,	0,	0;
    93.67,	93.67, 123.99,	0,	0,	0;
    0,	0,	0,46.12, 0,	0;
    0,	0,  0,	0,46.12,  0;
    0,  0,	0,	0,	0,46.12];

phasestiffness(2).name='Corundum';
phasestiffness(2).stiff=[497.350000000000,163.970000000000,112.200000000000,-23.5800000000000,0,0;
    163.970000000000,497.350000000000,112.200000000000,23.5800000000000,0,0;
    112.200000000000,112.200000000000,499.110000000000,0,0,0;
    -23.5800000000000,23.5800000000000,0,147.390000000000,0,0;
    0, 0,0,0,147.390000000000,-23.5800000000000;
    0, 0,0,0,-23.5800000000000,166.690000000000];

phasestiffness(3).name='Aluminium';
phasestiffness(3).stiff=    [106.750000000000,60.4100000000000,60.4100000000000,0,0,0;
    60.4100000000000,106.750000000000,60.4100000000000,0,0,0;
    60.4100000000000,60.4100000000000,106.750000000000,0,0,0;
    0,0,0,28.3400000000000,0,0;
    0,0,0,0,28.3400000000000,0;
    0,0,0,0,0,28.3400000000000];

phasestiffness(4).name='Diamond';
phasestiffness(4).stiff=[1040,170,170,0,0,0;
    170,1040,170,0,0,0;
    170,170,1040,0,0,0;
    0,0,0,550,0,0;
    0,0,0,0,550,0;
    0,0,0,0,0,550];

phasestiffness(5).name='Chromium';
phasestiffness(5).stiff=[339.800000000000,58.6000000000000,58.6000000000000,0,0,0;
    58.6000000000000,339.800000000000,58.6000000000000,0,0,0;
    58.6000000000000,58.6000000000000,339.800000000000,0,0,0;
    0,0,0,99,0,0;
    0,0,0,0,99,0;
    0,0,0,0,0,99];

phasestiffness(6).name='Copper';
phasestiffness(6).stiff=[168.300000000000,122.100000000000,122.100000000000,0,0,0;
    122.100000000000,168.300000000000,122.100000000000,0,0,0;
    122.100000000000,122.100000000000,168.300000000000,0,0,0;
    0,0,0,75.7000000000000,0,0;
    0,0,0,0,75.7000000000000,0;
    0,0,0,0,0,75.7];

phasestiffness(7).name='Lithium';
phasestiffness(7).stiff=[13.5,	11.44,	11.44,	0	,0	,0	;
    11.44	,13.5	,11.44	,0	,0	,0	;
    11.44	,11.44	,13.5	,0	,0	,0	;
    0	,0	,0	,8.78	,0	,0	;
    0	,0	,0	,0	,8.78	,0	;
    0	,0	,0	,0	,0	,8.78];

phasestiffness(8).name='Iron-alpha';
phasestiffness(8).stiff=[230,   135,    135,    0,  0,  0;
                         135,   230,    135,    0,  0,  0;
                         135,   135,    230,    0,  0,  0;
                         0,     0,      0,      117,0,  0;
                         0,     0,      0,      0,  117,0;
                         0,     0,      0,      0,  0,  117];

phasestiffness(9).name='Iron-Austenite';
phasestiffness(9).stiff=[231.4, 134.7,  134.7,  0,      0,      0;
                         134.7, 231.4,  134.7,  0,      0,      0;
                         134.7, 134.7,  231.4,  0,      0,      0;
                         0,     0,      0,      116.4,  0,      0;
                         0,     0,      0,      0,      116.4,  0;
                         0,     0,      0,      0,      0,      116.4];

phasestiffness(10).name='Iron-beta';
%no stiffness matrix
phasestiffness(11).name='Iron-delta';
%no stiffness matrix

phasestiffness(12).name='Hematite';
phasestiffness(12).stiff=[242.430000000000,54.6400000000000,15.4200000000000,-12.4700000000000,0,0;
    54.6400000000000,242.430000000000,15.4200000000000,12.4700000000000,0,0;
    15.4200000000000,15.4200000000000,227.340000000000,0,0,0;
    -12.4700000000000,12.4700000000000,0,85.6900000000000,0,0;
    0,0,0,0,85.6900000000000,-12.4700000000000;
    0,0,0,0,-12.4700000000000,93.8950000000000];

phasestiffness(13).name='Magnetite';
phasestiffness(13).stiff=[273,106,106,0,0,0;
    106,273,106,0,0,0;
    106,106,273,0,0,0;
    0,0,0,97.1000000000000,0,0;
    0,0,0,0,97.1000000000000,0;
    0,0,0,0,0,97.1000000000000];

phasestiffness(14).name='Magnesium';
phasestiffness(14).stiff=[59.5000000000000,26.1200000000000,21.8000000000000,0,0,0;
    26.1200000000000,59.5000000000000,21.8000000000000,0,0,0;
    21.8000000000000,21.8000000000000,61.5500000000000,0,0,0;
    0,0,0,16.3500000000000,0,0;
    0,0,0,0,16.3500000000000,0;
    0,0,0,0,0,16.6900000000000];

phasestiffness(15).name='Manganese-gamma';
%no stiffness matrix

phasestiffness(16).name='Molybdnenum-bcc';
phasestiffness(16).stiff=[463.700000000000,157.800000000000,157.800000000000,0,0,0;
    157.800000000000,463.700000000000,157.800000000000,0,0,0;
    157.800000000000,157.800000000000,463.700000000000,0,0,0;
    0,0,0,109.200000000000,0,0;
    0,0,0,0,109.200000000000,0;
    0,0,0,0,0,109.200000000000];

phasestiffness(17).name='Halite';
phasestiffness(17).stiff=[49.4700000000000,12.8800000000000,12.8800000000000,0,0,0;
    12.8800000000000,49.4700000000000,12.8800000000000,0,0,0;
    12.8800000000000,12.8800000000000,49.4700000000000,0,0,0;
    0,0,0,12.8700000000000,0,0;
    0,0,0,0,12.8700000000000,0;
    0,0,0,0,0,12.8700000000000];

phasestiffness(18).name='GaAs';
phasestiffness(18).stiff=[48.8000000000000,41.4000000000000,41.4000000000000,0,0,0;
    41.4000000000000,48.8000000000000,41.4000000000000,0,0,0;
    41.4000000000000,41.4000000000000,48.8000000000000,0,0,0;
    0,0,0,14.8000000000000,0,0;
    0,0,0,0,14.8000000000000,0;
    0,0,0,0,0,14.8000000000000]; %DO CHECK WHETHER THESE ARE CORRECT - will depend on manufacturing route.

phasestiffness(19).name='Nickel-cubic';
phasestiffness(19).stiff=[249 152 152 0 0 0;
    152 249 152 0 0 0;
    152 152 249 0 0 0;
    0 0 0 124 0 0;
    0 0 0 0 124 0;
    0 0 0 0 0 124];

phasestiffness(20).name='Olivine';
phasestiffness(20).stiff=[324,59,79,0,0,0;
    59,198,78,0,0,0;
    79,78,249,0,0,0;
    0,0,0,66.7000000000000,0,0;
    0,0,0,0,81,0;
    0,0,0,0,0,79.3000000000000];

phasestiffness(21).name='Quartz';
phasestiffness(21).stiff=[86.8000000000000,7.04000000000000,11.9100000000000,-18.0400000000000,0,0;
    7.04000000000000,86.8000000000000,11.9100000000000,18.0400000000000,0,0;
    11.9100000000000,11.9100000000000,105.750000000000,0,0,0;
    -18.0400000000000,18.0400000000000,0,58.2000000000000,0,0;
    0,0,0,0,58.2000000000000,-18.0400000000000;
    0,0,0,0,-18.0400000000000,39.8800000000000];

phasestiffness(22).name='Silicon'; %the orthotropic stifness matrix 
% ref: What is the Young's Modulus for Silicon?
phasestiffness(22).stiff=  [165.7,  63.9,   63.9,   0,      0,      0;
                            63.9,   165.7,  63.9,   0,      0,      0;
                            63.9,   63.9,   165.7,  0,      0,      0;
                            0,      0,      0,      79.6,   0,      0;
                            0,      0,      0,      0,      79.6,   0;
                            0,      0,      0,      0,      0,      79.6];

phasestiffness(23).name='Titanium-alpha';
phasestiffness(23).stiff=[162.4,92,69,0,0,0;
    92,162.4,69,0,0,0;
    69,69,180.7,0,0,0;
    0,0,0,46.7,0,0;
    0,0,0,0,46.7,0;
    0,0,0,0,0,35.2];


phasestiffness(24).name='Titanium-beta'; %https://doi.org/10.3390/met8100822
phasestiffness(24).stiff=[134,110,110,0,0,0;
    110,134,110,0,0,0;
    110,110,110,0,0,0;
    0,0,0,55,0,0;
    0,0,0,0,55,0;
    0,0,0,0,0,55];

phasestiffness(25).name='Baddeleyite'; %WILLI PABST, GABRIELA TICHÁ, EVA GREGOROVÁ, 2004
phasestiffness(25).stiff=[327,100,62,0,0,0;
    100,327,62,0,0,0;
    62,62,264,0,0,0;
    0,0,0,64,0,0;
    0,0,0,0,64,0;
    0,0,0,0,0,64];

phasestiffness(26).name='Zirconium-bcc'; %"Lattice dynamics of hcp and bcc zirconium", Jerel L. Zarestky, 1979
phasestiffness(26).stiff=[143.4,72.8,65.3,0,0,0;
    72.8,143.4,65.3,0,0,0;
    65.3,65.3,164.8,0,0,0;
    0,0,0,32,0,0;
    0,0,0,0,32,0;
    0,0,0,0,0,75.3];

phasestiffness(27).name='Zirconium-hcp'; %xebsd2
phasestiffness(27).stiff=[143.4,72.8,65.3,0,0,0;
    72.8,143.4,65.3,0,0,0;
    65.3,65.3,164.8,0,0,0;
    0,0,0,32,0,0;
    0,0,0,0,32,0;
    0,0,0,0,0,35.3];

phasestiffness(28).name='Moissanite';
phasestiffness(28).stiff=[504,  98,     56, 0	,0	,0	;
                          98,   504,    56, 0	,0	,0	;
                          56,   56,     566,0	,0	,0	;
                          0,    0,      0,  170	,0	,0	;
                          0,    0,      0,  0	,170,0	;
                          0,    0,      0,  0	,0	,154];

phasestiffness(29).name='Tungsten'; %crosscourt, not xebsd2
phasestiffness(29).stiff=[522.39, 204.37, 204.37,   0,      0,      0;
                          204.37, 522.39, 204.37,   0,      0,      0;
                          204.37, 204.37, 522.39,   0,      0,      0;
                           0	, 0,        0,      160.83, 0,      0;
                           0	, 0,        0,      0,      160.83, 0;
                           0	, 0,        0,      0,      0,      160.83];

% Titanium aluminide (1/1)
phasestiffness(30).name  = 'TiAl-Gamma'; 
phasestiffness(30).stiff = [200	62	84	0	0	0
                            62	200	84	0	0	0
                            84	84	174	0	0	0
                            0	0	0	112	0	0
                            0	0	0	0	112	0
                            0	0	0	0	0	41];
                        
% Aluminium titanium (1/3)
phasestiffness(31).name  = 'Ti3Al'; 
phasestiffness(31).stiff = [192	85	63	0	0	0
                            85	192	63	0	0	0
                            63	63	234	0	0	0
                            0	0	0	60	0	0
                            0	0	0	0	60	0
                            0	0	0	0	0	54];
                        
% titanium Aluminium  (1/3)
phasestiffness(32).name  = 'TiAl3'; 
phasestiffness(32).stiff = [189	64	64	0	0	0
                            64	189	64	0	0	0
                            64	64	189	0	0	0
                            0	0	0	73	0	0
                            0	0	0	0	73	0
                            0	0	0	0	0	73];
               
% Modify names
 if  strcmpi(materials,'Ferrite, bcc (New)') || strcmpi(materials,'Ferrite')
	materials = 'Iron-alpha';
elseif strcmpi(materials,'Austenite, fcc (New)') || strcmpi(materials, 'Austenite')
	materials = 'Iron-Austenite';
elseif strcmpi(materials,'Moissanite 6H')
    materials = 'Moissanite';
 end

%
t = strcmp({phasestiffness(:).name}, materials); % find the field with the right name
stiffvalues=phasestiffness(t).stiff; %use the field for the stiffness matrix

end