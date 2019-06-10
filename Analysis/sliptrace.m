% find the plane orienation == from EBSD map
% find the twin orienation  == from EBSD map

%% the slip direction required to cause this == cuasing the GB angle

% SrotedGrainsArea = sort(grains.area);   
% out = SrotedGrainsArea(end-3); %smal to big
% [id] = ind2sub(size(grains.area),find(grains.area==out));
ebsd_id = ebsd(grains(id));
gB      = grains(id).boundary(ebsd_id,ebsd_id);
% plot(gB,gB.misorientation.angle./degree,'linewidth',1); 
% colormap(jet(256)); mtexColorbar('title','Angle^{o}')
MainAngle = trimmean(gB.misorientation.angle./degree,50);

crystalShape

viewSamp = vector3d(x,y,0);
viewCrys = ori\viewSamp;
traceCrys = trace(sS,viewCrys);
traceSamp = ori * traceCrys;

%% Calculate slip trace vector
% viewing plane normal
viewSamp = vector3d(x, y, 0); % sample frame
viewCrys = ori \ viewSamp; % crystal frame
sS = slipSystem(d,n);% slip plane
% calculate slip trace vector
traceCrys = trace(sS, viewCrys); % crystal frame
traceSamp = ori * traceCrys; % sample frame

%% To plot crystal morphology
cS = crystalShape.hex(ebsd('W C').CS);
figure; plot(cS); 

% To plot unit cell orientation
cS = crystalShape.hex(ebsd.CS);
ori = grains.meanOrientation;
figure; mp = newMapPlot;
plot(ori*cS,'parent',mp.ax);

%% MTEX import - space group #187
CS = crystalSymmetry('-6m2', [2.9065 2.9065, 2.8366], 'X||a*', 'Y||b',...
    'Z||c*','mineral', 'W C', 'color', 'light red');
%Equivalent Laue class
CS = crystalSymmetry('6/mmm',[2.9065 2.9065 2.8366], 'X||a*', 'Y||b',...
    'Z||c*','mineral', 'W C','color', 'light red'); 

%% Define slip system in MTEX
% assume a force normal to the surface
% slip direction d
d = normalize(Miller(2,-1,1,0, ebsd.CS,'uvtw')); % <a> crystal direction
% slip plane n
n = normalize(Miller(0,1,-1,0, ebsd.CS,'hkil')); % prismatic plane
% define slip system
sS = slipSystem(d,n); % <a> prismatic
% find slip-symmetric variants
sSSyms = sS.symmetrise('antipodal');