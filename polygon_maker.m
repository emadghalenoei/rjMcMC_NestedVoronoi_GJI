function P= polygon_maker(P)

%P = [x; y]; % coordinates / points 
c = mean(P,1); % mean/ central point 
d = P-c ; % vectors connecting the central point and the given points 
th = atan2(d(:,2),d(:,1)); % angle above x axis
[th, idx] = sort(th);   % sorting the angles 
P = P(idx,:); % sorting the given points

P = [P; P(1,:)]; % add the first at the end to close the polygon



%[in,on] = inpolygon(xq,yq,xv,yv)