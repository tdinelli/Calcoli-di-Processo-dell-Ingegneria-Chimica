%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%          Author: Marco Mehl <marco.mehl@polimi.it>                      %
%                  Timoteo Dinelli <timoteo.dinelli@polimi.it>            %
%          CRECK Modeling Lab <www.creckmodeling.polimi.it>               %
%          Department of Chemistry, Materials and Chemical Engineering    %
%          Politecnico di Milano                                          %
%          P.zza Leonardo da Vinci 32, 20133 Milano                       %
%                                                                         %
% ----------------------------------------------------------------------- %
%% ODE Solvers Comparison - Test Script
% Problem: dx/dt = -k*x, x(0) = x0
% Analytical solution: x(t) = x0*exp(-k*t)
%
% This script compares four different ODE solvers:
% 1. MATLAB's ode45 (adaptive Runge-Kutta 4-5)
% 2. Forward Euler (explicit, first-order)
% 3. Backward Euler (implicit, first-order)
% 4. Heun Adaptive (explicit RK2 with adaptive step size)

clear; close all; clc;

%% ========================================================================
%  PROBLEM SETUP
%  ========================================================================

% Physical parameters
k = 1.0;                % Rate constant [1/s]
x0 = 1.0;               % Initial condition
t_span = [0, 5];        % Time interval [t_start, t_end]

% Numerical parameters
h_fixed = 0.1;          % Fixed step size for Euler methods
h_init = 0.1;           % Initial step size for Heun adaptive
tol = 1e-4;             % Error tolerance for Heun adaptive

% Define the ODE function: dx/dt = f(t, x)
ode_function = @(t, x) -k * x;

%% ========================================================================
%  SOLVE WITH ALL METHODS
%  ========================================================================

fprintf('=== Solving ODE: dx/dt = -%.2f*x, x(0) = %.2f ===\n\n', k, x0);

% Method 1: MATLAB's ode45 (reference solution)
fprintf('1. Running ode45...\n');
[t_ode45, x_ode45] = ode45(ode_function, t_span, x0);
fprintf('   Steps taken: %d\n', length(t_ode45));
fprintf('   Final value: x(%.1f) = %.6f\n\n', t_span(2), x_ode45(end));

% Method 2: Forward Euler
fprintf('2. Running Forward Euler (h = %.3f)...\n', h_fixed);
[t_fe, x_fe] = forward_euler(ode_function, t_span, x0, h_fixed);
fprintf('   Steps taken: %d\n', length(t_fe));
fprintf('   Final value: x(%.1f) = %.6f\n\n', t_span(2), x_fe(end));

% Method 3: Backward Euler
fprintf('3. Running Backward Euler (h = %.3f)...\n', h_fixed);
n_intervals = round((t_span(2) - t_span(1)) / h_fixed);
[t_be, x_be] = backward_euler(ode_function, t_span, x0, n_intervals);
fprintf('   Steps taken: %d\n', length(t_be));
fprintf('   Final value: x(%.1f) = %.6f\n\n', t_span(2), x_be(end));

% Method 4: Heun Adaptive
fprintf('4. Running Heun Adaptive (h_init = %.3f, tol = %.1e)...\n', h_init, tol);
[t_heun, x_heun, h_history] = heun_adaptive(ode_function, t_span, x0, h_init, tol);
fprintf('   Steps taken: %d\n', length(t_heun));
fprintf('   Average step size: %.4f\n', mean(h_history));
fprintf('   Final value: x(%.1f) = %.6f\n\n', t_span(2), x_heun(end));

% Analytical solution (for comparison)
t_analytical = linspace(t_span(1), t_span(2), 1000);
x_analytical = x0 * exp(-k * t_analytical);

%% ========================================================================
%  COMPUTE ERRORS
%  ========================================================================

% Interpolate analytical solution at computed time points
x_anal_ode45 = x0 * exp(-k * t_ode45);
x_anal_fe = x0 * exp(-k * t_fe);
x_anal_be = x0 * exp(-k * t_be);
x_anal_heun = x0 * exp(-k * t_heun);

