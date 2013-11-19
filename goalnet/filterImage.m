%
% filter an image with double gauss deriv filter
%

filename = '/Volumes/Data/videoData/goals/LIV-MUtd-EPL13-goal/LIV-MUtd-EPL13-goal1.mov';
obj = VideoReader(filename);
video = read(obj);


for iFrame = 1 : size(video,4)
    clear resp;
    
    if mod(iFrame,10) ~= 0
        continue;
    end
    
    iFrame

    sigm = 1;
    %lineDist = 4;
    edgeSize = sigm * 5;

    I = video(:,:,1,iFrame);

    for cellDist = 1 : 50

      % use 3rd party funtion
      gaussDiff = gaussDiffKernel (sigm, 1, edgeSize / sigm);
      %lineKernel = doubleKernel(gaussDiff, lineDist, 1);
      %cellKernel = doubleKernel(lineKernel, cellDist, 0);
      cellKernel = doubleKernel(gaussDiff, cellDist, 1);

      kernel2D = cellKernel * ones(1,5);

      resp(cellDist) = sum(sum(abs(conv2(double(I), kernel2D'))));

    end

    resp = resp(10:end);
    spectrum(iFrame,:) = abs(real(fft(resp - mean(resp))));

end

%figure(1)
%plot(resp)
%figure(2)
%plot(spectrum(1:20))

h = fspecial('gaussian', [3 1], 1);
for i = 1 : size(spectrum,1)
    a = conv(spectrum(i,:), h);
    a2 = a(1:2:length(a));
    [~, xpks] = findpeaks(a2, 'THRESHOLD', 0.8);
    
    detected(i) = 0;
    if (length(xpks) > 0 && xpks(1) >= 4 && xpks(1) <= 6)
        detected(i) = 1;
    end
end
plot(detected)
