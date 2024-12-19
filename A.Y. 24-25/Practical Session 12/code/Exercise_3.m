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
% Black Body Radiation Analysis
% This script calculates and plots the spectral power emission of a black 
% body and finds the peak wavelength both numerically and using Wien's Law
clear all
close all
clc

%% Data
C1 = 3.742e8;    % W·μm⁴/m²
C2 = 1.439e4;    % μm·K
C3 = 2897.8;     % μm·K (Wien's constant)
T = 800;         % Temperature in K

% Define the objective function (negative of Eb since fmincon minimizes)
function_obj = @(lambda) -C1 ./ (lambda.^5 .* (exp(C2./(lambda*T)) - 1));

% Set optimization options
options = optimoptions('fmincon', 'Display', 'iter', ...
                      'OptimalityTolerance', 1e-10, ...
                      'ConstraintTolerance', 1e-10);

% Initial guess (using Wien's Law as starting point)
lambda0 = C3/T;

% Lower and upper bounds for wavelength
lb = 0.1;   % Lower bound (μm)
ub = 100;   % Upper bound (μm)

% Run optimization
[lambda_max_numerical, fval, exitflag] = fmincon(function_obj, lambda0,...
    [], [], [], [], lb, ub, [], options);

% Calculate maximum Eb (negative of fval since we minimized negative Eb)
max_Eb = -fval;

% Calculate peak wavelength using Wien's Law
lambda_max_wien = C3/T;

% Calculate relative error
relative_error = ...
    abs(lambda_max_numerical - lambda_max_wien)/lambda_max_wien * 100;

% Create wavelength range for plotting
lambda = logspace(-1, 2, 1000);  % Range from 0.1 to 100 μm

% Calculate spectral power emission for plotting
Eb = C1 ./ (lambda.^5 .* (exp(C2./(lambda*T)) - 1));

% Create the log-log plot
figure('Position', [100, 100, 800, 600]);
loglog(lambda, Eb, 'b-', 'LineWidth', 2)
hold on
plot(lambda_max_numerical, max_Eb, 'ro', 'MarkerSize', 10, 'LineWidth', 2)
plot(lambda_max_wien, ...
    C1/(lambda_max_wien^5 * (exp(C2/(lambda_max_wien*T)) - 1)), ...
    'go', 'MarkerSize', 10, 'LineWidth', 2)

% Add grid and labels
grid on
xlabel('Wavelength λ (μm)', 'FontSize', 12)
ylabel('Spectral Power Emission E_b (W/m²·μm)', 'FontSize', 12)
title(sprintf('Black Body Radiation at T = %d K', T), 'FontSize', 14)
legend('Spectral Power Emission', 'Numerical Peak (fmincon)', ...
    'Wien''s Law Peak', 'Location', 'northwest')

% Display results
fprintf('\nResults for Black Body Radiation at T = %d K:\n', T)
fprintf('Numerical peak wavelength (fmincon): %.3f μm\n', lambda_max_numerical)
fprintf('Wien''s Law peak wavelength: %.3f μm\n', lambda_max_wien)
fprintf('Relative error: %.3f%%\n', relative_error)
fprintf('Peak spectral power emission: %.2e W/m²·μm\n', max_Eb)
fprintf('Optimization exit flag: %d\n', exitflag)