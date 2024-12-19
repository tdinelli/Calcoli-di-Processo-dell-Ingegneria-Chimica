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
global Q m cp Fin

% System parameters
Q = 1e6;       % Heat input rate [W]
Fin = 8;       % Inlet flow rate [kmol/s]
m = 100;       % System mass [kmol]
cp = 2.5*1000; % Specific heat capacity [J/kmolK]
Tin = 300;     % Initial inlet temperature [K]

%% Numerical Solution
% ODE solver with default settings
[t15, T15] = ode15s(@temperature_balance, [0 300], Tin);

% ODE solver with different numerical method
[t45, T45] = ode45(@temperature_balance, [0 300], Tin);

%% Plotting
hold on
grid on
% Plot results from both ODE solvers
plot(t15, T15, 'LineWidth', 2.2)
plot(t45, T45, 'LineWidth', 2.2)

% Axis labels and legend
xlabel('time [s]', 'FontSize', 18)
ylabel('Temperature [K]', 'FontSize', 18)
legend('Outlet temperature [K] -> ode 15s',...
    'Outlet temperature [K] -> ode 45', 'FontSize', 18, ...
    'location', 'northwest')

%% Temperature Balance ODE Function
function dTdt = temperature_balance(t, y)
    % Global variables for system parameters
    global Q m cp Fin
    
    % Current temperature
    T = y(1);
    
    % Inlet temperature change at t = 150s
    if t < 150
        Tin = 300;
    else
        Tin = 330;
    end
    
    % Temperature balance differential equation
    % Combines heat input, heat loss, and flow effects
    dTdt(1) = (Q/(m * cp)) - (Fin/m) * (T-Tin);
end