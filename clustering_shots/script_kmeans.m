close all; clear;clc

k=4;
im_per_shot=3;
show=1;

dir_mat='E:\videoData';
video_dirs=dir(dir_mat);
video_dirs={video_dirs(3:end-1).name};
features_all=cell(numel(video_dirs),1);

for video_no=1:numel(video_dirs)
    file=dir(fullfile(dir_mat,video_dirs{video_no},'*.mat'));
    file=file(1).name;
    load(fullfile(dir_mat,video_dirs{video_no},file));
    features_all{video_no}=cell2mat(features);
end

features_all=cell2mat(features_all);

features_all_n=normc(features_all);

[IDX,C,sumd,D] = kmeans(features_all_n,k,'distance','cosine');


idx_record=reshape(1:numel(IDX),im_per_shot,[]);
shot_cluster=zeros(size(idx_record,2),1);
shot_distances=zeros(size(idx_record,2),k);

%get cluster of each shot
for i=1:numel(shot_cluster)
    dist_curr=D(idx_record(:,i),:);
    dist_curr=sum(dist_curr,1);
    [~,min_idx]=min(dist_curr);
    shot_cluster(i)=min_idx;
    shot_distances(i,:)=dist_curr;
end

%create list of dirs to shots
all_files_list=cell(1,0);

dir_mat='E:\videoData';

video_dirs=dir(dir_mat);
video_dirs={video_dirs(3:end).name};

for i=1:numel(video_dirs)
    video_dir_curr=video_dirs{i};
    shot_dir=fullfile(dir_mat,video_dir_curr,'features-w160-fps25');
    shots=dir(fullfile(shot_dir,'*.mat'));
    shots={shots(:).name};
    cell_curr=cellfun(@(x) fullfile(shot_dir,x),shots,'UniformOutput',0);
    all_files_list=[all_files_list,cell_curr];
end


if show>0
    IDX=shot_cluster;
    total_rand=5;
    for k_no=1:k
        idx=find(IDX==k_no);
        idx_idx=randperm(numel(idx),total_rand);
        rand_files=all_files_list(idx(idx_idx));
        figure;
        title(num2str(k_no));
        for i=1:total_rand
            load(rand_files{i});
            im_curr=record_shot.ims(:,:,:,2);
            
            subplot(1,total_rand,i)
            imshow(im_curr);
        end
    end
end
