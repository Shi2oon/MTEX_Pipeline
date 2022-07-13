function [StepSize]=CalcStepSize(ebsd)
if ebsd.prop.x(2)-ebsd.prop.x(1) == 0
%     StepSize = abs(ebsd.prop.y(2)-ebsd.prop.y(1));
    StepSize = mode(round(gradient(ebsd.prop.y),3));
else
%     StepSize = abs(ebsd.prop.x(2)-ebsd.prop.x(1));
    StepSize = mode(round(gradient(ebsd.prop.x),3));
end

StepSize = round(StepSize,3);