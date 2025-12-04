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
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Exercise 3: Rally Race - Overtaking Analysis
% This script analyzes the motion of two rally cars with different velocity 
% profiles to determine:
% 1. When the first overtaking occurs (when one car passes the other)
% 2. Which car is in the lead 1 hour after the first overtaking
%
% Both cars start side by side from rest at t=0
clear, close, clc

%% Define Velocity Functions
% Declare global variables for use in helper functions
global velocityA velocityB

% Define the velocity functions for cars A and B (in meters per minute)
velocityA = @(t) 2*sqrt(t) + cos(t + pi/2);  % Car A: v = 2√t + cos(t + π/2) = 2√t - sin(t)
velocityB = @(t) sin(t) + 0.5*t;             % Car B: v = sin(t) + 0.5t

% Define position functions (integral of velocity from 0 to t)
positionA = @(t) integral(velocityA, 0, t);
positionB = @(t) integral(velocityB, 0, t);

fprintf('======================================================\n');
fprintf('Exercise 3: Rally Race Overtaking Analysis\n');
fprintf('======================================================\n\n');

%% Find First Overtaking Point
% The first overtaking occurs when the distance difference changes sign
% (after both cars have started moving and one catches up to the other)

% First, find when positions are equal (excluding t=0)
% We need to find the first crossing after t=0
initialGuess = 2;  % Start searching after t=0
timeFirstCrossing = fzero(@findPositionDifference, initialGuess);

fprintf('Question 1: At what time does the first overtaking occur?\n');
fprintf('First overtaking occurs at t = %.4f minutes\n', timeFirstCrossing);

% Calculate positions at overtaking
posA_overtaking = positionA(timeFirstCrossing);
posB_overtaking = positionB(timeFirstCrossing);

fprintf('At this time, both cars are at position: %.2f meters\n', posA_overtaking);

% Determine which car is overtaking (by checking velocities)
velA_overtaking = velocityA(timeFirstCrossing);
velB_overtaking = velocityB(timeFirstCrossing);

if velA_overtaking > velB_overtaking
    fprintf('Car A is overtaking Car B (faster at the crossing point)\n\n');
else
    fprintf('Car B is overtaking Car A (faster at the crossing point)\n\n');
end

%% Calculate Positions After 1 Hour from First Overtaking
% Question 2: After 1 hour from the first overtaking, which car is in the lead?

timeAfterOvertaking = 60;  % 1 hour = 60 minutes
timeFinal = timeFirstCrossing + timeAfterOvertaking;

% Calculate final positions
posA_final = positionA(timeFinal);
posB_final = positionB(timeFinal);

% Calculate distances traveled in the 1-hour interval
distanceA_interval = posA_final - posA_overtaking;
distanceB_interval = posB_final - posB_overtaking;

fprintf('Question 2: After 1 hour from first overtaking, which car is in the lead?\n');
fprintf('Time of analysis: t = %.4f minutes\n', timeFinal);
fprintf('\nPositions at t = %.4f minutes:\n', timeFinal);
fprintf('Car A position: %.2f meters\n', posA_final);
fprintf('Car B position: %.2f meters\n', posB_final);
fprintf('\nDistances traveled in the 1-hour interval:\n');
fprintf('Car A traveled: %.2f meters\n', distanceA_interval);
fprintf('Car B traveled: %.2f meters\n', distanceB_interval);
fprintf('\nResult: ');

if posA_final > posB_final
    fprintf('Car A is in the lead by %.2f meters\n', posA_final - posB_final);
else
    fprintf('Car B is in the lead by %.2f meters\n', posB_final - posA_final);
end

fprintf('\n======================================================\n');

%% Visualize Results
% Create detailed time vector for plotting
timeRange = 0:0.01:timeFinal;

% Calculate velocities
velocityA_values = arrayfun(velocityA, timeRange);
velocityB_values = arrayfun(velocityB, timeRange);

% Calculate positions
positionA_values = arrayfun(positionA, timeRange);
positionB_values = arrayfun(positionB, timeRange);

