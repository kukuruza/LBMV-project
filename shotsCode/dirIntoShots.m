dirName = '/Volumes/Data/videoData/src/goals-WC10/';

listing = dir(dirName);
names = {listing(:).name};
isdirs = {listing(:).isdir};

for i = 1 : length(names)
    subdir = fullfile(dirName, names{i});
    
    if isdirs{i} == 0
        continue
    end
    if names{i}(1) == '.'
        continue
    end
    if exist(fullfile(subdir, 'shots-640'))
        rmdir(fullfile(subdir, 'shots-640'), 's');
    end

    % % hist diff
    % for i = 1 : length(names)
    %     videoName = names{i};
    %     [~, name, ext] = fileparts(videoName);
    %     currentDir = fullfile(dirName, strcat('shots-', name));
    %     
    %     mkdir (currentDir);
    %     fprintf ('video %s \n', fullfile(dirName, videoName));
    %     getHistDiff(fullfile(dirName, videoName), fullfile(currentDir, 'hist_diff.txt'));
    % end

    % cut shots
    videoPath = fullfile(subdir, strcat(names{i}, '-640.avi'));
    mkdir(subdir, 'shots-640');

    cutIntoShots (subdir, 'hist_diff.txt', videoPath, ...
                  fullfile(subdir, 'shots-640'), 'hist_peaks.txt', '', ...
                  '/usr/local/bin/ffmpeg', 25)

    % generate image-list for video features
%     for i = 1 : length(names)
%         [~, name, ext] = fileparts(names{i});
%         videoName = names{i};
%         currentDir = fullfile(dirName, strcat('shots-', name));
% 
%         listingShots = dir(currentDir);
%         shots={listingShots(:).name};
% 
%         for j = length(shots) : -1 : 1
%             [~, ~, ext] = fileparts(shots{j});
%             if ~strcmp(ext, '.mp4')
%                 shots(j) = [];
%             end
%         end
%         shots'
%         fid = fopen (fullfile(currentDir, 'image-list.txt'), 'w');
%         for i = 1 : length(shots)
%             fprintf(fid, '%s\n', shots{i});
%             fprintf('%s\n', shots{i});
%         end
%         fclose(fid);
%     end

end
