function [cS,xx] = findShape(CS,iK)
xx=0;
    if sum(strfind(CS.lattice,'cubic'))~=0
        cS  = crystalShape.cube(CS );
    elseif sum(strfind(CS.lattice,'hexagonal'))~=0
        cS  = crystalShape.hex(CS );
    elseif sum(strfind(CS.lattice,'apatite'))~=0 
        cS  = crystalShape.apatite;   %plot(cS)
    elseif sum(strfind(CS.lattice,'quartz'))~=0
        cS  = crystalShape.quartz;
    elseif sum(strfind(CS.lattice,'topaz'))~=0 
        cS  = crystalShape.topaz;
    elseif sum(strfind(CS.lattice,'garnet'))~=0 
        cS  = crystalShape.garnet;
    elseif sum(strfind(CS.lattice,'olivine'))~=0 
        cS  = crystalShape.olivine;
    else
        xx = iK; %if not there
    end
end