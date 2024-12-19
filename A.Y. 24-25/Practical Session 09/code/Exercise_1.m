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
clear, close, clc

%% Data Section
% Define global variables to be used across different functions
global k1 k2 k3

% Kinetic parameters for the biomass growth model
k1 = 0.5;    % Maximum specific growth rate [1/h]
k2 = 1e-7;   % Half-saturation constant [kmol/m3]
k3 = 0.6;    % Substrate consumption rate coefficient

% Simulation time and initial conditions
tfinal = 15; % Total simulation time [h]
B0 = 0.03;   % Initial biomass concentration [kmol/m3]
S0 = 4.5;    % Initial substrate concentration [kmol/m3]

%% ODE Solution
% Default ODE solver options (no special settings)
[tbase, ybase] = ode15s(@biomass, [0 tfinal], [B0 S0]);

% ODE solver with more precise tolerance settings
% RelTol: Relative tolerance
% AbsTol: Absolute tolerance
% These settings improve the numerical accuracy of the solution
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[topt, yopt] = ode15s(@biomass, [0 tfinal], [B0 S0], opts);

%% Plotting
% Create a figure with two subplots side by side
% First subplot: Default ODE solver results
subplot(1,2,1)
hold on
% Plot biomass concentration
plot(tbase, ybase(:,1), 'LineWidth', 2.2)
% Plot substrate concentration
plot(tbase, ybase(:,2), 'LineWidth', 2.2)
% Axis labels and formatting
xlabel('time [h]', 'FontSize', 18)
ylabel('Concentration [kmol/m3]', 'FontSize', 18)
legend('Biomass','Substrate', 'FontSize', 22)

% Second subplot: ODE solver with improved tolerance
subplot(1,2,2)
hold on
% Plot biomass concentration
plot(topt, yopt(:,1), 'LineWidth', 2.2)
% Plot substrate concentration
plot(topt, yopt(:,2), 'LineWidth', 2.2)
% Axis labels and formatting
xlabel('time [h]', 'FontSize', 18)
ylabel('Concentration [kmol/m3]', 'FontSize', 18)
legend('Biomass','Substrate', 'FontSize', 22, 'location','northwest')

%% Biomass Growth ODE Function
function dCdt = biomass(t, x)
    % This function defines the ordinary differential equations 
    % for biomass and substrate concentrations
    
    % Access global kinetic parameters
    global k1 k2 k3
    
    % Extract current biomass and substrate concentrations
    B = x(1);  % Biomass concentration
    S = x(2);  % Substrate concentration
    
    % Equation 1: Biomass growth rate
    % Uses Monod equation for microbial growth kinetics
    % Growth rate depends on current biomass and substrate concentrations
    eq1 = (k1 * B * S) / (k2 + S);
    
    % Equation 2: Substrate consumption rate
    % Proportional to biomass growth, but with a negative sign 
    % (as substrate is consumed during growth)
    eq2 = -k3 * (k1 * B * S) / (k2 + S);
    
    % Return the rate of change as a column vector
    dCdt = [eq1 eq2]';
end