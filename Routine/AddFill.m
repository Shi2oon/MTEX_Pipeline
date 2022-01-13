function c = AddFill(a, b)
sa = size(a);
sb = size(b);
c = zeros(max(sa, sb));   % Pre-allocate
c(1:sa(1), 1:sa(2)) = a;  % Assign a
c(1:sb(1), 1:sb(2)) = c(1:sb(1), 1:sb(2)) + b;  % Add b