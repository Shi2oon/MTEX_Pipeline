function [value]=erroOPFe(Dir,CS,PsI,Psi)
close all
modelODF = fibreODF(Miller(1,1,1,crystalSymmetry(CS.lattice)),xvector);
ori=calcOrientations(modelODF,10000);
hw = 1:20;

e = zeros(size(hw));
for i = 1:length(hw)
  odf = calcODF(ori,'halfwidth',hw(i)*degree,'silent');
  e(i)= calcError(modelODF, odf);
end

  odf = calcODF(ori,'halfwidth',Psi.halfwidth,'silent');
  psIErr= calcError(modelODF, odf);
  odf = calcODF(ori,'halfwidth',PsI.halfwidth,'silent');
  psiErr= calcError(modelODF, odf);

plot(hw,e,'--ob','DisplayName','Estimated'); hold on
xlabel('halfwidth, \Theta (Degrees)')
ylabel('Esimation Error (%)')
legend('location','southeast'); 
set(gcf,'position',[500,200,1000,750])
line([Psi.halfwidth*180/pi Psi.halfwidth*180/pi],[0 psIErr],...
            'Color','r','LineStyle','--','HandleVisibility','off')
line([0 Psi.halfwidth*180/pi],[psIErr psIErr],...
            'Color','r','LineStyle','--','DisplayName','Grains')
line([PsI.halfwidth*180/pi PsI.halfwidth*180/pi],[0 psiErr],...
            'Color','k','LineStyle','--','HandleVisibility','off')
line([0 PsI.halfwidth*180/pi],[psiErr psiErr],...
            'Color','k','LineStyle','--','DisplayName','EBSD')
        hold off
Dir = fullfile(Dir,[CS.mineral ' erro est.png']);
saveas(gcf,Dir); close all        

[fj]=ind2sub(size(e),find(e==min(e)));
HW=hw(fj);
%optimum half width value
if abs(HW-Psi.halfwidth*180/pi)<abs(HW-PsI.halfwidth*180/pi)
    value=Psi; 
else
    value=PsI; 
end


