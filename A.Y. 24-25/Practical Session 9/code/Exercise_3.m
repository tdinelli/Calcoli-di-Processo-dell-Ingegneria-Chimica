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

%% Data Section
% Define global variables for use across functions
global Fin0 A r

% System parameters
A = 30;     % Tank cross-sectional area [m²]
Fin0 = 7.5; % Initial inlet flow rate [m³/s]
r = 0.4;    % Time constant [s/m²]
h0 = 3;     % Initial height [m]

%% Numerical Solution
% ODE solver with options for two different scenarios
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

% Solve for constant inlet flow
[t, y] = ode15s(@odesys, [0 100], 3, opts);

% Solve for varying inlet flow
[t1, y1] = ode15s(@odesys2, [0 100], 3, opts);

%% Plotting
% First figure: Constant inlet flow
figure(1)
plot(t, y, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)

% Second figure: Varying inlet flow
figure(2)
% Subplot 1: Tank level dynamics
subplot(2,1,1)
plot(t1, y1, 'LineWidth', 2.2, 'Color', 'red')
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Single tank: height dynamics', 'FontSize', 20)

% Subplot 2: Inlet flow variation
subplot(2,1,2)
% Calculate inlet flow over time
for i = 1:length(t1)
    if t1(i) <= 30
        F(i) = Fin0 - ((Fin0/2)/30) * t1(i);
    else
        F(i) = Fin0 - ((Fin0/2)/30) * 30;
    end
end
plot(t1, F, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Inlet Flow [m3/s]', 'FontSize', 18)
title('Inlet Flow', 'FontSize', 20)

%% ODE Functions
% Function for constant inlet flow
function df = odesys(t, y)
    global Fin0 A r
    h = y(1);
    Fi = Fin0/2;
    df(1) = Fi/A - h/A/r; 
end

% Function for varying inlet flow
function df = odesys2(t, y)
    global Fin0 A r 
    h = y(1);
    % Inlet flow decreases linearly for first 30 seconds
    if t <= 30
        Fi = Fin0 - ((Fin0/2)/30) * t;
    else
        Fi = Fin0 - ((Fin0/2)/30) * 30;
    end
    df(1) = Fi/A - h/A/r; 
end