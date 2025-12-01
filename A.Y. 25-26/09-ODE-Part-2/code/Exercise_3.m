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
% Define global variables for use across functions
global Fin0 A r
% System parameters
A = 30;     % Tank cross-sectional area [m²]
Fin0 = 7.5; % Initial inlet flow rate [m³/s]
r = 0.4;    % Hydraulic resistance coefficient [m²/s]
h0 = 3;     % Initial height [m]
%% Numerical Solution
% ODE solver with options for two different scenarios
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
% Solve for step change in inlet flow (instant reduction to half)
[t, h] = ode15s(@odesys_step, [0 100], h0, opts);
% Solve for linear ramp in inlet flow (gradual reduction over 30s)
[t1, h1] = ode15s(@odesys_ramp, [0 100], h0, opts);
%% Plotting
% First figure: Step change in inlet flow
figure(1)
plot(t, h, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Single tank: step change in inlet flow', 'FontSize', 20)
grid on
% Second figure: Linear ramp in inlet flow
figure(2)
% Subplot 1: Tank level dynamics
subplot(2,1,1)
plot(t1, h1, 'LineWidth', 2.2, 'Color', 'red')
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Single tank: height dynamics with linear ramp', 'FontSize', 20)
grid on
% Subplot 2: Inlet flow variation over time
subplot(2,1,2)
% Calculate inlet flow over time
Fin = zeros(size(t1));
for i = 1:length(t1)
    if t1(i) <= 30
        Fin(i) = Fin0 - (Fin0/2/30) * t1(i);
    else
        Fin(i) = Fin0/2;
    end
end
plot(t1, Fin, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Inlet Flow [m³/s]', 'FontSize', 18)
title('Inlet Flow Rate', 'FontSize', 20)
grid on
%% ODE Functions
% Function for step change in inlet flow
function dhdt = odesys_step(t, h)
    global Fin0 A r
    
    % Step change: inlet flow instantly reduced to half
    Fin = Fin0/2;
    
    % Mass balance equation
    dhdt = Fin/A - h/(A*r); 
end
% Function for linear ramp in inlet flow
function dhdt = odesys_ramp(t, h)
    global Fin0 A r 
    
    % Linear ramp: inlet flow decreases linearly for first 30 seconds
    if t <= 30
        Fin = Fin0 - (Fin0/2/30) * t;
    else
        Fin = Fin0/2;
    end
    
    % Mass balance equation
    dhdt = Fin/A - h/(A*r); 
end