function sol_interpolated=ParseSolution(sol_particle,model,env)
    xobs=env.obs.x;
    yobs=env.obs.y;
    robs=env.obs.radius;
    XS=[env.xStart sol_particle.x env.xGoal]; 
    YS=[env.yStart sol_particle.y env.yGoal]; 
    
    k=numel(XS); % model.nKeypoints+2
    TS=linspace(0,1,k);
    tt=linspace(0,1,model.nWaypoints);
    xx=spline(TS,XS,tt);
    yy=spline(TS,YS,tt);   
    dx=diff(xx);
    dy=diff(yy);
    
    L=sum(sqrt(dx.^2+dy.^2));    % L parameter in the paper 
    nobs = numel(xobs);          % Number of Obstacles
    Violation = 0;
    for k=1:nobs
        d=sqrt((xx-xobs(k)).^2+(yy-yobs(k)).^2);
        v=max(1-d/robs(k),0);
        Violation=Violation+mean(v);
    end  
    % save the solution to a structure
    sol_interpolated.TS=TS;
    sol_interpolated.XS=XS;
    sol_interpolated.YS=YS;
    sol_interpolated.tt=tt;
    sol_interpolated.xx=xx;
    sol_interpolated.yy=yy;
    sol_interpolated.dx=dx;
    sol_interpolated.dy=dy;
    sol_interpolated.L=L;
    sol_interpolated.Violation=Violation;
    sol_interpolated.IsFeasible=(Violation==0);
end
