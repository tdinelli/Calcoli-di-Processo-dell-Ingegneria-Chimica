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
% REACTION_CONVERSION_ANALYSIS - Analyzes conversion in a first-order reaction
% 
% This script analyzes the conversion of reactant A in the reaction:
%     A -> B (first-order, irreversible)
% 
% The conversion (χ) is analyzed using both:
% 1. Analytical solution: χ(t) = 1 - exp(-kt)
% 2. Numerical solution using ODE45: dχ/dt = k(1-χ)
% 
% Problem Objectives:
% 1. Calculate time needed for 90% conversion
% 2. Calculate time needed for 99.9% conversion
% 
% Reaction Parameters:
% - Rate constant (k) = 0.01 s^-1
% - Initial concentration (CA0) = 2 mol/L
% 
% Note: For a first-order reaction, conversion is independent of initial concentration
clc, clear all, close all;

%% Define Reaction Parameters
k = 0.01;    % First-order rate constant [s^-1]
CA0 = 2;     % Initial concentration [mol/L]

%% Analytical Solution
% Define analytical solution function for conversion
X_analitical_function = @(t) 1-exp(-k*t);

% Generate time points and calculate conversion
t_analitical = 1:1:1000;  % Time vector [s]
for i=1:1000
    X_analitical(i) = X_analitical_function(i);
end

% Calculate times for target conversions (can be done analytically)
t_90 = -log(0.1)/k;    % Time for 90% conversion
t_999 = -log(0.001)/k; % Time for 99.9% conversion

%% Numerical Solution using ODE45
% Define ODE for conversion: dχ/dt = k(1-χ)
X_numerical_function = @(t,x) k*(1-x);

% Solve ODE numerically
[t45, y45] = ode45(X_numerical_function, [0,1000], 0);

%% Create Visualization
figure(1)

% Plot 1: Combined comparison plot (top)
subplot(2,2,[1 2])
hold on
ax = gca;
ax.FontSize = 15;
title('Analytical Solution VS Numerical Solution')
xlabel('time [s]')
ylabel('Conversion \chi [-]')
plot(t_analitical, X_analitical, 'LineWidth', 3, 'color', 'g')
plot(t45, y45, 'LineStyle', '--','LineWidth', 3, 'Color', 'r')
legend({'Analytical Solution','Numerical Solution'},'Location','northeast')
grid on

% Plot 2: Analytical solution only (bottom left)
subplot(2,2,3)
hold on
ax = gca;
ax.FontSize = 15;
title('Analytical Solution')
xlabel('time [s]')
ylabel('Conversion \chi [-]')
plot(t_analitical, X_analitical,'LineWidth', 3, 'color', 'g')
grid on

% Plot 3: Numerical solution only (bottom right)
subplot(2,2,4)
hold on
ax = gca;
ax.FontSize = 15;
title('Numerical Solution')
xlabel('time [s]')
ylabel('Conversion \chi [-]')
plot(t45, y45, 'LineStyle', '--','LineWidth', 3, 'Color', 'r')
grid on

% Add annotations for target conversion times
text(50, 0.9, sprintf('t_{90%%} = %.0f s', t_90), 'FontSize', 12)
text(50, 0.8, sprintf('t_{99.9%%} = %.0f s', t_999), 'FontSize', 12)