dir="/media/evg/WinHome/LBMV-project/videoData/goals/Все-голы-чемпионата-мира-2010/"
for subdir in $dir/*
do
    for f in $subdir/*160.avi
    do
        echo $(basename $f)
        ~/projects/LBMV-project/shotsCode/getHistDiff/bin/getHistDiff -i $f -o $subdir/hist_diff.txt
    done
done

