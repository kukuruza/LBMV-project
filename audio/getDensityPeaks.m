function [max_d_f,second_count,seconds_in_signal]=getDensityPeaks(signal,sec_percent,show)

%fft params
fs=48000;
range=[100,400];

%sliding window
overlap=0.75;
window_msec=100;

%bump detecting kernel
kernel=[0;-1;0;0;0;2;0;0;0;-1;0];
win=5;



[cft_bin,window_pos]=getCFT(signal,fs,range,window_msec,overlap);
d_f=getDensityProfile(cft_bin,kernel,win);


max_d_f=-1*d_f;
% % max_d_f=-1*min(d_f);
[second_count,seconds_in_signal]=getSecondPerWindowPos(window_pos,win,sec_percent,fs);

if show>0
    figure;
    subplot(3,1,1);plot(signal);
    subplot(3,1,2);imagesc(cft_bin);
    subplot(3,1,3);plot(1:numel(max_d_f),max_d_f);
end




end


function [d_f]=getDensityProfile(cft_bin,kernel,win)
d_f = filter2(kernel,cft_bin,'valid');
d_f=sum(d_f,1);
d_f=filter(ones(1,win),1,d_f);
d_f(1:win-1)=[];
end


function [cft_bin,window_pos]=getCFT(signal,fs,range,window_msec,overlap)
window_signal=fs*window_msec/1000;
step_size=(1-overlap)*window_signal;
window_pos=1:step_size:numel(signal);

for i=1:numel(window_pos)-1
    signal_curr=signal(window_pos(i):min(window_pos(i)+window_signal-1,numel(signal)));
    signal_fft=abs(fft(double(signal_curr)));
    freq_bins=getFreqByHz(signal_fft,range,fs);
    signal_fft_2=abs(fft(freq_bins));
    temp=round(numel(signal_fft_2)/2);
    if i==1
        cft_bin=zeros(temp,numel(window_pos)-1);
    end
    cft_bin(1:temp,i)=signal_fft_2(1:temp);
end


end


function freq_bins=getFreqByHz(signal_fft,range,fs)
hz_to_bin=numel(signal_fft)/fs;
range_bins=round(range*hz_to_bin);
freq_bins=signal_fft(range_bins(1):range_bins(2));
end

function [second_count,seconds_in_signal]=getSecondPerWindowPos(window_pos,win,sec_percent,fs)

signal_pos=window_pos(win:end-1);


seconds_in_signal=(max(signal_pos)-min(signal_pos))/(fs*sec_percent);
seconds_in_signal=ceil(seconds_in_signal);
second_count=zeros(size(signal_pos));

init_pos=min(signal_pos);

for sec_no=1:seconds_in_signal
    bin=signal_pos>=init_pos+(sec_no-1)*(fs*sec_percent);
    second_count(bin)=second_count(bin)+1;
end

end