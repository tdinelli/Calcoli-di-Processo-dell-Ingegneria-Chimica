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
% BOEING 737 LANDING PROBLEM - ROOT FINDING WITH SUCCESSIVE SUBSTITUTIONS %
% ----------------------------------------------------------------------- %
clear variables
close all
clc

%% Physical Data
global Sout f A m0 rho v_in t_stop

v_in = 210 / 3.6; % Landing velocity [m/s] - converted from km/h
t_stop = 15;      % Stopping time [s]
m0 = 35000;       % Initial Boeing mass [kg]
Sout = 0.085;     % Exhaust gas outlet section [m^2]
f = 0.97;         % Drag coefficient [-]
A = 25;           % Frontal area subjected to air drag [m^2]
rho = 1;          % Air density [kg/m^3]

% Utilities for the printing
formatSpec_v = '%.5f';
formatSpec_f = '%.4e';
%% Numerical Solution - Successive Substitutions Method
% The problem is reduced to finding the root of: v = g(v)
% where g(v) is defined in the EquationModified function
% This is derived from the momentum balance and Bernoulli's theorem
v_firstguess = 10; % First guess solution for relative exhaust velocity [m/s]
epsi = 1.e-5;      % Convergence tolerance
max_iter = 150;    % Maximum iterations to avoid infinite loops
iter_number = 1;   % Iteration counter

% Initialize the iterative process
v = EquationModified(v_firstguess);
error = abs(v_firstguess - v);

% Successive substitutions loop: v_new = g(v_old)
while abs(v_firstguess - v) > epsi && iter_number < max_iter
    v_old = v_firstguess;
    v_firstguess = v;
    v = EquationModified(v_firstguess);
    
    % Store results for convergence analysis
    v_computed(iter_number) = v; 
    vector_FG(iter_number) = v_firstguess; 
    computed_error(iter_number) = abs(v_firstguess - v);
    
    % Print iteration evolution on the screen
    fprintf('%d)   v_FG = %.5f    f(v) = %.5f   error = %.4e\n', ...
        iter_number, v_firstguess, v, abs(v_firstguess - v));
    
    iter_vector(iter_number) = iter_number;
    iter_number = iter_number + 1; % Increment iteration counter
end

% Display final solution
fprintf('\n');
fprintf('Solution found:\n');
fprintf('      velocity = %.5f m/s,  error = %.4e\n', ...
    v_computed(end), computed_error(end));
fprintf('\n');

%% Convergence Analysis Plots
% Plot 1: Error evolution
subplot(2,1,1)
hold on
plot(iter_vector, computed_error,'r-o', 'LineWidth',2)
scatter(iter_vector(end), computed_error(end), 140,'green', 'filled','square')
xlabel('Iteration number', 'FontSize', 16)
ylabel('Computed error', 'FontSize', 16)
legend('Error Function', 'Convergence', 'FontSize', 18)

% Plot 2: Velocity evolution
subplot(2,1,2)
hold on
plot(iter_vector, v_computed, 'LineWidth', 2.5, 'Color', 'blue')
scatter(iter_vector, vector_FG, 70, "red")
xlabel('Iteration number', 'FontSize', 16)
ylabel('Velocity [m/s]', 'FontSize', 16)
legend('Computed Velocity', 'First Guess', 'FontSize', 18)

%% Function Definition
% EquationModified: Implements the rearranged momentum equation
% This function represents the right-hand side of the fixed-point equation:
%
% v = (gamma/(2*rho*S*t)) * (1 - exp(term_1))
% 
% Derivation from momentum balance:
% - alpha = 2*S*v_r^2   (exhaust momentum term)
% - beta = 0.5*f*A      (drag term coefficient)
% - gamma = m0          (initial mass)
% - delta = 2*rho*S*v_r (mass flow rate coefficient)
%
% The arctangent term comes from integrating the velocity-dependent forces

function EM = EquationModified(v_gas)
    global Sout f A m0 rho v_in t_stop
    
    % Define auxiliary coefficients from the integrated momentum equation
    alpha = 2 * Sout * v_gas^2;      % Exhaust momentum coefficient
    beta = 0.5 * f * A;              % Aerodynamic drag coefficient
    gamma = m0;                      % Initial aircraft mass
    delta = 2 * rho * Sout * v_gas;  % Mass flow rate term
    
    % Integral term from velocity integration (arctangent solution)
    term_1 = (-delta / (rho * sqrt(alpha * beta))) * ...
        atan(v_in * sqrt(beta/alpha));
    
    % Compute the relative exhaust velocity from the fixed-point equation
    EM = (gamma / (2 * rho * Sout * t_stop)) * (1 - exp(term_1));
end