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
%                                                                         %
% Heat Capacity Integration for Power Calculation                         %
%                                                                         %
% This script calculates the power needed to heat a gas from Tmin to Tmax %
% accounting for temperature-dependent heat capacity.                     %
%                                                                         %
%-------------------------------------------------------------------------%
clear; close all; clc;

%% Input Parameters
% Shomate equation coefficients for heat capacity
A = 3.3375e4;
B = 2.5864e4;
C = 9.3280e2;
D = 1.0880e4;
E = 4.2370e2;

% Temperature-dependent heat capacity [J/(kmol·K)]
% Shomate equation form
cp = @(T) A + B * (C ./ T ./ sinh(C ./ T)).^2 + ...
              D * (E ./ T ./ cosh(E ./ T)).^2;

% Operating conditions
T_min = 230 + 273.15;           % Minimum temperature [K] (230°C)
T_max = 480 + 273.15;           % Maximum temperature [K] (480°C)
n_dot = 300 / 3600;             % Molar flow rate [kmol/s] (300 kmol/h)

% Temperature vector for analysis
T_range = T_min:0.1:T_max;      % [K]

%% Method 1: Accurate Integration
% Calculate power using integral of cp(T) over temperature range
fprintf('=== Accurate Method (Integration) ===\n')
tic
integral_cp = trapezoidal(cp, T_min, T_max, 10000);
time_elapsed = toc;

% Power = n_dot * integral(cp dT)
Power_accurate = n_dot * integral_cp;   % [W]

fprintf('Integrated cp:  %.2f J/(kmol·K)\n', integral_cp)
fprintf('Power required: %.3f MW\n', Power_accurate / 1e6)
fprintf('Computation time: %.4f s\n\n', time_elapsed)

%% Method 2: Constant Heat Capacity Approximations
% Compare with simplified methods using constant cp
fprintf('=== Approximate Methods (Constant cp) ===\n')

% At minimum temperature
cp_min = cp(T_min);
P_at_Tmin = n_dot * cp_min * (T_max - T_min);
error_min = abs(P_at_Tmin - Power_accurate) / Power_accurate * 100;
fprintf('Using cp at T_min: %.3f MW (Error: %.1f%%)\n', ...
        P_at_Tmin / 1e6, error_min)

% At maximum temperature
cp_max = cp(T_max);
P_at_Tmax = n_dot * cp_max * (T_max - T_min);
error_max = abs(P_at_Tmax - Power_accurate) / Power_accurate * 100;
fprintf('Using cp at T_max: %.3f MW (Error: %.1f%%)\n', ...
        P_at_Tmax / 1e6, error_max)

% At average temperature
T_avg = (T_min + T_max) / 2;
cp_avg = cp(T_avg);
P_at_Tavg = n_dot * cp_avg * (T_max - T_min);
error_avg = abs(P_at_Tavg - Power_accurate) / Power_accurate * 100;
fprintf('Using cp at T_avg: %.3f MW (Error: %.1f%%)\n', ...
        P_at_Tavg / 1e6, error_avg)

%% Visualization
figure('Position', [100 100 900 600])

% Plot 1: Heat capacity vs temperature
subplot(2, 1, 1)
plot(T_range, cp(T_range), 'b-', 'LineWidth', 2)
hold on
% Mark key temperatures
plot(T_min, cp_min, 'ro', 'MarkerSize', 10, 'LineWidth', 2)
plot(T_max, cp_max, 'go', 'MarkerSize', 10, 'LineWidth', 2)
plot(T_avg, cp_avg, 'mo', 'MarkerSize', 10, 'LineWidth', 2)
grid on; box on;
xlabel('Temperature [K]', 'FontSize', 14)
ylabel('Heat Capacity [J/(kmol·K)]', 'FontSize', 14)
title('Temperature-Dependent Heat Capacity', 'FontSize', 16)
legend('cp(T)', 'T_{min}', 'T_{max}', 'T_{avg}', ...
       'Location', 'best', 'FontSize', 11)

% Plot 2: Cumulative enthalpy change
subplot(2, 1, 2)
% Calculate cumulative integral
H_cumulative = zeros(size(T_range));
for i = 2:length(T_range)
    H_cumulative(i) = H_cumulative(i-1) + ...
                      trapezoidal(cp, T_range(i-1), T_range(i), 10);
end

plot(T_range, H_cumulative / 1e6, 'r-', 'LineWidth', 2)
grid on; box on;
xlabel('Temperature [K]', 'FontSize', 14)
ylabel('Cumulative Enthalpy Change [MJ/kmol]', 'FontSize', 14)
title('Enthalpy Change During Heating', 'FontSize', 16)