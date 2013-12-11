function [ excitement_per_sec,bins_excitement ] =getExcitementPerSec( max_segments_all,show ,percent_threshes,merge_range)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

if nargin<2
    show=0;
end
if nargin<3
    percent_threshes=0.5:0.05:1;
end
if nargin<4
    merge_range=5;
end

max_thresh_per_sec=sum(max_segments_all,1);

if show>0
figure; plot(1:numel(max_thresh_per_sec),max_thresh_per_sec);
end
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
   
    if show>0
    figure; plot(merge_curr);hold on;
    plot([0,numel(merge_curr)],[thresh_curr,thresh_curr],'-k');
    title(num2str(percent_threshes(percent_no)))
    end
end

excitement_per_sec=sum(bins_excitement,1);
end

