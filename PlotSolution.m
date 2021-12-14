function PlotSolution(sol,env,iter,BestCost)
    xobs=env.obs.x;
    yobs=env.obs.y;
    robs=env.obs.radius;
    
    XS=sol.XS;
    YS=sol.YS;
    xx=sol.xx;
    yy=sol.yy;
    
    theta=linspace(0,2*pi,100);
    for k=1:numel(xobs)
        fill(xobs(k)+robs(k)*cos(theta),yobs(k)+robs(k)*sin(theta),[0.5 0.7 0.8]);
        hold on;
    end
    plot(xx,yy,'k','LineWidth',2);
    plot(XS,YS,'ro');
    plot(env.xStart,env.yStart,'bs','MarkerSize',12,'MarkerFaceColor','y');
    plot(env.xGoal,env.yGoal,'kp','MarkerSize',16,'MarkerFaceColor','g');
    xlabel(['Iteration ' num2str(iter) ': Minimal cost=' num2str(BestCost)]);
    hold off;
    grid on;
    axis equal;
end