function [times_mat]=getTimes(times,tags,beginning_offset,halftime_offset)

times_mat=zeros(size(times));
%find all the pluses
pluses=~cellfun(@isempty,strfind(times,'+'));
non_pluses=~pluses;

%fix halftime plus
halftime_idx=find(strcmp('Half time',tags));
if ~isempty(strfind(times{halftime_idx},'+'))
    halftime_overtime=getDecimalTime({strrep(times{halftime_idx},'+','')});
    halftime_offset=halftime_offset+halftime_overtime;
    times_mat(halftime_idx)=halftime_overtime+45;
    pluses(halftime_idx)=0;
end

%remove pluses for fulltime processing
times(pluses)=cellfun(@(x) strrep(x,'+',''),times(pluses),'UniformOutput',0);
times_mat(pluses)=getDecimalTime(times(pluses))+90;

%get decimal time
times_mat(non_pluses)=getDecimalTime(times(non_pluses));

%add beginning offset
times_mat=times_mat+beginning_offset;
%add halftime offset
times_mat(1:halftime_idx-1)=times_mat(1:halftime_idx-1)+halftime_offset;




end

function [time_mat]=getDecimalTime(time_str_cell)

        unit_split=cellfun(@(x) regexpi(x,':','split'),time_str_cell,'UniformOutput',0);
        minutes=cellfun(@(x) str2double(x{1}),unit_split);
        seconds=cellfun(@(x) str2double(x{2})/60,unit_split);
        time_mat=minutes+seconds;
    
end