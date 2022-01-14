function [var] = LoadEBSD(DirxEBSD)
% this function takes data from xEBSD and then gives the user chance to
% selctr the crack location, rotate the crack and crop the crack area
% urrounding the crack. the output area in mm for x and y        
DirDef     = [fileparts(DirxEBSD) '\' date '_Profile_Lines'];          
mkdir(DirDef); 
[Maps]     = loadingXEBSD(DirxEBSD);

var.xy_input_unit   = 'um';         % (um) default for xEBSD ;
var.S_input_unit    = 'GPa';        % xEBSD default  
var.W_input_unit    = 'rad';        var.E_input_unit    = 'Abs.';
UserSelectHorizLine = true;         DisplayFigure       = true;
UserCropData        = true;
% Which component to visualise for user input? A{Vi,Vj}
V.i = 1;            V.j = 2;            V.type = 'G';

fprintf(1,'\nOriginal Data Size:%.0f x %.0f (%.0f data points)\n',...
    size(Maps.X,1),size(Maps.X,2),size(Maps.X,1)*size(Maps.X,2));

    % 'Displacement Gradient Tensor' where A(i,j) = du_i/dx_j
    % A = E (strain tensor) + W (rotation tensor)
    try 
        Maps.A = {  Maps.A11 Maps.A12 Maps.A13;...
                    Maps.A21 Maps.A22 Maps.A23;...
                    Maps.A31 Maps.A23 Maps.A33};
    cath
    Maps.A = {Maps.E11             Maps.W12+Maps.E12    Maps.W13+Maps.E13; ...
              Maps.W21+Maps.E12    Maps.E22             Maps.W23+Maps.E23;
              Maps.W31+Maps.E13    Maps.W32+Maps.E23    Maps.E33};
    end      
    Maps.W = {Maps.W11             Maps.W12             Maps.W13;...
              Maps.W21             Maps.W22             Maps.W23;...
              Maps.W31             Maps.W32             Maps.W33};
    
    for i=1:3
        for j=1:3
            Maps.GNDs{i,j} = Maps.GND; % just creat an array of GNDs
        end
    end
    
    % Convert to Pa
    if          strcmp(var.S_input_unit,'KPa')
                sf = 1e3;
    elseif      strcmp(var.S_input_unit,'MPa')
                sf = 1e6;
    elseif strcmp(var.S_input_unit,'GPa')
                sf = 1e9;
    else
                sf = 1;
    end
        Maps.S = {Maps.S11.*sf Maps.S12.*sf Maps.S13.*sf;...
            Maps.S12.*sf Maps.S22.*sf Maps.S23.*sf;...
            Maps.S13.*sf Maps.S23.*sf Maps.S33.*sf};
        var.S_input_unit    = 'Pa';
    
    Maps.E = {Maps.E11 Maps.E12 Maps.E13;...
        Maps.E12 Maps.E22 Maps.E23;...
        Maps.E13 Maps.E23 Maps.E33};
    
    % Maps.W = 1/2{SijEij}
    Maps.Wo = (1/2).*(Maps.S{1,1}.*Maps.E{1,1} + Maps.S{2,1}.*Maps.E{2,1} ...
        + Maps.S{3,1}.*Maps.E{3,1} +...
        Maps.S{2,1}.*Maps.E{2,1} + Maps.S{2,2}.*Maps.E{2,2} + ...
        Maps.S{2,3}.*Maps.E{2,3} +...
        Maps.S{3,1}.*Maps.E{3,1} + Maps.S{3,2}.*Maps.E{3,2} +...
        Maps.S{3,3}.*Maps.E{3,3});

%% Find Stepsize
% Scale the X and Y axes to get lengths in [um]
stepsize = Maps.stepsize * 0.001; % convert um into mm
var.stepsize=stepsize;
V.unit   = 'mm'; %units for plotting
var.xy_input_unit = V.unit;
Maps.X   = Maps.X .* 0.001;
Maps.Y   = Maps.Y .* 0.001;

%% DEFINE HORIZONTAL LINE
if UserSelectHorizLine
    % Take user input to define horizontal line
    if     V.type == 'A'
        [ptX,ptY] =  selectHorizLine(Maps.X,Maps.Y,Maps.A{V.i,V.j},V);
    elseif V.type == 'S'
        [ptX,ptY] =  selectHorizLine(Maps.X,Maps.Y,Maps.S{V.i,V.j},V);
    elseif V.type == 'E'
        [ptX,ptY] =  selectHorizLine(Maps.X,Maps.Y,Maps.E{V.i,V.j},V);
    elseif V.type == 'G'
        [ptX,ptY] =  selectHorizLine(Maps.X,Maps.Y,Maps.GNDs{V.i,V.j},V);
    elseif V.type == 'W'
        [ptX,ptY] =  selectHorizLine(Maps.X,Maps.Y,Maps.W{V.i,V.j},V);
    else
        error('Incorrect visualisation type');
    end
else
    % OR use default values
    ptX = [max(max((Maps.X))); min(min((Maps.X)))];
    ptY = [max(max((Maps.Y))); max(max((Maps.Y)))];
end

theta = atan((ptY(2)-ptY(1))/(ptX(2)-ptX(1)));
if abs(theta*180/pi-90)<=3
    theta = pi/2;
elseif abs(theta*180/pi-45)<=3
    theta = pi/4;
elseif abs(theta*180/pi-270)<=3
    theta = pi*3/4;
end

% fprintf('Is the crack is witthin 90 to 270 (anti-clockwise) Y/N?:  ');
% isDisp = input('','s');
% if isDisp=='Y' || isDisp=='y'  
%     theta = theta + pi; % rotates by 180 degrees
% end
% deg = theta*180/pi;
close all
% X,Y are the x and y co-ordinates of the original data points, defined
% with respect to the original frame of reference
X = Maps.X(:);              Y = Maps.Y(:);
a = DirectionCosine(theta);

%% Rotate the locations of the data points
% Define a new set of points, with respect to the original axes, but whose
% locations are rotated by an angle theta about the origin.
Xnew   = a(1,1).*X + a(1,2)*Y;            Ynew = a(2,1).*X + a(2,2)*Y;
Xnew   = double(Xnew);                    Ynew = double(Ynew);
ptXnew = a(1,1).*ptX + a(1,2)*ptY;      ptYnew = a(2,1).*ptX + a(2,2)*ptY;

% create a coarse grid of points to visualise data
i = (min(Xnew):stepsize:max(Xnew));
j = (min(Ynew):stepsize:max(Ynew));
% xq and yq are the co-ordinates of a grid parellel to the crack,
% defined with respect to the original frame of reference.
[xq,yq] = meshgrid(i,j);
xq      = double(xq);                       yq = double(yq);
% interpolate data onto this new grid of xq,yq to allow a contour plot to
% be made
[Maps]  = interpolateData(Xnew,Ynew,Maps,xq,yq);

%% Perform tensor transformation to new, rotated, co-ordinate system
% Displacement Gradient Tensor:
[Maps.txf.A]    = componentTensorTransform(Maps.rot.A,a);
% Stress Tensor:
[Maps.txf.S]    = componentTensorTransform(Maps.rot.S,a);
% Strain Tensor:
[Maps.txf.E]    = componentTensorTransform(Maps.rot.E,a);
% GNDs:
[Maps.txf.GNDs] = componentTensorTransform(Maps.rot.GNDs,a);
% Rotation Tensor:
[Maps.txf.W]   = componentTensorTransform(Maps.rot.W,a);

%% CROP THE DATA
if UserCropData
    % Get User Input to crop the required data
    if     V.type == 'A'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.A{V.i,V.j},...
            ptXnew,ptYnew,V);
    elseif V.type == 'S'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.S{V.i,V.j},...
            ptXnew,ptYnew,V);
    elseif V.type == 'E'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.E{V.i,V.j},...
            ptXnew,ptYnew,V);
    elseif V.type == 'G'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.GNDs{V.i,V.j},...
            ptXnew,ptYnew,V);
    elseif V.type == 'W'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.GNDs{V.i,V.j},...
            ptXnew,ptYnew,V);
    else
        error('Incorrect visualisation type');
    end
