function [sS,LoSf]=Local_SF(CS,ebsd,grains,path)
clc; warning('off'); close all; 
DirDef=fullfile(path,'Deformation');  mkdir(DirDef);

%% Calc.
for i=1:length(ebsd.indexedPhasesId)
    [~,sS{i}] = decideDS(CS{ebsd.indexedPhasesId(i)},0.3); % find slip system
   
    sigma  = stressTensor.uniaxial(vector3d.X); % or use xvector
    LSF{i} = sS{i}.SchmidFactor(inv(ebsd(ebsd.mineralList...
                {ebsd.indexedPhasesId(i)}).orientations)*sigma); 
    [LSF{i},bMaxId{i}]=max(LSF{i},[],2); % index of the most active slip system - largest b
    minLSF(i) = min(LSF{i});
    if length(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}))==1
        [LSF{i},bMaxId{i}]=max(LSF{i},[],1);
    end

    plot(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}),LSF{i}); hold on
end

plot(grains.boundary); hold off; 
colormap(jet(256)); 
%mtexColorMap white2black;  % colorize grains according to  factor
mtexColorbar('title','LSF','fontsize',20); 
setColorRange([min(minLSF),0.5]); 
DirSave=fullfile(DirDef,'LSF EBSD.fig'); saveas(gcf,DirSave);    
DirSave=fullfile(DirDef,'LSF EBSD.png'); saveas(gcf,DirSave);   close all 

% re-arrange form cells to a one map
[lsf] = cells2map(LSF,ebsd);
LoSf.Cell  = LSF;
LoSf.total = lsf;