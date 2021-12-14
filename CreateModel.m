function model=CreateModel()
    %%%%%% PSO Parameters %%%%%%
    model.nKeypoints=5;     % number of nodes, dimension of particle, M in the paper
    model.nWaypoints=500;   % number of waypoints in the path, n in the paper
    model.beta=100;         % penalty parameter for obstacle collision, c_v in the paper
    model.MaxIt=100;        % Maximum Number of Iterations G=50 in the paper
    model.nParticle=300;    % number of particles for each iteration P=300 in the paper
    
    % % Constriction Coefficient
    % Clerc, Maurice, and James Kennedy. "The particle swarm-explosion, stability,
    % and convergence in a multidimensional complex space." IEEE transactions on 
    % Evolutionary Computation 6.1 (2002): 58-73.
    model.phi1=2.05;
    model.phi2=2.05;
    phi=model.phi1+model.phi2;
    chi=2/(phi-2+sqrt(phi^2-4*phi));
    model.w=chi;                     % Inertia Weight
    model.wdamp=1;                   % Inertia Weight Damping Ratio
    model.c1=chi*model.phi1;         % Personal Learning Coefficient
    model.c2=chi*model.phi2;         % Global Learning Coefficient
    
    % % Constriction Coefficient
    % w=1;                % Inertia Weight
    % wdamp=0.98;         % Inertia Weight Damping Ratio
    % c1=1.5;             % Personal Learning Coefficient
    % c2=1.5;             % Global Learning Coefficient
end