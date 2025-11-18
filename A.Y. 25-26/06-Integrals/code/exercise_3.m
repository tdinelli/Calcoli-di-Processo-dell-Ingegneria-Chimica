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
% Average Concentration Analysis in a Dynamic System                      %
%                                                                         %
% This script finds the time at which the average concentration equals    %
% a target value for a time-varying concentration profile.                %
%                                                                         %
%-------------------------------------------------------------------------%
clear; close all; clc;

%% Input Parameters
% Time-dependent concentration function [mol/L]
X = @(t) sin(sqrt(t)) .* exp(-2 * t.^2);

% Target average concentration [mol/L]
C_target = 0.3;

% Time range for analysis [hours]
t_range = 0:0.001:2;

%% Find Time When Average Concentration Equals Target
% We need to solve: (1/t) * integral(X(tau), 0, t) = C_target
% This is equivalent to finding the root of: average_X(t) - C_target = 0

fprintf('=== Finding Time for Target Average Concentration ===\n')
options = optimset('Display', 'off');  % Hide iterations for cleaner output

% Use fzero to find when average concentration equals target
[t_solution, fval, exitflag] = fzero(@(t) average_minus_target(t, X, C_target), ...
                                     1, options);

if exitflag == 1
    fprintf('Solution found at t = %.4f hours\n', t_solution)
    fprintf('Average concentration = %.4f mol/L\n', C_target)
    fprintf('Function value at solution = %.2e (should be ≈0)\n\n', fval)
else
    warning('Solution not found!')
end

%% Find Intersection Points
% Find times where instantaneous concentration equals target
fprintf('=== Finding Intersection Points ===\n')
intersections = [];
for i = 2:length(t_range)
    % Check if concentration crosses the target line
    if (X(t_range(i-1)) - C_target) * (X(t_range(i)) - C_target) < 0
        t_intersect = fzero(@(t) X(t) - C_target, t_range(i), options);
        intersections = [intersections, t_intersect];
        fprintf('Intersection %d at t = %.4f hours\n', length(intersections), t_intersect)
    end
end
fprintf('\n')

%% Visualization

% Figure 1: Basic plot showing concentration and target
figure('Position', [100 100 900 400])
plot(t_range, X(t_range), 'b-', 'LineWidth', 2.5)
hold on; grid on; box on;
yline(C_target, 'r--', 'LineWidth', 2, 'Label', 'Target = 0.3 mol/L', ...
      'LabelHorizontalAlignment', 'left', 'FontSize', 12)
plot(t_solution, C_target, 'go', 'MarkerSize', 12, 'LineWidth', 2, ...
     'MarkerFaceColor', 'g')
xlabel('Time [hours]', 'FontSize', 14)
ylabel('Concentration [mol/L]', 'FontSize', 14)
title('Concentration Profile and Target Average', 'FontSize', 16)
legend('X(t)', 'Target Average', sprintf('Solution (t=%.3f h)', t_solution), ...
       'Location', 'best', 'FontSize', 11)

% Figure 2: Detailed analysis with regions
figure('Position', [100 100 1000 500])
hold on; grid on; box on;

% Define regions based on intersections
if length(intersections) >= 2
    regions = [0, intersections, t_solution];
    colors = [0.8 0.9 1; 0.9 0.8 1; 1 0.9 0.8; 0.9 1 0.8];
    
    % Plot shaded regions
    for i = 1:length(regions)-1
        t_region = linspace(regions(i), regions(i+1), 1000);
        x_region = X(t_region);
        fill([t_region, fliplr(t_region)], ...
             [x_region, zeros(size(x_region))], ...
             colors(mod(i-1, 4)+1, :), 'EdgeColor', 'none', ...
             'FaceAlpha', 0.5)
    end
    
    % Plot vertical lines at key points
    for i = 1:length(intersections)
        xline(intersections(i), 'k--', 'LineWidth', 1.5, ...
              'Label', sprintf('Int %d', i), 'FontSize', 10)
    end
    xline(t_solution, 'g-.', 'LineWidth', 2.5, ...
          'Label', 'Solution', 'FontSize', 11)
end

% Plot concentration curve and target line
plot(t_range, X(t_range), 'b-', 'LineWidth', 2.5)
yline(C_target, 'r--', 'LineWidth', 2)

% Mark intersection points
if ~isempty(intersections)
    plot(intersections, C_target * ones(size(intersections)), ...
         'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k')
end

% Mark solution point
plot(t_solution, C_target, 'go', 'MarkerSize', 12, 'LineWidth', 2, ...
     'MarkerFaceColor', 'g')

xlabel('Time [hours]', 'FontSize', 14)
ylabel('Concentration [mol/L]', 'FontSize', 14)
title('Concentration Regions and Average Analysis', 'FontSize', 16)
ylim([min(0, min(X(t_range))*1.1), max(X(t_range))*1.1])

%% Helper Function
function f = average_minus_target(t, X, C_target)
    % Calculate difference between average concentration and target
    %
    % Inputs:
    %   t        - Time point [hours]
    %   X        - Concentration function handle [mol/L]
    %   C_target - Target average concentration [mol/L]
    %
    % Output:
    %   f        - Difference (should equal zero at solution)
    
    if t <= 0
        f = NaN;  % Avoid division by zero
        return
    end
    
    % Calculate average: (1/t) * integral(X, 0, t)
    integral_X = trapezoidal(X, 0, t, 100);
    average_X = integral_X / t;
    
    % Return difference from target
    f = average_X - C_target;
end