function [fitness]=fitness_function_LSTM(T,S_loop_sum,I_loop_sum,R_loop_sum,L_loop_sum, Cases_Table,num_day)
S_cases=0;
I_cases=0;
R_cases=0;

T;
num_day;

for i=1:88
    if S_loop_sum{i}(1)~=0
%           Ierr=Ierr+ rmse(Cases_Table{i}(num_day:T,1),I_loop_sum{i}(1:T)');
          I_cases = I_cases + I_loop_sum{i}(1:T);
    end
end
fitness= [I_cases];
end