% Compute absolute errors
error_ode45 = abs(x_ode45 - x_anal_ode45);
error_fe = abs(x_fe - x_anal_fe);
error_be = abs(x_be - x_anal_be);
error_heun = abs(x_heun - x_anal_heun);

%% ========================================================================
%  VISUALIZATION - MAIN COMPARISON
%  ========================================================================

figure('Position', [100, 100, 1400, 900], 'Name', 'ODE Solvers Comparison');

% Subplot 1: Solution comparison
subplot(2,3,1);
plot(t_analytical, x_analytical, 'k-', 'LineWidth', 2.5, 'DisplayName', 'Analytical');
hold on;
plot(t_ode45, x_ode45, 'm.-', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'ode45');
plot(t_fe, x_fe, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Forward Euler');
plot(t_be, x_be, 'bs-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Backward Euler');
plot(t_heun, x_heun, 'g^-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Heun Adaptive');
xlabel('Time [s]');
ylabel('x(t)');
title('Solution Comparison');
legend('Location', 'northeast');
grid on;
box on;

% Subplot 2: Zoomed view (early time behavior)
subplot(2,3,2);
plot(t_analytical, x_analytical, 'k-', 'LineWidth', 2.5, 'DisplayName', 'Analytical');
hold on;
plot(t_ode45, x_ode45, 'm.-', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'ode45');
plot(t_fe, x_fe, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Forward Euler');
plot(t_be, x_be, 'bs-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Backward Euler');
plot(t_heun, x_heun, 'g^-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Heun Adaptive');
xlabel('Time [s]');
ylabel('x(t)');
title('Zoomed View (Early Time)');
legend('Location', 'northeast');
grid on;
box on;
xlim([0, 1]);
ylim([0.3, 1.05]);

% Subplot 3: Error analysis (log scale)
subplot(2,3,3);
semilogy(t_ode45, error_ode45, 'm.-', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'ode45');
hold on;
semilogy(t_fe, error_fe, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Forward Euler');
semilogy(t_be, error_be, 'bs-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Backward Euler');
semilogy(t_heun, error_heun, 'g^-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Heun Adaptive');
xlabel('Time [s]');
ylabel('Absolute Error');
title('Error vs Time (Log Scale)');
legend('Location', 'best');
grid on;
box on;

% Subplot 4: Adaptive step size history (Heun only)
subplot(2,3,4);
stairs([t_heun(1); t_heun(2:end)], [h_history(1); h_history], 'g-', 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Step Size h');
title('Adaptive Step Size (Heun Method)');
grid on;
box on;
ylim([0, max(h_history)*1.1]);

% Subplot 5: Computational cost comparison
subplot(2,3,5);
methods = {'ode45', 'Forward\newlineEuler', 'Backward\newlineEuler', 'Heun\newlineAdaptive'};
num_steps = [length(t_ode45), length(t_fe), length(t_be), length(t_heun)];
bar(num_steps, 'FaceColor', [0.3, 0.6, 0.9]);
set(gca, 'XTickLabel', methods);
ylabel('Number of Steps');
title('Computational Cost Comparison');
grid on;
box on;

% Subplot 6: Final error comparison
subplot(2,3,6);
final_errors = [error_ode45(end), error_fe(end), error_be(end), error_heun(end)];
bar(final_errors, 'FaceColor', [0.9, 0.4, 0.3]);
set(gca, 'XTickLabel', methods);
ylabel('Final Absolute Error');
title(sprintf('Final Error at t = %.1f', t_span(2)));
set(gca, 'YScale', 'log');
grid on;
box on;

%% ========================================================================
%  STABILITY ANALYSIS - DIFFERENT k VALUES
%  ========================================================================

fprintf('=== Stability Analysis ===\n');
fprintf('Testing with different values of k and larger step size h = 0.5\n\n');

k_values = [0.1, 0.5, 1.0, 2.0, 5.0];
h_test = 0.5;  % Larger step size to test stability limits

figure('Position', [100, 100, 1200, 800], 'Name', 'Stability Analysis');

for idx = 1:length(k_values)
    k_current = k_values(idx);
    f_current = @(t, x) -k_current * x;
    
    % Solve with different methods
    [t_ode45_k, x_ode45_k] = ode45(f_current, t_span, x0);
    [t_fe_k, x_fe_k] = forward_euler(f_current, t_span, x0, h_test);
    
    % For Backward Euler, calculate number of intervals
    n_intervals_test = round((t_span(2) - t_span(1)) / h_test);
    [t_be_k, x_be_k] = backward_euler(f_current, t_span, x0, n_intervals_test);
    
    % Analytical solution
    t_anal = linspace(t_span(1), t_span(2), 1000);
    x_anal = x0 * exp(-k_current * t_anal);
    
    % Plot
    subplot(3, 2, idx);
    plot(t_anal, x_anal, 'k-', 'LineWidth', 2.5, 'DisplayName', 'Analytical');
    hold on;
    plot(t_ode45_k, x_ode45_k, 'm.-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'ode45');
    plot(t_fe_k, x_fe_k, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Forward Euler');
    plot(t_be_k, x_be_k, 'bs-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Backward Euler');
    xlabel('Time [s]');
    ylabel('x(t)');
    title(sprintf('k = %.1f, h = %.1f', k_current, h_test));
    legend('Location', 'best');
    grid on;
    box on;
    
    % Check stability condition for Forward Euler
    stability_factor = k_current * h_test;
    fprintf('k = %.1f, h = %.1f --> k*h = %.2f ', k_current, h_test, stability_factor);
    if stability_factor > 2
        fprintf('(UNSTABLE for Forward Euler!)\n');
    else
        fprintf('(stable)\n');
    end
end

sgtitle('Stability Analysis: Effect of k on Different Methods (h = 0.5)');

%% ========================================================================
%  SUMMARY STATISTICS
%  ========================================================================

fprintf('\n=== SUMMARY ===\n\n');

fprintf('Method Characteristics:\n');
fprintf('  ode45:          Adaptive RK45, high accuracy, automatic step size\n');
fprintf('  Forward Euler:  Explicit, simple, conditionally stable (k*h < 2)\n');
fprintf('  Backward Euler: Implicit, unconditionally stable, requires equation solving\n');
fprintf('  Heun Adaptive:  Explicit RK2, adaptive step size, good balance\n\n');

fprintf('Computational Cost:\n');
fprintf('  ode45:          %4d steps (adaptive)\n', length(t_ode45));
fprintf('  Forward Euler:  %4d steps (h = %.3f, fixed)\n', length(t_fe), h_fixed);
fprintf('  Backward Euler: %4d steps (h = %.3f, fixed)\n', length(t_be), (t_span(2)-t_span(1))/n_intervals);
fprintf('  Heun Adaptive:  %4d steps (h_avg = %.4f, adaptive)\n\n', length(t_heun), mean(h_history));

fprintf('Final Errors at t = %.1f:\n', t_span(2));
fprintf('  ode45:          %.6e\n', error_ode45(end));
fprintf('  Forward Euler:  %.6e\n', error_fe(end));
fprintf('  Backward Euler: %.6e\n', error_be(end));
fprintf('  Heun Adaptive:  %.6e\n\n', error_heun(end));

fprintf('Stability Limit for Forward Euler:\n');
fprintf('  For stability: k*h < 2\n');
fprintf('  Current: k*h = %.2f*%.3f = %.4f ', k, h_fixed, k*h_fixed);
if k*h_fixed < 2
    fprintf('(STABLE)\n\n');
else
    fprintf('(UNSTABLE - reduce h!)\n\n');
end

fprintf('Script completed successfully!\n');