close all; clear; clc;

dir_videos='C:\Users\Maheen\Dropbox\LBMV\videoData';
out_dir='E:\videoData';


video_names=dir(dir_videos);
video_names={video_names(3:end).name};

addpath(genpath('toolbox'));
addpath(genpath('gistdescriptor'));


images_per_shot=3;

for video_no=2:numel(video_names)
video_name_curr=video_names{video_no};

dir_shots=fullfile(dir_videos,video_name_curr,'shots-w160-fps25');
out_dir_curr=fullfile(out_dir,video_name_curr,'features-w160-fps25');

if ~exist(out_dir_curr,'dir')
    mkdir(out_dir_curr);
end


shot_names=dir(fullfile(dir_shots,'*.mp4'));
shot_names={shot_names(:).name};

for shot_no=1:numel(shot_names)
    shot_no
record_shot=struct('ims',0,'hogs',0,'gists',0,'obj',0);

filename=fullfile(dir_shots,shot_names{shot_no});
obj = VideoReader(filename);
video = read(obj);

[ims,hogs,gists]=getImsAndFeatures(video,images_per_shot);

record_shot.ims=ims;
record_shot.hogs=hogs;
record_shot.gists=gists;
record_shot.obj=obj;

out_file_name=[shot_names{shot_no}(1:end-4) '.mat'];
save(fullfile(out_dir_curr,out_file_name),'record_shot');

end
end

rmpath(genpath('toolbox'));
rmpath(genpath('gistdescriptor'));
