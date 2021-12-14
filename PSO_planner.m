function GlobalBest = PSO_planner(pStart,pGoal)
plot_env = false;
env=CreateEnv(pStart,pGoal,plot_env);                     %% setup the environment
model=CreateModel();                             %% setup PSO parameters
CostFunction=@(x) CurrentPathCost(x,model,env);  % Cost Function
VarSize=[1 model.nKeypoints];                    
%% Initialization
% Create Empty Particle Structure
empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];
% Initialize Global Best
GlobalBest.Cost=inf;
% Create Particles Matrix
particle=repmat(empty_particle,model.nParticle,1);
% Initialization loop
for i=1:model.nParticle
    % Initialize Position
    if i > 1
        particle(i).Position=CreateRandomPath(model,env);
    else
        % 1 particle is the straight line from xStart to xGoal
        xx = linspace(env.xStart, env.xGoal, model.nKeypoints+2);
        yy = linspace(env.yStart, env.yGoal, model.nKeypoints+2);
        particle(i).Position.x = xx(2:end-1);
        particle(i).Position.y = yy(2:end-1);
    end
    
    % Initialize Velocity
    particle(i).Velocity.x=zeros(VarSize);
    particle(i).Velocity.y=zeros(VarSize);
    
    % Evaluation
    [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost   
        GlobalBest=particle(i).Best;     
    end
end

% Array to Hold Best Cost Values at Each Iteration
BestCost=zeros(model.MaxIt,1);
%% PSO Main Loop
for it=1:model.MaxIt   
    for i=1:model.nParticle
        % x Part
        % Update Velocity
        particle(i).Velocity.x = model.w*particle(i).Velocity.x ...
            + model.c1*rand(VarSize).*(particle(i).Best.Position.x-particle(i).Position.x) ...
            + model.c2*rand(VarSize).*(GlobalBest.Position.x-particle(i).Position.x);
        % Update Velocity Bounds
        particle(i).Velocity.x = max(particle(i).Velocity.x,env.vel_xmin);
        particle(i).Velocity.x = min(particle(i).Velocity.x,env.vel_xmax);       
        % Update Position
        particle(i).Position.x = particle(i).Position.x + particle(i).Velocity.x;    
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Position.x<env.xmin | particle(i).Position.x>env.xmax);
        particle(i).Velocity.x(OutOfTheRange)=-particle(i).Velocity.x(OutOfTheRange);       
        % Update Position Bounds
        particle(i).Position.x = max(particle(i).Position.x,env.xmin);
        particle(i).Position.x = min(particle(i).Position.x,env.xmax);
        
        % y Part   
        % Update Velocity
        particle(i).Velocity.y = model.w*particle(i).Velocity.y ...
            + model.c1*rand(VarSize).*(particle(i).Best.Position.y-particle(i).Position.y) ...
            + model.c2*rand(VarSize).*(GlobalBest.Position.y-particle(i).Position.y);
        % Update Velocity Bounds
        particle(i).Velocity.y = max(particle(i).Velocity.y,env.vel_ymin);
        particle(i).Velocity.y = min(particle(i).Velocity.y,env.vel_ymax);   
        % Update Position
        particle(i).Position.y = particle(i).Position.y + particle(i).Velocity.y;
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Position.y<env.ymin | particle(i).Position.y>env.ymax);
        particle(i).Velocity.y(OutOfTheRange)=-particle(i).Velocity.y(OutOfTheRange);
        % Update Position Bounds
        particle(i).Position.y = max(particle(i).Position.y,env.vel_ymin);
        particle(i).Position.y = min(particle(i).Position.y,env.vel_ymax);
        % Evaluation
        [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end     
        end
    end
    % Update Best Cost Ever Found
    BestCost(it)=GlobalBest.Cost;
    
    % Inertia Weight Damping
    model.w=model.w*model.wdamp;

    % Show Iteration Information
    if GlobalBest.Sol.IsFeasible
        Flag=' *';
    else
        Flag=[', Violation = ' num2str(GlobalBest.Sol.Violation)];
    end
    disp(['Iteration ' num2str(it) ': Minimal cost=' num2str(BestCost(it)) Flag]);
    % Plot Solution
    figure(1);
    PlotSolution(GlobalBest.Sol,env,it,GlobalBest.Cost);
    if it == 1
        date = datestr(now,'mmddyy-HHMMSS');
        gif(['PSO-' date '.gif']);
    else
        gif
    end
    pause(0.005);
end
%% Results
f = figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Minimal Cost');
grid on;
exportgraphics(f,['cost-' date '.png'],'Resolution',300)