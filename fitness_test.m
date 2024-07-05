function fitness= fitness_test(pred, true)
fitness=0;
pred= double(extractdata(pred))
true = extractdata(true);
for i=1:length(true)
    fitness= fitness + immse(true(1,i), pred(1,i));
end

end