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
% Define global parameters for population dynamics
global alpha beta gamma delta

% Set system parameters
alpha = .05;      % Growth rate of prey
beta = 0.002;     % Predation rate
gamma = .000004;  % Growth rate of predators from predation
delta = .003;     % Natural death rate of predators

% Solve system for 10 years (3650 days) with initial populations
[t,y] = ode45(@PopODE, [0 10*365], [10000 30]); % Initial: 10000 prey, 30 predators

% Create subplot figure
figure(1)
% Plot prey population over time
subplot(2,2,1);
plot(t,y(:,1));
% Plot predator population over time
subplot(2,2,2);
plot(t,y(:,2));

% Find equilibrium populations using final values as initial guess
firstguess = y(end,:);
pop = fsolve(@PopAlg, firstguess);
R0 = round(pop(1));    % Equilibrium prey population
D0 = round(pop(2));    % Equilibrium predator population

% Test algebraic system
testAlg = PopAlg([2000 30]);

% Change death rate and simulate for 120 days from equilibrium
delta = 0.015;
[t,y] = ode45(@PopODE, [0 120], [R0 D0]);

% Plot new populations
subplot(2,2,3);
plot(t,y(:,1));
subplot(2,2,4);
plot(t,y(:,2));

R_120 = round(y(end,1)); % Final prey population after 120 days

% Wrapper function for ODE system
function dydt = PopODE(t,y)
    dydt = PopAlg(y);
end

% Main system of equations
function dydt = PopAlg(y)
    global alpha beta gamma delta
    R = y(1);  % Prey population (R for "rabbits" or similar)
    D = y(2);  % Predator population (D for "dogs" or similar)
    
    % Prey population change
    dydt(1,1) = alpha*R - beta*R*D;  % Growth - predation
    
    % Predator population change with carrying capacity of 40
    dydt(2,1) = gamma*(1-D/40)*R*D - delta*D;  % Growth from predation - natural death
end