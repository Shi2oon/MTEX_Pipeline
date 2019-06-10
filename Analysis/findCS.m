function [CS_Trace] = findCS(CS,ebsd_line)   
ebsd_line = ebsd_line('indexed'); 
if CS{1} == 'notIndexed';       CS(1)=[];       end

for ii=1:length(CS)
    if length(ebsd_line.mineralList{ebsd_line.indexedPhasesId(1)})...
                    == length(CS{ii}.mineral)        
                CS_Trace = CS{ii};
    end
end