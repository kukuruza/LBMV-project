function [max_val_idx_to_keep,max_val_to_keep]=getPeaks(diff_hist,window_sizes)
    
if nargin<2
window_sizes=[10,20,30,40,50];
end

diff_hist_minMax=cell(size(window_sizes));
idx=cell(size(window_sizes));
strs=cell(size(window_sizes));

for i=1:numel(window_sizes)
    [diff_hist_minMax{i}]=getMinMaxDiff(window_sizes(i),diff_hist);
    [idx{i},~]=getMaxBin(diff_hist_minMax{i});
end


idx_mat=cell2mat(idx');
idx_mat=sum(idx_mat,1);
max_all=idx_mat==numel(idx);

max_all_border=max_all-[max_all(2:end) max_all(end)];
max_all=find(max_all_border);

max_val=zeros(1,numel(max_all)/2);
max_val_idx=zeros(1,numel(max_all)/2);
for i=1:2:numel(max_all)
    temp_idx_range=max_all(i)-3:max_all(i+1)+3;
    [max_val((i+1)/2),max_idx]=max(diff_hist(temp_idx_range));
    max_val_idx((i+1)/2)=temp_idx_range(max_idx);
end


max_val_diff=diff_hist_minMax{1}(max_val_idx);
max_val_thresh=median(max_val_diff)/2;
max_val_idx_to_keep=max_val_idx(max_val_diff>max_val_thresh);
max_val_to_keep=max_val(max_val_diff>max_val_thresh);
end


function [bin_max,bin_max_idx]=getMaxBin(hist_new)

diff_curr_diff=[hist_new(2:end),hist_new(end)];
idx=find(diff_curr_diff-hist_new);

idx=[1 idx numel(hist_new)];

bin_max=zeros(size(hist_new));
bin_max_idx=zeros(1,numel(idx)-1);



for i=1:numel(idx)-1

    if (i==1)
        bin_max_idx(i)=mode(hist_new(idx(i):idx(i+1)))>mode(hist_new(idx(i+1):idx(i+2)));
    else
        bin_bef=~bin_max_idx(i-1);
        if i==numel(idx)-1
            bin_aft=1;
        else
            bin_aft=mode(hist_new(idx(i):idx(i+1)))>mode(hist_new(idx(i+1):idx(i+2)));
        end
        bin_max_idx(i)=bin_bef & bin_aft;
    end
end

for i=1:numel(idx)-1
    bin_max(idx(i):idx(i+1))=bin_max_idx(i);
end

end

function [hist_new]=getMinMaxDiff(window_size,hist_old)

hist_new=zeros(size(hist_old));
for i=1:window_size:numel(hist_old)-window_size
    min_window=min(hist_old(i:i+window_size-1));
    max_window=max(hist_old(i:i+window_size-1));
    hist_new(i:i+window_size-1)=max_window-min_window;
    
end

min_window=min(hist_old(i:end));
max_window=max(hist_old(i:end));
hist_new(i:end)=max_window-min_window;


end



