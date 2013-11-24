% ccc
% load('record_continuousWAV_min','max_segments_all','record_signals','signal_length');

load('E:\learning_project\fullVideoAudio_mat\Swansea City - Manchester United 17.08.13.mat','max_segments_all')

convert_to_minute=1/60;
max_thresh_per_sec=sum(max_segments_all,1);

percent_threshes=0.5:0.05:1;
figure; plot(1:numel(max_thresh_per_sec),max_thresh_per_sec);
figure;imagesc(max_segments_all);
merge_range=5;

% bins_excitement=zeros(numel(merge_range),numel(max_thresh_per_sec));
bins_excitement=zeros(numel(percent_threshes),numel(max_thresh_per_sec));
for percent_no=1:numel(percent_threshes)
    percent_thresh=percent_threshes(percent_no);
    thresh_curr=(max(max_thresh_per_sec)-min(max_thresh_per_sec))*percent_thresh;
    thresh_curr=min(max_thresh_per_sec)+thresh_curr;
    max_thresh_per_sec_thresh=max_thresh_per_sec;
    max_thresh_per_sec_thresh(max_thresh_per_sec<thresh_curr)=0;
    merge_curr=imdilate(max_thresh_per_sec_thresh,strel('line',merge_range,0));
    bins_excitement(percent_no,:)=merge_curr>=thresh_curr;
%     figure; plot(merge_curr);hold on;
%     plot([0,numel(merge_curr)],[thresh_curr,thresh_curr],'-k');
%     title(num2str(percent_threshes(percent_no)))
    
end

excitement_per_sec=sum(bins_excitement,1);
figure; plot(1/60*[1:numel(excitement_per_sec)],excitement_per_sec);

load('E:\learning_project\VideoTagsTransp_mat\Swansea_Man_Utd_17_August_2013.mat')
hold on;
for i=1:numel(times_decimal)
    if strcmp(tags{i},'Goal scored')
    plot([times_decimal(i),times_decimal(i)],[0,1],'-r','linewidth',3);    
    else
    plot([times_decimal(i),times_decimal(i)],[0,1],'-c','linewidth',3);
    end
end
% minute_increments=1:60:numel(excitement_per_sec);
% minute_increments(end)=numel(excitement_per_sec);
% important_minutes=zeros(1,numel(minute_increments)-1);
% for i=1:numel(minute_increments)-1
%     important_minutes(i)=sum(excitement_per_sec(minute_increments(i):minute_increments(i+1)-1));
% end
% 
% [~,most_important_minutes]=sort(important_minutes,'descend');
% most_important_minutes(1:15)
% most_important_minutes(end-10:end)

