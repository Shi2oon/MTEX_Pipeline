%% clear repeated values in slips
function [sS] = ClearSlip(sS)
[counters]  = findrepeat(sS); 

if counters ~=0
    [Ncount,sS] = removeRepeat(counters,sS);

    if Ncount>=2 %repeat again
        for ix=1:Ncount-1
        [counters] = findrepeat(sS);
        [~,sS]     = removeRepeat(counters,sS);
        end
    end
end
end

function [counters]=findrepeat(sS)
counters = 0;
if isa(sS,'numeric') == 0
[L,R] = size(sS.b.uvw);
for i = 1:L
    for iv = i+1:1:L
        countx = 0;
        for ii = 1:R
            if round(sS.b.uvw(i,ii)) == round(sS.b.uvw(iv,ii)) && ...
               round(sS.n.hkl(i,ii)) == round(sS.n.hkl(iv,ii))
               countx = countx+1;
            end
        end
        if countx==R;       counters(i) = iv;       end
    end
end
end
end

function [Ncount,sS]=removeRepeat(counters,sS)
% remove
if exist('counters','var')==1
    counters(counters==0)=[];  
    countered = unique(counters,'first'); 
    Ncount    = max(histc(counters, countered)); % number of repetition
    countered = sort(countered);
    for i=length(countered):-1:1
        sS(countered(i))=[];
    end
end
end