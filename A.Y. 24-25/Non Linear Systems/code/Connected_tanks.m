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
clear all
close all
clc

%% Define Global Parameters
global D1 L1 D3 L3 mu rho za zb epssuD g

% System constants
epssuD = 0.001;    % Relative roughness (epsilon/D)
g = 9.81;          % Gravitational acceleration [m/s^2]

% Pipe dimensions
D1 = 0.3;          % Diameter of pipe 1 [m]
L1 = 300;          % Length of pipe 1 [m]
D3 = 0.4;          % Diameter of pipe 3 [m]
L3 = 900;          % Length of pipe 3 [m]

% Fluid properties (water)
rho = 1000;        % Density [kg/m^3]
mu = 1.141e-3;     % Dynamic viscosity [Pa·s]

% Tank heights
za = 80;           % Height of tank A [m]
zb = 30;           % Height of tank B [m]

%% Solve System of Equations
% Initial test with arbitrary values
v_test = tanks([.1 .1 .1]);

% Solve system using fsolve
% Initial guess: [f1 f3 Q] = [0.009 0.009 0.2]
solution = fsolve(@tanks,[0.009 0.009 0.2]);

disp(['Firction factor for pipe 1: ', num2str(solution(1))])
disp(['Firction factor for pipe 2: ', num2str(solution(2))])
disp(['Volumetric flow rate: ', num2str(solution(3)), ' [m^3/s]'])

%% System of Equations Function
function eqn = tanks(unknowns)
    global D1 L1 D3 L3 mu rho za zb epssuD g
    
    % Unpack variables
    f1 = unknowns(1);     % Friction factor for pipe 1
    f3 = unknowns(2);     % Friction factor for pipe 3
    Q  = unknowns(3);     % Volumetric flow rate [m^3/s]
    
    % Calculate velocities
    v1 = Q / (pi*D1^2/4);  % Velocity in pipe 1 [m/s]
    v3 = Q / (pi*D3^2/4);  % Velocity in pipe 3 [m/s]
    
    % Calculate Reynolds numbers
    Re1 = v1 * D1 * rho / mu;
    Re3 = v3 * D3 * rho / mu;
    
    % Calculate head losses using Darcy-Weisbach equation
    dH1 = 4 * L1/D1 * f1 * v1^2/2/g;    % Head loss in pipe 1 [m]
    dH3 = 4 * L3/D3 * f3 * v3^2/2/g;    % Head loss in pipe 3 [m]
    
    % System of equations:
    % 1. Energy balance between tanks
    eqn(1) = za - zb - dH1 - dH3;
    
    % 2. Colebrook-White equation for pipe 1
    eqn(2) = 1/f1^0.5 + 4*log10(1/3.7*epssuD + 1.255/(Re1*f1^0.5));
    
    % 3. Colebrook-White equation for pipe 3
    eqn(3) = 1/f3^0.5 + 4*log10(1/3.7*epssuD + 1.255/(Re3*f3^0.5));
end