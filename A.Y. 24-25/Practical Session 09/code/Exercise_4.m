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
% Define global variables for tank system
global Fin0 r1 r2 A1 A2

% Tank parameters
A1 = 30;    % First tank cross-sectional area [m²]
r1 = 1.2;   % First tank time constant [s/m²]
A2 = 50;    % Second tank cross-sectional area [m²]
r2 = 0.7;   % Second tank time constant [s/m²]
Fin0 = 9.4; % Initial inlet flow rate [m³/s]

%% Numerical Solution
% ODE solver options
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

% Solve for non-interacting tanks
[tnonint, ynonint] = ode15s(@noninteractingtanks, [0 500], [11.28 6.58], opts);

% Solve for interacting tanks
[tint, yint] = ode15s(@interactingtanks, [0 500], [17.86 6.58], opts);

%% Plotting
% First figure: Comparing tank levels for non-interacting and interacting scenarios
figure(1)
% Subplot for non-interacting tanks
subplot(1,2,1)
hold on
plot(tnonint, ynonint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(tnonint, ynonint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Non Interacting Tanks', 'FontSize', 20)

% Subplot for interacting tanks
subplot(1,2,2)
hold on
plot(tint, yint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(tint, yint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Interacting Tanks', 'FontSize', 20)

% Second figure: Overlay of non-interacting and interacting tank levels
figure(2)
hold on
plot(tnonint, ynonint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(tnonint, ynonint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
plot(tint, yint(:,1), 'Color', 'red', 'LineWidth', 2.2, 'LineStyle','--')
plot(tint, yint(:,2), 'Color', 'blue', 'LineWidth', 2.2, 'LineStyle','--')
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
legend('Tank 1 non interacting', 'Tank 2 non interacting', ...
    'Tank 1 interacting', 'Tank 2 interacting')

%% ODE Functions
% Function for non-interacting tanks
function df = noninteractingtanks(t, y)
    global Fin0 r1 r2 A1 A2
    h1 = y(1);
    h2 = y(2);

    % Inlet flow decreases linearly for first 30 seconds
    if t <= 30
        Fi = Fin0 - ((Fin0/2)/30) * t;
    else
        Fi = Fin0 - ((Fin0/2)/30) * 30;
    end

    % Differential equations for tank levels
    df(1) = (Fi - (h1/r1)) / A1; 
    df(2) = ((h1/r1) - (h2/r2)) / A2; 

    df = df';
end

% Function for interacting tanks
function df = interactingtanks(t, y)
    global Fin0 r1 r2 A1 A2
    h1 = y(1);
    h2 = y(2);

    % Same inlet flow calculation as non-interacting tanks
    if t <= 30
        Fi = Fin0 - ((Fin0/2)/30) * t;
    else
        Fi = Fin0 - ((Fin0/2)/30) * 30;
    end

    % Differential equations accounting for interaction between tanks
    df(1) = (Fi - ((h1-h2)/r1)) / A1; 
    df(2) = (((h1-h2)/r1) - (h2/r2)) / A2; 

    df = df';
end