%
% filter an image with double gauss deriv filter
%

clear all

% consts
%
% extracted channel
Channel = 1;
%
sigm = 1;
%
FirstDist = 10;
NumDists = 128;
% model threshold, the more the more probable is the peak
Thresh = 0.2;

MinPeakFreq = 5;



I = imread ('/Users/evg/Desktop/CMU/course-LBMV/LBMV-project/goalnet/im00004.jpg');

I = I(:,:,Channel);



clear resp;

edgeSize = sigm * 5;
for dist = 1 : FirstDist + NumDists

  % use 3rd party funtion
  gaussDiff = gaussDiffKernel (sigm, 1, edgeSize / sigm);
  cellKernel = doubleKernel(gaussDiff, dist, 1);

  kernel2D = cellKernel * ones(1,5);
  kernel2D = kernel2D'; % default kernel will be horizontal

  signal(dist) = sum(sum(abs(conv2(double(I), kernel2D)))) / size(I,1) / size(I,2);

end

% EITHER
% remove the straight line using moving average
%movingAvgFilter = repmat(1/FirstDist/2, FirstDist*2, 1);
%signal = resp(FirstDist : end-FirstDist) - conv(resp, movingAvgFilter, 'valid');

signal = signal(FirstDist:end);

% OR
signal = signal - [1:length(signal)] / length(signal) * (signal(end) - signal(1));
signal' - mean(signal);

spectrum = abs(real(fft(signal)));
% remove the second half of the spectrum
spectrum(uint32(length(spectrum)/2) : end) = [];
spectrum(1:2) = 0;


figure(1)
plot(signal)
figure(2)
plot(spectrum)


% get the highest
[maxVal, maxInd] = max(spectrum(MinPeakFreq : end));
% remove peak and +- 30%
spectrum( uint32(maxInd * 0.7) : uint32(maxInd * 1.3) ) = [];
% get the mean w/o peak
meanSpectr = mean(spectrum);


% compare the max and the mean w/o peak
metrics = meanSpectr / maxVal
if meanSpectr / maxVal < Thresh
    detected = 1
    period = NumDists / (maxInd + MinPeakFreq)
else
    detected = 0
end
