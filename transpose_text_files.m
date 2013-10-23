function transpose_text_files (input_dir, output_dir, dilimiter)
%% TRANSPOSE_TEXT_FILES
% read delimited text files transpose the mtrics and write it back

listing = dir(input_dir);

for i = 1 : size(listing)
    
    file_in_name = listing(i).name;
    
    % filter non-txt files
    if length(file_in_name) < 4 || ~strcmp(file_in_name(end-3:end), '.txt')
        continue
    end
    
    A = readtext(fullfile(input_dir, file_in_name), dilimiter);
    A = A';
    
    file_out_path = fullfile(output_dir, file_in_name);
    fid = fopen(file_out_path, 'wt');
    
    for row = 1 : size(A,1)
        for col = 1 : size(A,2)
            fprintf(fid, '%s\t', char(A(row,col)));
        end
        fprintf(fid, '\n');
    end
            
    fclose(fid);
    
end