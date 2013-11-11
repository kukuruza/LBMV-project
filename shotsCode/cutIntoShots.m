cutIntoShots (inDirPath, histDiffName, inVideoName, ...
              outDirPath, histPeaksName, shotsNamePrefix, ffmpeg_path)
%% CUTINTOSHOTS
%
% This script loads the hist_diff file in format [frame_id diff] x NRows
% It then runs getPeaks function and saves the peak results
%
% After that system calls to ffmpeg are executed to split the video.
% There can be two ways of cutting out a shot:
%   1) reencode video, because to avoid problems with exact start/end time.
%   2) copy the video part
%


%% constants

Container = 'mp4';

%cutMethod =  ' -vcodec copy -acodec copy';
cutMethod =  ' -c:v libx264 -strict -2';

fps = 25;


%% input

if nargin == 0
    return
    ffmpeg_path = '/usr/local/bin/ffmpeg';

    % in
    inDirPath = '/Volumes/WinHome/LBMV-project/videoData/src/Arsenal_Tottenham_1_September_2013/';
    histDiffName = 'Ars-Tot-2-hist_diff.txt';
    inVideoName = 'Ars-Tot-2.mkv';

    % out
    histPeaksName = 'Ars-Tot-2-hist_peaks.txt';
    outDirPath = '/Volumes/WinHome/LBMV-project/videoData/shots';
    shotsNamePrefix = 'Ars-Tot-2-';
end

%% getting frames of shot change

% format from file
histDiffArray = dlmread (fullfile(inDirPath, histDiffName), ' ');
% format for getPeaks
histDiff = histDiffArray (2:end,2)';

[peakFrames, ~] = getPeaks (histDiff);
% add the zero frame
peakFrames = [0 peakFrames];



%% write file with shot change data

fid=fopen (fullfile(inDirPath, histPeaksName),'wt');
for i = 1 : length(peakFrames)
    value = peakFrames(i);
    fprintf (fid, '%s ', num2str(value));
    fprintf (fid, '%s\n', datestr(value/24/3600/fps, 'HH:MM:SS.FFF'));
end
fclose(fid);



%% cutting video

% use ffmpeg to cut shots
toTime = peakFrames(1);
for i = 2 : length(peakFrames)
    fromTime = toTime;
    toTime = peakFrames(i);
    durationTime = toTime - fromTime;
    
    from_str = datestr (fromTime/24/3600/fps, 'HH:MM:SS.FFF');
    duration_str = datestr (durationTime/24/3600/fps, 'HH:MM:SS.FFF');
    
    outShotName = fullfile (outDirPath, ... 
                    strcat(shotsNamePrefix, num2str(i-1), '.', Container));

    command = strcat (ffmpeg_path, ...
                      ' -ss', {' '}, from_str, ...
                      ' -t', {' '}, duration_str, ...
                      ' -i', {' '}, fullfile(inDirPath, inVideoName), ...
                      ' -f', {' '}, Container, ...
                      ' -y', {' '}, ...
                      cutMethod, {' '}, ...
                      outShotName);
                  
    [status, stdout] = system(char(command));
    if status ~= 0
        fprintf ('%s \n', stdout);
        error ('Error in system(char(command))');
    end
    
    fprintf ('%d / %d \n', i, length(peakFrames));
end

