function [Maps] = interpolateData(Xnew,Ynew,Maps,xq,yq)
[fi,fj] = size(Maps.A);
for i = 1:fi
    for j = 1:fj
        Maps.rot.A{i,j}     = griddata(Xnew,Ynew,Maps.A{i,j}(:),xq,yq);
        Maps.rot.S{i,j}     = griddata(Xnew,Ynew,Maps.S{i,j}(:),xq,yq);
        Maps.rot.E{i,j}     = griddata(Xnew,Ynew,Maps.E{i,j}(:),xq,yq);
        Maps.rot.W{i,j}     = griddata(Xnew,Ynew,Maps.W{i,j}(:),xq,yq);
        Maps.rot.GNDs{i,j}  = griddata(Xnew,Ynew,Maps.GNDs{i,j}(:),xq,yq);
    end
end
