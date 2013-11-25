function [xPCAwhite]=whiten_data(x)
epsilon=0.0001;

    avg = mean(x, 1);     % Compute the mean pixel intensity value separately for each patch. 
x = x - repmat(avg, size(x, 1), 1);

sigma = x * x' / size(x, 2);

[U,S,~] = svd(sigma);
xPCAwhite = diag(1./sqrt(diag(S) + epsilon)) * U' * x;
end