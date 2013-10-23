#! /bin/bash
#
# The script cuts out fragments of less than a minute from a video.
#   Start, end time, and fragment duation can be specified
#
# Currently please specify the end time - script cannot figure it out
#

## input ##

file_path="videoSrc/Liverpool_Man_Utd_1_September_2013/20130901-LIV-MNU-EPL_1.mkv"

# the '*' will be replaced with minute
output_template="videoFragments/Liverpool_Man_Utd_1_September_2013-1st-*.mkv"

# duration of fragments in seconds
duration=50

# interval between start of subsequent fragments in seconds
time_gap=2

# first minute
time_first=10

# last minute
time_last=52



## code ##

time=$time_first

ffmpeg_return=0
while (( $ffmpeg_return == 0 && $time < $time_last ))
do
    time_format=""
    if (( $time < 60 ))
    then
        time_format=00:"$time"
    elif (( $time > 59 && $time < 120 ))
    then
        time_format=01:"$(($time-60))"
    elif (( $time > 119 && $time < 180 ))
    then
        time_format=02:"$(($time-120))"
    else
        echo "Input video of less than 3 hours please"
        exit 1
    fi

    output_path=${output_template/"*"/$time}

    ffmpeg -ss $time_format:00 -t 00:00:$duration -i $file_path -vcodec copy -acodec copy $output_path

    ffmpeg_return=$?
    time=$(($time + $time_gap))
done

exit 0


