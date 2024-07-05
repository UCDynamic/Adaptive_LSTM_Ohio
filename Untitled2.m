


x1 = [ 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9]; % Lower bound of parameters
x2 = [1 1 1 1 1 1 2 2 2 2] %Upper bound for parameters
A = [0 -1 0 0 2 0 0 0 0 0; 0 0 0 0 1 0 -1.5 0 0 0];
b = [0;0];
Aeq = [0 0 0 0 0 1 0 -1 0 0];
beq = [2.268e-6];

x0 =  [4.4020e-09,1.0005e-10,5.4308e-05,2.1123e-10, 1.8759e-10, 1.6735e-10,1.0291e-10,0.2312,4.6386e-06,0.2312]; % Array of initial guess of the parameters values
options = optimset('Display','iter','PlotFcns',@optimplotfval,'MaxIter', 5000, 'TolX',1e-9);
[x, fval] = fmincon(@simulation,x0,A,b,Aeq,beq,x1,x2,[],options)
%  [x,fval] = fminsearch(@simulation,x,options)
 % save('x','x')



% 
% 
% %
% pc = parcluster('local')
% parpool(pc, 2)
% % x1 = [ 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9 0.1e-9] % Lower bound of parameters
% % x2 = [1 1 1 1 1 1 2 2 2 2] %Upper bound for parameters
% % A = [0 -1 0 0 2 0 0 0 0 0; 0 0 0 0 1 0 -1.5 0 0 0];
% % b = [0;0];
% % Aeq = [0 0 0 0 0 1 0 -1 0 0];
% % beq = [2.268e-6];
% % 
% % x0 =  [4.4020e-09,1.0005e-10,5.4308e-05,2.1123e-10, 1.8759e-10, 1.6735e-10,1.0291e-10,0.2312,4.6386e-06,0.2312]; % Array of initial values
% % options = optimset('Display','iter','PlotFcns',@optimplotfval,'MaxIter', 5000, 'TolX',1e-9);
% % [x, fval] = ga(@simulation,10,A,b,Aeq,beq,x1,x2,[],options)
% % %  [x,fval] = fminsearch(@simulation,x,options)
% %  save('x','x')
% save
% 
% 
% % param2= [0.3802, 0.00000401, 0.0000643, 0.000000623, 0.00000307, 0.04143227, 0.00000503, 0.0414300, 0.0389, 2.5]
% % param= [0.4249, 0.8791, 0.531, 0.0552, 0.3328, 0.7230, 0.9338, 0.9879, 0.1758, 0.0610]
% 
%  % Define the GA options
% options = optimoptions('ga', ...
%     'PopulationSize', 50, ...
%     'MaxGenerations', 100, ...
%     'UseParallel', true, ...
%     'Display', 'iter', 'ConstraintTolerance',1e-6, 'PlotFcns', @gaplotbestf);
% 
% % options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);
% 
% % Define the lower and upper bounds for each parameter
% lb = [0.001, 0.0000001, 0.0000001, 0.0000001, 0.0000001, 0.001, 0.0000001, 0.001, 0.001, 1];
% ub = [1, .0001, .0001, .0001, .0001, 1, .0001, 1, 1, 3];
% 
% % Run the GA to optimize the parameters
% [params_opt, fval_opt] = ga(@simulation, 10, [], [], [], [], lb, ub, [], options);
% save('x', 'x')
% 
% % Train the final PDE based SLIR model with the optimized parameters
% % final_model = train_pde_slir_model(params_opt);
% delete(gcp('nocreate'))