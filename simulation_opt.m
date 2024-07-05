
function [obj]=simulation_opt(param_solving,num_day)

% param= chromosome(param)

loadFilename = sprintf('env_%d', num_day)
load(loadFilename)
% [genome]=chromosome(param);%assign your genome(combination of parameter)
% param= genome;
Time=14+num_day;
iter=15;
param = [0.3802,4.0005e-06,6.4308e-5,6.23e-07,3.0759e-06,0.0414,5.0291e-06,0.0414,0.0389,2.3]; % Your initial guess for the parameters
param(2) = param_solving(1);
param(4) = param_solving(2);
param(5) = param_solving(3);
% param_list(T,:)= param;
[genome]=chromosome(param);%assign your genome(combination of parameter)

param = genome
if num_day > 1
    for i=1:param.grid
        for j=1:param.grid
            Mat_idx(j,i)=env(j,i).index;
        end
    end
    for i=1:88
        i;
        row=[];
        col=[];
        IDX=i; %county index of interest
        
         [row, col]=find(Mat_idx==IDX); %find row and column numbers of the environment with that county
         t_cells=length(row); %total number of cells
         
         population=Cases_Table{IDX}(16,5)/t_cells;   %pop per cell in a county
         initial_inf=Cases_Table{IDX}(16,1)/t_cells;
         initial_r=Cases_Table{IDX}(16,4)/t_cells;
         for j=1:t_cells
             env(row(j),col(j)).S=population;
             env(row(j),col(j)).I=initial_inf;
             env(row(j),col(j)).R=initial_r;
         end     
    end
end
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