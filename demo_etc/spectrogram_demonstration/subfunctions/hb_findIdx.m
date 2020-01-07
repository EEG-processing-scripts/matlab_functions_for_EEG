function [idx,short] = hb_findIdx( range, fullData )
% function idx = hb_findIdx( range, fullData )

short=false;
idx = max(find( fullData < range(1)))+1:max(find(fullData<range(2)));

if length(idx)==0
%     idx
    idx = 1:max(find(fullData<range(2)));
end

if range(2) > fullData(end)
    short=1;
%     disp(['Requested range: .. ' num2str( range(2)) ]);
%     disp(['Actual range: .. ' num2str(fullData(end)) ]);
%     disp(['Short: ' num2str( short) ]); 
end

return

