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
%% Exercise 2: Isothermal Batch Reactor
% 
% Chemical Reaction: A -> B (first-order reaction)
% 
% Mass balances:
%   dCA/dt = -k*CA   (consumption of A)
%   dCB/dt = +k*CA   (production of B)
%
% Conversion definition:
%   XA = (CA0 - CA) / CA0
%
% This script compares different numerical methods for solving the
% batch reactor ODEs and calculates conversion profiles.

clear; close all; clc;

%% ========================================================================
%  PROBLEM SETUP
%  ========================================================================
% Kinetic parameters (global for use in subfunctions)
global k
k = 0.01;           % Rate constant [s^-1]

% Initial conditions
CA0 = 1.0;          % Initial concentration of A [mol/L]
CB0 = 0.0;          % Initial concentration of B [mol/L]

% Time span
t_span = [0, 500];  % Time interval [s]

% Numerical parameters
h_fixed = 1.0;      % Step size for manual methods [s]

fprintf('=== Isothermal Batch Reactor: A -> B ===\n');
fprintf('Rate constant k = %.3f s^-1\n', k);
fprintf('Initial concentration CA0 = %.2f mol/L\n\n', CA0);

%% ========================================================================
%  SOLUTION METHOD 1: MATLAB's ode45 (System of ODEs)
%  ========================================================================
fprintf('1. Solving with ode45 (system of ODEs)...\n');

% Initial conditions vector [CA; CB]
y0_system = [CA0; CB0];

% Solve
[t_ode45, y_ode45] = ode45(@batch_reactor_system, t_span, y0_system);

% Extract results
CA_ode45 = y_ode45(:,1);  % Concentration of A
CB_ode45 = y_ode45(:,2);  % Concentration of B
X_ode45 = (CA0 - CA_ode45) / CA0;  % Conversion

fprintf('   Steps taken: %d\n', length(t_ode45));
fprintf('   Final CA = %.4f mol/L\n', CA_ode45(end));
fprintf('   Final CB = %.4f mol/L\n', CB_ode45(end));
fprintf('   Final conversion = %.2f%%\n\n', X_ode45(end)*100);

%% ========================================================================
%  SOLUTION METHOD 2: MATLAB's ode45 (Conversion ODE)
%  ========================================================================
fprintf('2. Solving with ode45 (conversion ODE)...\n');

% Initial conversion
X0 = 0.0;

% Solve
[t_X, X_ode45_direct] = ode45(@conversion_ode, t_span, X0);

fprintf('   Steps taken: %d\n', length(t_X));
fprintf('   Final conversion = %.2f%%\n\n', X_ode45_direct(end)*100);

%% ========================================================================
%  SOLUTION METHOD 3: Forward Euler (Manual Implementation)
%  ========================================================================
fprintf('3. Solving with Forward Euler (h = %.2f s)...\n', h_fixed);

% Define ODE for CA only: dCA/dt = -k*CA
ode_CA = @(t, CA) -k * CA;

% Solve
[t_fe, CA_fe] = forward_euler(ode_CA, t_span, CA0, h_fixed);

% Calculate CB from mass balance: CA + CB = CA0
CB_fe = CA0 - CA_fe;

% Calculate conversion
X_fe = (CA0 - CA_fe) / CA0;

fprintf('   Steps taken: %d\n', length(t_fe));
fprintf('   Final CA = %.4f mol/L\n', CA_fe(end));
fprintf('   Final CB = %.4f mol/L\n', CB_fe(end));
fprintf('   Final conversion = %.2f%%\n\n', X_fe(end)*100);

%% ========================================================================
%  SOLUTION METHOD 4: Backward Euler (Manual Implementation)
%  ========================================================================
fprintf('4. Solving with Backward Euler (h = %.2f s)...\n', h_fixed);

% Calculate number of intervals
n_intervals = round((t_span(2) - t_span(1)) / h_fixed);

% Solve only for CA
[t_be, CA_be] = backward_euler(ode_CA, t_span, CA0, n_intervals);

