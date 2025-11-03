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

% TODO

%% Successive Substitutions Method (Fixed-Point Iteration)
% Solving: D = 0.837 * (sqrt(D/4) + 0.5)^(1/3)
% This formulation is derived from Bernoulli's equation with Chézy losses:
% Y = (v²/C²*R_h)*L, where C is the Chézy coefficient

% TODO

%% Solve Using fzero (Newton-Raphson Based Method)
% Alternative method: solve the zero of f(D) = Y - (distributed losses)
% This is more robust and typically converges faster than fixed-point
% iteration

% TODO

%% Convergence Comparison Plot

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
% TODO
end