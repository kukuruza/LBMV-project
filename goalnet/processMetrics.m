rootDir = '/Volumes/Data/videoData/src/goals-WC10/goals-WC10-w640';

folders = {'001', '002', '003', '004', '005', '006', '007', '008', ...
           '010', '011', '012', '013', '014', '015', '016', '017', '018', '019'};
      
for i = 1 : length(folders);
    inTxtFile = fullfile(rootDir, folders{i}, 'goalnet-response.txt');

    if ~exist(inTxtFile, 'file')
        continue
    end

    response = dlmread(inTxtFile);

    plot (response(:,1) .* response(:,2));
    title(folders{i});
    ylim([0 0.03]);
    waitforbuttonpress

    threshold = 0.02;
    if max(response(:,1) .* response(:,2)) > threshold
        decision = '1';
    else
        decision = '0';
    end
        
    dlmwrite (fullfile(rootDir, folders{i}, 'goalnet-decision.txt'), decision);
end