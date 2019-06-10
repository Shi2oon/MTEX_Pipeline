function [best]=findslipplane(Dir,angle)

for iJ=1:length(Dir.SFM)
	if angle==0
        Angle = mode(round(Dir.Misanglede{iJ,iJ}));
    else
        Angle = angle; %do nothing
    end  
    
    Schmid = table2array(Dir.SFM{1,iJ});
    count=1; STrace=zeros(1,8);
    for ii=1:length(Schmid(:,7))
        Diff = abs(Schmid(ii,7)-Angle); 
        if Diff < 7
            Dir.STrace{iJ}(count,:) = Dir.SFM{1,iJ}(ii,:);
            STrace(count,:)=Schmid(ii,:);
            count = count+1;
        end
    end
    
    if STrace~=0
        [indexy] = ind2sub(size(STrace(:,8)),find(STrace(:,8)==max(STrace(:,8))));
        best{1,iJ}  = Dir.STrace{iJ}(indexy,:);
        for ii=1:(count-1)
            if STrace(ii,8)<max(STrace(:,8)) || ...
                    STrace(ii,8)>max(STrace(:,8))-(0.5-max(STrace(:,8)))
                best{2,iJ}(ii,:)  = Dir.STrace{iJ}(ii,:);
            end
        end
    else
        best{1,iJ}=0;
    end
end