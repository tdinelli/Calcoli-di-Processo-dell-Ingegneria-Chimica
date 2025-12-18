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
% Define global variables
global g rho_a Cd A mass x_0 y_0 x_tgt y_tgt time

% Set simulation parameters
time = 1;            % Total simulation time (seconds)
g = -9.81;          % Gravity acceleration (m/s²)
Cd = 1;             % Drag coefficient
rho_a = 1.2;        % Air density (kg/m³)
D = 0.015;          % Object diameter (m)
L = .07;            % Object length (m)
rho_s = 800;        % Object density (kg/m³)

% Calculate object properties
Vol = pi*D^2/4*L;   % Volume (m³)
mass = Vol*rho_s;   % Mass (kg)
A = D*L;            % Cross-sectional area (m²)

% Initial and target positions
x_0 = 0;            % Initial x position (m)
y_0 = 12;           % Initial y position (m)
x_tgt = 3;          % Target x position (m)
y_tgt = 1;          % Target y position (m)

% Test blocks
testODE = trajectory(2,[1 1 1 1]);    % Test ODE system
testAlg = target_alg([2 .5]);        % Test algebraic system

% Find initial velocity and angle to hit target
x = fsolve(@target_alg, [2 -pi/10]);  % Solve for initial conditions
v0 = x(1);          % Initial velocity magnitude
theta = x(2);       % Initial angle

% Calculate initial velocity components
v0x = v0*cos(theta);    % Initial x velocity
v0y = v0*sin(theta);    % Initial y velocity

% Solve trajectory and plot
[t,y] = ode45(@trajectory,[0 time],[x_0 y_0 v0x v0y]);
plot(y(:,1),y(:,2))

% Function to calculate error between final and target positions
function err = target_alg(x)
    global x_0 y_0 x_tgt y_tgt time
    
    % Extract initial conditions
    v0 = x(1);
    theta = x(2);
    v0x = v0*cos(theta);
    v0y = v0*sin(theta);
    
    % Calculate trajectory
    [t, y] = ode45(@trajectory,[0 time],[x_0 y_0 v0x v0y]);
    
    % Calculate error from target
    err(1) = x_tgt - y(end,1);    % X position error
    err(2) = y_tgt - y(end,2);    % Y position error
end

% Function to calculate trajectory derivatives
function dydt = trajectory(t,y)
    global g rho_a Cd A mass
    
    % Extract current state
    sx = y(1);    % X position
    sy = y(2);    % Y position
    vx = y(3);    % X velocity
    vy = y(4);    % Y velocity
    
    % Calculate derivatives
    dydt(1,1) = vx;    % dx/dt = vx
    dydt(2,1) = vy;    % dy/dt = vy
    dydt(3,1) = -(0.5 * A * rho_a * Cd * vx^2) / mass;  % dvx/dt (air resistance)
    dydt(4,1) = g - (0.5 * A * rho_a * Cd * vy^2) / mass; % dvy/dt (gravity + air resistance)
end