filename = 'videoFragments/Liverpool_Man_Utd_1_September_2013-1st-10-sm.mp4';

%obj = VideoReader(filename);
%video = read(obj);

numFrames = size(video, 4);
numBinsChannel = 100;

for iFrame = 1 : numFrames - 1

    I1 = video(:,:,:,iFrame);
    I2 = video(:,:,:,iFrame+1);

    h1red   = imhist(I1(:,:,1), numBinsChannel);
    h1green = imhist(I1(:,:,2), numBinsChannel);
    h1blue  = imhist(I1(:,:,3), numBinsChannel);
    h1 = [h1red; h1green; h1blue];

    h2red   = imhist(I2(:,:,1), numBinsChannel);
    h2green = imhist(I2(:,:,2), numBinsChannel);
    h2blue  = imhist(I2(:,:,3), numBinsChannel);
    h2 = [h2red; h2green; h2blue];

    diff(iFrame) = sum(abs(h1 - h2)) / 2 / size(I1,1) / size(I1,2);
    diff(iFrame)
    
end
