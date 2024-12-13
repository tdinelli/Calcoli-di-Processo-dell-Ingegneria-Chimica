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
% Clear workspace and command window
clear all; clc;

%% Constants and Parameters
k = 0.005;          % Thermal conductivity [W/mK]
d = 0.30;           % Depth [m]
T0 = 253;           % Temperature at depth [K]
sigma = 5.67e-8;    % Stefan-Boltzmann constant [W/m²K⁴]
emissivity = 0.89;  % Surface emissivity

% Solar flux values [W/m²]
q_solar_day = 1200;
q_solar_night = 0;

%% Define Energy Balance Function
function F = energy_balance(T, q_solar, k, d, T0, sigma, emissivity)
    % Radiative flux out
    q_rad = emissivity * sigma * T^4;
    
    % Conductive flux out
    q_cond = (T - T0) * k/d;
    
    % Energy balance: q_solar = q_rad + q_cond
    F = q_solar - (q_rad + q_cond);
end

%% Solve for Day Temperature
% Initial guess for daytime temperature
T_guess_day = 350;

% Solve using fzero
T_day = fzero(@(T) energy_balance(T, q_solar_day, k, d, T0, sigma, emissivity), T_guess_day);

%% Solve for Night Temperature
% Initial guess for nighttime temperature
T_guess_night = 100;

% Solve using fzero
T_night = fzero(@(T) energy_balance(T, q_solar_night, k, d, T0, sigma, emissivity), T_guess_night);

%% Display Results
fprintf('Lunar Surface Temperature Results:\n')
fprintf('Daytime Temperature: %.1f K (%.1f °C)\n', T_day, T_day - 273.15)
fprintf('Nighttime Temperature: %.1f K (%.1f °C)\n', T_night, T_night - 273.15)

%% Plot Temperature Profile
T = linspace(T_night, T_day, 100);
q_solar_values = [q_solar_night, q_solar_day];

figure;
hold on;
for i = 1:2
    q_rad = emissivity * sigma * T.^4;
    q_cond = (T - T0) * k/d;
    q_total = q_rad + q_cond - q_solar_values(i);
    plot(T, q_total)
end
grid on
xlabel('Temperature [K]')
ylabel('Net Energy Flux [W/m²]')
title('Energy Balance vs Temperature')
legend('Night', 'Day')
yline(0, 'k--', 'Zero Net Flux')
hold off
