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
global % TODO

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
v_firstguess = ; % First guess solution for relative exhaust velocity [m/s]
epsi = ;      % Convergence tolerance
max_iter = ;    % Maximum iterations to avoid infinite loops
iter_number = ;   % Iteration counter

% Initialize the iterative process

% Successive substitutions loop: v_new = g(v_old)

% Display final solution

%% Convergence Analysis Plots
% Plot 1: Error evolution

% Plot 2: Velocity evolution

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
    % TODO
    % Define auxiliary coefficients from the integrated momentum equation
    alpha = ;      % Exhaust momentum coefficient
    beta = ;              % Aerodynamic drag coefficient
    gamma = ;                      % Initial aircraft mass
    delta = ;  % Mass flow rate term
    
    % Integral term from velocity integration (arctangent solution)
    term_1 = ;
    
    % Compute the relative exhaust velocity from the fixed-point equation
    EM = ;
end