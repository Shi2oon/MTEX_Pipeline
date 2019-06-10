function [z]=debatableTrace(CS,hkl,uvw)
counter=1;
for j=1:length(hkl)
    for J=1:length(uvw)
        ori = orientation.byMiller(hkl(j,:),uvw(J,:),CS).angle./degree;
        z(counter,:)=[hkl(j,:), uvw(J,:), ori];
        counter=counter+1;
    end
end