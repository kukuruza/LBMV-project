function nospaces_filenames (input_dir, output_dir)
%% NOSPACES_FILENAMES
% replaces spaces in .txt filenames to underscores

listing = dir(input_dir);

for i = 1 : size(listing)
    
    file_in_name = listing(i).name;
    
    % filter non-txt files
    if length(file_in_name) < 4 || ~strcmp(file_in_name(end-3:end), '.txt')
        continue
    end
    
    file_out_name = regexprep (file_in_name, ' ', '_');
    
    file_in_path = fullfile(input_dir, file_in_name);
    file_out_path = fullfile(output_dir, file_out_name);
    
    movefile (file_in_path, file_out_path);
    
end