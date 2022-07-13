function SlipTraces(ebsd,grain,fname,direction,rot_sample,Grain_stress_sample)
CS = ebsd.CS;
if      strcmpi(CS.mineral,'Ferrite, bcc (New)') ||...
        strcmpi(CS.mineral,'Ferrite') ||...
        strcmpi(CS.mineral,'Iron-alpha')
    CS.opt.type='bcc';
    CS.mineral = 'Ferrite';
elseif  strcmpi(CS.mineral,'Austenite, fcc (New)') ||...
        strcmpi(CS.mineral,'Austenite') ||...
        strcmpi(CS.mineral,'Iron-Austenite')
    CS.opt.type='fcc';
    CS.mineral = 'Austenite';
elseif  strcmpi(CS.mineral,'Silicon')
    CS.opt.type='fcc';
elseif  strcmpi(CS.mineral,'Moissanite 6H') ||...
        strcmpi(CS.mineral,'Moissanite')
    CS.opt.type='fcc';
    CS.mineral = 'Moissanite';
elseif  strcmpi(CS.mineral,'Ni-superalloy') ||...
        strcmpi(CS.mineral,'Ni') ||...
        strcmpi(CS.mineral,'Nickel-cubic')
    CS.opt.type='fcc';
    CS.mineral = 'Nickel-cubic';
end
%%
[~,sS]     = decideDS(CS,0.3);     % find slip system
if direction == 'X' || direction == 'x'
    sigma = stressTensor.uniaxial(vector3d.X);
elseif direction == 'Y' || direction == 'y'
    sigma = stressTensor.uniaxial(vector3d.X);
else
    sigma = stressTensor.uniaxial(vector3d.Z);
end
%     sigma     = grain.meanOrientation * sigma;
sSlocal   = grain.meanOrientation * sS; %.matrix% rotate slip systems into specimen coordinae
if exist('Grain_stress_sample','var')
%     Rxyz = @(p1,p,p2)[cos(p1)*cos(p2)-cos(p)*sin(p1)*sin(p2)    ...
%         cos(p)*cos(p1)*sin(p2)+sin(p1)*cos(p2)  sin(p)*sin(p2); ...
%         -cos(p1)*sin(p2)-cos(p)*sin(p1)*cos(p2) ...
%         cos(p)*cos(p1)*cos(p2)-sin(p1)*sin(p2)  sin(p)*cos(p2);
%         sin(p)*sin(p1)  -sin(p)*cos(p1) cos(p)];
%     
%     Rx=@(theta)[1 0 0;0 cos(theta) -sin(theta);0 sin(theta) cos(theta)];
%     Ry=@(theta)[cos(theta) 0 sin(theta);0 1 0; -sin(theta) 0 cos(theta)];
%     Rz=@(theta)[cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1];
%     for iO=1:size(Grain_stress_sample,1)
%         for iC=1:size(Grain_stress_sample,2)
%             Grain_stress_sample(iO,iC,:,:) = Rz(rot_sample.phi2)*Ry(rot_sample.Phi)*...
%                 Rx(rot_sample.phi1)*squeeze(Grain_stress_sample(iO,iC,:,:))*...
%                 Rz(rot_sample.phi2)'*Ry(rot_sample.Phi)'*Rx(rot_sample.phi1)';
%             
%             %                 Grain_stress_sample(iO,iC,:,:) = Rxyz(rot_sample.phi1,...
%             %                     rot_sample.Phi,rot_sample.phi2)*squeeze(...
%             %                     Grain_stress_sample(iO,iC,:,:));
%         end
%     end
    rot_sample.CS = CS;
    direction = 'Calculated';
for ix=1:size(Grain_stress_sample,1)
    for iy=1:size(Grain_stress_sample,2)
        Grain_stress_Cr(ix,iy,:,:) = rot_sample.matrix*squeeze(Grain_stress_sample(ix,iy,:,:))...
            *transpose(rot_sample.matrix);
    end
end
    sigma = stressTensor(siMba(Grain_stress_Cr));
    sigma.CS = CS;
    
    sSlocal   = rot_sample * sS;
end
%tau    = sS.SchmidFactor(line);
SF      = sSlocal.SchmidFactor(sigma); %plot(SF)
sSlocal.CRSS = abs(SF)'/0.5;
%plot(grain,SFMax,'micronba r','off','linewidth',2);  hold on;    legend off

%%
%{
    iO=1;
% sS=SS; SF=Sf;
while iO<=length(sS)
    iV=iO+1;
    while iV<=length(sS)
        iniO = sS(iO).trace;                iniV = sS(iV).trace;
        if (round(iniO.x,4)==round(iniV.x,4)) && (round(iniO.y,4)==round(iniV.y,4))...
                && (round(iniO.z,4)==round(iniV.z,4))
            if SF(iO)>SF(iV)
                sS(iV)=[];      SF(iV)=[];
                io = 1;
            else
                sS(iO)=[];      SF(iO)=[];
                io = 0;         iV=length(sS);
            end
        else
            io = 1;
        end
        iV = iV+1;
    end
    iO=iO+io;
end
%}
%% plot
close all;
for i=1:length(sSlocal)
    % visualize the trace of the slip plane
    quiver(grain,sSlocal(i).trace,'autoScaleFactor',abs(SF(i)),'color','k')
    hold on;
