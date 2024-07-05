% Assuming you have a function 'simulateSIR' that simulates the SIR model for a given day and returns model output
% And 'computeRMSE' that computes the RMSE between the simulated data and true data
% 'params' is a vector containing your model parameters

% Initialize parameters for day 1
params = [0.3802,4.0005e-06,6.4308e-05,6.23e-07,3.0759e-06,0.0414,5.0291e-06,0.0414,0.0389,2.3]; % Random initial guess for day 1 parameters
numDays= 10;

% Define true SIR data for each day: trueDataDay{1}, trueDataDay{2}, ..., trueDataDay{T}
% trueDataDay = {...}; % Cell array of true data for each day

% Define options for the optimizer
options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'iter');

% Preallocate array for storing optimal parameters each day
optimalParamsDay = zeros(10, numDays);

% Sequentially estimate parameters for each day
for day = 1:numDays
    % Define the objective function for the current day
    objectiveFunction = @(x) simulation(x, day, day, optimalParamsDay);
    % Run the optimizer for the current day
    [optimalParams, ~] = fminunc(objectiveFunction, params, options);

    
    
    % [optimalParams, ~] = fminunc(simulation(params, day,day, optimalParamsDay), params, options);
    
    % Store the optimal parameters for the current day
    optimalParamsDay(day,:) = optimalParams;
    
    % Update initial guess for the next day's parameters
    params = optimalParams;
end

% Custom function to compute RMSE might look like this:
function rmse = computeRMSE(simulatedData, trueData)
    differences = simulatedData - trueData;
    rmse = sqrt(mean(differences .^ 2));
end
