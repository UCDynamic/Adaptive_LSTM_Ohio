
function [obj]=simulation_LSTM(param)

% param= chromosome(param)
load('env')
% [genome]=chromosome(param);%assign your genome(combination of parameter)
% param= genome;
Time=15;
iter=15;
num_day=1;
% param_list(T,:)= param;
[genome]=chromosome(param);%assign your genome(combination of parameter)

param= genome;

 [S_loop, I_loop, R_loop,L_loop]=solve_loop(env, param,iter,1) ;
%n
for i=1:88
    for j=1:iter
S_loop_sum{i}(j)=0; 
I_loop_sum{i}(j)=0;
R_loop_sum{i}(j)=0;
L_loop_sum{i}(j)=0;
    end
end

cells=zeros(88,1);

for index=1:88
    for i=1:50
        for j=1:50
            if env(j,i).index==index
                cells(index)=cells(index)+1;
                for T=1:iter
                S_loop_sum{index}(T)=S_loop_sum{index}(T)+S_loop{j,i}(T);
                L_loop_sum{index}(T)=L_loop_sum{index}(T)+L_loop{j,i}(T);
                I_loop_sum{index}(T)=I_loop_sum{index}(T)+I_loop{j,i}(T);
                R_loop_sum{index}(T)=R_loop_sum{index}(T)+R_loop{j,i}(T);
                end
            end
        end
    end
end

% S_loop_sum
% L_loop_sum
% I_loop_sum
% R_loop_sum


%calculate the error of the suggested parameters
fitness=fitness_function(Time,S_loop_sum,I_loop_sum,R_loop_sum,L_loop_sum, Cases_Table, num_day);
% obj=mean(fitness)
obj= mean(fitness)
end