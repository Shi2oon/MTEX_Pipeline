function [dS,sS,dST,sST]=decideDS(CS,nu)
% The central idea of Pantleon is that the dislocation density tensor is 
% build up by single dislocations with different densities such that the total 
% energy is minimum. Depending on the attomic lattice different dislocattion 
% systems have to be considered.Those principle dislocations are defined in 
% MTEX either by their Burgers and line vectors or as below

if  sum(strfind(CS.lattice,'cubic'))~=0
    if  sum(strfind(CS.opt.type,'bcc'))~=0
        sS = symmetrise(slipSystem.bcc(CS),'antipodal');
        %dS = dislocationSystem.bcc(CS);
        sST = symmetrise(slipSystem.bccTwin(CS),'antipodal');
        %dST = dislocationSystem.bccTwin(CS);

    elseif sum(strfind(CS.opt.type,'fcc'))~=0
        sS = symmetrise(slipSystem.fcc(CS),'antipodal');
        %dS = dislocationSystem.fcc(CS);
        sST = symmetrise(slipSystem.fccTwin(CS),'antipodal');
        %dST = dislocationSystem.fccTwin(CS);
%         sSC = symmetrise(slipSystem.fccCrack(CS),'antipodal');
        
    elseif sum(strfind(CS.opt.type,'fct'))~=0
        sS  = symmetrise(slipSystem.fct(CS),'antipodal');
        sST = symmetrise(slipSystem.fct(CS),'antipodal');
        %dS = dislocationSystem(sS);
    end

elseif sum(strfind(CS.lattice,'hexagonal'))~=0      || sum(strfind(CS.lattice,'triclinic'))~=0
    if any(ismember(fields(CS.opt),'hcptype'))==1
        [~,sS,~,sST] = HCPmajor(CS);
    else
        sS = symmetrise(slipSystem.hcp(CS),'antipodal');
        %dS = dislocationSystem.hcp(CS);
        sST = symmetrise(slipSystem.hcpTwin(CS),'antipodal');   
        %dST = dislocationSystem.hcpTwin(CS);
    end
    
elseif sum(strfind(CS.lattice,'trigonal'))~=0 
    sS  = symmetrise(slipSystem.basal(CS),'antipodal');
    sST = symmetrise(slipSystem.basal(CS),'antipodal');
    %dS = dislocationSystem(sS);
    
elseif sum(strfind(CS.lattice,'tetragonal'))~=0 
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