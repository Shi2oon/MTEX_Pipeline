function [Dir]=GndsCalc(Dir,CS,ebsd,grains)
clc; warning('off'); close all;
Dir.Def = fullfile(Dir.path,'Deformation');     mkdir(Dir.Def);
setMTEXpref('defaultColorMap',WhiteJetColorMap) 

if length(grains.id)<3000
%% denoise orientation data
%noisy orientation data lead to overestimate the GND density we apply sime
% denoising techniques to the data.
F = halfQuadraticFilter;
F.threshold = 1.5*degree;
F.eps = 1e-2;           F.alpha = 0.01;
EbsdDenoised = smooth(ebsd('indexed'),F,'fill',grains);
%%raw
for i=1:length(EbsdDenoised.indexedPhasesId)   
% a key the colorizes according to misorientation angle and axis
% define the color key
ipfKey = ipfHSVKey(EbsdDenoised(EbsdDenoised.mineralList...
    {EbsdDenoised.indexedPhasesId(i)}));
ipfKey.inversePoleFigureDirection = yvector;% reconstruct grains
ipfKey = axisAngleColorKey(EbsdDenoised(EbsdDenoised.mineralList...
    {EbsdDenoised.indexedPhasesId(i)}));
ipfKey.oriRef = grains(EbsdDenoised(EbsdDenoised.mineralList...
    {EbsdDenoised.indexedPhasesId(i)}).grainId).meanOrientation;

plot(EbsdDenoised(EbsdDenoised.mineralList{EbsdDenoised.indexedPhasesId(i)}),...
    ipfKey.orientation2color(EbsdDenoised(EbsdDenoised.mineralList...
    {EbsdDenoised.indexedPhasesId(i)}).orientations),'micronBar','off'); hold on
end
plot(grains.boundary,'linewidth',2); hold off; set(gcf,'position',[500,100,950,700]);
Dir.Save = fullfile(Dir.Def,'Constrained Rotation.png');
saveas(gcf,Dir.Save); close all

%% cal. Gnds
%dislocation density tensor
newMtexFigure('nrows',3,'ncols',3);
for i=1:length(EbsdDenoised.indexedPhasesId)
    Dir.GNDsGrid{i} =EbsdDenoised(EbsdDenoised.mineralList...
                {EbsdDenoised.indexedPhasesId(i)}).gridify;
    kappa=Dir.GNDsGrid{i}.curvature;  % compute the curvature tensor
    alpha = kappa.dislocationDensity;
% The central idea of Pantleon is that the dislocation density tensor is build up
%  by single dislocations with different densities such that the total energy is  
% minimum. Depending on the attomic lattice different dislocattion systems  
% have to be considered. Those principle dislocations are defined
% in MTEX either by their Burgers and line vectors or by
        [dS,~] = decideDS(CS{i}, 0.3); % nu = 0.3; %poisson ratio

%Note that the unit of this tensors is the same as the unit used for describing 
%the length of the unit cell, which is in most cases Angstrom (au). Furthremore,
% we observe that the tensor is given with respect to the crystal reference
% frame while the dislocation densitiy tensors are given with respect to the
% specimen reference frame. Hence, to make them compatible we have to rotate the
% dislocation tensors into the specimen reference frame as well. This is done by
    dSRot = Dir.GNDsGrid{i}.orientations * dS;
    [rho,factor] = fitDislocationSystems(kappa,dSRot);
    Dir.GNDs{i}=factor*sum(abs(rho.*dSRot.u),2);    
    % the restored dislocation density tensors
    alpha = sum(dSRot.tensor .* rho,2);
    % we have to set the unit manualy since it is not stored in rho
    alpha.opt.unit = '1/um';
    kappa = alpha.curvature;

    % cycle through all components of the tensor
    for ii = 1:3
        for j = 1:3
            nextAxis(ii,j)
            plot(Dir.GNDsGrid{i},kappa{ii,j},'micronBar','off'); hold on;
             plot(grains.boundary,'linewidth',2); hold off
        end
    end
    clear kappa factor rho dSRot alpha
end  
% unify the color rage  - you may also use setColoRange equal
% colormap(jet(256));,
setColorRange([-0.005,0.005]);  set(gcf,'position',[200,10,1550,1050]);
Dir.Save = fullfile(Dir.Def,'Rotation Tensors.fig');  saveas(gcf,Dir.Save);
mtexColorbar('title',['Rotation tensors, \omega (rad) with Step Size = '...
    num2str(Dir.StepSize) ' \mum']);
Dir.Save = fullfile(Dir.Def,' Rotation Tensors.png');  saveas(gcf,Dir.Save); 
close all;

%% The total dislocation energy
for i=1:length(EbsdDenoised.indexedPhasesId)
  plot(Dir.GNDsGrid{i},Dir.GNDs{i}); hold on 
  %clear GNDsGrid
end
colormap(jet(256));     set(gcf,'position',[500,100,950,700]);
set(gca,'ColorScale','log'); % this works only starting with Matlab 2018a
set(gca,'CLim',[10^13 10^15.5]);
Dir.Save = fullfile(Dir.Def,'GNDs.fig'); saveas(gcf,Dir.Save); 
% mtexColorMap('hot'); 
plot(grains.boundary,'linewidth',2,'micronbar','on'); hold off
title(['Step Size = ' num2str(Dir.StepSize) '\mum']);
mtexColorbar('title','GNDs density (m/m^{3}), Logarithmic scale','fontsize',20)
Dir.Save = fullfile(Dir.Def,'GNDs.png'); saveas(gcf,Dir.Save); close all

else
fprintf('\n\n No GNDs will be calculated .. because the Array exceeds maximum\n');
fprintf(' array size preference. Creation of arrays greater than this limit\n');
fprintf(' may take a long time and cause MATLAB to become unresponsive.\n\n');  
end
