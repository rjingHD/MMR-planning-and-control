function sol=CreateRandomPath(model,env)
    sol.x=unifrnd(env.xmin,env.xmax,1,model.nKeypoints);
    sol.y=unifrnd(env.ymin,env.ymax,1,model.nKeypoints);
end