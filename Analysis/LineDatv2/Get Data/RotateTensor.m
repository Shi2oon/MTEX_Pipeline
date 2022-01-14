function [A_new] = RotateTensor(A_old,theta)
% Tensor transformation for 2nd rank tensor
% Takes tensor 'A_old', defined with respect to 'old' axes, and transforms to
%  tensor 'A_new', defined with respect to the new axes.

% The new axes are rotated 'theta' degrees anticlockwise about the 3 axis.

a = DirectionCosine(theta);
A_new = transform(A_old,a);
