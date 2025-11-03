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
clear variables
close all
clc

%% Physical Data and System Parameters
global % TODO

N = 1;          % Initial number of taps
P0 = 1.5e5;     % Inlet pressure [Pa] = 1.5 bar
Patm = 1e5;     % Atmospheric pressure [Pa] = 1 bar
rho = 1000;     % Water density [kg/m³]
g = 9.81;       % Gravitational acceleration [m/s²]
gamma = rho*g;  % Specific weight [N/m³]
dt = 3e-2;      % Pipe diameter [m] = 3 cm
dr = 1e-2;      % Tap diameter [m] = 1 cm
L = 5;          % Distance between taps [m]
K = 4;          % Localized loss coefficient [-]
epsi = 1e-5;    % Pipe roughness [m]

options = optimset('Display','iter'); % Show fsolve iterations

%% Solution for N = 1 (Single Tap Case)
% This corresponds to objective 1: calculate outlet velocity with only
% one tap present. The system has 4 unknowns and 4 equations:
% 1) Bernoulli between inlet and tap outlet (with losses)
% 2) Continuity equation
% 3) Friction factor (Colebrook for turbulent or f=16/Re for laminar)
% 4) Boundary condition: v_a(1) = 0 (pipe closed after the tap)
fprintf('\n========================================\n');
fprintf('CASE 1: SINGLE TAP (N = 1)\n');
fprintf('========================================\n\n');


%% Solution for N = 5 (Five Taps)
% Test case with 5 taps to analyze pressure drop and flow distribution

%% Solution for N = 20 (Maximum Number Test)
% Objective 2 & 3: Determine maximum number of taps and pressure profile
% A tap can deliver water only if P_a(i) > P_atm

%% Function: System of Nonlinear Equations
% For N taps, this function defines the 4N equations:
%
% For each tap i (i = 1 to N):
%   1) Bernoulli equation between inlet and tap i outlet:
%      (P0-Patm)/γ + v_b(i)²/(2g) = v_out(i)²/(2g) +
%           ΣΔH_distributed + ΣΔH_localized
%
%   2) Continuity equation:
%      v_b(i)*D² = v_out(i)*d² + v_a(i)*D²
%
%   3) Friction factor (Colebrook correlation for turbulent flow):
%      1/√f = -4*log10(ε/(3.71*D) + 1.256/(Re*√f))  for Re > 2000
%      f = 16/Re                                    for Re < 2000
%
%   4) Boundary conditions:
%      v_a(i) = v_b(i+1)  for i < N  (continuity between taps)
%      v_a(N) = 0         for i = N  (pipe closed at the end)

function F = rubinettiInSerie(x)
% TODO System of equations implementation
end