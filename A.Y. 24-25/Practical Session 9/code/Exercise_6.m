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
global m g k c

% Define system parameters
m = 1;     % Mass [kg]
g = -9.81; % Acceleration due to gravity [m/s^2] 
k = 10;    % Spring constant [N/m]
c = 1;     % Damping coefficient [N*s/m]
z0 = 0;    % Initial position [m]

% Solve the differential equations
[t, y] = ode45(@ODE_sys, [0 10], [0 0]);

% Plot the results
plot(t, y)

% Differential equation function
function dydt = ODE_sys(t, y)
   global m g k c
   z = y(1); % Position [m]
   v = y(2); % Velocity [m/s]
   
   % Differential equations
   dydt(1, 1) = v;
   dydt(2, 1) = g - k*z/m - c*v/m;
end