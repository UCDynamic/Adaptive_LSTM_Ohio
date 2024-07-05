
function [obj]=simulation_LSTM_13_3(params_test, Time, iter)
load('env')
% [genome]=chromosome(param);%assign your genome(combination of parameter)
% param= genome;

num_day=1;

[S_loop, I_loop, R_loop,L_loop]=solve_loop_opt(env, params_test,iter,1) ;
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
%                 S_loop_sum{index}(T)=S_loop_sum{index}(T)+S_loop{j,i}(T);
%                 L_loop_sum{index}(T)=L_loop_sum{index}(T)+L_loop{j,i}(T);
                I_loop_sum{index}(T)=I_loop_sum{index}(T)+I_loop{j,i}(T);
%                 R_loop_sum{index}(T)=R_loop_sum{index}(T)+R_loop{j,i}(T);
                end
            end
        end
    end
end

I_cases = 0;

for i=1:88
%     if S_loop_sum{i}(1)~=0
%           Ierr=Ierr+ rmse(Cases_Table{i}(num_day:T,1),I_loop_sum{i}(1:T)');
          I_cases = I_cases + I_loop_sum{i}(1:Time);
%     end
end

%calculate the error of the suggested parameters
% fitness=fitness_function(Time,S_loop_sum,I_loop_sum,R_loop_sum,L_loop_sum, Cases_Table, num_day);

obj = dlarray(sum(I_cases), 'CB')
end