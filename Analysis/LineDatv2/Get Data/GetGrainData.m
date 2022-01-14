function [Maps,alldata]=GetGrainData(fname,unique)
%% load data
if exist('unique','var') == 0;     unique ='_';     end
Answers = input('Do you wan to use a specific grain (S) or the whole map (W)? ','s');
if strcmpi(Answers, 'S')
    set(0,'DefaultLineMarkerSize',10)
% startup_mtex
try
    load(fname,'Map_RefID','C_voight', 'GND','Map_EBSD_MTEX','MicroscopeData',...
        'Grain_Map_A0_sample','Data', 'Grain_Map_rotation_sample', 'Data_InputMap',...
        'Grain_Map_strain_sample', 'Grain_Map_stress_sample','GrainData','Maps',...
        'Grain_Map_PH2','Grain_Map_MAE2');
catch
    fname = erase(fname,'.mat');
    fname = [fname '_XEBSD.mat'];
    load(fname,'Map_RefID','C_voight', 'GND','Map_EBSD_MTEX','MicroscopeData',...
        'Grain_Map_A0_sample','Data', 'Grain_Map_rotation_sample', 'Data_InputMap',...
        'Grain_Map_strain_sample', 'Grain_Map_stress_sample','GrainData','Maps',...
        'Grain_Map_PH2','Grain_Map_MAE2');
end
    Map = Maps; clear Maps
%% plot to select the boundray
close all;  	warning off;        s3=subplot(1,1,1);
imagesc(Data_InputMap.X_axis,Data_InputMap.Y_axis,Map_RefID); hold on
axis off;           axis image;         axis xy;        s3.YDir='reverse';   
colormap jet;       s3.XDir='reverse';                  
title('Respond in the Command Line')
if isempty(GrainData.RefPoint)
    [GrainData.RefPoint] = to_label(Data_InputMap, Map_RefID);
else
    for i=1:length(GrainData.RefPoint.x)       
        GrainData.RefPoint.prop.labels{i} = num2str(i);     
    end
end
scatter(GrainData.RefPoint.x,GrainData.RefPoint.y,'k','filled');
scatter(GrainData.RefPoint.x,GrainData.RefPoint.y,'w');
labelpoints(GrainData.RefPoint.x,GrainData.RefPoint.y,GrainData.RefPoint.prop.labels);     
hold off;      set(gcf,'position',[30 50 1300 950])
Spec    = input('Which Grain you want to explore?   '); % select
SavingD = fullfile(fileparts(fname),[unique '_Grain no ' num2str(Spec)]);  mkdir(SavingD);

%% save data
A = squeeze(Grain_Map_A0_sample(:,:,Spec,:,:));             % DEFORMAION
W = squeeze(Grain_Map_rotation_sample(:,:,Spec,:,:));       % ROTATION
E = squeeze(Grain_Map_strain_sample(:,:,Spec,:,:));         % STRAIN
S = squeeze(Grain_Map_stress_sample(:,:,Spec,:,:));         % STRESS
% save GNDS PH and MAE
[rowC,colZ] = find(S(:,:,1,1));  % linear indices for nonzero element
Maps.GND    = zeros(size(squeeze(S(:,:,1,1))));
for i=1:length(colZ);   Maps.GND(rowC(i),colZ(i)) = GND.total(rowC(i),colZ(i)); end
Maps.PH  = mean(squeeze(Grain_Map_PH2(:,:,Spec,:)),3);
Maps.MAE = mean(squeeze(Grain_Map_MAE2(:,:,Spec,:)),3);
% Rotation
Maps.W11 = W(:,:,1,1);      Maps.W12 = W(:,:,1,2);      Maps.W13 = W(:,:,1,3);  
Maps.W21 = W(:,:,2,1);      Maps.W22 = W(:,:,2,2);      Maps.W23 = W(:,:,2,3);  
Maps.W31 = W(:,:,3,1);      Maps.W32 = W(:,:,3,2);      Maps.W33 = W(:,:,3,3);  
% Stress
Maps.S11 = S(:,:,1,1);      Maps.S12 = S(:,:,1,2);      Maps.S13 = S(:,:,1,3);  
Maps.S21 = S(:,:,2,1);      Maps.S22 = S(:,:,2,2);      Maps.S23 = S(:,:,2,3);  
Maps.S31 = S(:,:,3,1);      Maps.S32 = S(:,:,3,2);      Maps.S33 = S(:,:,3,3); 
% Strain
Maps.E11 = E(:,:,1,1);      Maps.E12 = E(:,:,1,2);      Maps.E13 = E(:,:,1,3);  
Maps.E21 = E(:,:,2,1);      Maps.E22 = E(:,:,2,2);      Maps.E23 = E(:,:,2,3);  
Maps.E31 = E(:,:,3,1);      Maps.E32 = E(:,:,3,2);      Maps.E33 = E(:,:,3,3); 
% Deformation gradient
Maps.A11 = A(:,:,1,1);      Maps.A12 = A(:,:,1,2);      Maps.A13 = A(:,:,1,3);  
Maps.A21 = A(:,:,2,1);      Maps.A22 = A(:,:,2,2);      Maps.A23 = A(:,:,2,3);  
Maps.A31 = A(:,:,3,1);      Maps.A32 = A(:,:,3,2);      Maps.A33 = A(:,:,3,3);

