function [ output_args ] = StrainPlot( Maps )
%STRESSPLOT Summary of this function goes here
%   Detailed explanation goes here

figure
% PH      = [0 1];                 % PH limits
Strain  =  5E-3;                 % Strain range (absolute)
% Stress  =  1.5;                   % Stress range (GPa)
% Rots    =  5E-3;                  %  rots (rad)
% GNDTot  = [14 15.5];              % in log10(lines per square m)

E11  = Maps.crop.E{1,1};
E12  = Maps.crop.E{1,2};
E13  = Maps.crop.E{1,3};
E22  = Maps.crop.E{2,2};
E23  = Maps.crop.E{2,3};
E33  = Maps.crop.E{3,3};
Wo   = Maps.crop.Wo;
GNDs = Maps.crop.GNDs{1,1};
Maxiall = max([E11(:); E12(:); E13(:); E22(:); E23(:); E33(:)]);
Miniall = min([E11(:); E12(:); E13(:); E22(:); E23(:); E33(:)]);
if abs(Maxiall) > Strain;       Maxiall = Strain;       Miniall = -Strain; end

% Remove extreme values from plot
factor = 10;
E11(abs(E11)>factor*nanmean(abs(E11(:)))) = NaN;
E12(abs(E12)>factor*nanmean(abs(E12(:)))) = NaN;
E13(abs(E13)>factor*nanmean(abs(E13(:)))) = NaN;
E22(abs(E22)>factor*nanmean(abs(E22(:)))) = NaN;
E23(abs(E23)>factor*nanmean(abs(E23(:)))) = NaN;
E33(abs(E33)>factor*nanmean(abs(E33(:)))) = NaN;

% minA = min([min(min(E11)) min(min(E12)) min(min(E13)) min(min(E22)) min(min(E23)) min(min(E33))]);
% maxA = max([max(max(E11)) max(max(E12)) max(max(E13)) max(max(E22)) max(max(E23)) max(max(E33))]);
% clim = [minA maxA];

Xvec = Maps.crop.X(1,:);
Yvec = Maps.crop.Y(:,1);

figh = figure(1);colormap jet

h1 = subplot(3,3,1);            imagesc(Xvec,Yvec,E11)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title('\fontsize{16}\epsilon\fontsize{10}11')

h2 = subplot(3,3,2);            imagesc(Xvec,Yvec,E12)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title('\fontsize{16}\epsilon\fontsize{10}12')

h3 = subplot(3,3,3);            imagesc(Xvec,Yvec,E13)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title('\fontsize{16}\epsilon\fontsize{10}13')

h4 = subplot(3,3,5);            imagesc(Xvec,Yvec,E22)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title('\fontsize{16}\epsilon\fontsize{10}22')

h5 = subplot(3,3,6);            imagesc(Xvec,Yvec,E23)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title('\fontsize{16}\epsilon\fontsize{10}23')

h6 = subplot(3,3,9);            imagesc(Xvec,Yvec,E33)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]); 	ylim([min(Yvec) max(Yvec)])
xlabel('x[\mum]');          	ylabel('y[\mum]');
colorbar;                    	caxis([Miniall Maxiall]); 
title('\fontsize{16}\epsilon\fontsize{10}33') %should be close to zero

h7 = subplot(3,3,4);            imagesc(Xvec,Yvec,Wo)
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       title('W')

h8 = subplot(3,3,7);            imagesc(Xvec,Yvec,GNDs); 
set(gca,'Ydir','normal');       axis equal;     axis tight
xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colormap(jet(256));            	%set(gcf,'position',[500,100,950,700]);
set(gca,'ColorScale','log');  	set(gca,'CLim',[10^13 10^15.5]);    
c = colorbar;                  	c.Label.String    = 'log(m/m^{3})';%labelling
title('\rho_G_N_D_s')

pos = get(figh,'position');
set(figh,'position',[pos(1:2)/4 pos(3:4)*2])

% L = max([abs(minA) abs(maxA)]);
% set([h1 h2 h3 h4 h5 h6],'clim',[-L L]);
end

