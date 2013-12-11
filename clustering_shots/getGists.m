function [gists]=getGists(ims,show)


if nargin<2
    show=0;
end

param.imageSize = [size(ims(:,:,:,1),1) size(ims(:,:,:,1),2)];
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;


n_features = sum(param.orientationsPerScale)*param.numberBlocks^2;
gists = zeros([size(ims,4) n_features]);



for i=1:size(ims,4)
    %     avg_fig=getAverageFrame(video_seg{i});
    avg_fig=ims(:,:,:,i);
    if show>0
        [gists(i, :),param_temp] = LMgist(avg_fig, '', param);
        figure;
        subplot(121);
        imshow(avg_fig);
        title('Input image');
        subplot(122);
        showGist(gists(i,:), param_temp);
        title('Descriptor');
    else
        gists(i, :)= LMgist(avg_fig, '', param);
    end
    
end



end