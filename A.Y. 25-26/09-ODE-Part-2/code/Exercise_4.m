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
% Define global variables for tank system
global Fin0 r1 r2 A1 A2

% Tank parameters
A1 = 30;    % First tank cross-sectional area [m²]
r1 = 1.2;   % First tank hydraulic resistance coefficient [m²/s]
A2 = 50;    % Second tank cross-sectional area [m²]
r2 = 0.7;   % Second tank hydraulic resistance coefficient [m²/s]
Fin0 = 9.4; % Initial inlet flow rate [m³/s]

% Initial conditions
h1_nonint_0 = 11.28;  % Initial height tank 1 (non-interacting) [m]
h2_nonint_0 = 6.58;   % Initial height tank 2 (non-interacting) [m]
h1_int_0 = 17.86;     % Initial height tank 1 (interacting) [m]
h2_int_0 = 6.58;      % Initial height tank 2 (interacting) [m]

%% Numerical Solution
% ODE solver options
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

% Solve for non-interacting tanks
[t_nonint, h_nonint] = ode15s(@noninteracting_tanks, [0 500], ...
    [h1_nonint_0 h2_nonint_0], opts);

% Solve for interacting tanks
[t_int, h_int] = ode15s(@interacting_tanks, [0 500], ...
    [h1_int_0 h2_int_0], opts);

%% Plotting
% First figure: Comparing tank levels for non-interacting and interacting scenarios
figure(1)
% Subplot for non-interacting tanks
subplot(1,2,1)
hold on
plot(t_nonint, h_nonint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(t_nonint, h_nonint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Non-interacting Tanks', 'FontSize', 20)
legend('Tank 1', 'Tank 2', 'FontSize', 14)
grid on

% Subplot for interacting tanks
subplot(1,2,2)
hold on
plot(t_int, h_int(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(t_int, h_int(:,2), 'Color', 'blue', 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Interacting Tanks', 'FontSize', 20)
legend('Tank 1', 'Tank 2', 'FontSize', 14)
grid on

% Second figure: Overlay of non-interacting and interacting tank levels
figure(2)
hold on
plot(t_nonint, h_nonint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(t_nonint, h_nonint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
plot(t_int, h_int(:,1), 'Color', 'red', 'LineWidth', 2.2, 'LineStyle','--')
plot(t_int, h_int(:,2), 'Color', 'blue', 'LineWidth', 2.2, 'LineStyle','--')
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
legend('Tank 1 non-interacting', 'Tank 2 non-interacting', ...
    'Tank 1 interacting', 'Tank 2 interacting', 'FontSize', 14)
title('Comparison of Tank Configurations', 'FontSize', 20)
grid on

%% ODE Functions
% Function for non-interacting tanks
function dhdt = noninteracting_tanks(t, h)
    global Fin0 r1 r2 A1 A2
    
    h1 = h(1);  % Height of tank 1
    h2 = h(2);  % Height of tank 2

    % Inlet flow decreases linearly for first 30 seconds, then constant
    if t <= 30
        Fin = Fin0 - (Fin0/2/30) * t;
    else
        Fin = Fin0/2;
    end

    % Differential equations for non-interacting tank levels
    dh1dt = (Fin - h1/r1) / A1; 
    dh2dt = (h1/r1 - h2/r2) / A2; 

    dhdt = [dh1dt; dh2dt];
end

% Function for interacting tanks
function dhdt = interacting_tanks(t, h)
    global Fin0 r1 r2 A1 A2
    
    h1 = h(1);  % Height of tank 1
    h2 = h(2);  % Height of tank 2

    % Inlet flow decreases linearly for first 30 seconds, then constant
    if t <= 30
        Fin = Fin0 - (Fin0/2/30) * t;
    else
        Fin = Fin0/2;
    end

    % Differential equations for interacting tank levels
    % Flow between tanks depends on height difference
    dh1dt = (Fin - (h1 - h2)/r1) / A1; 
    dh2dt = ((h1 - h2)/r1 - h2/r2) / A2; 

    dhdt = [dh1dt; dh2dt];
end