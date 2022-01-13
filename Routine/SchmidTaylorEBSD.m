function [sS,Schmid,SFM,mP,TraceSy]=SchmidTaylorEBSD(CS,ebsd,Misanglede,grains,Dirpath)
clc; warning('off'); close all; 
DirDef=fullfile(Dirpath,'Deformation');  mkdir(DirDef);

%% Calc.
if length(grains)~=1 
    Operation={'Schmid','Taylor'};
for k=1:length(Operation)
for i=1:length(ebsd.indexedPhasesId)
    [~,sS{i}]=decideDS(CS{i},0.3); % find slip system
    
if k==1     % compute Schmid factor for all slip systems (Resolved shear stress)
    sigma = stressTensor.uniaxial(vector3d.Z); % or use xvector
    SF{k,i} = sS{i}.SchmidFactor(inv(grains(ebsd.mineralList...
                {ebsd.indexedPhasesId(i)}).meanOrientation)*sigma); 
    [SF{k,i},bMaxId{k,i}]=max(SF{k,i},[],2); % index of the most active slip system - largest b  
    if length(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}))==1
        [SF{k,i},bMaxId{k,i}]=max(SF{k,i},[],1);
    end
    
elseif k==2     % compute Taylor factor for all orientations
    q = 0; % some strain or q = 0.5; % consider plane strain
    epsilon=strainTensor(diag([1 -q -(1-q)])); %only xx yy zz
    [SF{k,i},b,mori{i}] = calcTaylor(inv(grains(ebsd.mineralList...
                {ebsd.indexedPhasesId(i)}).meanOrientation)*epsilon,sS{i});
    [~,bMaxId{k,i}]=max(b,[],2); % index of the most active slip system - largest b
end 

    % rotate the moste active slip system in specimen coordinates
    sSGrains{k,i} = grains(ebsd.mineralList{ebsd.indexedPhasesId(i)})...
        .meanOrientation .* sS{i}(bMaxId{k,i});
    plot(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}),SF{k,i}); hold on;  

    % visualize slip direction and slip plane for each grain
    quiver(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        sSGrains{k,i}.b,'autoScaleFactor',0.5,'displayName','Burgers vector')
    quiver(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
        sSGrains{k,i}.trace,'autoScaleFactor',0.5,'displayName','slip plane trace')
%     quiver(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
%         cross(sSGrains{i}.n,zvector),'displayName','slip plane')
%     quiver(grains(ebsd.mineralList{ebsd.indexedPhasesId(i)}),...
%         sSGrains{i}.b,'displayName','slip direction')

    DN = sS{i}(bMaxId{k,i});        hkl=DN.n.hkl;       uvw=DN.b.uvw;
    Angles = orientation('map',Miller(sSGrains{k,i}.b,CS{i}),...
                Miller(sSGrains{k,i}.n,CS{i})).angle./degree;
try
    SFM{k,i} = table(hkl,uvw,Angles,SF{k,i},'VariableNames',...
                    {[ebsd.mineralList{ebsd.indexedPhasesId(i)} '_hkil'],...
                    [ebsd.mineralList{ebsd.indexedPhasesId(i)} '_uvtw'],...
                    'Angle',[Operation{k} '_Factor']});
    %[Dir.SFMDebat{k,i}]=debatableTrace(CS{i},hkl,uvw);
catch err
    warning(err.message); 
    SFM{k,i} = table(hkl,uvw,Angles,SF{k,i},'VariableNames',...
                    {['Material_' num2str(i) '_hkil'],...
                    ['Material_' num2str(i) '_uvtw'],...
                    'Angle',[Operation{k} '_Factor']});
end
    end

%set(gcf,'position',[500,100,950,700]); 
hold off; colormap(jet(256)); 
%mtexColorMap white2black;  % colorize grains according to  factor
mtexColorbar('title',[Operation{k} ' Factor'],'fontsize',20); 
setColorRange([0,0.5+4.5*(k-1)]); 
DirSave=fullfile(DirDef,[Operation{k} ' EBSD.png']); saveas(gcf,DirSave); 
DirSave=fullfile(DirDef,[Operation{k} ' EBSD.fig']); saveas(gcf,DirSave); close all 

%% set new annotation style to display RD and ND
for i=1:length(ebsd.indexedPhasesId)
    plot(sSGrains{k,i}.b,'smooth'); mtexColorbar;  %,'complete','upper'
    DirSave = fullfile(DirDef,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                ' ' Operation{k} ' ODF.png']); saveas(gcf,DirSave); close all
    if k==1 % calculate schmid factor  for all slip systems
       SFa = sS{i}.SchmidFactor;           [SFMax,Schmid{i}] = max(abs(SFa,[],2)); 
       plot(SFMax,'complete','upper');     mtexColorbar; 
       DirSave = fullfile(DirDef,[ebsd.mineralList{ebsd.indexedPhasesId(i)}...
                        ' MaxSF.png']); saveas(gcf,DirSave); close all
%     elseif k==2 % taylor
%            TaylorInverse(mori{i},SF{k,i},DirDef,ebsd.mineralList{ebsd.indexedPhasesId(i)});
    end
    
    if length(ebsd.indexedPhasesId)==1;   SumIt=sSGrains{k,i}.b;
    elseif i==1;                          SumIt=sSGrains{k,i}.b;
    else;                                 SumIt=[SumIt; sSGrains{k,i}.b];
    end
end

plot(SumIt,'smooth');                   mtexColorbar; %,'complete','upper'
DirSave = fullfile(DirDef,['Sum all phases '  Operation{k} ' ODF.png']); 
saveas(gcf,DirSave); close all

if k==1 %m' calculations
        %mPSlip(grains,sSGrains{1,:},sS,Dir.Def) 5does not work
        %SlipTransmission(ebsd,sSGrains,Dir.Def,grains);
        [TraceSy] = findslipplane(SFM,Misanglede,0); %best fit
        try
            [mP]  = SlipTransmission2(ebsd,sS,DirDef); 
        catch
            mP =[];
        end
end
end
else
    fprintf('there is no boundray to to calculate global Schmid and Taylor factors\n');
    fprintf(' Try calculating local Schmid factor\n');
    sS = []; Schmid= []; SFM =[]; mP =[]; TraceSy=[];
end