%% Figure 1: Velocity Profiles
figure('Name', 'Velocity Profiles', 'NumberTitle', 'off')
hold on
plot(timeRange, velocityA_values, 'b-', 'LineWidth', 2)
plot(timeRange, velocityB_values, 'r-', 'LineWidth', 2)

% Mark overtaking point
plot(timeFirstCrossing, velocityA(timeFirstCrossing), 'ko', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'g', 'LineWidth', 2)
xline(timeFirstCrossing, 'g--', 'LineWidth', 1.5, 'Alpha', 0.5)

% Mark 1-hour after overtaking
xline(timeFinal, 'm--', 'LineWidth', 1.5, 'Alpha', 0.5)

xlabel('Time [min]', 'FontSize', 12)
ylabel('Velocity [m/min]', 'FontSize', 12)
title('Velocity Profiles of Cars A and B', 'FontSize', 14)
legend('Car A', 'Car B', 'First Overtaking', 'Location', 'best')
grid on
hold off

%% Figure 2: Position vs Time
figure('Name', 'Position Profiles', 'NumberTitle', 'off')
hold on
plot(timeRange, positionA_values, 'b-', 'LineWidth', 2)
plot(timeRange, positionB_values, 'r-', 'LineWidth', 2)

% Mark overtaking point
plot(timeFirstCrossing, posA_overtaking, 'ko', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'g', 'LineWidth', 2)
xline(timeFirstCrossing, 'g--', 'LineWidth', 1.5, 'Alpha', 0.5)

% Mark final positions
plot(timeFinal, posA_final, 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'LineWidth', 2)
plot(timeFinal, posB_final, 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'LineWidth', 2)
xline(timeFinal, 'm--', 'LineWidth', 1.5, 'Alpha', 0.5)

xlabel('Time [min]', 'FontSize', 12)
ylabel('Position [m]', 'FontSize', 12)
title('Position vs Time for Cars A and B', 'FontSize', 14)
legend('Car A', 'Car B', 'First Overtaking', 'Location', 'best')
grid on
hold off

% Add text annotations
text(timeFirstCrossing + 1, posA_overtaking, sprintf('Overtaking\nt = %.2f min', timeFirstCrossing), ...
     'FontSize', 9, 'Color', 'g')
text(timeFinal + 1, max(posA_final, posB_final), sprintf('t = %.2f min', timeFinal), ...
     'FontSize', 9, 'Color', 'm')

%% Figure 3: Position Difference
figure('Name', 'Position Difference', 'NumberTitle', 'off')
positionDiff = positionA_values - positionB_values;

plot(timeRange, positionDiff, 'k-', 'LineWidth', 2)
hold on
yline(0, 'k--', 'LineWidth', 1)

% Mark overtaking point
plot(timeFirstCrossing, 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'LineWidth', 2)
xline(timeFirstCrossing, 'g--', 'LineWidth', 1.5, 'Alpha', 0.5)
xline(timeFinal, 'm--', 'LineWidth', 1.5, 'Alpha', 0.5)

% Mark final difference
plot(timeFinal, posA_final - posB_final, 'ms', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'm', 'LineWidth', 2)

xlabel('Time [min]', 'FontSize', 12)
ylabel('Position Difference (A - B) [m]', 'FontSize', 12)
title('Position Difference Between Cars', 'FontSize', 14)
legend('Position Difference', 'Equal Positions', 'First Overtaking', 'Location', 'best')
grid on
hold off

% Add shading to show who's ahead
idx_A_ahead = positionDiff > 0;
idx_B_ahead = positionDiff < 0;

%% Functions
function positionDiff = findPositionDifference(t)
    % findPositionDifference - Calculates the difference in position 
    % between cars A and B at time t
    %
    % Parameters:
    %   t - Time point at which to evaluate the position difference [min]
    %
    % Returns:
    %   positionDiff - Difference in position (A - B) [m]
    %
    % Note: When positionDiff = 0, the cars are at the same position 
    global velocityA velocityB
    
    % Calculate positions by integrating velocity from 0 to t
    positionA = integral(velocityA, 0, t);
    positionB = integral(velocityB, 0, t);
    
    % Calculate difference in positions
    positionDiff = positionA - positionB;
end