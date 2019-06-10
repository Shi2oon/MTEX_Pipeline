function [xLin,yLin,zlin]=fig2image(h)

    if length(h)==1
        x{1}=h.XData;               y{1}=h.YData;               z{1}=h.CData;
    else
        for i=1:length(h)
            x{i}=h(i).XData;         y{i}=h(i).YData;         z{i}=h(i).CData;
        end
    end
        
    zlin=0;                             [fy,fx]=size(z{1});
    xLin=linspace(x{1}(1),x{1}(2),fx);  yLin=linspace(y{1}(1),y{1}(2),fy);

    for i=1:length(z)
        for j=1:fy
            for k=1:fx
                if z{i}(j,k)>=0 || z{i}(j,k)<0
                else
                    z{i}(j,k)=0;
                end
            end
        end
        zlin=z{i}+zlin;
    end