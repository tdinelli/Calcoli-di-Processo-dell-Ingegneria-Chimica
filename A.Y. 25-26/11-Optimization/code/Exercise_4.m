%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Autoignition Delay Time Model Fitting
% This script fits a power law model to autoignition delay time data
% using least squares optimization
clear all
close all
clc

%% Data
% Experimental data
P = [3; 10; 20; 30; 40; 60];    % Pressure [atm]
tau_exp = [0.75; 0.20; 0.10; 0.55; 0.04; 0.03];  % Delay time [ms]

% Reference values
P0 = 10;     % Reference pressure [atm]
tau0 = 0.20; % Reference delay time (at 10 atm) [ms]

% Model function: tau = tau0 * (P/P0)^beta
model_fun = @(beta, P) tau0 * (P/P0).^beta;

% Objective function: sum of squared residuals
obj_fun = @(beta) sum((tau_exp - model_fun(beta, P)).^2);

% Optimization using fmincon
options = optimoptions('fmincon', 'Display', 'iter', ...
                      'OptimalityTolerance', 1e-10, ...
                      'ConstraintTolerance', 1e-10);

beta0 = 5;  % Initial guess for beta
[beta_opt, fval] = fmincon(obj_fun, beta0, ...
    [], [], [], [], [], [], [], options);

% Calculate model predictions with optimal beta
tau_model = model_fun(beta_opt, P);

% Calculate R-squared value
SS_res = sum((tau_exp - tau_model).^2);
SS_tot = sum((tau_exp - mean(tau_exp)).^2);
R_squared = 1 - SS_res/SS_tot;

% Display results
fprintf('\nOptimization Results:\n')
fprintf('Optimal beta: %.4f\n', beta_opt)
fprintf('Sum of squared residuals: %.6f\n', fval)
fprintf('R-squared value: %.4f\n', R_squared)

% Create comparison table
fprintf('\nComparison of experimental and model values:\n')
fprintf('P [atm]\tτ_exp [ms]\tτ_model [ms]\tResidual [ms]\n')
fprintf('%7.1f\t%10.3f\t%11.3f\t%13.3f\n', [P, tau_exp, tau_model, tau_exp-tau_model]')

% Plotting
figure('Position', [100, 100, 1000, 400]);

% Plot 1: Regular scale
subplot(1,2,1)
plot(P, tau_exp, 'bo', 'MarkerSize', 8, 'LineWidth', 2)
hold on
P_fine = linspace(min(P), max(P), 100);
tau_fine = model_fun(beta_opt, P_fine);
plot(P_fine, tau_fine, 'r-', 'LineWidth', 2)
grid on
xlabel('Pressure [atm]')
ylabel('Delay Time [ms]')
title('Autoignition Delay Time vs. Pressure')
legend('Experimental Data', 'Model Fit', 'Location', 'best')

% Plot 2: Log-log scale
subplot(1,2,2)
loglog(P, tau_exp, 'bo', 'MarkerSize', 8, 'LineWidth', 2)
hold on
loglog(P_fine, tau_fine, 'r-', 'LineWidth', 2)
grid on
xlabel('Pressure [atm]')
ylabel('Delay Time [ms]')
title('Autoignition Delay Time vs. Pressure (Log-Log)')
legend('Experimental Data', 'Model Fit', 'Location', 'best')

% Add residuals plot
figure('Position', [100, 550, 500, 300]);
plot(P, tau_exp - tau_model, 'bo-', 'LineWidth', 2)
hold on
plot([min(P), max(P)], [0, 0], 'k--')
grid on
xlabel('Pressure [atm]')
ylabel('Residual [ms]')
title('Model Residuals')