function [dS,sS,dST,sST]=decideDS(CS,nu)

% The central idea of Pantleon is that the dislocation density tensor is 
% build up by single dislocations with different densities such that the total 
% energy is minimum. Depending on the attomic lattice different dislocattion 
% systems have to be considered.Those principle dislocations are defined in 
% MTEX either by their Burgers and line vectors or as below

if sum(strfind(CS.opt.type,'bcc'))~=0
    dS = dislocationSystem.bcc(CS);
    sS = symmetrise(slipSystem.bcc(CS),'antipodal');
    dST = dislocationSystem.bccTwin(CS);
    sST = symmetrise(slipSystem.bccTwin(CS),'antipodal');

elseif sum(strfind(CS.opt.type,'fcc'))~=0
    dS = dislocationSystem.fcc(CS);
    sS = symmetrise(slipSystem.fcc(CS),'antipodal');
    dST = dislocationSystem.fccTwin(CS);
    sST = symmetrise(slipSystem.fccTwin(CS),'antipodal');

elseif sum(strfind(CS.opt.type,'hcp'))~=0   % need more improvement
    [dS,sS]=HCPmajor(CS);
    
else
    fprintf('Only for FCC, BCC and HCP');
end

dS(dS.isEdge).u = 1; % energy of the edge dislocations
dS(dS.isScrew).u = 1 - nu; % energy of the screw dislocations