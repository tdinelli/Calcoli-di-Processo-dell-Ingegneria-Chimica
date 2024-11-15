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
% This code solves for the tensions in the ropes and acceleration of three
% stuntmen connected by ropes in free fall, considering air resistance.
%
% Problem Description:
% - Three stuntmen of different masses are connected by two ropes
% - They fall from a height of 15m
% - Air resistance is proportional to velocity
% - The system is solved using Newton's Second Law for each stuntman
%
% The system solves for:
% - Common acceleration (a)
% - Tension in upper rope (T)
% - Tension in lower rope (R)

%% Clear workspace
clear all
close all
clc

%% Define Global Parameters
global m1 g c1 v_freeFall m2 m3 c2 c3

% Stuntmen masses
m1 = 70;    % Mass of stuntman 1 [kg]
m2 = 60;    % Mass of stuntman 2 [kg]
m3 = 40;    % Mass of stuntman 3 [kg]

% Physical constants
g = 9.81;   % Gravitational acceleration [m/s^2]
h = 15;     % Height of fall [m]

% Air resistance coefficients
c1 = 10;    % Air resistance coefficient for stuntman 1 [kg/s]
c2 = 14;    % Air resistance coefficient for stuntman 2 [kg/s]
c3 = 17;    % Air resistance coefficient for stuntman 3 [kg/s]

% Calculate free fall velocity
v_freeFall = sqrt(2*g*h);    % Terminal velocity [m/s]

%% Solve System of Equations
% Initial guess for [acceleration, upper tension, lower tension]
sol0 = [10 200 150];

% Solve system using fsolve
sol = fsolve(@System, sol0);

% Extract solutions
a = sol(1);    % Common acceleration [m/s^2]
T = sol(2);    % Tension in upper rope [N]
R = sol(3);    % Tension in lower rope [N]

%% System of Equations Function
function eq = System(x)
    global m1 g c1 v_freeFall m2 m3 c2 c3
    
    % Unpack variables
    a = x(1);    % Acceleration
    T = x(2);    % Upper rope tension
    R = x(3);    % Lower rope tension
    
    % System of equations based on Newton's Second Law for each stuntman
    % For stuntman 1 (top):
    eq(1) = m1*g - T - c1*v_freeFall - m1*a;
    
    % For stuntman 2 (middle):
    eq(2) = m2*g + T - c2*v_freeFall - R - m2*a;
    
    % For stuntman 3 (bottom):
    eq(3) = m3*g - c3*v_freeFall + R - m3*a;
end