else
    % or use default crop values...
    selXcrop = [min(min((Maps.X))); max(max((Maps.X)))];
    selYcrop = [min(min((Maps.Y))); max(max((Maps.Y)))];
end
close all
% Generate crop Mask
cropMask                   = xq;
cropMask(xq<min(selXcrop)) = 0;
cropMask(xq>max(selXcrop)) = 0;
cropMask(yq<min(selYcrop)) = 0;
cropMask(yq>max(selYcrop)) = 0;
cropMask(cropMask~=0)      = 1;

[Ycrop, Xcrop] = find(cropMask~=0);
Xcrop          = [min(Xcrop) max(Xcrop)];
Ycrop          = [min(Ycrop) max(Ycrop)];

% Crop the data
% Crop the x-coordinates
Maps.crop.X = xq(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop));
% Crop the y-coordinates
Maps.crop.Y = yq(min(Ycrop):max(Ycrop),min(Xcrop):max(Xcrop)); 
for i = 1:3
    for j = 1:3
        [Maps.crop.A{i,j}]    = Crop(Maps.txf.A{i,j},Xcrop,Ycrop);
        [Maps.crop.S{i,j}]    = Crop(Maps.txf.S{i,j},Xcrop,Ycrop);
        [Maps.crop.E{i,j}]    = Crop(Maps.txf.E{i,j},Xcrop,Ycrop);
        [Maps.crop.GNDs{i,j}] = Crop(Maps.txf.GNDs{i,j},Xcrop,Ycrop);
        [Maps.crop.W{i,j}]    = Crop(Maps.txf.W{i,j},Xcrop,Ycrop);
    end
