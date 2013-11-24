function [record_signals,threshes,max_segments_all]=getAudioStruct(filename,show,param_struct)

if nargin<2
    show=0;
end

if nargin<3
    minute_length=60*48000;
    number_threshes=1000;
    sec_percent=1;
else
   minute_length=param_struct.minute_length; 
   number_threshes=param_struct.number_threshes;
   sec_percent=param_struct.sec_percent;
end

%get total size
signal_length=wavread(filename,'size');
signal_length=signal_length(1);

%get window_points
window_points=1:minute_length:signal_length;
window_points(end)=signal_length;
% window_points(1)=0;

temp=cell(numel(window_points)-1,1);
record_signals=struct('max_d_f',temp,'second_count',temp,'seconds_in_signal',temp,'max_segments',temp);

max_yet=-Inf;
min_yet=Inf;

for i=1:numel(window_points)-1
    i
    % small hack for 200 msec (5 frames) offset +100 msec offset at end of
    % segment
    if i==1
        window_begin=window_points(i);
    else
        window_begin=window_points(i)-(48000*300/1000)+1;
    end
    
    signal_curr=wavread(filename,[window_begin,window_points(i+1)],'native');
    signal_curr=mean(signal_curr,2);
    [max_d_f,second_count,seconds_in_signal]=getDensityPeaks(signal_curr,sec_percent,show);
    
    max_yet=max(max_yet,max(max_d_f));
    min_yet=min(min_yet,min(max_d_f));
    
    record_signals(i).max_d_f=max_d_f;
    record_signals(i).second_count=second_count;
    record_signals(i).seconds_in_signal=seconds_in_signal;
    if show>0
        pause;
    end
end

threshes=linspace(min_yet,max_yet,number_threshes);

for i=1:numel(record_signals)
    i
    record_signals(i).max_segments=getThresholdedSegments(threshes,record_signals(i).max_d_f,...
        record_signals(i).seconds_in_signal,record_signals(i).second_count,show);
    if show>0
        pause;
    end
end

max_segments_all={record_signals(:).max_segments};
max_segments_all=cell2mat(max_segments_all);

end