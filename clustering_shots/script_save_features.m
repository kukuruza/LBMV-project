close all; clear; clc

dir_mat='E:\videoData';

video_dirs=dir(dir_mat);
video_dirs={video_dirs(3:end).name};

for video_no=1:numel(video_dirs)
    video_dir_curr=video_dirs{video_no};
    shot_dir=fullfile(dir_mat,video_dir_curr,'features-w160-fps25');
    out_dir=fullfile(dir_mat,video_dir_curr);
    out_file_name='features_all_shots.mat';
    
    shots=dir(fullfile(shot_dir,'*.mat'));
    shots={shots(:).name};
    
    features=cell(numel(shots),2);
    durations=zeros(numel(shots),1);
    
    for shot_no=1:numel(shots)
        fprintf('%d/%d of video %d/%d\n',shot_no,numel(shots),video_no,numel(video_dirs));
        load(fullfile(shot_dir,shots{shot_no}));
        durations(shot_no)=record_shot.obj.Duration;
        features{shot_no,1}=record_shot.gists;
        features{shot_no,2}=record_shot.hogs;
    end
%     features=cell2mat(features);
    
    save(fullfile(out_dir,out_file_name),'features','durations');
    

end