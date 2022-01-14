function [A_new] = transform(A_old,a)
% Tensor transformation for 2nd rank tensor
% Takes tensor 'A_old', defined with respect to 'old' axes, and transforms to
%  tensor 'A_new', defined with respect to the new axes.
% The matrix a contains the direction cosines a(i,j) of the transformation.
% In Einstein Summation Convention, A_new_ij = a_ik a_jl A_old_kl

A_new = zeros(3,3);

% loop through all elements in A_new
for i = 1:3
    for j = 1:3
        
        % Calculate A_new(i,j), summing over k and l
        for k = 1:3
            for l = 1:3  
                A_new(i,j) = A_new(i,j) + a(i,k)*a(j,l)*A_old(k,l);
            end
        end
        
    end
end

