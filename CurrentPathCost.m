function [z, solWaypoints]=CurrentPathCost(solKeypoints,model,env)
    solWaypoints=ParseSolution(solKeypoints,model,env); 
    z=solWaypoints.L*(1+model.beta*solWaypoints.Violation);
end