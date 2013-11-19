function outKernel = doubleGaussDiffKernel (singleSigma, dist)
%
% create bimodal gaussian deriv kernel
%

%singleSigma = 2;
%dist = singleSigma * 5;
edgeSize = singleSigma * 3;

% use 3rd party funtion
singleKernel = gaussDiffKernel (singleSigma, 1, edgeSize / singleSigma);
outKernel = doubleKernel(singleKernel, dist);
