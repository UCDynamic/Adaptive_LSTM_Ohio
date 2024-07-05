function [fitness]=fitness_function(T,S_loop_sum,I_loop_sum,R_loop_sum,L_loop_sum, Cases_Table,num_day)
Serr=0;
Ierr=0;
Rerr=0;
Lerr=0;

S_cases=0;
I_cases=0;
R_cases=0;


S_model=0;
I_model=0;
I_true=0;
T;
num_day;

for i=1:88
    if S_loop_sum{i}(1)~=0
        % current use
%         I_model = I_model + I_loop_sum{i}(1:5);
%         I_true = I_true + Cases_Table{i}(15+1:15+5,1);
       
%          Serr=Serr+ rmse(Cases_Table{i}(num_days:T,5),(S_loop_sum{i}(num_days:T)+L_loop_sum{i}(num_days:T))');
%          Serr=Serr+ rmse(Cases_Table{i}(num_day+14:T+14,5),(S_loop_sum{i}(1:15)+L_loop_sum{i}(1:15))');
          Ierr=Ierr+ rmse(Cases_Table{i}(16:25,1),I_loop_sum{i}(1:10)');
%           Ierr=Ierr+ rmse(Cases_Table{i}(T,1),I_loop_sum{i}(15));
%           Rerr=Rerr+ rmse(Cases_Table{i}(num_days:T,4),R_loop_sum{i}(num_days:T)');
%           Rerr=Rerr+ rmse(Cases_Table{i}(num_day+14:T+14,4),R_loop_sum{i}(1:15)');

    end
end

% fitness_new= Serr+ Ierr+ Rerr;
% Serr;
% Ierr
% Rerr

% Ierr=Ierr+ rmse(I_true, I_model);
% fitness=[Serr Ierr Rerr];
fitness= [Ierr]
% class(fitness);
% S_error= S_cases - S_model;
% I_error= I_cases - I_model;
% R_error= R_cases - R_model;
% 
% 
% % fitness= mean(abs([S_cases, I_cases, R_cases] - [S_model, I_model, R_model]));
% fitness= mean(abs([S_error, I_error, R_error]));
end