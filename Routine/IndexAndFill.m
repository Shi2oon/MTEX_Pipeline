function [ebsdfiltered,CSOut,grains]=IndexAndFill(ebsd,CS)

%Smooth
% F    = halfQuadraticFilter;   	F.alpha = 0.01;         F.eps = 0.001;
% ebsd = smooth(ebsd('indexed'),F);
% F    = meanFilter;           	 ebsd  = smooth(ebsd,F);
         
% if length(ebsd('notIndexed'))/length(ebsd)*100 <2.5
%     ebsd = fill(ebsd);
% end
% [ebsd] = clean4fem(ebsd);           
CS(1) = [];     %ebsd = ebsd('indexed'); 
% ebsd = ebsd('indexed'); 
% ebsd = fill(ebsd);

counter=0;
for i=1:length(ebsd.indexedPhasesId)
    if length(ebsd(ebsd.mineralList{ebsd.indexedPhasesId(i)}))...
            /length(ebsd)*100>1
        for ii=1:length(CS)
            if sum(strfind(ebsd.mineralList{ebsd.indexedPhasesId(i)},CS{ii}.mineral))
                counter = counter+1;          
                CSOut{counter}=CS{ii};
            end
        end
    end
end

if counter      == 1
    ebsdfiltered = ebsd(CSOut{1}.mineral);
    
elseif counter  == 2
    ebsdfiltered = [ebsd(CSOut{1}.mineral),ebsd(CSOut{2}.mineral)];
    
elseif counter  == 3
    ebsdfiltered = [ebsd(CSOut{1}.mineral),ebsd(CSOut{2}.mineral),...
                    ebsd(CSOut{3}.mineral)];
    
elseif counter  == 4
    ebsdfiltered = [ebsd(CSOut{1}.mineral),ebsd(CSOut{2}.mineral),...
                    ebsd(CSOut{3}.mineral),ebsd(CSOut{4}.mineral)];
    
elseif counter  == 5
    ebsdfiltered = [ebsd(CSOut{1}.mineral),ebsd(CSOut{2}.mineral),...
                    ebsd(CSOut{3}.mineral),ebsd(CSOut{4}.mineral),...
                    ebsd(CSOut{5}.mineral)];
    
elseif counter  == 6
    ebsdfiltered = [ebsd(CSOut{1}.mineral),ebsd(CSOut{2}.mineral),...
                    ebsd(CSOut{3}.mineral),ebsd(CSOut{4}.mineral),...
                    ebsd(CSOut{5}.mineral),ebsd(CSOut{6}.mineral)];
else
    ebsdfiltered = ebsd; %do nothing
end

%% grain boundray
[grains,ebsdfiltered.grainId,ebsdfiltered.mis2mean] = ...
    calcGrains(ebsdfiltered('indexed'),'angle',15*degree);
ebsdfiltered(grains(grains.grainSize<=5)) = []; 
grains          = grains('indexed');       
grains.boundary = grains.boundary('indexed');
grains          = smooth(grains,5);

ebsdfiltered = fill(ebsdfiltered);