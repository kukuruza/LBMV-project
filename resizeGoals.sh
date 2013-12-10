dir="/media/evg/WinHome/LBMV-project/videoData/goals/Все-голы-чемпионата-мира-2010"
for subdir in $dir/*
do
    for f in $subdir/*.avi
    do
        dirname=$(basename $subdir)
        name=$(basename $f)
        suffix=-160.avi
        
        newf=$subdir/$dirname$suffix
        echo $dirname
        ffmpeg -n -v fatal -i $f -c:v h264 -crf 20 -vf scale=160:-1 $newf
    done
done

