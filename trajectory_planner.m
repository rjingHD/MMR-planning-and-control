clc;
clear;
close all;
%% look at the environment
plot_env = true;
env=CreateEnv(pStart,pGoal,plot_env);
%% run PSO trajectory planner
%% Test case 1
pStart.x = 0;
pStart.y = 0;
pGoal.x = 9;
pGoal.y = 9;
GlobalBest1 = PSO_planner(pStart,pGoal);
%% Test case 2
pStart.x = 0;
pStart.y = 2;
pGoal.x = 9;
pGoal.y = 5;
GlobalBest2 = PSO_planner(pStart,pGoal);