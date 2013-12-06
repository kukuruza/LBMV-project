dirName = '/Volumes/Data/videoData/src/goals-WorldCup-2010/goals-WorldCup10-50s-w160/';

listing = dir(dirName);
names={listing(:).name};

for i = length(names) : -1 : 1
    [~, name, ext] = fileparts(names{i});
    if ~strcmp(ext, '.mp4')
        names(i) = [];
        continue
    end
    if name(1) == '.'
        names(i) = [];
        continue
    end
    if strcmp(name(1:5), 'shots')
        names(i) = [];
    end
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
% for i = 1 : length(names)
%     [~, name, ext] = fileparts(names{i});
%     videoName = names{i};
%     currentDir = fullfile(dirName, strcat('shots-', name));
%     
%     cutIntoShots (currentDir, 'hist_diff.txt', fullfile(dirName, videoName), ...
%                   currentDir, 'hist_peaks.txt', '', '/usr/local/bin/ffmpeg', 25)
% end

% generate image-list for video features
for i = 1 : length(names)
    [~, name, ext] = fileparts(names{i});
    videoName = names{i};
    currentDir = fullfile(dirName, strcat('shots-', name));
 
    listingShots = dir(currentDir);
    shots={listingShots(:).name};
    
    for j = length(shots) : -1 : 1
        [~, ~, ext] = fileparts(shots{j});
        if ~strcmp(ext, '.mp4')
            shots(j) = [];
        end
    end
    shots'
    fid = fopen (fullfile(currentDir, 'image-list.txt'), 'w');
    for i = 1 : length(shots)
        fprintf(fid, '%s\n', shots{i});
        fprintf('%s\n', shots{i});
    end
    fclose(fid);
end


