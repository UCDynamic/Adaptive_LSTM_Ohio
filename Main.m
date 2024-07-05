
clear
clc

%% controling paramters of the GA algortihm
Problem.obj = @simulation;
Problem.nVar = 10;

M = 20; % number of chromosomes (cadinate solutions)
N = Problem.nVar;  % number of genes (variables)
MaxGen = 3;
Pc = 0.85;
Pm = 0.01;
Er = 0.05;
lower_limit=[0.1,0.1,10e-6,10e-7,10e-6,10e-6,10e-6,0.01,0.01,0.5];
upper_limit=[1,1,10e-7,10e-8,10e-7,10e-7,10e-7,1,1,2.5];
visualization = 1; % set to 0 if you do not want the convergence curve 

[BestChrom]  = GeneticAlgorithm (M , N, MaxGen , Pc, Pm , Er , Problem.obj , visualization, lower_limit, upper_limit)

disp('The best chromosome found: ')
BestChrom.Gene
disp('The best fitness value: ')
BestChrom.Fitness