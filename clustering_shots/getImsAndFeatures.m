function [ims_for_shot,hogs,gists]=getImsAndFeatures(video,images_per_shot)

if nargin<3
    show=0;
end

ims_in_shot=size(video,4);
inc=floor(ims_in_shot/(images_per_shot+1));
inc=inc:inc:ims_in_shot;
inc=inc(1:images_per_shot);
ims_for_shot=video(:,:,:,inc);


for i=1:size(ims_for_shot,4)
    hog_curr=getHogFeature(ims_for_shot(:,:,:,i),show);
    if i==1
        hogs=zeros(size(ims_for_shot,4),numel(hog_curr));
    end
    hogs(i,:)=hog_curr;
end
gists=getGists(ims_for_shot,show);

end