function [NewTensorMap] = componentTensorTransform(OldTensorMap,a)

% Input: 
% series of 9 maps representing the spatial variation of the 9
% components of a second rank tensor, with respect to an old co-ordinate
% system.  The transformation from the old to the new co-ordinate system is
% defined by the direction cosine matrix a.

% Output: 
% series of 9 maps representing the spatial variation of the
% components of the same system, this time with respect to the new
% co-ordinate system



NewTensorMap = cell(3,3);

parfor i=1:3
    for j=1:3
        [sizeX,sizeY]     = size(OldTensorMap{i,j});
        NewTensorMap{i,j} = zeros(sizeX,sizeY);
    end
end

parfor i=1:3
    for j=1:3
        % Perform einstein summation for component {i,j} 
        for k = 1:3
            for l = 1:3  
                NewTensorMap{i,j} = NewTensorMap{i,j} + a(i,k).*a(j,l).*OldTensorMap{k,l};
            end
        end
    end
end