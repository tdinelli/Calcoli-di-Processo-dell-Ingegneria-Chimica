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
clear all
close all
clc

%% Function definitions
f = @(x) 1./(x-2) - 2;           % Main function

%% Parameters
tol = 1e-2;      % Required precision
maxiter = 100;   % Maximum iterations

%% Test different initial guesses for Newton method
x0_tests = [1.8, 4, 2.2];  % Different initial guesses to test

% Store results for each initial guess
newton_solutions = cell(length(x0_tests), 1);
newton_errors = cell(length(x0_tests), 1);

% Try Newton method with each initial guess
for i = 1:length(x0_tests)
    [sol, err] = Newton(x0_tests(i), f, tol, maxiter);
    newton_solutions{i} = sol;
    newton_errors{i} = err;
end

%% Find appropriate interval for Bisection method
% From graph analysis, we can use [2.1, 4] as our interval
a = 2.1;  % Left boundary
b = 4;    % Right boundary

% Apply Bisection method
[sol_bisection, error_bisection] = Bisection(f, a, b, tol);

%% Solve using MATLAB's built-in methods
options = optimset('Display', 'iter', 'TolX', tol);
[sol_fzero, fval_fzero] = fzero(f, 2.2, options);
[sol_fsolve, fval_fsolve] = fsolve(f, 2.2, options);

%% Create visualization
% Generate points for plotting
x = linspace(1.5, 4.5, 1000);
y = f(x);

% Create figure
figure('Position', [100, 100, 1200, 800])

% Subplot 1: Function and asymptote visualization
subplot(2,1,1)
hold on
plot(x, y, 'b-', 'LineWidth', 2)
plot(x, zeros(size(x)), 'k--')  % x-axis
plot([2 2], [-10 10], 'r--')    % Vertical asymptote
grid on
xlabel('x')
ylabel('f(x)')
title('f(x) = 1/(x-2) - 2')

% Plot Newton iterations for successful case
if ~isnan(newton_solutions{3})
    scatter(newton_solutions{3}, f(newton_solutions{3}), 100, 'g', 'filled')
end
% Plot Bisection solution
scatter(sol_bisection(end), f(sol_bisection(end)), 100, 'm', 'filled')
% Plot built-in solutions
scatter(sol_fzero, fval_fzero, 100, 'c', 'filled')
scatter(sol_fsolve, fval_fsolve, 100, 'y', 'filled')

legend('f(x)', 'Zero line', 'Asymptote', 'Newton', 'Bisection', 'fzero', 'fsolve')
ylim([-10 10])

% Subplot 2: Error convergence
subplot(2,1,2)
hold on
% Plot errors for successful Newton case
if ~isnan(newton_solutions{3})
    semilogy(abs(newton_errors{3}), 'g.-', 'LineWidth', 2, 'MarkerSize', 15)
end
semilogy(abs(error_bisection), 'm.-', 'LineWidth', 2, 'MarkerSize', 15)
grid on
xlabel('Iteration')
ylabel('Error (log scale)')
title('Convergence Comparison')
legend('Newton (x0=2.2)', 'Bisection')

%% Print results
fprintf('\nResults Summary:\n')
fprintf('------------------\n')

% Newton results for each initial guess
for i = 1:length(x0_tests)
    fprintf('\nNewton Method with x0 = %.1f:\n', x0_tests(i))
    if ~isnan(newton_solutions{i})
        fprintf('Root: %.6f\n', newton_solutions{i}(end))
        fprintf('Function value at root: %.2e\n', f(newton_solutions{i}(end)))
        fprintf('Iterations: %d\n', length(newton_solutions{i})-1)
    else
        fprintf('Failed to converge\n')
    end
end

fprintf('\nBisection Method:\n')
fprintf('Root: %.6f\n', sol_bisection(end))
fprintf('Function value at root: %.2e\n', f(sol_bisection(end)))
fprintf('Iterations: %d\n', length(sol_bisection)-1)

fprintf('\nMATLAB fzero:\n')
fprintf('Root: %.6f\n', sol_fzero)
fprintf('Function value at root: %.2e\n', fval_fzero)

fprintf('\nMATLAB fsolve:\n')
fprintf('Root: %.6f\n', sol_fsolve)
fprintf('Function value at root: %.2e\n', fval_fsolve)

%% Explanation of Newton method behavior
fprintf('\nExplanation of Newton Method Behavior:\n')
fprintf('--------------------------------------\n')
fprintf(['The Newton method fails for x0 = 1.8 and x0 = 4 because:\n\n'...
    '1. The function has a vertical asymptote at x = 2\n'...
    '2. For x0 = 1.8, the initial point is too close to the asymptote\n'...
    '3. For x0 = 4, the tangent line might lead to points near the asymptote\n'...
    '4. The successful case (x0 = 2.2) starts on the correct side of the\n'...
    '   asymptote and is close enough to the root.\n\n'...
    'The safe interval for initial guesses appears to be approximately [2.1, 2.5]\n'])