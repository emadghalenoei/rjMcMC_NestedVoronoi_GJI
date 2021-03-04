function [data_mean, hpd] = HPD_FAST(x,alpha)
% x your signal
% alpha: the code returns the 100(1 - alpha)% confidence intervals. For example, alpha = 0.05 yields 95% confidence intervals.
%p for 100-p% HPD
p=alpha*100;
pts=linspace(0.1,99.9-p,20);
data_mean = zeros(size(x,1),1);
hpd = zeros(size(x,1),2);
K = ceil(size(x,1)/1000);
for i = 1: K
    inx1 = 1000*(i-1)+1;
    if i < K
        inx2 = 1000*i;
    else
        inx2 = size(x,1);
    end
    xm = x(inx1:inx2,:);
    pt1=prctile(xm,pts(end),2);      %Calculate the 95th percentiles along the rows of x
    pt2=prctile(xm,p(1)+pts(1),2);   %Calculate the 5th percentiles along the rows of x
    data_mean(inx1:inx2,1) = mean(xm,2);
    hpd(inx1:inx2,1:2)=[pt2 pt1];
end
end