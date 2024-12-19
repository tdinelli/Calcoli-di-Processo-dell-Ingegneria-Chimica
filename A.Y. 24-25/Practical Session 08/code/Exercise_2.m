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
% SEQUENTIAL_REACTION_SIMULATION - Simulates a sequential chemical reaction system
% 
% This script simulates the following sequential reaction system:
%     A -> B -> C
% 
% Where:
% - A is the initial reactant (CA0 = 10)
% - B is an intermediate product
% - C is the final product
% 
% The reaction system is described by the following ODEs:
%     dCA/dt = -k1*CA         (consumption of A)
%     dCB/dt = k1*CA - k2*CB  (formation of B from A, consumption of B to C)
%     dCC/dt = k2*CB          (formation of C)
% 
% With k1 = k2 = 1 (first-order rate constants)
% 
% Initial conditions:
%     CA(0) = 10 (initial concentration of A)
%     CB(0) = 0  (no initial B present)
%     CC(0) = 0  (no initial C present)
clear all, close all, clc;

%% Solve the System of ODEs
% Use MATLAB's ODE45 (adaptive Runge-Kutta) solver
% Time span: 0 to 5 time units
% Initial conditions: [CA0 CB0 CC0] = [10 0 0]
[t, y] = ode45(@reactions, [0 5], [10 0 0]);

%% Plot Results
figure(1)
hold on
% Plot concentration profiles for all species
plot(t, y(:,1), 'LineWidth', 2.2)  % Species A
plot(t, y(:,2), 'LineWidth', 2.2)  % Species B
plot(t, y(:,3), 'LineWidth', 2.2)  % Species C
legend('CA', 'CB', 'CC', 'FontSize', 18)
xlabel('Time', 'FontSize', 14)
ylabel('Concentration', 'FontSize', 14)
title('Sequential Reaction: A -> B -> C', 'FontSize', 16)
grid on

%% Reaction System Definition
function dydt = reactions(t, y)
    % System of ODEs for the sequential reaction A -> B -> C
    % Input:
    %   t - time (not used in this autonomous system)
    %   y - vector of concentrations [CA; CB; CC]
    % Output:
    %   dydt - vector of concentration derivatives [dCA/dt; dCB/dt; dCC/dt]
    
    % Rate equations:
    dydt(1) = -y(1);           % dCA/dt = -k1*CA
    dydt(2) = y(1) - y(2);     % dCB/dt = k1*CA - k2*CB
    dydt(3) = y(2);            % dCC/dt = k2*CB
    
    dydt = dydt';              % Transpose to match ODE45 requirements
end