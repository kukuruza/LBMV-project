function [] = getHistDiff (videoFile, outTxtFile, video)

if nargin <= 3
   obj = VideoReader(videoFile);
   video = read(obj);
end

numFrames = size(video, 4);
numBinsChannel = 25;

diffs = zeros(numFrames - 1, 1);

I2 = video(:,:,:,1);
for iFrame = 1 : numFrames - 1

    I1 = I2;
    I2 = video(:,:,:,iFrame+1);

    h1red   = imhist(I1(:,:,1), numBinsChannel);
    h1green = imhist(I1(:,:,2), numBinsChannel);
    h1blue  = imhist(I1(:,:,3), numBinsChannel);
    h1 = [h1red; h1green; h1blue];

    h2red   = imhist(I2(:,:,1), numBinsChannel);
    h2green = imhist(I2(:,:,2), numBinsChannel);
    h2blue  = imhist(I2(:,:,3), numBinsChannel);
    h2 = [h2red; h2green; h2blue];

    diffs(iFrame) = sum(abs(h1 - h2)) / 2 / size(I1,1) / size(I1,2);
    if (mod(iFrame, 100) == 0)
        fprintf('frame %d \n', iFrame);
    end
    
end

dlmwrite (outTxtFile, [[1:length(diffs)]', diffs], ' ');
