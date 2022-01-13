function [best]=findslipplane(SFM,Misanglede,angle)

for iJ=1:length(SFM)
	if angle==0
        Angle = mode(round(Misanglede{iJ,iJ}));
    else
        Angle = angle; %do nothing
    end  
    
    Schmid = table2array(SFM{1,iJ});
    [x,y]  = size(Schmid);
    count  = 1;         STrace = zeros(1,y);
    for ii = 1:x
        Diff = abs(Schmid(ii,7)-Angle); 
        if Diff < 7
            DSTrace{iJ}(count,:) = SFM{1,iJ}(ii,:);
            STrace(count,:)         = Schmid(ii,:);
            count                   = count+1;
        end
    end
    
    if STrace~=0
        [indexy]    = ind2sub(size(STrace(:,8)),find(STrace(:,8)==max(STrace(:,8))));
        best{1,iJ}  = DSTrace{iJ}(indexy,:);
        for ii=1:(count-1)
            if STrace(ii,8)<max(STrace(:,8)) || ...
                    STrace(ii,8)>max(STrace(:,8))-(0.5-max(STrace(:,8)))
                best{2,iJ}(ii,:)  = DSTrace{iJ}(ii,:);
            end
        end
    else
        best{1,iJ}=0;
    end
end