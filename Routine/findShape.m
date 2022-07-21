function [cS,xx] = findShape(CS,iK)
xx=0;
    if strcmpi(CS.lattice,'cubic')
        cS  = crystalShape.cube(CS );
    elseif strcmpi(CS.lattice,'hexagonal')
        cS  = crystalShape.hex(CS );
    elseif strcmpi(CS.lattice,'apatite') 
        cS  = crystalShape.apatite;   %plot(cS)
    elseif strcmpi(CS.lattice,'quartz')
        cS  = crystalShape.quartz;
    elseif strcmpi(CS.lattice,'topaz') 
        cS  = crystalShape.topaz;
    elseif strcmpi(CS.lattice,'garnet') 
        cS  = crystalShape.garnet;
    elseif strcmpi(CS.lattice,'olivine') 
        cS  = crystalShape.olivine;
    else
        xx = iK; %if not there
    end
end