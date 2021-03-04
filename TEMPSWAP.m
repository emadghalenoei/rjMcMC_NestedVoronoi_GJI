function TAB=TEMPSWAP(T,TAB0)
global swap_counter swap_total
% a usefull formula: T(p)*T(q) == min(T(T > 1)) % swap between level 1 and 2
% level 1 means T==1
% level 2 means T== 1.5^1
TAB=TAB0;
n=size(TAB0,1);
p = randi([1,n],1,1);
q = randi([1,n],1,1);
while T(p)==T(q)
    p = randi([1,n],1,1);
    q = randi([1,n],1,1);
end
swap_total(p,q) = swap_total(p,q) + 1;
swap_total(q,p) = swap_total(q,p) + 1;
Prob=exp(((1/T(p))-(1/T(q)))*(TAB(q,1)-TAB(p,1)));
if rand() <=Prob
    TAB(p,:)=TAB0(q,:);
    TAB(q,:)=TAB0(p,:);
    swap_counter(p,q) = swap_counter(p,q) + 1;
    swap_counter(q,p) = swap_counter(q,p) + 1;
else
end
