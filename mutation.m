
function [child] = mutation(child, Pm)

Gene_no = length(child.Gene);

for k = 1: Gene_no
    R = rand();
    if R < Pm
        child.Gene(k) = ~ child.Gene(k);
    end
end

end