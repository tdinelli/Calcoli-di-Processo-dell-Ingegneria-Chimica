%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl <marco.mehl@polimi.it>                             %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.chem.polimi.it>            %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% DYNAMIC_SYSTEMS_SIMULATION - Simulates two classic dynamical systems:
% 
% 1. Lotka-Volterra Predator-Prey Model:
%    A classic model describing the dynamics between predator and prey populations
%    dx/dt = αx - βxy     (prey population)
%    dy/dt = δxy - γy     (predator population)
%    where:
%    - x: prey population
%    - y: predator population
%    - α: prey growth rate
%    - β: predation rate
%    - γ: predator death rate
%    - δ: predator growth rate from predation
% 
% 2. Lorenz System:
%    A chaotic system that demonstrates the butterfly effect
%    dx/dt = σ(y - x)
%    dy/dt = x(ρ - z) - y
%    dz/dt = xy - βz
%    Classic parameters: σ = 10, ρ = 28, β = 8/3
clear all, close all, clc

%% Part 1: Lotka-Volterra Simulation
% Define global parameters for the predator-prey model
global alpha beta gamma delta
alpha = .3;   % Prey growth rate
beta = .15;   % Predation rate
gamma = .1;   % Predator death rate
delta = .1;   % Predator growth rate from predation

% Solve the system using ODE45 
% Initial conditions: 7 prey, 3 predators
[t, y] = ode45(@lotkavolterra, [0 200], [7 3]);

% Visualize predator-prey dynamics
figure(1)
hold on
plot(t, y(:,1), 'LineWidth', 2.2, 'LineStyle','--')
plot(t, y(:,2), 'LineWidth', 2.2, 'LineStyle','-.')
title('Lotka-Volterra Predator-Prey Model', 'FontSize', 18)
legend('Predator', 'Prey', 'FontSize', 18)
xlabel('Time', 'FontSize', 18)
ylabel('Population Size', 'FontSize', 18)
grid on

%% Part 2: Lorenz System Simulation
% Lorentz parameters
params = [10, 28, 8/3];

% Generate 100 random initial conditions in [-15, 15]³
x0 = -15 + 30 * rand(100, 3);

% Simulate and visualize trajectories from each initial condition
figure(2)
hold on
grid on
view(3)  % Set 3D view
title('Lorenz Attractor', 'FontSize', 18)
xlabel('X', 'FontSize', 14)
ylabel('Y', 'FontSize', 14)
zlabel('Z', 'FontSize', 14)

odeFun = @(t, y) lorentz3D(t, y, params);
for i = 1:length(x0)
    % Solve system from each initial condition
    [tL, yL] = ode45(odeFun, [0 8], x0(i,:));
    
    % Plot trajectory and initial point
    plot3(yL(:,1), yL(:,2), yL(:,3), 'LineWidth', 1)
    scatter3(x0(i,1), x0(i,2), x0(i,3), 'filled')
end

%% Functions
function dydt = lotkavolterra(t, y)
    global alpha beta gamma delta
    % Lotka-Volterra equations
    dydt = zeros(2,1);
    dydt(1) = alpha*y(1) - beta*y(1)*y(2);    % Prey
    dydt(2) = delta*y(1)*y(2) - gamma*y(2);   % Predator
end

function dydt = lorentz3D(t, y, params)
    sigma = params(1);
    rho = params(2);
    beta = params(3);

    % Lorenz equations
    dydt = zeros(3,1);
    dydt(1) = sigma*(y(2) - y(1));
    dydt(2) = y(1)*(rho - y(3)) - y(2);
    dydt(3) = y(1)*y(2) - beta*y(3);
end