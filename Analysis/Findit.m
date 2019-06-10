% SrotedGrainsArea = sort(grains.area);   out = SrotedGrainsArea(end-1); %smal to big
% [id] = ind2sub(size(grains.area),find(grains.area==out));
% [~,idx]=max(grains.area); %plot largest grain
% 
% %[h,k,l,u,v,w,MainAngle,error]=Findit(ebsd,grains,id)
% [h,k,l,u,v,w,ang,err] = Findit(ebsd,grains,idx);
% [H,K,L,U,V,W,ANG,ERR] = Findit(ebsd,grains,id);
% orientation.byMiller([h k 1],[U V W],CS{1}).angle/degree;
% 
% orientation(Miller(h,k,l,CS{1}),Miller(H,K,L,CS{1}))

function [h,k,l,u,v,w,MainAngle,error]=Findit(ebsd,grains,id)
ebsd_id=ebsd(grains(id));
gB = grains(id).boundary(ebsd_id,ebsd_id);
% plot(gB,gB.misorientation.angle./degree,'linewidth',1); 
MainAngle=trimmean(gB.misorientation.angle./degree,50);

meanmean.CS         =   ebsd_id.mis2mean.CS;
meanmean.SS         =   ebsd_id.mis2mean.SS;
meanmean.antipodal  =   ebsd_id.mis2mean.antipodal;
meanmean.i          =   trimmean(ebsd_id.mis2mean.i,50);
meanmean.phi1       =   trimmean(ebsd_id.mis2mean.phi1,50);
meanmean.Phi        =   trimmean(ebsd_id.mis2mean.Phi,50);
meanmean.phi2       =   trimmean(ebsd_id.mis2mean.phi2,50);
meanmean.a          =   trimmean(ebsd_id.mis2mean.a,50);
meanmean.b          =   trimmean(ebsd_id.mis2mean.b,50);
meanmean.c          =   trimmean(ebsd_id.mis2mean.c,50);
meanmean.d          =   trimmean(ebsd_id.mis2mean.d,50);
meanmean.opt        =   ebsd_id.mis2mean.opt;

% for cubic
h=sin(meanmean.Phi)*sin(meanmean.phi2);     h=round(h);
k=sin(meanmean.Phi)*cos(meanmean.phi2);  	k=round(k); 
l=cos(meanmean.Phi);                        l=round(l);

u=cos(meanmean.phi1)*cos(meanmean.phi2)-sin(meanmean.phi1)*...
    sin(meanmean.phi2)*cos(meanmean.Phi);   u=round(u);
v=-cos(meanmean.phi1)*cos(meanmean.phi2)-sin(meanmean.phi1)*...
    cos(meanmean.phi2)*cos(meanmean.Phi);   v=round(v);
w=sin(meanmean.phi1)*sin(meanmean.Phi);     w=round(w);

error=100*(cos(meanmean.Phi)*tan(meanmean.phi1)-l*w/(k*u-h*v))*2/...
    (cos(meanmean.Phi)*tan(meanmean.phi1)+l*w/(k*u-h*v));

end