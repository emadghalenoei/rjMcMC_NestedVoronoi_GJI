function [identity, kcell] = Identify(xm,zm,xchild,zchild)

xm = xm';
zm = zm';
xchild = xchild';
zchild = zchild';
Nnode = length(xchild);

IDXX = knnsearch([xm zm], [xchild  zchild]);
IDXX = reshape(IDXX,size(xchild));

region = zeros(3,Nnode);
ind = sub2ind(size(region),IDXX,(1:Nnode)');
region(ind) = 1;

region(1,:) = 1 * region(1,:); %sed
region(2,:) = 2 * region(2,:); %salt
region(3,:) = 3 * region(3,:); %basement

identity = sum(region,1);

ksed  = sum(identity==1);
ksalt = sum(identity==2);
kbase = sum(identity==3);

kcell = [ksed, ksalt, kbase];

end