end
Maps.crop.Wo =  (1/2).*(Maps.crop.S{1,1}.*Maps.crop.E{1,1} +...
    Maps.crop.S{2,1}.*Maps.crop.E{2,1} + Maps.crop.S{3,1}.*Maps.crop.E{3,1} +...
    Maps.crop.S{2,1}.*Maps.crop.E{2,1} + Maps.crop.S{2,2}.*Maps.crop.E{2,2} +...
    Maps.crop.S{2,3}.*Maps.crop.E{2,3} +...
    Maps.crop.S{3,1}.*Maps.crop.E{3,1} + Maps.crop.S{3,2}.*Maps.crop.E{3,2} +...
    Maps.crop.S{3,3}.*Maps.crop.E{3,3});

% Shift the X and Y axes to give values starting at zero
Maps.crop.Xsc = Maps.crop.X - min(Maps.crop.X(:));
Maps.crop.Ysc = Maps.crop.Y - min(Maps.crop.Y(:));

fprintf(1,'Cropped Data Size:%.0f x %.0f (%.0f data points)',...
    size(Maps.crop.X,1),size(Maps.crop.X,2),size(Maps.crop.X,1)*size(Maps.crop.X,2));
var.Save = [DirDef '\Cropping.png'];

%% PLOT FIGURE SHOWING CROPPED DATA
if DisplayFigure
    Xvec = Maps.crop.Xsc(1,:);
    Yvec = Maps.crop.Ysc(:,1);
    figure
    if V.type == 'A'
        imagesc(Xvec,Yvec,Maps.crop.A{V.i,V.j})
    elseif V.type == 'S'
        imagesc(Xvec,Yvec,Maps.crop.S{V.i,V.j})
    elseif V.type == 'E'
        imagesc(Xvec,Yvec,Maps.crop.E{V.i,V.j})
    elseif V.type == 'G'
        imagesc(Xvec,Yvec,log10(Maps.crop.GNDs{V.i,V.j}))
        colormap(jet(256));            	set(gca,'CLim',[14 15.5]); 
    elseif V.type == 'W'
        imagesc(Xvec,Yvec,Maps.crop.W{V.i,V.j})
    else
        error('Incorrect visualisation type');
    end
    % hold on
    % plot([min(Maps.crop.X(:));ptXnew(2)],ptYnew,'color','y') 
    % plots horizontal line
    % hold off
    set(gca,'YDir','normal')
    axis equal; axis tight
    str = ['Cropped Data [Displaying the ',V.type,'_',num2str(V.i),...
        '_',num2str(V.j),'^n^e^w component, with respect to the new axes)'];
    title(str)
    xlim([min(Xvec) max(Xvec)])
    ylim([min(Yvec) max(Yvec)])
    colorbar
    xlabel(['x-position [',V.unit,']']);
    ylabel(['y-position [',V.unit,']']);
else
end

%StressPlot(Maps)
CroppedPlot(Maps,V.type)
var.Save = [DirDef '\Croped Maps.fig'];     saveas(gcf,var.Save); close all
var.Save = [DirDef '\Croped Maps.png'];     saveas(gcf,var.Save); close all
%% BUILD EBSDdata ARRAY
var.X   =  Maps.crop.Xsc;          var.Y   =  Maps.crop.Ysc;
var.GND =  Maps.crop.GNDs{1,1};    Maps.Wo  =  Maps.crop.Wo;
var.PH_2=  Maps.crop.GNDs{1,3};

