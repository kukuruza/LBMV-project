function [max_segments]=getThresholdedSegments(threshes,max_d_f,seconds_in_signal,second_count,show)
max_segments=zeros(numel(threshes),seconds_in_signal);

for percent_no=1:numel(threshes);
    
    thresh=threshes(percent_no);
    bin_thresh=max_d_f>=thresh;
    
    % make bin for each sec_percent
    bin_second=zeros(1,seconds_in_signal);
    for i=1:numel(bin_second)
        bin_second(i)=max(bin_thresh(second_count==i));
    end
    max_segments(percent_no,:)=bin_second;
    
end
    if show>0
        
    figure;imagesc(max_segments);
    end
end
