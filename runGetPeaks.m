%% RUNGETPEAKS
%
% This script loads the hist_diff file in format [frame_id diff] x NRows
% It then runs getPeaks function and saves the peak results
%


%% input

%DirPath = 'videoData/videoSrc/Liverpool_Man_Utd_1_September_2013';
DirPath = 'runGetPeaks_testData';

HistDiffName = '/20130901-LIV-MNU-EPL_1-hist_diff.txt';
HistPeaksName = '/20130901-LIV-MNU-EPL_1-hist_peaks.txt';


%% code

% format from file
histDiffArray = dlmread(fullfile(DirPath, HistDiffName), ' ');
% format for getPeaks
histDiff = histDiffArray(:,2)';
% subset of histDiff
histDiffTestSubset = histDiff(2:2000);



[max_val_idx_to_keep,max_val_to_keep]=getPeaks (histDiffTestSubset);

figure;
plot(1:numel(diff_hist),diff_hist,'-r');
hold on;
plot(max_val_idx_to_keep,max_val_to_keep,'*g');


%[peakFrames, ~] = getPeaks (histDiff(1:1000));
%dlmwrite (fullfile(DirPath, HistPeaksName), peakFrames);

