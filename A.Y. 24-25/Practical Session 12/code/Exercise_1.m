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
% Pressure Vessel Optimization
% This script determines the optimal dimensions of a cylindrical pressure
% vessel with flat ends to minimize surface area for a given volume
clear all
close all
clc
%% Data
V = 100;

%% Part 1: Direct Analytical Solution
% For a cylinder with flat ends, the optimal L/D ratio is 1
% This means L = 2r
% Using volume equation: V = πr²L
% V = πr²(2r) = 2πr³
% Therefore: r = (V/(2π))^(1/3)

% Calculate optimal radius
r_optimal = (V/(2*pi))^(1/3);

% Calculate optimal length
L_optimal = 2 * r_optimal;

% Calculate optimal surface area
SA_optimal = 2*pi*r_optimal^2 + 2*pi*r_optimal*L_optimal;

% Calculate L/D ratio
LD_ratio = L_optimal/(2*r_optimal);

%% Part 2: Numerical Solution using fmincon
% Define objective function (surface area)
objective = @(x) 2*pi*x(1)^2 + 2*pi*x(1)*x(2);  % x(1)=r, x(2)=L

% Define nonlinear constraint function
% c(x) <= 0 and ceq(x) = 0
nonlcon = @(x) deal([], pi*x(1)^2*x(2) - V);  % Volume constraint as equality

% Alternative implementation for nonlcon see the function at the end of the
% file
% nonlcon = @(x) volume_constraint(x, V);

% Initial guess [r, L] - use analytical solution as starting point
x0 = [1, 1];

% Lower and upper bounds [r, L]
lb = [0.1, 0.1];     % Avoid zero dimensions
ub = [10, 20];       % Reasonable upper limits

% Run optimization
[x_opt, fval] = fmincon(objective, x0, [], [], [], [], ...
    lb, ub, nonlcon);

% Extract results
r_numerical = x_opt(1);
L_numerical = x_opt(2);
LD_ratio_numerical = L_numerical/(2*r_numerical);

% Display results
fprintf('\nAnalytical Solution:\n')
fprintf('Optimal radius: %.2f m\n', r_optimal)
fprintf('Optimal length: %.2f m\n', L_optimal)
fprintf('Optimal L/D ratio: %.2f\n', LD_ratio)
fprintf('Minimum surface area: %.2f m²\n', SA_optimal)

fprintf('\nNumerical Solution:\n')
fprintf('Optimal radius: %.2f m\n', r_numerical)
fprintf('Optimal length: %.2f m\n', L_numerical)
fprintf('Optimal L/D ratio: %.2f\n', LD_ratio_numerical)
fprintf('Minimum surface area: %.2f m²\n', fval)

% Plot the surface area as a function of radius
r_range = linspace(0.5, 5, 100);
SA_values = zeros(size(r_range));

for i = 1:length(r_range)
    r = r_range(i);
    L = V/(pi*r^2);  % Length from volume constraint
    SA_values(i) = 2*pi*r^2 + 2*pi*r*L;
end

figure;
plot(r_range, SA_values, 'b-', 'LineWidth', 2)
hold on
plot(r_optimal, SA_optimal, 'ro', 'MarkerSize', 10)
xlabel('Radius (m)')
ylabel('Surface Area (m²)')
title('Surface Area vs. Radius for Fixed Volume')
grid on
legend('Surface Area', 'Optimal Point')

%% Alternative implementation for nonlcon
% Define the constraint function separately for clarity
function [c, ceq] = volume_constraint(x, V)
    c = [];  % No inequality constraints
    ceq = pi*x(1)^2*x(2) - V;  % Volume equality constraint
end