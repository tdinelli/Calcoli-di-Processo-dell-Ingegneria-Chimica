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
global Q m cp Fin
% System parameters
Q = 1e6;       % Heat input rate [W]
Fin = 8;       % Inlet flow rate [kmol/s]
m = 100;       % System mass [kmol]
cp = 2.5e3;    % Specific heat capacity [J/(kmol*K)]
T0 = 300;      % Initial temperature [K]
%% Numerical Solution
% ODE solver with stiff solver (ode15s)
[t15, T15] = ode15s(@temperature_balance, [0 300], T0);
% ODE solver with non-stiff solver (ode45)
[t45, T45] = ode45(@temperature_balance, [0 300], T0);
%% Plotting
hold on
grid on
% Plot results from both ODE solvers
plot(t15, T15, 'LineWidth', 2.2)
plot(t45, T45, 'LineWidth', 2.2)
% Axis labels and legend
xlabel('time [s]', 'FontSize', 18)
ylabel('Temperature [K]', 'FontSize', 18)
legend('Outlet temperature [K] - ode15s',...
    'Outlet temperature [K] - ode45', 'FontSize', 18, ...
    'location', 'southeast')
%% Temperature Balance ODE Function
function dTdt = temperature_balance(t, T)
    % Global variables for system parameters
    global Q m cp Fin
    
    % Inlet temperature: step change at t = 150s
    if t < 150
        Tin = 300;  % Initial inlet temperature [K]
    else
        Tin = 330;  % Inlet temperature after step increase [K]
    end
    
    % Temperature balance differential equation
    % Combines heat input, heat loss, and flow effects
    dTdt = (Q/(m * cp)) - (Fin/m) * (T - Tin);
end