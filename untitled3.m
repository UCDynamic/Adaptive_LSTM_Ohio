% % Define the initial parameters for your SIR model
% params_initial = [0.3802,4.0005e-06,6.4308e-05,6.23e-07,3.0759e-06,0.0414,5.0291e-06,0.0414,0.0389,2.3]; % Random initial guess for day 1 parameters
% numDays= 10;
% dayData=1;
% optimalParamsDay = zeros(10, numDays);
% 
% % Define options for the optimization
% options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'iter-detailed', 'MaxFunctionEvaluations', 1000);
% 
% % Define the objective function for the optimizer
% objectiveFunction = @(x) simulation(x, dayData, dayData, optimalParamsDay);
% 
% % Run the optimizer
% [optimalParams, fval, exitflag, output] = fminunc(objectiveFunction, params_initial, options);
% 
% for day = 1:numDays
%     dayData = day; % Or any other relevant data needed for the simulation
% 
%     % Call the optimizer with the updated objective function for the current day
%     [optimalParams, fval, exitflag, output] = fminunc(objectiveFunction, optimalParams, options); % Use the previous day's optimalParams as the initial guess
% 
%     % Store the optimal parameters and any other relevant info
%     optimalParamsDay(day,:) = optimalParams;
%     fvalHistory(day) = fval;
%     exitflagHistory(day) = exitflag;
% 
%     % Optional: Update your model or process based on the results here
% end


% Define options for the optimization
% options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'iter-detailed', 'MaxFunctionEvaluations', 1000,'FunctionTolerance', 1e-6);
% options = optimset('Display','iter','PlotFcns',@optimplotfval,'MaxIter', 500, 'TolX',1e-9);
options = optimoptions('fmincon', 'Display', 'iter', 'StepTolerance', 1e-11);
numDays=45;

%mincon parameters
% x1 = [ 0.1e-9 0.1e-9 0.1e-19 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9]; % Lower bound of parameters
% x2 = [1 0.1e-2 0.1e-4 0.1e-2 0.1e-2 1 0.1e-2 2 2 3]; %Upper bound for parameters\
% x1=[];
% x2=[];
x1 = [0.1e-9,0.8e-9,0.1e-9];
x2 = [0.1e-3,0.1e-2,0.1e-3];
% A = [0 -1 0 0 2 0 0 0 0 0; 0 0 0 0 1 0 -1.5 0 0 0];
% b = [0;0];
A=[];
b=[];
% Aeq = [0 0 0 0 0 1 0 -1 0 0];
% beq = [2.268e-6];
Aeq=[];
beq=[];
iter=15;
% Initialize parameters
params_initial = [0.3802,4.0005e-06,6.4308e-5,6.23e-07,3.0759e-06,0.0414,5.0291e-06,0.0414,0.0389,2.3]; % Your initial guess for the parameters
% params_initial= [4.4020e-09,1.0005e-10,5.4308e-05,2.1123e-10, 1.8759e-10, 1.6735e-10,1.0291e-10,0.2312,4.6386e-06,0.2312];

% Preallocate array for storing optimal parameters each day
optimalParamsHistory = zeros(numDays, 1);
for i=1:numDays
optimalParamsHistory(i,1) = params_initial(2);
optimalParamsHistory(i,2) = params_initial(4);
optimalParamsHistory(i,3) = params_initial(5);
end
% [x, fval] = fmincon(@(x) simulation_opt(x,2,2,optimalParamsHistory),optimalParamsHistory(1,:),A,b,Aeq,beq,x1,x2,[],options);
param_initial = [4.0005e-06, 6.23e-07, 3.0759e-06];
x = [4.0005e-06, 6.23e-07, 3.0759e-06];

% Loop through each day, updating parameters
for num = 2:numDays
    % Define the objective function for the current day
    % Assuming 'simulateSIR' returns the simulated data for the current 'params' and 'day'
    % And 'computeRMSE' computes the RMSE for the simulated data against true data for 'day'
    % objectiveFunction = @(x) simulation(x, day, day, optimalParamsHistory);
    loadFilename = sprintf('env_%d', num-1)
    load(loadFilename)
    if num < numDays
        x_project = params_initial;
        if num ==2
            x_project(2) = param_initial(1);
            x_project(4) = param_initial(2);
            x_project(5) = param_initial(3);
        else
            x_project(2) = x(1);
            x_project(4) = x(2);
            x_project(5) = x(3);
        end
        x_project = chromosome(x_project);
        [S_loop, I_loop, R_loop,L_loop]=solve_loop(env, x_project,15,1);
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
        loadFilename = sprintf('env_%d', num);
        load(loadFilename);
        for i=1:88
            if S_loop_sum{i}(1)~=0
                Cases_Table{i}(16,5) = S_loop_sum{i}(1,2);
                Cases_Table{i}(16,1) = I_loop_sum{i}(1,2);
                Cases_Table{i}(16,4) = R_loop_sum{i}(1,2);         
            end
        end
    end
    saveFilename = sprintf('env_%d', num);
    save(saveFilename,'env','Cases_Table','S_T_loop','I_T_loop');
    % Run the optimizer for the current day
    % [optimalParams, fval, exitflag, output] = fminunc(objectiveFunction, params_initial, options);
    num_day= num-1;
    [x, fval] = fmincon(@(x) simulation_opt(x,num_day),[0.001*num_day,0.001*num_day,0.001*num_day],A,b,Aeq,beq,x1,x2,[],options);

    % Store the optimal parameters for the current day
    optimalParamsHistory(num,:) = x
    fval
    
    % Update initial guess for the next day's parameters
    % params = optimalParams;
end
for i = 1:numDays
    optimalParams(i,:) = params_initial;
    optimalParams(i,2) = optimalParamsHistory(i,1);
    optimalParams(i,4) = optimalParamsHistory(i,2);
    optimalParams(i,5) = optimalParamsHistory(i,3);
end
% Display or use optimalParamsHistory as needed
