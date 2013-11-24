clear all; close all; clc;

in_dir=fullfile('..','..','VideoTagsTransp');
out_dir=fullfile('..','..','VideoTagsTransp_mat');
if ~exist(out_dir)
    mkdir(out_dir);
end

filename='Swansea_Man_Utd_17_August_2013.txt';
tags_file=fullfile(in_dir,filename);
out_filename=[filename(1:end-4) '.mat'];

fid=fopen(tags_file);
text=textscan(fid,'%s','delimiter','\t');
text=text{1};
tags=text(2:2:end);
times=text(1:2:end);

beginning_offset=3+19/60;
halftime_offset=38/60;

times_decimal=getTimes(times,tags,beginning_offset,halftime_offset);

save(fullfile(out_dir,out_filename),'times_decimal','times','tags',...
    'beginning_offset','halftime_offset');

