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
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% TWO NAPHTHA TANKS PROBLEM - ROOT FINDING WITH SUCCESSIVE SUBSTITUTIONS  %
% ----------------------------------------------------------------------- %
clear variables
close all
clc

%% Physical Data
mu = 0.030;      % Dynamic viscosity of naphtha [Pa·s]
gammma = 8445;   % Specific weight of naphtha [N/m³]
Y = 30;          % Height difference between tank free surfaces [m]
L = 4000;        % Pipe length [m]
D = 0.25;        % Initial pipe diameter [m]
V_dot_prime = 1; % Required flow rate [m³/s]
m_kutter = 0.5;  % Kutter roughness coefficient [m^0.5]

%% Graphical Visualization of Fixed-Point Functions
% Compare two different formulations:
% A2(x): Converging formulation - D = 0.837 * (sqrt(D/4) + 0.5)^(1/3)
% A3(x): Oscillating formulation - D = 4*(sqrt(Y*D^6/10.36) - 0.5)^2
% The intersection with y = x represents the solution

x_v = 0:.0001:1;
A1 = @(x) x; % Identity line (y = x)
A2 = @(x) 0.837*((x/4).^(1/2) + 0.5).^(1/3);    % Converging formulation
A3 = @(x) 4*(sqrt((30 * x.^6)/10.36) - 0.5).^2; % Oscillating formulation

figure(1)
% Plot 1: Converging formulation (Good for successive substitutions)
subplot(1,2,1)
hold on
plot(x_v, A1(x_v), 'LineStyle','--','Color','black','LineWidth',2.5)
plot(x_v, A2(x_v), 'LineStyle','-.','Color','black','LineWidth',2.5)
xlabel('X', 'FontSize', 18)
ylabel('Y', 'FontSize', 18)
legend('y = D', 'y = f(D) - Converging', 'FontSize', 18)
title('Converging Formulation', 'FontSize', 16)

% Plot 2: Oscillating formulation (Poor convergence - demonstrates instability)
subplot(1,2,2)
hold on
plot(x_v, A1(x_v), 'LineStyle','--','Color','black','LineWidth',2.5)
plot(x_v, A3(x_v), 'LineStyle','-.','Color','black','LineWidth',2.5)
xlabel('X', 'FontSize', 18)
ylabel('Y', 'FontSize', 18)
legend('y = D', 'y = f(D) - Oscillating', 'FontSize', 18)
title('Oscillating Formulation (Unstable)', 'FontSize', 16)

%% Successive Substitutions Method (Fixed-Point Iteration)
% Solving: D = 0.837 * (sqrt(D/4) + 0.5)^(1/3)
% This formulation is derived from Bernoulli's equation with Chézy losses:
% Y = (v²/C²*R_h)*L, where C is the Chézy coefficient

firstguess = 10; % First guess solution for diameter [m]
epsi = 1.e-5;    % Convergence tolerance [m]
max_iter = 150;  % Maximum iterations to avoid infinite loops
iter_number = 1; % Iteration counter

D_sol = A2(firstguess);
error = abs(firstguess - D_sol);

fprintf('\n=== SUCCESSIVE SUBSTITUTIONS METHOD ===\n');
fprintf('Solving for pipe diameter with V_dot = 1 m³/s\n\n');

% Fixed-point iteration loop: D_new = g(D_old)
while abs(firstguess - D_sol) > epsi && iter_number < max_iter
    D_old = firstguess;
    firstguess = D_sol;
    D_sol = A2(firstguess);
    
    % Store iteration history for convergence analysis
    D_computed(iter_number) = D_sol;
    vector_FG(iter_number) = firstguess;
    computed_error(iter_number) = abs(firstguess - D_sol);
    
    % Print iteration progress
    fprintf('Iteration %d:   D_guess = %.6f m    D_computed = %.6f m    error = %.4e m\n', ...
        iter_number, firstguess, D_sol, abs(firstguess - D_sol));
    
    iter_vector(iter_number) = iter_number;
    iter_number = iter_number + 1;
end

fprintf('\n--- Solution found (Successive Substitutions) ---\n');
fprintf('Theoretical diameter D_t = %.6f m\n', D_computed(end));
fprintf('Number of iterations: %d\n', length(iter_vector));
fprintf('Final error: %.4e m\n\n', computed_error(end));

%% Solve Using fzero (Newton-Raphson Based Method)
% Alternative method: solve the zero of f(D) = Y - (distributed losses)
% This is more robust and typically converges faster than fixed-point
% iteration
fprintf('=== FZERO METHOD (Newton-Raphson) ===\n');
options = optimset('Display','iter'); % Show iterations
[sol, fval, exitFlag] = fzero(@bernoulli, 1.7, options);

fprintf('\n--- Solution found (fzero) ---\n');
fprintf('Theoretical diameter D_t = %.6f m\n', sol);
fprintf('Function value at solution: %.4e\n', fval);
fprintf('Exit flag: %d\n\n', exitFlag);

%% Convergence Comparison Plot
figure(2)
subplot(2,1,1)
hold on
plot(iter_vector, computed_error, 'r-o', 'LineWidth', 2)
scatter(iter_vector(end), computed_error(end), 140, 'green', 'filled', 'square')
xlabel('Iteration Number', 'FontSize', 16)
ylabel('Error [m]', 'FontSize', 16)
title('Convergence of Successive Substitutions', 'FontSize', 16)
legend('Error Evolution', 'Final Convergence', 'FontSize', 14)
grid on

subplot(2,1,2)
hold on
plot(iter_vector, D_computed, 'LineWidth', 2.5, 'Color', 'blue')
scatter(iter_vector, vector_FG, 70, 'red')
xlabel('Iteration Number', 'FontSize', 16)
ylabel('Diameter [m]', 'FontSize', 16)
title('Diameter Evolution During Iteration', 'FontSize', 16)
legend('Computed D', 'Guess D', 'FontSize', 14)
grid on

%% Function Definition
% bernoulli: Implements the Bernoulli equation with Chézy losses
% 
% From the document, Bernoulli's theorem gives:
% Y = ΔH = (v²/(C²*R_h))*L
% where C = 100*sqrt(R_h)/(m + sqrt(R_h)) is the Chézy coefficient
% and R_h = D/4 is the hydraulic radius for circular pipes
%
% For V_dot' = 1 m³/s, this reduces to:
% Y = 10.37*(sqrt(D/4) + 0.5)² / D^6
%
% The function returns zero when the diameter satisfies the flow condition
function f = bernoulli(D)
    % Right-hand side: head loss expression from Chézy formula
    right = (10.37.*(sqrt(D/4) + 0.5).^2) / (D.^6);
    
    % Left-hand side: height difference between tanks
    left = 30;
    
    % Return the residual (should be zero at solution)
    f = left - right;
end