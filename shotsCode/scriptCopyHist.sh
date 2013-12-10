dirremote="/media/evg/WinHome/LBMV-project/videoData/goals/Все-голы-чемпионата-мира-2010"
dirlocal="/Volumes/Data/videoData/src/Все-голы-чемпионата-мира-2010"
for subdir in $dirlocal/*
do
    subdirname=$(basename $subdir)
    scp evg@128.2.130.36:$dirremote/$subdirname/hist_diff.txt $subdir
done

