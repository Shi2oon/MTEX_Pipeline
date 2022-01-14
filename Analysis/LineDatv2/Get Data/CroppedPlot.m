function CroppedPlot(Maps,Vtype)
set(0,'defaultAxesFontSize',16);    set(0,'DefaultLineMarkerSize',12)  
if Vtype == 'G';            Vtype = 'S';        end
%% Arrange data and limits
        % normalise units to GPa
        if      strcmp(Maps.units.S,'KPa');         sf = 1e-6;
        elseif  strcmp(Maps.units.S,'MPa');         sf = 1e-3;
        elseif strcmp(Maps.units.S,'GPa');          sf = 1;   
        elseif strcmp(Maps.units.S,'Pa');           sf = 1e-9;  end
        if      Maps.units.xy == 'um'; Maps.units.xy = '\mum';  end
        
    if Vtype == 'A'
        E11  = Maps.A11;        E12  = Maps.A12;        E13  = Maps.A13;        
        E22  = Maps.A22;        E23  = Maps.A23;        E33  = Maps.A33;
        unit = 'Abs';           LAB  = 'A';
        Maxiall = 0.9;          Miniall = 1.1;
    elseif Vtype == 'S'        
        E11  = Maps.S11.*sf;	E12  = Maps.S12.*sf;
        E13  = Maps.S13.*sf;	E22  = Maps.S22*sf;
        E23  = Maps.S23.*sf;	E33  = Maps.S33.*sf;
        unit = 'GPa';           LAB  = '\sigma';
        Maxiall = 1.5;           Miniall = -1.5;
    elseif Vtype == 'E'
        E11  = Maps.E11;        E12  = Maps.E12;
        E13  = Maps.E13;        E22  = Maps.E22;
        E23  = Maps.E23;        E33  = Maps.E33;
        unit = 'abs';           LAB  = '\epsilon';
        Maxiall = 5E-3;         Miniall = -5E-3;
    elseif Vtype == 'W'
        E11  = Maps.W11;        E12  = Maps.W12;
        E13  = Maps.W13;        E22  = Maps.W22;
        E23  = Maps.W23;        E33  = Maps.W33;
        unit = 'rad';           LAB  = '\omega';
        Maxiall = 5E-3;         Miniall = -5E-3;
    else
        error('Incorrect visualisation type');
    end
Wo   = Maps.Wo.*sf;
GNDs = log10(Maps.GND);      GNDTot  = [13 15.5];
% Maxiall = max([E11(:); E12(:); E13(:); E22(:); E23(:); E33(:)]);
% Miniall = min([E11(:); E12(:); E13(:); E22(:); E23(:); E33(:)]);
Xvec = unique(Maps.X);       
Yvec = unique(Maps.Y);

%% Remove extreme values from plot
factor = 10;
E11(abs(E11)>factor*nanmean(abs(E11(:)))) = NaN;
E12(abs(E12)>factor*nanmean(abs(E12(:)))) = NaN;
E13(abs(E13)>factor*nanmean(abs(E13(:)))) = NaN;
E22(abs(E22)>factor*nanmean(abs(E22(:)))) = NaN;
E23(abs(E23)>factor*nanmean(abs(E23(:)))) = NaN;
E33(abs(E33)>factor*nanmean(abs(E33(:)))) = NaN;

%% Ploting
% Maxiall = 1.5;        Miniall=-1.5;
close all
figh = figure(1);               colormap jet
h1 = subplot(3,3,1);            imagesc(Xvec,Yvec,E11)
axis image;axis xy;             h1.YDir='reverse';      h1.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_1_1'])

h2 = subplot(3,3,2);            imagesc(Xvec,Yvec,E12)
axis image;axis xy;             h2.YDir='reverse';      h2.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_1_2'])

h3 = subplot(3,3,3);            imagesc(Xvec,Yvec,E13)
axis image;axis xy;             h3.YDir='reverse';      h3.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_1_3'])

h4 = subplot(3,3,5);            imagesc(Xvec,Yvec,E22)
axis image;axis xy;             h4.YDir='reverse';      h4.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_2_2'])

h5 = subplot(3,3,6);            imagesc(Xvec,Yvec,E23)
axis image;axis xy;             h5.YDir='reverse';      h5.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colorbar;                       caxis([Miniall Maxiall]); 
title(['\fontsize{16}' LAB '\fontsize{10}_2_3'])

h6 = subplot(3,3,9);            imagesc(Xvec,Yvec,E33)
axis image;axis xy;             h6.YDir='reverse';      h6.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]); 	ylim([min(Yvec) max(Yvec)])
xlabel('x[\mum]');          	ylabel(['y[' Maps.units.xy ']']);
c = colorbar;                   caxis([Miniall Maxiall]);
c.Label.String = unit;%labelling
title(['\fontsize{16}' LAB '\fontsize{10}_3_3'])%should be close to zero

h7 = subplot(3,3,4);            imagesc(Xvec,Yvec,Wo)
axis image;axis xy;             h7.YDir='reverse';      h7.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
caxis([0 1.5]);
colorbar;                       title('W')

h8 = subplot(3,3,7);            imagesc(Xvec,Yvec,GNDs); 
axis image;axis xy;             h8.YDir='reverse';      h8.XDir='reverse'; 
% set(gca,'Ydir','normal');       axis equal;     axis tight
% xlim([min(Xvec) max(Xvec)]);    ylim([min(Yvec) max(Yvec)])
colormap(jet(256));            	set(gca,'CLim',GNDTot);    
c = colorbar;                  	c.Label.String = 'log10(m/m^{3})';%labelling
title('\rho_G_N_D_s')

% pos = get(figh,'position');
% set(figh,'position',[pos(1:2)/4 pos(3:4)*2])
set(figh,'position',[30 50 1100 1550])

set([h1 h2 h3 h4 h5 h6],'clim',[Miniall Maxiall]);
end

