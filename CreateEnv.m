function env=CreateEnv(pStart,pGoal,plot_env)
% Start position
env.xStart=pStart.x;
env.yStart=pStart.y;
% Goal position
env.xGoal=pGoal.x;
env.yGoal=pGoal.y;
% obstacle parameters
     env.obs.x=[1.5 4.0 2.0 6.0 6.5 8.0 5.0];
     env.obs.y=[4.5 3.0 1.0 7.0 2.5 4.0 5.0];
env.obs.radius=[0.6 0.7 0.8 1.0 1.0 0.6 0.4];
% limit the canvas
env.xmin=-10;
env.xmax=10;
env.ymin=-10;
env.ymax=10;
% limit the maximum velocity
alpha=0.1; % maximum velocity ratio
env.vel_xmax=alpha*(env.xmax-env.xmin);    % Maximum Velocity in x direction
env.vel_xmin=-env.vel_xmax;                % Minimum Velocity in x direction
env.vel_ymax=alpha*(env.ymax-env.ymin);    % Maximum Velocity in y direction
env.vel_ymin=-env.vel_ymax;                % Minimum Velocity in y direction

if plot_env
    figure()
    xobs=env.obs.x;
    yobs=env.obs.y;
    robs=env.obs.radius;
    theta=linspace(0,2*pi,100);
    for k=1:numel(xobs)
        fill(xobs(k)+robs(k)*cos(theta),yobs(k)+robs(k)*sin(theta),[0.5 0.7 0.8]);
        hold on;
    end
    plot(env.xStart,env.yStart,'bs','MarkerSize',12,'MarkerFaceColor','y');
    plot(env.xGoal,env.yGoal,'kp','MarkerSize',16,'MarkerFaceColor','g');
    hold off;
    grid on;
    axis equal;
end