% Calculate CB from mass balance
CB_be = CA0 - CA_be;

% Calculate conversion
X_be = (CA0 - CA_be) / CA0;

fprintf('   Steps taken: %d\n', length(t_be));
fprintf('   Final CA = %.4f mol/L\n', CA_be(end));
fprintf('   Final CB = %.4f mol/L\n', CB_be(end));
fprintf('   Final conversion = %.2f%%\n\n', X_be(end)*100);

%% ========================================================================
%  ANALYTICAL SOLUTION
%  ========================================================================
% Generate fine time grid for smooth plots
t_analytical = linspace(t_span(1), t_span(2), 1000);

% Analytical solutions
CA_analytical = CA0 * exp(-k * t_analytical);
CB_analytical = CA0 * (1 - exp(-k * t_analytical));
X_analytical = 1 - exp(-k * t_analytical);

%% ========================================================================
%  CALCULATE KEY PARAMETERS
%  ========================================================================

% Time to reach 90% conversion
X_target = 0.90;
t_90 = -log(1 - X_target) / k;

fprintf('=== KEY RESULTS ===\n');
fprintf('Time to reach 90%% conversion: %.2f s\n', t_90);
fprintf('Final conversion at t = %.0f s: %.2f%%\n\n', t_span(2), X_analytical(end)*100);

%% ========================================================================
%  PLOTTING - MAIN RESULTS
%  ========================================================================
figure('Position', [100, 100, 1400, 500], 'Name', 'Batch Reactor Results');

% Subplot 1: Species Concentrations
subplot(1,3,1);
plot(t_analytical, CA_analytical, 'r-', 'LineWidth', 2.5, 'DisplayName', 'C_A (analytical)');
hold on;
plot(t_analytical, CB_analytical, 'b-', 'LineWidth', 2.5, 'DisplayName', 'C_B (analytical)');
plot(t_ode45, CA_ode45, 'ro', 'MarkerSize', 5, 'DisplayName', 'C_A (ode45)');
plot(t_ode45, CB_ode45, 'bo', 'MarkerSize', 5, 'DisplayName', 'C_B (ode45)');
plot(t_fe, CA_fe, 'r^--', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'C_A (Forward Euler)');
plot(t_fe, CB_fe, 'b^--', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'C_B (Forward Euler)');
xlabel('Time [s]');
ylabel('Concentration [mol/L]');
title('Species Concentrations vs Time');
legend('Location', 'east');
grid on;
box on;

% Subplot 2: Conversion
subplot(1,3,2);
plot(t_analytical, X_analytical, 'k-', 'LineWidth', 2.5, 'DisplayName', 'Analytical');
hold on;
plot(t_ode45, X_ode45, 'ko', 'MarkerSize', 5, 'DisplayName', 'ode45 (system)');
plot(t_X, X_ode45_direct, 'ms', 'MarkerSize', 5, 'DisplayName', 'ode45 (conversion)');
plot(t_fe, X_fe, 'r^--', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'Forward Euler');
plot(t_be, X_be, 'bs--', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'Backward Euler');
yline(X_target, 'g--', 'LineWidth', 2, 'DisplayName', sprintf('%.0f%% conversion', X_target*100));
xline(t_90, 'g--', 'LineWidth', 2, 'HandleVisibility', 'off');
xlabel('Time [s]');
ylabel('Conversion X_A [-]');
title('Conversion vs Time');
legend('Location', 'southeast');
grid on;
box on;
ylim([0, 1.05]);

% Subplot 3: Mass Balance Verification
subplot(1,3,3);
total_conc_ode45 = CA_ode45 + CB_ode45;
total_conc_fe = CA_fe + CB_fe;
total_conc_be = CA_be + CB_be;