var.A11 =  Maps.crop.A{1,1};
var.A12 =  Maps.crop.A{1,2};       var.A13 =  Maps.crop.A{1,3};
var.A21 =  Maps.crop.A{2,1};       var.A22 =  Maps.crop.A{2,2};
var.A23 =  Maps.crop.A{2,3};       var.A31 =  Maps.crop.A{3,1};   
var.A32 =  Maps.crop.A{3,2};       var.A33 =  Maps.crop.A{3,3};

var.S11 =  Maps.crop.S{1,1};       var.S12 =  Maps.crop.S{1,2}; 
var.S13 =  Maps.crop.S{1,3};       var.S22 =  Maps.crop.S{2,2};   
var.S23 =  Maps.crop.S{2,3};       

var.E11 =  Maps.crop.E{1,1};       var.E12 =  Maps.crop.E{1,2}; 
var.E13 =  Maps.crop.E{1,3};       var.E22 =  Maps.crop.E{2,2};   
var.E23 =  Maps.crop.E{2,3};       var.E33 =  Maps.crop.E{3,3};

var.W12 =  Maps.crop.W{1,2};       var.W21 =  Maps.crop.W{2,1};
var.W13 =  Maps.crop.W{1,3};       var.W31 =  Maps.crop.W{3,1}; 
var.W23 =  Maps.crop.W{2,3};       var.W32 =  Maps.crop.W{3,2}; 

var.Dir =  DirDef;                 var.Stiffness  =  Maps.Stiffness;
var.nu  =  Maps.Stiffness(1,2)/(Maps.Stiffness(1,1)+Maps.Stiffness(1,2));
var.E   =  Maps.Stiffness(1,1)*(1-2*var.nu)*(1+var.nu)/(1-var.nu); 

%% Data fo J-MAN
% [1x 2y 3GNDs 4A11  5A12  6A13  7A21  8A22  9A23  10A31 11A32 12A33 13S11 14S12 15S13  
%  16S22 17S23 18E11 19E12 20E13 21E22 22E23 23E33 24W12 25W13 26W21 27W23 28W31 29W32]
EBSDdata = [Maps.crop.Xsc(:)    Maps.crop.Ysc(:)    Maps.crop.GNDs{1,1}(:)...
            Maps.crop.A{1,1}(:) Maps.crop.A{1,2}(:) Maps.crop.A{1,3}(:)... % DGT
            Maps.crop.A{2,1}(:) Maps.crop.A{2,2}(:) Maps.crop.A{2,3}(:)...
            Maps.crop.A{3,1}(:) Maps.crop.A{3,2}(:) Maps.crop.A{3,3}(:)...
            ...
            Maps.crop.S{1,1}(:) Maps.crop.S{1,2}(:) Maps.crop.S{1,3}(:)... % stress
            Maps.crop.S{2,2}(:) Maps.crop.S{2,3}(:) ...
            ...
            Maps.crop.E{1,1}(:) Maps.crop.E{1,2}(:) Maps.crop.E{1,3}(:)... % strain
            Maps.crop.E{2,2}(:) Maps.crop.E{2,3}(:) Maps.crop.E{3,3}(:)...
            ...
            Maps.crop.W{1,2}(:)	Maps.crop.W{2,1}(:)	Maps.crop.W{1,3}(:)... % Rotation
            Maps.crop.W{3,1}(:)	Maps.crop.W{2,3}(:)	Maps.crop.W{3,2}(:)];
        
EBSDdata(isnan(EBSDdata)) = 0;  % Replace NaN values with 0
var.EBSD = EBSDdata;
% 'alldata' file [x y exx eyy exy]
alldata  = [Maps.crop.Xsc(:)    Maps.crop.Ysc(:) Maps.crop.E{1,1}(:) ...
                Maps.crop.E{2,2}(:) Maps.crop.E{1,2}(:)];
var.J_MAN = alldata;
input_unit.xy = var.xy_input_unit;      input_unit.S  = var.S_input_unit;
input_unit.W  = var.W_input_unit;       input_unit.E  = var.E_input_unit;
%% save
clearvars -except EBSDdata alldata input_unit var
Maps = var; 
save([var.Dir '\Cropped_Data.mat'],'Maps');
save([var.Dir '\JMAN_Data.mat'],'EBSDdata','alldata','input_unit');
end