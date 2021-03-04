function newChain = IncreaseKmax(Chain, newKmax)
Nchain = size(Chain,1);
oldcolumn = size(Chain,2);
newChain = zeros(Nchain,4+(newKmax*2)+2*(newKmax-3));
newChain(:,1:oldcolumn) = Chain;
end