classdef chromosome
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    grid
    limits 
    del_x
    tau
    N
    lambda % alpha in non-dim. model
    eta_s
    theta
    phi
    eta_l
    delta
    eta_r
    omega
     e
    alpha
    
    end
    
    methods
        function genome = chromosome(Array)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here
            genome.grid = 50;
            genome.limits = [-85,-80,38,43]; 
            genome.del_x = 345/50;
            genome.tau = 15;
            genome.N = 1;
            genome.lambda = Array(1);     
            genome.eta_s = Array(2);      
            genome.theta = Array(3);    
            genome.phi = Array(4);  
            genome.eta_l = Array(5);        
            genome.delta = Array(6);
            genome.eta_r = Array(7);
            genome.omega = Array(8);
    % latency terms
            genome.e = Array(9);     
            genome.alpha = Array(10); 
        

        end 
    end
end

