clear all; close all; clc;

in_dir='E:\learning_project\shots\';
out_dir=fullfile('..','..','fullVideoAudio_mat');
if ~exist(out_dir)
    mkdir(out_dir);
end

filename='Swansea City - Manchester United 17.08.13.wav';

[record_signals,threshes,max_segments_all]=getAudioStruct(fullfile(in_dir,filename));
figure;imagesc(max_segments_all);


out_filename=[filename(1:end-4) '.mat'];
load('E:\learning_project\fullVideoAudio_mat\Swansea City - Manchester United 17.08.13.mat','max_segments_all')
[ excitement_per_sec,bins_excitement ] =getExcitementPerSec( max_segments_all );
figure; plot(1/60*[1:numel(excitement_per_sec)],excitement_per_sec);
save(fullfile(out_dir,out_filename),'record_signals','threshes','max_segments_all');


