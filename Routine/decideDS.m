function [dS,sS,dST,sST]=decideDS(CS,nu)
% The central idea of Pantleon is that the dislocation density tensor is 
% build up by single dislocations with different densities such that the total 
% energy is minimum. Depending on the attomic lattice different dislocattion 
% systems have to be considered.Those principle dislocations are defined in 
% MTEX either by their Burgers and line vectors or as below

if  strcmpi(CS.lattice,'cubic')
    if  strcmpi(CS.opt.type,'bcc')
        sS = symmetrise(slipSystem.bcc(CS),'antipodal');
        %dS = dislocationSystem.bcc(CS);
        sST = symmetrise(slipSystem.bccTwin(CS),'antipodal');
        %dST = dislocationSystem.bccTwin(CS);

    elseif strcmpi(CS.opt.type,'fcc')
        sS = symmetrise(slipSystem.fcc(CS),'antipodal');
        %dS = dislocationSystem.fcc(CS);
        sST = symmetrise(slipSystem.fccTwin(CS),'antipodal');
        %dST = dislocationSystem.fccTwin(CS);
%         sSC = symmetrise(slipSystem.fccCrack(CS),'antipodal');
        
    elseif strcmpi(CS.opt.type,'fct')
        sS  = symmetrise(slipSystem.fct(CS),'antipodal');
        sST = symmetrise(slipSystem.fct(CS),'antipodal');
        %dS = dislocationSystem(sS);
    end

elseif strcmpi(CS.lattice,'hexagonal') || strcmpi(CS.lattice,'triclinic')
    if any(ismember(fields(CS.opt),'hcptype'))==1
        [~,sS,~,sST] = HCPmajor(CS);
    else
        sS = symmetrise(slipSystem.hcp(CS),'antipodal');
        %dS = dislocationSystem.hcp(CS);
        sST = symmetrise(slipSystem.hcpTwin(CS),'antipodal');   
        %dST = dislocationSystem.hcpTwin(CS);
    end
    
elseif strcmpi(CS.lattice,'trigonal')
    sS  = symmetrise(slipSystem.basal(CS),'antipodal');
    sST = symmetrise(slipSystem.basal(CS),'antipodal');
    %dS = dislocationSystem(sS);
    
elseif strcmpi(CS.lattice,'tetragonal')
    sS  = symmetrise(slipSystem.fct(CS),'antipodal');
    sST = symmetrise(slipSystem.fct(CS),'antipodal');
    %dS = dislocationSystem(sS);
else
    fprintf('Only for FCC, BCC, BCT, trigonal and HCP');
end

[sS] = ClearSlip(sS);           dS   = dislocationSystem(sS); 
dS(dS.isEdge).u  = 1;           dS(dS.isScrew).u = 1 - nu;   
if isa(sST,'numeric') ~=1
    [sST] = ClearSlip(sST);     dST  = dislocationSystem(sST);          
    dST(dST.isEdge).u  = 1;       % energy of the edge dislocations 
    dST(dST.isScrew).u = 1 - nu;  % energy of the screw dislocations
else
    dST = 0;
end