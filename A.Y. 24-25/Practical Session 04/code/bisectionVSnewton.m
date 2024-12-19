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
% Script to compare Bisection and Newton methods for root finding
% Function: f(x) = 3e^x - 4cos(x)
clear all
close all
clc

%% Function definitions
f = @(x) 3*exp(x) - 4*cos(x);        % Main function

%% Parameters for both methods
tol = 1e-8;      % Tolerance
maxiter = 100;   % Maximum iterations

%% Initial guesses and intervals
% For Newton method
x0_newton = 0;   % Initial guess

% For Bisection method 
% Need to find interval [a,b] where f(a)*f(b) < 0
a = -5;          % Left boundary
b = 5;           % Right boundary

%% Solve using both methods
% Using Newton method with both analytical and numerical derivatives
[sol_newton_numerical, error_newton_numerical] = Newton(x0_newton, f, ...
    tol, maxiter);

% Using Bisection method
[sol_bisection, error_bisection] = Bisection(f, a, b, tol);

%% Plotting results
% Create x values for plotting
x = linspace(-2, 1, 1000);
y = f(x);

% Create figure
figure('Position', [100, 100, 1200, 800])

% Subplot 1: Function and solutions
subplot(2,1,1)
hold on
plot(x, y, 'b-', 'LineWidth', 2)
plot(x, zeros(size(x)), 'k--')  % x-axis
scatter(sol_newton_numerical(end), f(sol_newton_numerical(end)), 100, 'g', 'filled')
scatter(sol_bisection(end), f(sol_bisection(end)), 100, 'm', 'filled')
grid on
xlabel('x')
ylabel('f(x)')
title('f(x) = 3e^x - 4cos(x)')
legend('f(x)', 'Zero line', 'Newton', 'Bisection')

% Subplot 2: Error convergence
subplot(2,1,2)
hold on
semilogy(abs(error_newton_numerical), 'g.-', 'LineWidth', 2, 'MarkerSize', 15)
semilogy(abs(error_bisection), 'm.-', 'LineWidth', 2, 'MarkerSize', 15)
grid on
xlabel('Iteration')
ylabel('Error (log scale)')
title('Convergence Comparison')
legend('Newton', 'Bisection')

%% Print results

fprintf('\nResults:\n')

fprintf('Newton Method (Numerical):\n')
fprintf('Root: %.10f\n', sol_newton_numerical(end))
fprintf('Function value at root: %.2e\n', f(sol_newton_numerical(end)))
fprintf('Iterations: %d\n\n', length(sol_newton_numerical)-1)

fprintf('Bisection Method:\n')
fprintf('Root: %.10f\n', sol_bisection(end))
fprintf('Function value at root: %.2e\n', f(sol_bisection(end)))
fprintf('Iterations: %d\n', length(sol_bisection)-1)