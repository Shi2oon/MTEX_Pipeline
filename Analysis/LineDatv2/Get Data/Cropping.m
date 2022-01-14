function [Crop] = Cropping(Maps,SavingD)
% Plots Z (defined at co-ordinates [X],[Y]) and the associated horizontal
% line defined by lineX and lineY
% Asks for user input to crop a region
close all;              fig=subplot(1,1,1);
if isfield(Maps,'W11') == 1
    imagesc(Maps.X(1,:),Maps.Y(:,1),Maps.S11) %GPa
    caxis([-1.5 1.5]); c.Label.String = 'GPa';     %labelling
else
    imagesc(unique(Maps.X),unique(Maps.Y),Maps.E11) %GPa
    caxis([-5e-3 5e-3]); 
    Maps.X = Maps.X';  Maps.Y = Maps.Y';
end
axis image;             set(gca,'Ydir','normal');   %axis off;  
fig.XDir='reverse';     colormap jet;              
c = colorbar;           
fig.YDir='reverse';      set(gcf,'position',[30 50 1300 950])
title('\sigma_{13} :: Select Area to Crop');        ylabel('y-position [\mum]');
xlabel('x-position [\mum]');

[Xcrop,Ycrop] = ginput(2);
Xcrop = [min(Xcrop);max(Xcrop)];
Ycrop = [min(Ycrop);max(Ycrop)];
hold on
plot([Xcrop(1) Xcrop(2) Xcrop(2) Xcrop(1) Xcrop(1)],...
    [Ycrop(1) Ycrop(1) Ycrop(2) Ycrop(2) Ycrop(1)],'color','k')
hold off

%% Data
xLin     = Maps.X(1,:);
[~, index1] = min(abs(xLin-Xcrop(1)));          Xcrop(1) = index1;
[~, index2] = min(abs(xLin-Xcrop(2)));          Xcrop(2) = index2;
yLin     = Maps.Y(:,1); 
[~, indey1] = min(abs(yLin-Ycrop(1)));          Ycrop(1) = indey1;
[~, indey2] = min(abs(yLin-Ycrop(2)));          Ycrop(2) = indey2;

% XY, steps and stifness
Crop.X   = Maps.X(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.Y   = Maps.Y(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.X   = Crop.X - min(min(Crop.X));  	Crop.Y   = Crop.Y - min(min(Crop.Y));
Crop.Stiffness = Maps.Stiffness;        Crop.stepsize = Maps.stepsize;
if (Crop.X(1) - Crop.X(end))>0;         Crop.X = flip(Crop.X,2);         end
if (Crop.Y(1) - Crop.Y(end))>0;         Crop.Y = flip(Crop.Y,1);         end

Crop.nu  =  Crop.Stiffness(1,2)/(Crop.Stiffness(1,1)+ Crop.Stiffness(1,2));
Crop.E   =  Crop.Stiffness(1,1)*(1-2*Crop.nu)*(1+Crop.nu)/(1-Crop.nu);

% units
Crop.units.xy = 'um';       Crop.units.S  = 'GPa';      Crop.units.W = 'rad';    
Crop.units.E  = 'Abs.';     Crop.units.St = 'GPa'; close

% Strain
Crop.E11 = Maps.E11(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E12 = Maps.E12(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E22 = Maps.E22(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));

if isfield(Maps,'W11') == 1
Crop.GND = Maps.GND(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));   % GNDs
% Rotation
Crop.W11 = Maps.W11(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W12 = Maps.W12(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W13 = Maps.W13(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W21 = Maps.W21(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W22 = Maps.W22(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W23 = Maps.W23(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W31 = Maps.W31(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W32 = Maps.W32(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.W33 = Maps.W33(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
% Stress
Crop.S11 = Maps.S11(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S12 = Maps.S12(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S13 = Maps.S13(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S21 = Maps.S21(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S22 = Maps.S22(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S23 = Maps.S23(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S31 = Maps.S31(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S32 = Maps.S32(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.S33 = Maps.S33(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
% Defromation
Crop.A11 = Maps.A11(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A12 = Maps.A12(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A13 = Maps.A13(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A21 = Maps.A21(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A22 = Maps.A22(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A23 = Maps.A23(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A31 = Maps.A31(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A32 = Maps.A32(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.A33 = Maps.A33(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
% strain
Crop.E13 = Maps.E13(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E21 = Maps.E21(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E23 = Maps.E23(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E31 = Maps.E31(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E32 = Maps.E32(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
Crop.E33 = Maps.E33(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));

Crop.Wo  = (1/2).*(Crop.S11.*Crop.E11 + Crop.S12.*Crop.E12 + Crop.S13.*Crop.E13 +...
                   Crop.S21.*Crop.E21 + Crop.S22.*Crop.E22 + Crop.S23.*Crop.E23 +...
                   Crop.S31.*Crop.E31 + Crop.S32.*Crop.E32 + Crop.S33.*Crop.E33);
               
CroppedPlot(Crop,'S')
saveas(gcf,[SavingD '\Cropped.png']);     
saveas(gcf,[SavingD '\Cropped.fig']);     close all
end
             
%%
% close all;              fig = subplot(1,1,1);
% imagesc(Crop.X(1,:),flip(Crop.Y(:,1)),Crop.S11)
% axis image;             set(gca,'Ydir','normal');   % axis off;  
% colormap jet;           colorbar;                   caxis([-1.5 1.5]); 
% c = colorbar;           c.Label.String = 'GPa';     % labelling  
% title('\sigma_{13} Cropped');             	ylabel('y-position [\mum]');
% set(gcf,'position',[30 50 1300 950]);       xlabel('x-position [\mum]');
