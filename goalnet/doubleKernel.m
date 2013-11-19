function outKernel = doubleKernel (inKernel, dist, doFlip)

assert (size(inKernel,2) == 1);

% shift usual derivative one and the other way along the axis
shiftUp   = [inKernel; zeros(dist,1)];
shiftDown = [zeros(dist,1); inKernel];

if doFlip == 0
    outKernel = shiftUp + shiftDown;
else
    outKernel = shiftUp - shiftDown;
end

