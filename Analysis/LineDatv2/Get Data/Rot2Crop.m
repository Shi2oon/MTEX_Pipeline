function [var] = Rot2Crop(Maps,SavingD,answers)
% this function takes data from xEBSD and then gives the user chance to
% selctr the crack location, rotate the crack and crop the crack area
% urrounding the crack. the output area in mm for x and y
% if answers is 'S' this means the rotation is done prependicluar to the chosen axes
% if answers is anything else this means rotation will be by the selected incline

UserSelectHorizLine = true;     DisplayFigure       = true;
UserCropData        = true;
% Which component to visualise for user input? A{Vi,Vj}
V.i = 1;            V.j = 3;            V.type = 'S';
V.unit = Maps.units.xy;

fprintf(1,'\nOriginal Data Size:%.0f x %.0f (%.0f data points)\n',...
    size(Maps.X,1),size(Maps.X,2),size(Maps.X,1)*size(Maps.X,2));

    % 'Displacement Gradient Tensor' where A(i,j) = du_i/dx_j
    % A = E (strain tensor) + W (rotation tensor)
    if isfield(Maps,'A11')==1 
        Maps.A = {  Maps.A11 Maps.A12 Maps.A13;...
                    Maps.A21 Maps.A22 Maps.A23;...
                    Maps.A31 Maps.A23 Maps.A33};
    else
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
    
                sf = 1;

        Maps.S = {Maps.S11.*sf Maps.S12.*sf Maps.S13.*sf;...
            Maps.S12.*sf Maps.S22.*sf Maps.S23.*sf;...
            Maps.S13.*sf Maps.S23.*sf Maps.S33.*sf};
    
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
end

theta = atan((ptY(2)-ptY(1))/(ptX(2)-ptX(1)));
% if ~exist('answers','var')                
    answers = 'W';
% elseif answers == 'S' || answers == 's';    theta = theta+deg2rad(90); end
if abs(round(abs(rad2deg(theta))-90))<=4
    theta = sign(theta)*deg2rad(90);
elseif abs(round(abs(rad2deg(theta))-0))<=4
    theta = 0;
elseif abs(round(abs(rad2deg(theta))-45))<=4
    theta = sign(theta)*deg2rad(45);
end

% X,Y are the x and y co-ordinates of the original data points, defined
% with respect to the original frame of reference
X = Maps.X(:);              Y = Maps.Y(:);
a = DirectionCosine(theta);      % edited by Abdo 22.10.19

%% Rotate the locations of the data points
% Define a new set of points, with respect to the original axes, but whose
% locations are rotated by an angle theta about the origin.
Xnew   = a(1,1).*X + a(1,2)*Y;            Ynew = a(2,1).*X + a(2,2)*Y; 
Xnew   = double(Xnew);                    Ynew = double(Ynew);
ptXnew = a(1,1).*ptX + a(1,2)*ptY;      ptYnew = a(2,1).*ptX + a(2,2)*ptY;

% create a coarse grid of points to visualise data
i = (min(Xnew):Maps.stepsize:max(Xnew));
j = (min(Ynew):Maps.stepsize:max(Ynew));
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
            ptXnew,ptYnew,V,answers);
    elseif V.type == 'S'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.S{V.i,V.j},...
            ptXnew,ptYnew,V,answers);
    elseif V.type == 'E'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.E{V.i,V.j},...
            ptXnew,ptYnew,V,answers);
    elseif V.type == 'G'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.GNDs{V.i,V.j},...
            ptXnew,ptYnew,V,answers);
    elseif V.type == 'W'
        [selXcrop,selYcrop,~] = selectCrop(xq,yq,Maps.txf.GNDs{V.i,V.j},...
            ptXnew,ptYnew,V,answers);
    else
        error('Incorrect visualisation type');
    end
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
% if size(Maps.crop.Y) ~= Maps.crop.E{1,1} end
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
        imagesc(Xvec,Yvec,real(log10(Maps.crop.GNDs{V.i,V.j})))
        colormap(jet(256));            	set(gca,'CLim',[13 15.5]); 
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
    axis equal
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

%% BUILD EBSDdata ARRAY
var.X   =  Maps.crop.Xsc;          var.Y   =  Maps.crop.Ysc;
var.GND =  Maps.crop.GNDs{1,1};    var.Wo  =  Maps.crop.Wo;
var.PH_2=  Maps.crop.GNDs{1,3};

var.A11 =  Maps.crop.A{1,1};    var.A12 =  Maps.crop.A{1,2};   	var.A13 =  Maps.crop.A{1,3};
var.A21 =  Maps.crop.A{2,1};  	var.A22 =  Maps.crop.A{2,2};    var.A23 =  Maps.crop.A{2,3};       
var.A31 =  Maps.crop.A{3,1};    var.A32 =  Maps.crop.A{3,2};  	var.A33 =  Maps.crop.A{3,3};

var.S11 =  Maps.crop.S{1,1};	var.S12 =  Maps.crop.S{1,2};	var.S13 =  Maps.crop.S{1,3};
var.S21 =  Maps.crop.S{2,1};	var.S22 =  Maps.crop.S{2,2};	var.S23 =  Maps.crop.S{2,3};
var.S31 =  Maps.crop.S{3,1};	var.S32 =  Maps.crop.S{3,2};	var.S33 =  Maps.crop.S{3,3};

var.E11 =  Maps.crop.E{1,1};   	var.E12 =  Maps.crop.E{1,2};    var.E13 =  Maps.crop.E{1,3}; 
var.E21 =  Maps.crop.E{2,1};   	var.E22 =  Maps.crop.E{2,2};    var.E23 =  Maps.crop.E{2,3};
var.E31 =  Maps.crop.E{3,1};   	var.E32 =  Maps.crop.E{3,2};    var.E33 =  Maps.crop.E{3,3};

var.W11 =  Maps.crop.W{1,1};   	var.W12 =  Maps.crop.W{1,2};    var.W13 =  Maps.crop.W{1,3};       
var.W21 =  Maps.crop.W{2,1};   	var.W22 =  Maps.crop.W{2,2};    var.W23 =  Maps.crop.W{2,3}; 
var.W31 =  Maps.crop.W{3,1};   	var.W32 =  Maps.crop.W{3,2};    var.W33 =  Maps.crop.W{3,3}; 

var.SavingD =  SavingD;         var.Stiffness  =  Maps.Stiffness; 
var.nu  =  var.Stiffness(1,2)/(var.Stiffness(1,1)+var.Stiffness(1,2));
var.E   =  var.Stiffness(1,1)*(1-2*var.nu)*(1+var.nu)/(1-var.nu); 
var.stepsize =(abs(var.X(1,1)-var.X(1,2)));

% units (defualt xEBSD units)
var.units.xy = 'um';       var.units.S  = 'GPa';   var.units.St = 'GPa';      
var.units.E  = 'Abs.';     var.units.W = 'rad'; 

% plot cropped data
CroppedPlot(var,V.type)
var.Save = [SavingD '\Croped Maps.png'];    saveas(gcf,var.Save); 
var.Save = [SavingD '\Croped Maps.fig'];    saveas(gcf,var.Save); close all
end