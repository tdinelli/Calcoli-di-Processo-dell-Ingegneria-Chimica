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
% Clear workspace and command window
clear all; clc;

%% Constants
P = 0.15e5;    % Pressure [Pa] (0.15 bar converted to Pa)
R = 8.314;     % Gas constant [J/(mol·K)]
T = 298.15;    % Temperature [K]

% Henry's constants [Pa]
H_H2 = 7.158e10;
H_N2 = 9.244e10;
H_NH3 = 9.758e4;

% Vapor pressure [Pa]
P_H2O = 3.167e3;

% Gibbs free energy of formation [J/mol] (converted from kJ/mol)
dG_NH3 = -16.33e3;

%% Initial guess for lambda values
lambda0 = [1, 0, 0, 0.5, 4.5];

%% Solve system using fsolve
options = optimoptions('fsolve', 'Display', 'iter', 'FunctionTolerance', 1e-10);
[lambda, fval, exitflag] = fsolve(...
    @(lambda) equilibrium_equations(lambda, P, R, T, H_H2, H_N2, H_NH3, P_H2O, dG_NH3),...
    lambda0, options);

%% Calculate moles and molar fractions
[n_V, n_L, y, x] = calculate_compositions(lambda, P, R, T, H_H2, H_N2, H_NH3, P_H2O);

%% Display results
fprintf('\nResults:\n')
fprintf('Lambda values:\n')
fprintf('λ1 = %.4f\nλ2 = %.4f\nλ3 = %.4f\nλ4 = %.4f\nλ5 = %.4f\n', lambda)

fprintf('\nVapor phase molar fractions:\n')
fprintf('y_H2 = %.4f\ny_N2 = %.4f\ny_NH3 = %.4f\ny_H2O = %.4f\n', y)

fprintf('\nLiquid phase molar fractions:\n')
fprintf('x_H2 = %.4f\nx_N2 = %.4f\nx_NH3 = %.4f\nx_H2O = %.4f\n', x)

%% Function to calculate equilibrium equations
function F = equilibrium_equations(lambda, P, R, T, H_H2, H_N2, H_NH3, P_H2O, dG_NH3)
    % Calculate moles and molar fractions
    [n_V, n_L, y, x] = calculate_compositions(lambda, P, R, T, H_H2, H_N2, H_NH3, P_H2O);
    
    % Chemical equilibrium equation
    K = exp(-dG_NH3/(R*T));
    F(1) = y(3)/(y(2)^0.5 * y(1)^1.5) - K;
    
    % Henry's law and vapor pressure equations
    F(2) = P*y(1) - H_H2*x(1);
    F(3) = P*y(2) - H_N2*x(2);
    F(4) = P*y(3) - H_NH3*x(3);
    F(5) = P*y(4) - P_H2O*x(4);
end

%% Function to calculate compositions
function [n_V, n_L, y, x] = calculate_compositions(lambda, P, R, T, H_H2, H_N2, H_NH3, P_H2O)
    % Calculate moles in vapor phase
    n_V = zeros(4,1);
    n_V(1) = 3 - 1.5*lambda(1) - lambda(3);    % H2
    n_V(2) = 1 - 0.5*lambda(1) - lambda(2);    % N2
    n_V(3) = lambda(1) - lambda(4);            % NH3
    n_V(4) = 5 - lambda(5);                    % H2O
    
    % Calculate moles in liquid phase
    n_L = zeros(4,1);
    n_L(1) = lambda(3);    % H2
    n_L(2) = lambda(2);    % N2
    n_L(3) = lambda(4);    % NH3
    n_L(4) = lambda(5);    % H2O
    
    % Calculate total moles in each phase
    n_T_V = sum(n_V);
    n_T_L = sum(n_L);
    
    % Calculate molar fractions
    y = n_V/n_T_V;    % Vapor phase
    x = n_L/n_T_L;    % Liquid phase
end
