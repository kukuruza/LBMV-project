

ffmpeg_path = '/usr/local/bin/ffmpeg';

inDirPaths = {...'/Volumes/WinHome/LBMV-project/videoData/src/Arsenal_Tottenham_1_September_2013/', ...
              '/Volumes/WinHome/LBMV-project/videoData/src/Chelsea - Everton 19.05.13/', ...
              '/Volumes/WinHome/LBMV-project/videoData/src/Chelsea - Everton 19.05.13/', ...
              
             };
inVideoNames = {...'Ars-Tot-2.mkv';
                'Chelsea-Everton-May2013-1.mkv', ...
                'Chelsea-Everton-May2013-2.mkv' ...
               };


for i = 1 : length(inDirPaths)
    
    inDirPath = char(inDirPaths{i});
    inVideoName =  char(inVideoNames{i});
    [~,name,~] = fileparts(inVideoName);

    outDirPath = fullfile(inDirPath, 'shots');
    histDiffName = strcat(name, '-hist_diff.txt');    
    histPeaksName =  strcat(name, '-hist_peaks.txt');
    shotsNamePrefix = strcat(name, '-');

    fprintf ('%s \n', inVideoName);
    
    command = strcat ('getHistDiff/bin/getHistDiff', ...
                      ' -i', {' '}, fullfile(inDirPath, inVideoName), ...
                      ' -o', {' '}, fullfile(inDirPath, histDiffName));
                  
    [status, stdout] = system(char(command));
    if status ~= 0
        fprintf ('%s \n', stdout);
        error ('Error in system(getHistDiff)');
    end
        
    cutIntoShots (inDirPath, histDiffName, inVideoName, ...
                  outDirPath, histPeaksName, shotsNamePrefix, ffmpeg_path);
              
end