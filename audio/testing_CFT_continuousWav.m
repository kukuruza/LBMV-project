clear all; close all; clc;

% in_dir='../../shots';
in_dir='I:\LBMV_Project\Gaurav_matches';
out_dir=fullfile('..','..','fullVideoAudio_mat');
if ~exist(out_dir)
    mkdir(out_dir);
end

filenames=dir(fullfile(in_dir,'*.wav'));
filenames={filenames(:).name};


for file_no=1:numel(filenames)
    filename=filenames{file_no};
    out_filename=[filename(1:end-4) '.mat'];
    [record_signals,threshes,max_segments_all]=getAudioStruct(fullfile(in_dir,filename));
    % figure;imagesc(max_segments_all);
    [ excitement_per_sec,bins_excitement ] =getExcitementPerSec( max_segments_all );
    figure; plot(1/60*[1:numel(excitement_per_sec)],excitement_per_sec);
    save(fullfile(out_dir,out_filename),'record_signals','threshes','max_segments_all');
end
