
function [ population ] = initialization(M, N, lower_limit, upper_limit)

for i = 1 : M
    for j = 1 : N 
        % population.Chromosomes(i).Gene(j) = [ rand() ];
        population.Chromosomes(i).Gene(j) = [ lower_limit(j) + (upper_limit(j) - lower_limit(j)) * rand];
    end
end

end


% lower_limit= 10e-4
% upper_limit=10e-5
% 
% test= lower_limit + (upper_limit - lower_limit) * rand;