end
axis off;       legend off;         hold off; axis image;
saveas(gcf,[fname,'_trace_' direction '.tif']);

%% plot
close all;  colormap('jet');    cc = jet(length(sSlocal));
SOF = sort(abs(SF),'descend');
i=0;
while i < length(sSlocal)
    i = i+1;
    if length(ind2sub(size(SF),find(abs(SF)==SOF(i))))==1
       noM(i)=ind2sub(size(SF),find(abs(SF)==SOF(i)));
    else
          OtM=ind2sub(size(SF),find(abs(SF)==SOF(i)));
        for iP=1:length(OtM)
            noM(i+iP-1) = OtM(iP);
        end
        i = i+iP-1;
    end
end

SF = round(SF,3);
count=0;
for i=noM
    count=count+1;
    % visualize the trace of the slip plane
    quiver(grain,sSlocal(i).trace,'autoScaleFactor',abs(SF(i)),'color',cc(i,:),...
        'DisplayName',[ '(' num2str(round(sS(i).n.h)) ...
        num2str(round(sS(i).n.k)) num2str(round(sS(i).n.l)) ')[' ...
        num2str(round(sS(i).b.u)) num2str(round(sS(i).b.v)) ...
        num2str(round(sS(i).b.w)) '], ' num2str(abs(SF(i)))],'linewidth',4)
    hold on;
end
axis off;       legend off;         hold off;
lgd = legend('location','bestoutside','fontsize',20,'box','off');
lgd.NumColumns = round(length(lgd.String)/10,0);
set(gcf,'position',[30 50 1500 950]); axis image
saveas(gcf,[fname,'_trace_SF_' direction '.fig']);
saveas(gcf,[fname,'_trace_SF_' direction '.tif']);close

%%
if ~exist('Grain_stress_sample','var')
%%
oM = ipfHSVKey(ebsd);
%define the direction of the ipf
oM.inversePoleFigureDirection = zvector;
%convert the ebsd map orientations to a color based on the IPF
color = oM.orientation2color(ebsd.orientations);
plot(ebsd,color);
count=0; hold on
for i=noM
    count=count+1;
    % visualize the trace of the slip plane
    quiver(grain,sSlocal(i).trace,'autoScaleFactor',abs(SF(i)),'color',cc(i,:),...
        'DisplayName',[ '(' num2str(round(sS(i).n.h)) ...
        num2str(round(sS(i).n.k)) num2str(round(sS(i).n.l)) ')[' ...
        num2str(round(sS(i).b.u)) num2str(round(sS(i).b.v)) ...
        num2str(round(sS(i).b.w)) '], ' num2str(abs(SF(i)))],'linewidth',4)
    hold on;
end
axis off;       legend off;         hold off;
lgd = legend('location','bestoutside','fontsize',20,'box','off');
lgd.NumColumns = round(length(lgd.String)/10,0);
set(gcf,'position',[30 50 1500 950]); axis image
saveas(gcf,[fname,'_trace_SF_' direction '_grain.fig']);
saveas(gcf,[fname,'_trace_SF_' direction '_grain.tif']);close

%%
plot(ebsd,color./color);hold on
count=0;
for i=noM
    count=count+1;
    % visualize the trace of the slip plane
    quiver(grain,sSlocal(i).trace,'autoScaleFactor',abs(SF(i)),'color',cc(i,:),...
        'DisplayName',[ '(' num2str(round(sS(i).n.h)) ...
        num2str(round(sS(i).n.k)) num2str(round(sS(i).n.l)) ')[' ...
        num2str(round(sS(i).b.u)) num2str(round(sS(i).b.v)) ...
        num2str(round(sS(i).b.w)) '], ' num2str(abs(SF(i)))],'linewidth',4)
    hold on;
end
axis off;       legend off;         hold off;
lgd = legend('location','bestoutside','fontsize',20,'box','off');
lgd.NumColumns = round(length(lgd.String)/10,0);
set(gcf,'position',[30 50 15000 9500]); axis image
saveas(gcf,[fname,'_trace_SF_' direction '_grain2.tif']);close
end
end

%% Grain_Map_stress_sample(x,y,spec,i,j)
function M = siMba(Grain_stress_sample)
for i=1:3
    for j=1:3
        S(i,j) = nanmean(nanmean(abs(Grain_stress_sample(:,:,i,j))));
    end
end

M = S./sum(S(:));

end
