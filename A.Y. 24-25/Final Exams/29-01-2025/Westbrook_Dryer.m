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
clear all, close all, clc
% Octane combustion kinetics parameter estimation
% Based on Westbrook and Dryer (1981) methodology
% This code estimates activation energy (Ea) for octane combustion using experimental data
% Define global variables to be used across functions
global A a b R C_fuel C_O2 r_exp T_exp

% Define known parameters from literature and experimental setup
R = 1.987;     % Gas constant in calories per mole-Kelvin [cal/(mol·K)]
a = 0.32;      % Reaction order for fuel [-]
b = 1.5;       % Reaction order for oxygen [-]
A = 4.6e11;    % Pre-exponential factor (Arrhenius equation) [1/s]

% Initial concentrations of reactants
C_fuel = 0.5;  % Fuel (octane) concentration [mol/m³]
C_O2 = 0.21;   % Oxygen concentration [mol/m³]

% Experimental data arrays
T_exp = [800.00, 821.05, 842.11, 863.16, 884.21, 905.26, 926.32, 947.37, 968.42, 989.47, 1010.53, 1031.58, 1052.63, 1073.68, 1094.74, 1115.79, 1136.84, 1157.89, 1178.95, 1200.00];
r_exp = [217.92, 427.13, 535.34, 1134.44, 1359.34, 2087.04, 3161.44, 4274.21, 5167.86, 7235.55, 9757.36, 17258.12, 20653.12, 23806.09, 38510.42, 44962.94, 59687.50, 69487.69, 101237.53, 124734.28];

% Set up optimization parameters using MATLAB's fmincon function
options = optimoptions('fmincon', 'Display', 'iter');  % Show iteration progress
Ea_init = 20000;  % Initial guess for activation energy [cal/mol]
lb = 10000;       % Lower bound for Ea [cal/mol]
ub = 40000;       % Upper bound for Ea [cal/mol]

% Optimize to find the best value of activation energy (Ea)
% fmincon minimizes the objective function while respecting bounds
Ea_est = fmincon(@objective, Ea_init, [], [], [], [], lb, ub, [], options);

% Display the results
fprintf('Estimated value of a: %.4f\n', Ea_est);

% Create visualization of results
figure(1)
% Plot experimental data points
plot(T_exp, r_exp, 'ko', 'DisplayName', 'Experimental Data')
hold on
% Calculate reaction rates using optimized Ea
k = A * exp(-Ea_est./(R*T_exp));    % Arrhenius equation for rate constant
r_final = k * C_fuel^a * C_O2^b;    % Rate equation using power law
% Plot model predictions
plot(T_exp, r_final, 'r-', 'LineWidth', 2, 'DisplayName', 'Model Fit')
% Add labels and formatting
xlabel('Temperature [K]')
ylabel('Reaction Rate')
title('Reaction Rate vs Temperature')
legend('Location', 'best')
grid on

% Objective function definition
function err = objective(E)
    % Access global variables
    global A a b R C_fuel C_O2 r_exp T_exp
    % Calculate rate constant using Arrhenius equation
    k = A * exp(-E./(R*T_exp));
    % Calculate reaction rates using power law
    r_calc = k * C_fuel^a * C_O2^b;
    % Calculate sum of squared errors between model and experimental data
    err = sum((r_calc - r_exp).^2);
end