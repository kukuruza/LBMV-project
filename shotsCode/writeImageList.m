function [] = writeImageList (inDir, outImageListFile)

listing = dir(inDir);
names={listing(:).name};

for i = 1 : length(names)
    name = names{i};
    [~, name, ~] = fileparts(name);
    indices = strfind(name, '-');
    names{i} = name;
end

namesNums = zeros(length(names), 1);

for i = 1 : length(names)
    name = names{i};
    indices = strfind(name, '-');
    if isempty(indices)
        namesNums(i) = length(names);
        continue
    end
    index = indices(end);
    numStr = name(index+1 : end);
    numDigits = length(numStr);
    namesNums(i) = str2double(numStr);
end

[~, namesIndices] = sort(namesNums);
names = names(namesIndices);
    
fid = fopen (outImageListFile, 'w');
for i = 1 : length(names)-2 % -2 is for . and ..
    fprintf(fid, '%s\n', names{i});
    fprintf('%s\n', names{i});
end
fclose(fid);