plot(t_ode45, total_conc_ode45, 'ko-', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'ode45');
hold on;
plot(t_fe, total_conc_fe, 'r^--', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'Forward Euler');
plot(t_be, total_conc_be, 'bs--', 'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'Backward Euler');
yline(CA0, 'g--', 'LineWidth', 2, 'DisplayName', sprintf('C_A^0 = %.2f', CA0));
xlabel('Time [s]');
ylabel('C_A + C_B [mol/L]');
title('Mass Balance Verification');
legend('Location', 'best');
grid on;
box on;
ylim([CA0*0.995, CA0*1.005]);

%% ========================================================================
%  PLOTTING - ERROR ANALYSIS
%  ========================================================================
figure('Position', [100, 100, 1200, 400], 'Name', 'Error Analysis');

% Subplot 1: Error in Conversion
subplot(1,2,1);

% Calculate analytical values at computed time points
X_anal_fe = 1 - exp(-k * t_fe);
X_anal_be = 1 - exp(-k * t_be);

% Plot errors
semilogy(t_fe, abs(X_fe - X_anal_fe), 'ro-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Forward Euler');
hold on;
semilogy(t_be, abs(X_be - X_anal_be), 'bs-', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Backward Euler');
xlabel('Time [s]');
ylabel('Absolute Error in X_A [-]');
title('Error in Conversion (Log Scale)');
legend('Location', 'best');
grid on;
box on;

% Subplot 2: Rate of Conversion
subplot(1,2,2);
dXdt_analytical = k * (1 - X_analytical);
plot(t_analytical, dXdt_analytical, 'k-', 'LineWidth', 2.5);
xlabel('Time [s]');
ylabel('dX_A/dt [s^{-1}]');
title('Rate of Conversion');
grid on;
box on;

%% ========================================================================
%  SUMMARY STATISTICS
%  ========================================================================
fprintf('=== MASS BALANCE CHECK ===\n');
fprintf('Maximum deviation from CA0:\n');
fprintf('  ode45:          %.6e mol/L\n', max(abs(total_conc_ode45 - CA0)));
fprintf('  Forward Euler:  %.6e mol/L\n', max(abs(total_conc_fe - CA0)));
fprintf('  Backward Euler: %.6e mol/L\n\n', max(abs(total_conc_be - CA0)));

fprintf('=== FINAL ERRORS (Conversion) ===\n');
X_exact_end = 1 - exp(-k * t_span(2));
fprintf('Exact final conversion: %.6f\n', X_exact_end);
fprintf('  ode45:          %.6e\n', abs(X_ode45(end) - X_exact_end));
fprintf('  Forward Euler:  %.6e\n', abs(X_fe(end) - X_exact_end));
fprintf('  Backward Euler: %.6e\n\n', abs(X_be(end) - X_exact_end));


%% ========================================================================
%  FUNCTION DEFINITIONS
%  ========================================================================
function dydt = batch_reactor_system(t, y)
    % BATCH_REACTOR_SYSTEM - System of ODEs for batch reactor
    %
    % Reaction: A -> B (first-order)
    %
    % Input:
    %   t - Time [s] (not used in this case, but required by ODE solvers)
    %   y - State vector [CA; CB] [mol/L]
    %
    % Output:
    %   dydt - Derivative vector [dCA/dt; dCB/dt]
    
    global k
    
    CA = y(1);  % Concentration of A
    CB = y(2);  % Concentration of B
    
    % Rate of reaction (first-order in A)
    r = k * CA;
    
    % Mass balances
    dCA_dt = -r;  % Consumption of A
    dCB_dt = +r;  % Production of B
    
    % Return derivatives
    dydt = [dCA_dt; dCB_dt];
end

function dXdt = conversion_ode(t, X)
    % CONVERSION_ODE - ODE for conversion
    %
    % For a first-order irreversible reaction A -> B:
    %   dX/dt = k*(1-X)
    %
    % Input:
    %   t - Time [s] (not used explicitly)
    %   X - Conversion of A [-]
    %
    % Output:
    %   dXdt - Rate of change of conversion [s^-1]
    
    global k
    
    dXdt = k * (1 - X);
end