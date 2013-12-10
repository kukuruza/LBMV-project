dirlocal="/Volumes/UbuntuHome/projects/goals-WC10/"

for subdir in $dirlocal/*
do
    subdirname=$(basename $subdir)
    #ffmpeg -i $dirlocal/$subdirname/$subdirname-160.avi -y -an $dirlocal/$subdirname/$subdirname-160.mp4
    rm $dirlocal/$subdirname/$subdirname-160.avi.mp4
    #for f in $subdir/shots-160/*.avi
    #do
    #    ffmpeg -i $f -an -vcodec copy $f.mp4
    #done

done

