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
global g v0
g = -3.71; % Mars gravity acceleration (m/s²)
v0 = 5;    % Initial velocity (m/s)

% Test: Calculate range for different angles
theta = [1:1:90].*pi./180;  % Convert angles from degrees to radians
gittata = -funzobj(theta);  % Calculate range (negative because we're minimizing)
plot(theta, gittata)        % Plot angle vs range
xlabel('Angle (radians)')
ylabel('Range (meters)')
title('Projectile Range vs Launch Angle on Mars')

% Optimization using fmincon
theta0 = pi/4;  % Initial guess (45 degrees)
lb = 0;         % Lower bound (0 degrees)
ub = pi/2;      % Upper bound (90 degrees)
A = [];         % No linear inequality constraints
b = [];
Aeq = [];       % No linear equality constraints
beq = [];
nonlcon = [];   % No nonlinear constraints

options = optimoptions('fmincon', 'Display', 'iter');
maxAngle = fmincon(@funzobj, theta0,...
    A, b, Aeq, beq, lb, ub, nonlcon, options); % [rad]

% Print result in degrees
fprintf('Optimal angle: %.2f degrees\n', maxAngle*180/pi)

% Objective function: Calculate negative range
% (negative because fmincon minimizes)
function dist = funzobj(theta)
    global g v0
    
    % Calculate initial velocity components
    v0x = v0*cos(theta);    % Initial horizontal velocity
    v0y = v0*sin(theta);    % Initial vertical velocity
    
    % Calculate range using projectile motion formula
    % Range = 2(v0y/g)v0x for symmetric trajectory
    dist = -(2.*v0y./g.*v0x);  % Negative for minimization
end