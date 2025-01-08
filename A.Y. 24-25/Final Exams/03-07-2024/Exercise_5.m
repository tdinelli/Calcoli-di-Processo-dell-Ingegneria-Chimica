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
global k beta mass vx L0

% System Parameters
beta = 1;    % Damping coefficient [N⋅s/m]
k = 30;      % Spring stiffness [N/m]
mass = 0.25; % Mass of the object [kg]

% Solve the differential equations using ode45
% Time span: 0 to 3 seconds
% Initial conditions: [initial_velocity initial_position] = [0 -0.20]
[t, ymass] = ode45(@ode_sys, [0 3], [0 -0.20]);

% Count the number of bounces
% A bounce occurs when the position crosses zero from negative to positive
bounces = 0;
for i = 1:length(t)-1
    % Check if position changes from negative to positive
    if sign(ymass(i,1)) < 0 && sign(ymass(i,1))*sign(ymass(i+1,1)) < 0
        bounces = bounces + 1;
    end
end

% Test the ODE function with sample values (for debugging)
test = ode_sys(1, [1 2]);

% Plot the position vs time
plot(t, ymass(:,2));
xlabel('Time [s]');
ylabel('Position [m]');
title('Mass Position Over Time');

% ODE System Function
function dydt = ode_sys(t, y)
    % Access global parameters
    global k beta mass
    
    % Extract state variables
    vy = y(1);    % Velocity [m/s]
    y = y(2);     % Position [m]
    
    % Calculate acceleration (dvydt) using Newton's Second Law
    dvydt = -9.81 - k*y/mass - beta*vy/mass;
    
    % Position change rate equals velocity
    dydt = vy;
    
    % Return state derivatives [acceleration; velocity]
    dydt = [dvydt; dydt];
end