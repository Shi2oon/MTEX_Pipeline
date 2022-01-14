function [ output_args ] = StressPlot( Maps )
%STRESSPLOT Summary of this function goes here
%   Detailed explanation goes here

figure

% S11 = Maps.S12_F;
% S12 = Maps.S12_F;
% S13 = Maps.S13_F;
% S22 = Maps.S22_F;
% S23 = Maps.S23_F;
% S33 = Maps.S33_F;

S11  = Maps.crop.S{1,1};
S12  = Maps.crop.S{1,2};
S13  = Maps.crop.S{1,3};
S22  = Maps.crop.S{2,2};
S23  = Maps.crop.S{2,3};
S33  = Maps.crop.S{3,3};
W    = Maps.crop.W;
GNDs = Maps.crop.GNDs;

% Remove extreme values from plot
factor = 10;
S11(abs(S11)>factor*nanmean(abs(S11(:)))) = NaN;
S12(abs(S12)>factor*nanmean(abs(S12(:)))) = NaN;
S13(abs(S13)>factor*nanmean(abs(S13(:)))) = NaN;
S22(abs(S22)>factor*nanmean(abs(S22(:)))) = NaN;
S23(abs(S23)>factor*nanmean(abs(S23(:)))) = NaN;
S33(abs(S33)>factor*nanmean(abs(S33(:)))) = NaN;

minA = min([min(min(S11)) min(min(S12)) min(min(S13)) min(min(S22)) min(min(S23)) min(min(S33))]);
maxA = max([max(max(S11)) max(max(S12)) max(max(S13)) max(max(S22)) max(max(S23)) max(max(S33))]);
clim = [minA maxA];

Xvec = Maps.crop.X(1,:);
Yvec = Maps.crop.Y(:,1);

colormap jet

h1 = subplot(3,3,1);
imagesc(Xvec,Yvec,S11)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('\fontsize{16}\sigma\fontsize{10}11')

h2 = subplot(3,3,2);
imagesc(Xvec,Yvec,S12)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('\fontsize{16}\sigma\fontsize{10}12')

h3 = subplot(3,3,3);
imagesc(Xvec,Yvec,S13)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('\fontsize{16}\sigma\fontsize{10}13')

h4 = subplot(3,3,5);
imagesc(Xvec,Yvec,S22)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('\fontsize{16}\sigma\fontsize{10}22')

h5 = subplot(3,3,6);
imagesc(Xvec,Yvec,S23)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('\fontsize{16}\sigma\fontsize{10}23')

h6 = subplot(3,3,9);
imagesc(Xvec,Yvec,S33)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('\fontsize{16}\sigma\fontsize{10}33') %should be close to zero

h7 = subplot(3,3,4);
imagesc(Xvec,Yvec,W)
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colorbar
title('W')

h8 = subplot(3,3,7);
imagesc(Xvec,Yvec,GNDs); 
set(gca,'Ydir','normal');
axis equal
xlim([min(Xvec) max(Xvec)])
ylim([min(Yvec) max(Yvec)])
colormap(jet(256));                 set(gcf,'position',[500,100,950,700]);
set(gca,'ColorScale','log');        set(gca,'CLim',[10^13 10^15.5]);    
c = colorbar;                       c.Label.String    = 'log';%labelling
title('GNDs')

set(gcf,'position',[800,80,1000,900])

% L = max([abs(minA) abs(maxA)]);
% set([h1 h2 h3 h4 h5 h6],'clim',[-L L]);
end

