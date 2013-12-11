function [hog_features]=getHogFeature(I,show)
if nargin<2
    show=0;
end

I=single(rgb2gray(I))/255;
 H=hog(I); 
 hog_features=H(:);
    if show>0
 figure(1); im(I); V=hogDraw(H); figure(2); im(V)
    end
end