%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
clear, close, clc

%% Data Section
% Define global variables
global m g k c

% System parameters
m = 1;     % Mass [kg]
g = -9.81; % Acceleration due to gravity [m/s²] 
k = 10;    % Spring constant [N/m]
c = 1;     % Damping coefficient [N*s/m]

% Initial conditions
z0 = 0;    % Initial position [m]
v0 = 0;    % Initial velocity [m/s]

%% Numerical Solution
% Solve the system of differential equations
[t, y] = ode45(@spring_damper_system, [0 10], [z0 v0]);

%% Plotting
figure(1)
subplot(2,1,1)
plot(t, y(:,1), 'LineWidth', 2.2, 'Color', 'blue')
xlabel('time [s]', 'FontSize', 18)
ylabel('Position [m]', 'FontSize', 18)
title('Position vs Time', 'FontSize', 20)
grid on

subplot(2,1,2)
plot(t, y(:,2), 'LineWidth', 2.2, 'Color', 'red')
xlabel('time [s]', 'FontSize', 18)
ylabel('Velocity [m/s]', 'FontSize', 18)
title('Velocity vs Time', 'FontSize', 20)
grid on

%% Phase Portrait
figure(2)
plot(y(:,1), y(:,2), 'LineWidth', 2.2, 'Color', 'green')
xlabel('Position [m]', 'FontSize', 18)
ylabel('Velocity [m/s]', 'FontSize', 18)
title('Phase Portrait', 'FontSize', 20)
grid on

%% Spring-Damper System ODE Function
function dydt = spring_damper_system(t, y)
   global m g k c
   
   z = y(1); % Position [m]
   v = y(2); % Velocity [m/s]
   
   % System of first-order ODEs
   dzdt = v;                    % Velocity equation
   dvdt = g - (k*z)/m - (c*v)/m; % Acceleration equation (Newton's 2nd law)
   
   dydt = [dzdt; dvdt];
end