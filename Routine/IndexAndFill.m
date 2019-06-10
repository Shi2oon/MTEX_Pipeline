function [ebsdfiltered,CSOut,grains]=IndexAndFill(ebsd,CS)
%% smooth USING grain boundray
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd('indexed'),'angle',7.5*degree);
ebsd(grains(grains.grainSize <= 3)) = [];        % remove small grains
F           = halfQuadraticFilter;   	F.alpha = 0.01;         F.eps = 0.001;
ebsd        = smooth(ebsd('indexed'),F,'fill',grains);
F           = meanFilter;           	ebsd   = smooth(ebsd,F);            
ebsdIndexed = ebsd('indexed');          CS(1)=[]; 

counter=0;
for i=1:length(ebsdIndexed.indexedPhasesId)
    if length(ebsdIndexed(ebsdIndexed.mineralList{ebsdIndexed.indexedPhasesId(i)}))...
            /length(ebsdIndexed)*100>2.5
        for ii=1:length(CS)
            if length(ebsdIndexed.mineralList{ebsdIndexed.indexedPhasesId(i)})...
                    == length(CS{ii}.mineral)
                counter = counter+1;          
                CSOut{counter}=CS{ii};
            end
        end
    end
end

if counter      == 1
    ebsdfiltered = ebsdIndexed(CSOut{1}.mineral);
    
elseif counter  == 2
    ebsdfiltered = [ebsdIndexed(CSOut{1}.mineral),ebsdIndexed(CSOut{2}.mineral)];
    
elseif counter  == 3
    ebsdfiltered = [ebsdIndexed(CSOut{1}.mineral),ebsdIndexed(CSOut{2}.mineral),...
                    ebsdIndexed(CSOut{3}.mineral)];
    
elseif counter  == 4
    ebsdfiltered = [ebsdIndexed(CSOut{1}.mineral),ebsdIndexed(CSOut{2}.mineral),...
                    ebsdIndexed(CSOut{3}.mineral),ebsdIndexed(CSOut{4}.mineral)];
    
elseif counter  == 5
    ebsdfiltered = [ebsdIndexed(CSOut{1}.mineral),ebsdIndexed(CSOut{2}.mineral),...
                    ebsdIndexed(CSOut{3}.mineral),ebsdIndexed(CSOut{4}.mineral),...
                    ebsdIndexed(CSOut{5}.mineral)];
    
elseif counter  == 6
    ebsdfiltered = [ebsdIndexed(CSOut{1}.mineral),ebsdIndexed(CSOut{2}.mineral),...
                    ebsdIndexed(CSOut{3}.mineral),ebsdIndexed(CSOut{4}.mineral),...
                    ebsdIndexed(CSOut{5}.mineral),ebsdIndexed(CSOut{6}.mineral)];
else
    ebsdfiltered = ebsdIndexed; %do nothing
end

%% grain boundray
[grains,ebsdfiltered.grainId,ebsdfiltered.mis2mean] = ...
    calcGrains(ebsdfiltered('indexed'),'angle',7.5*degree);
grains          = grains('indexed');       
grains.boundary = grains.boundary('indexed');
grains          = smooth(grains,5);