function [DataOut] = cells2map(DataIn,ebsd)
%% re-arange GNDS
 for i = 1:length(DataIn)                          % from MTEX
        DataIn{i} = AddFill(zeros(length(unique(ebsd.prop.x))...
            *length(unique(ebsd.prop.y)),1), DataIn{i});
 end
 counters = 0;
 for i=1:length(unique(ebsd.prop.x)) % arranaging GNDs
     for ii=1:length(unique(ebsd.prop.y))
         counters = counters+1;
         for iv = 1:length(DataIn)
             if isnan(DataIn{iv}(counters))==0 && DataIn{iv}(counters)~=0
                 DataOut(ii,i) = DataIn{iv}(counters);
             end
         end
     end
 end
 DataOut(DataOut==0)=NaN;

%imagesc(DataOut); colormap(jet(256));
        
        