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
% Define global variables used across all functions
global S Diff v nu rho rhoS Sc D0

% System Parameters
Vol = .002;     % Volume in cubic meters (m³)
rhoS = 400;     % Solid density in kg/m³
Diff = 10e-9;   % Diffusion coefficient in m²/s
v = 0.05;       % Fluid velocity in m/s
rho = 2160;     % Fluid density in kg/m³
m0 = 15;        % Initial mass in grams
D0 = 0.0018;    % Initial diameter in meters
nu = 5e-7;      % Kinematic viscosity in m²/s
Sc = 146;       % Schmidt number (dimensionless)

% Solve the system
TestSys = sysDiff(0, 6);       % Test the system at t=0 and D=6
tend = fzero(@fun2_0, 7);      % Find the time when diameter reaches zero
ode45(@sysDiff, [0 tend], D0); % Solve differential equation from 0 to tend

%% Functions definition
% Function to find when diameter reaches zero
function y = fun2_0(t)
    global D0
    [t, Diam] = ode45(@sysDiff, [0 t], D0); % Solve ODE up to time t
    y = Diam(end);                          % Return final diameter
end

% Main differential equation function describing diameter change over time
function dydt = sysDiff(t, y)
    global Diff v nu rho rhoS Sc
    D = y; % Current diameter

    if D > 0 % Only calculate if diameter is positive
        % Calculate dimensionless numbers
        Re = v*D/nu;                  % Reynolds number
        Sh = 2 + 0.6*Re^0.5*Sc^(1/3); % Sherwood number correlation

        % Calculate mass transfer coefficient
        hm = Sh*Diff/D; % Mass transfer coefficient

        % Calculate rate of diameter change
        dydt = -hm*2/rho*rhoS; % Rate equation for diameter change
    else
        dydt = 0; % If diameter <= 0, stop changing
    end
end
