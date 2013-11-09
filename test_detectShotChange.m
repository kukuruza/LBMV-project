load('diff.mat');
diff_hist=diff;
clearvars diff;

[max_val_idx_to_keep,max_val_to_keep]=getPeaks(diff_hist);

figure;
plot(1:numel(diff_hist),diff_hist,'-r');
hold on;
plot(max_val_idx_to_keep,max_val_to_keep,'*g');

