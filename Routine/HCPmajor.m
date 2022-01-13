function [dS,sS,dST,sST]=HCPmajor(CS) %try to find the dominate system
if sum(strfind(CS.opt.hcptype,'basal'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS01  = symmetrise(slipSystem.basal(CS),'antipodal');        
    dS01  = dislocationSystem(sS01);            count=1;
end
if sum(strfind(CS.opt.hcptype,'prismaticA'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS02  = symmetrise(slipSystem.prismaticA(CS),'antipodal');   
    dS02  = dislocationSystem(sS02);            count=2;
end
if sum(strfind(CS.opt.hcptype,'prismatic2A'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS03  = symmetrise(slipSystem.prismatic2A(CS),'antipodal');  
    dS03  = dislocationSystem(sS03);            count=3;
end
if sum(strfind(CS.opt.hcptype,'pyramidalA'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS04  = symmetrise(slipSystem.pyramidalA(CS),'antipodal');   
    dS04  = dislocationSystem(sS04);            count=4;
end
if sum(strfind(CS.opt.hcptype,'pyramidalCA'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS05  = symmetrise(slipSystem.pyramidalCA(CS),'antipodal');  
    dS05  = dislocationSystem(sS05);            count=5;
end
if sum(strfind(CS.opt.hcptype,'pyramidal2CA'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS06  = symmetrise(slipSystem.pyramidal2CA(CS),'antipodal'); 
    dS06  = dislocationSystem(sS06);            count=6;
end
if sum(strfind(CS.opt.hcptype,'twinT1'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS07  = symmetrise(slipSystem.twinT1(CS),'antipodal');       
    dS07  = dislocationSystem(sS07);            count=7;
end
if sum(strfind(CS.opt.hcptype,'twinT2'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS08  = symmetrise(slipSystem.twinT2(CS),'antipodal');       
    dS08  = dislocationSystem(sS08);            count=8;
end
if sum(strfind(CS.opt.hcptype,'twinC1'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS09  = symmetrise(slipSystem.twinC1(CS),'antipodal');       
    dS09  = dislocationSystem(sS09);            count=9;
end
if sum(strfind(CS.opt.hcptype,'twinC2'))~=0 || sum(strfind(CS.opt.hcptype,'unkown'))~=0
    sS010  = symmetrise(slipSystem.twinC2(CS),'antipodal');       
    dS010  = dislocationSystem(sS010);            count=10;
else
    fprintf('if youd dont know writ unkown, other options \n');
    fprintf('basal, prismaticA, prismatic2A, pyramidalA, pyramidalCA \n');
    fprintf('pyramidal2CA,twinT1, twinT2, twinC1, twinC2\n');
end

    if sum(strfind(CS.opt.hcptype,'unkown'))~=0
        sS =[sS01;sS02;sS03;sS04;sS05;sS06];
        dS =[dS01;dS02;dS03;dS04;dS05;dS06];
        sST=[sS07;sS08;sS09;sS010];
        dST=[dS07;dS08;dS09;dS010];
    elseif exist('count','var')==1
        if count>=7
            eval(sprintf('sST = sS0%d;    dST = dS0%d;',count,count));
                          sS  = 0;         dS = 0;
        else
            eval(sprintf('sS  = sS0%d;   dS = dS0%d;',count,count));
                          sST = 0;      dST = 0;
        end
    else
        warning('Unkown HCP type, all available HCP slip sytesms will be considers');
        dS  = dislocationSystem.hcp(CS);
        sS  = symmetrise(slipSystem.hcp(CS),'antipodal');
        dST = dislocationSystem.hcpTwin(CS);
        sST = symmetrise(slipSystem.hcpTwin(CS),'antipodal');
    end
    