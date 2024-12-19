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
% Clear workspace and command window for fresh start
clear all
close all
clc

% Define temperature bounds for water vapor pressure calculation
Tinf = 273.16; % Lower temperature bound (Kelvin) - Triple point of water
Tsup = 647.13; % Upper temperature bound (Kelvin) - Critical point of water

% Create temperature vector for plotting
% Uses 0.001 K steps for smooth visualization
T_vect = Tinf:0.001:Tsup;

% Calculate vapor pressure across temperature range
P0vap = PVapH2O(T_vect);

% Configure options for fsolve optimization
options = optimset('Display', 'iter',...          % Show iteration progress
    'PlotFcns', {@optimplotx, @optimplotfval},... % Plot convergence
    'TolX', 1e-20,...      % Very tight tolerance on x (temperature)
    'MaxFunEvals', 2e3,... % Maximum function evaluations
    'MaxIter', 2e3);       % Maximum iterations

%% Solve using both methods

% Solve using custom Newton implementation
% Starting guess: 310 K
% Tolerance: 1e-8
% Maximum iterations: 50
[sol_newton, error_newton] = Newton(310, @target, 1e-8, 50);

% Solve using MATLAB's fsolve function
% Starting guess: 310 K
[sol_fsolve, fval_fsolve, exitFlag_fsolve] = fsolve(@target, 310, options);

%% Visualization of results

% Create new figure
figure
hold on

% Plot vapor pressure curve
plot(T_vect, P0vap, 'LineWidth', 2.5)

% Plot zero reference line
plot([Tinf Tsup], [0 0], 'k--')

% Plot fsolve solution point
scatter(sol_fsolve, fval_fsolve, 140, 'MarkerFaceColor', 'red')

% Plot Newton method solution point
scatter(sol_newton(end), target(sol_newton(end)), 140,...
    'MarkerFaceColor', 'blue',...
    'MarkerEdgeColor', 'blue')

% Label axes and add legend
ylabel('P^{0}_{vap} [Pa]', 'FontSize', 18)
xlabel('T [K]', 'FontSize', 18)
legend('P^{0}_{vap}', '', 'fsolve solution', 'Newton solution', ...
    'FontSize', 18)

%% Helper Functions

function P = PVapH2O(T)
    % Calculate water vapor pressure using Antoine-like equation
    % Input: T - Temperature in Kelvin
    % Output: P - Vapor pressure in Pascal
    
    % Coefficients for vapor pressure equation
    A = 7.3649E+01;
    B = -7.2582E+03;
    C = -7.3037E+00;
    D = 4.1653E-06;
    E = 2.0000E+00;
    
    % Calculate pressure using modified Antoine equation
    % P = exp(A + B/T + C*ln(T) + D*T^E)
    P = exp(A + B./T + C .* log(T) + D * T.^E);
end

function f = target(T)
    % Target function to find zero
    % Calculates difference between vapor pressure at T and target pressure
    % Input: T - Temperature in Kelvin
    % Output: f - Difference between calculated and target pressure
    
    % Target pressure: 5.0662e4 Pa (approximately 0.5 atm)
    f = PVapH2O(T) - 5.0662e4;
end