% stifness:  crystal orientation is defined as the rotation that transforms crystal 
% coordinates, i.e., a description of a vector or a tensor with respect to the crystal
% reference frame, into specimen coordinates, i.e., a desciption of the same object
% with respect to a specimen fixed reference frame.
Maps.Stiffness = StiffnessRot(Map_EBSD_MTEX(sub2ind([MicroscopeData.NROWS,MicroscopeData.NCOLS],...
                              GrainData.RefPoint.prop.yi(Spec),GrainData.RefPoint.prop.xi(Spec)))...
                               .orientations.matrix,C_voight(:,:,Spec));            
Maps.nu  =  Maps.Stiffness(1,2)/(Maps.Stiffness(1,1)+ Maps.Stiffness(1,2)); %meaningless,not used
Maps.E   =  Maps.Stiffness(1,1)*(1-2*Maps.nu)*(1+Maps.nu)/(1-Maps.nu);%meaningless,not used
% Dim
Maps.X   = Data.XSample;    Maps.Y   = Data.YSample;  
Maps.stepsize  =(abs(Maps.X(1,1)-Maps.X(1,2)));         
Maps.Wo  = (1/2).*(Maps.S11.*Maps.E11 + Maps.S12.*Maps.E12 + Maps.S13.*Maps.E13 +...
                   Maps.S21.*Maps.E21 + Maps.S22.*Maps.E22 + Maps.S23.*Maps.E23 +...
                   Maps.S31.*Maps.E31 + Maps.S32.*Maps.E32 + Maps.S33.*Maps.E33);
% units (defualt xEBSD units)
Maps.units.xy = 'um';       Maps.units.S  = 'GPa';         
Maps.units.E  = 'Abs.';     Maps.units.W = 'rad'; 

elseif strcmpi(Answers, 'W')
    [Maps]  = loadingXEBSD(fname);
    SavingD = fullfile(fileparts(fname),[unique '_Full_map']);  mkdir(SavingD);
end

%% Plot selcted
% close all;              s3=subplot(1,1,1);
% imagesc(Data.XSample(1,:),Data.YSample(:,1),squeeze(Grain_Map_stress_sample(:,:,Spec,1,1))); %GPa
% axis image;             set(gca,'Ydir','normal');   %axis off;  
% s3.XDir='reverse';      colormap jet;               caxis([-1.5 1.5]);
% c = colorbar;           c.Label.String = 'GPa';     %labelling             
% s3.YDir='reverse';      set(gcf,'position',[30 50 1300 950])
% title(['\sigma_{11}^{'  num2str(Spec) '}']);      	xlabel('x[\mum]'); ylabel('y[\mum]');      
CroppedPlot(Maps,'S')
saveas(gcf,[SavingD '\Full.png']);     
saveas(gcf,[SavingD '\Full.fig']);     close all

%% crop data
answer = input('Do you want to crop (C) and/or rotate (R) data (C/R/N)? ','s');
if answer == 'C' || answer == 'c'
    [Maps] = Cropping(Maps,SavingD);        
    Saving = [SavingD '\Cropped Data.mat'];
elseif answer == 'R' || answer == 'r'
    [Maps] = Rot2Crop(Maps,SavingD,Answers);
    Saving = [SavingD '\Crop & Rot Data.mat'];
else
    Saving = [SavingD '\Full Data.mat'];
end

%% crack cordinates
try;    Maps = isNaN_Maps(Maps);       end % trim GB
%{
close all; 
    imagesc(Maps.X(1,:),Maps.Y(:,1),Maps.E12); 
    c=colorbar; c.Label.String = ['E_{12} [' Maps.units.xy ']']; 
    caxis([-5e-3 5e-3])
set(gca,'Ydir','normal');	axis image;
title('Answer in the command line');
xlabel(['X [' Maps.units.xy ' ]'],'FontSize',20,'FontName','Times New Roman');          
ylabel(['Y [' Maps.units.xy ' ]'],'FontSize',20,'FontName','Times New Roman');
set(gcf,'WindowStyle','normal')
set(gcf,'position',[30 50 1300 950]);
title('E_{12} :: Select the Crack, start from crack tip');
[Maps.xo,Maps.yo] = ginput(2);
title('E_{12} :: Select the Crack mask, start from crack tip');
[Maps.xm,Maps.ym] = ginput(2); close
%}

%% save and exit
Maps.SavingD = SavingD;
if ~strcmpi(Answers, 'S')
    Maps.results = fname;
    try;    Maps = SawpStif(Maps);  end
end
alldata = [Maps.X(:)   Maps.Y(:)   Maps.E11(:)   Maps.E22(:) Maps.E12(:) ...
                                   Maps.S11(:)   Maps.S22(:) Maps.S12(:)];
save(Saving,'Maps','alldata'); % save
end