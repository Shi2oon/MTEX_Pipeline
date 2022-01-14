function [label] = to_label(Data_InputMap, Map_RefID)
Ref = unique(Map_RefID(:));
for i = 1:length(Ref)
    [rowC,colZ]=ind2sub(size(Map_RefID),find(Map_RefID==Ref(i)));
    label.x(i) = Data_InputMap.X_axis(colZ(round(length(colZ)/2,0)));
    label.y(i) = Data_InputMap.Y_axis(rowC(round(length(rowC)/2,0)));
    label.prop.labels{i} = Ref(i);
end

