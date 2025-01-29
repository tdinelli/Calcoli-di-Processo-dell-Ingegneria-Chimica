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
clear all, close all, clc

% Global variables for pendulum parameters
global L g
L = 1;        % Length of pendulum [meters]
g = 9.81;     % Acceleration due to gravity [m/s²]

% Initial conditions
theta0 = pi/12;    % Initial angle [radians] (15 degrees)
omega0 = 0;        % Initial angular velocity [rad/s]

% Time span for simulation
tspan = [0 60];    % Simulate from 0 to 60 seconds

% Solve the differential equations using ODE45
% y(:,1) will contain theta values
% y(:,2) will contain omega values
[t,y] = ode45(@sys_ODE, tspan, [theta0 omega0]);

% Calculate analytical solution for velocity
% This is valid for small angle approximation (sin(θ) ≈ θ)
vanalitica = -theta0*sqrt(g)*sin(sqrt(g)*t);

% Plot numerical solution for angular velocity
plot(t,y(:,2)); hold on;
vmax_num = max(y(:,2))    % Maximum numerical velocity

% Plot analytical solution and find its maximum
vanalitica = -theta0*sqrt(g)*sin(sqrt(g)*t);
plot(t,vanalitica); hold on;
vmax_an = max(vanalitica)  % Maximum analytical velocity

hold off

% Calculate absolute difference between numerical and analytical maximum velocities
diff_abs = (vmax_num-vmax_an)

% Function defining the system of ODEs for the pendulum
function dydt = sys_ODE(t,y)
    % Access global parameters
    global L g
    
    % Extract current state variables
    theta = y(1);     % Current angle
    omega = y(2);     % Current angular velocity
    
    % Define the system of differential equations
    dydt(1,1) = omega;                % dθ/dt = ω
    dydt(2,1) = -g/L*sin(theta);      % dω/dt = -(g/L)sin(θ)
end