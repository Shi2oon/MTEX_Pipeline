function CroppedPlot(Maps,Vtype)
set(0,'defaultAxesFontSize',16);    set(0,'DefaultLineMarkerSize',12)  
%% Arrange data and limits
    if Vtype == 'A'
        E11  = Maps.crop.A{1,1};        E12  = Maps.crop.A{1,2};
        E13  = Maps.crop.A{1,3};        E22  = Maps.crop.A{2,2};
        E23  = Maps.crop.A{2,3};        E33  = Maps.crop.A{3,3};
        unit = 'GPa';                   LAB  = 'A';
    elseif Vtype == 'S'
        E11  = Maps.crop.S{1,1}.*1e-9;	E12  = Maps.crop.S{1,2}.*1e-9;
        E13  = Maps.crop.S{1,3}.*1e-9;	E22  = Maps.crop.S{2,2}.*1e-9;
        E23  = Maps.crop.S{2,3}.*1e-9;	E33  = Maps.crop.S{3,3}.*1e-9;
        unit = 'GPa';                   LAB  = '\sigma';
    elseif Vtype == 'E'
        E11  = Maps.crop.E{1,1};        E12  = Maps.crop.E{1,2};
        E13  = Maps.crop.E{1,3};        E22  = Maps.crop.E{2,2};
        E23  = Maps.crop.E{2,3};        E33  = Maps.crop.E{3,3};
        unit = 'abs';                   LAB  = '\epsilon';
    elseif Vtype == 'W'
        E11  = Maps.crop.W{1,1};        E12  = Maps.crop.W{1,2};
        E13  = Maps.crop.W{1,3};        E22  = Maps.crop.W{2,2};
        E23  = Maps.crop.W{2,3};        E33  = Maps.crop.W{3,3};
        unit = 'rad';                   LAB  = '\omega';
    else
        error('Incorrect visualisation type');
    end
Wo   = Maps.crop.Wo.*1e-9;
GNDs = log10(Maps.crop.GNDs{1,1});      GNDTot  = [14 15.5];
Maxiall = max([E11(:); E12(:); E13(:); E22(:); E23(:); E33(:)]);
Miniall = min([E11(:); E12(:); E13(:); E22(:); E23(:); E33(:)]);
Xvec = Maps.crop.Xsc(1,:)*1e3;       
Yvec = Maps.crop.Ysc(:,1)*1e3;

%% Remove extreme values from plot
factor = 10;
E11(abs(E11)>factor*nanmean(abs(E11(:)))) = NaN;
E12(abs(E12)>factor*nanmean(abs(E12(:)))) = NaN;
E13(abs(E13)>factor*nanmean(abs(E13(:)))) = NaN;
E22(abs(E22)>factor*nanmean(abs(E22(:)))) = NaN;
E23(abs(E23)>factor*nanmean(abs(E23(:)))) = NaN;
E33(abs(E33)>factor*nanmean(abs(E33(:)))) = NaN;

%% Ploting
Maxiall = 1.5;        Miniall=-1.5;
close all
figh = figure(1);               colormap jet
h1 = subplot(3,3,1);            imagesc(Xvec,Yvec,E11)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_1_1'])

h2 = subplot(3,3,2);            imagesc(Xvec,Yvec,E12)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_1_2'])

h3 = subplot(3,3,3);            imagesc(Xvec,Yvec,E13)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_1_3'])

h4 = subplot(3,3,5);            imagesc(Xvec,Yvec,E22)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_2_2'])

h5 = subplot(3,3,6);            imagesc(Xvec,Yvec,E23)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_2_3'])

h6 = subplot(3,3,9);            imagesc(Xvec,Yvec,E33)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]); 	ylim([min(Yvec) max(Yvec)])
xlabel('x[\mum]');          	ylabel('y[\mum]');
c = colorbar;                   caxis([Miniall Maxiall]);
c.Label.String = unit;%labelling
title(['\fontsize{16}' LAB '\fontsize{10}33'])%should be close to zero

h7 = subplot(3,3,4);            imagesc(Xvec,Yvec,Wo)
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
caxis([0 1.5]);
colorbar;                       title('W')

h8 = subplot(3,3,7);            imagesc(Xvec,Yvec,GNDs); 
set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colormap(jet(256));            	set(gca,'CLim',GNDTot);    
c = colorbar;                  	c.Label.String = 'log10(m/m^{3})';%labelling
title('\rho_G_N_D_s')

pos = get(figh,'position');
set(figh,'position',[pos(1:2)/4 pos(3:4)*2])

set([h1 h2 h3 h4 h5 h6],'clim',[Miniall Maxiall]);
end

