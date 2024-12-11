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
% This script analyzes the motion of two cars with different velocity 
% profiles to determine when one car overtakes the other and calculates 
% their subsequent distances traveled.
%
% The script performs the following operations:
% 1. Defines velocity functions for both cars
% 2. Finds the first overtaking point
% 3. Calculates distances traveled after overtaking
% 4. Visualizes the velocity profiles
clear all  % Clear all variables from workspace
close all  % Close all figure windows
clc        % Clear command window

%% Define Velocity Functions
% Declare global variables for use in helper functions
global velocityA velocityB

% Define the velocity functions for cars A and B (in meters per minute)
velocityA = @(t) 2*sqrt(t) + cos(t + pi/2);  % Car A: Combination of square root and cosine functions
velocityB = @(t) sin(t) + 0.5*t;             % Car B: Combination of sine and linear functions

%% Calculate Overtaking Point
% Find the time when cars A and B have traveled the same distance
% using numerical root-finding (fzero)
initialGuess = 1;  % Initial guess for root-finding algorithm (in minutes)
timeOvertaking = fzero(@findOvertakingPoint, initialGuess);

% Display overtaking time
fprintf('Cars overtake each other at t = %.2f minutes\n', timeOvertaking);

%% Calculate Post-Overtaking Distances
% Compute distances traveled by each car in the 60 minutes following overtaking
timeInterval = 60;  % Analysis interval in minutes

% Calculate distances using numerical integration
distanceA = integral(velocityA, timeOvertaking, timeOvertaking + timeInterval);
distanceB = integral(velocityB, timeOvertaking, timeOvertaking + timeInterval);

% Display results
fprintf('In the %d minutes after overtaking:\n', timeInterval);
fprintf('Car A travels: %.2f meters\n', distanceA);
fprintf('Car B travels: %.2f meters\n', distanceB);

%% Visualize Velocity Profiles
% Create time vector for plotting
timeRange = 0:0.1:10;  % Time points from 0 to 10 minutes, sampled every 0.1 minutes

% Calculate velocity values
velocityA_values = velocityA(timeRange);
velocityB_values = velocityB(timeRange);

% Create figure and plot velocities
hold on
plot(timeRange, velocityA_values, 'b-', 'LineWidth', 2)
plot(timeRange, velocityB_values, 'r--', 'LineWidth', 2)

% Add plot annotations
xlabel('Time [min]', 'FontSize', 12)
ylabel('Velocity [m/min]', 'FontSize', 12)
title('Velocity Profiles of Cars A and B', 'FontSize', 14)
legend('Car A', 'Car B', 'Location', 'best')
grid on

%% Functions
function distanceDifference = findOvertakingPoint(t)
    % findOvertakingPoint - Calculates the difference in distance traveled 
    % between cars
    % Parameters:
    %   t - Time point at which to evaluate the distance difference
    %
    % Returns:
    %   distanceDifference - Difference in distance traveled between cars 
    %                        A and B
    %
    % Note: When distanceDifference = 0, the cars have traveled the same distance
    
    global velocityA velocityB
    
    % Calculate distances traveled by each car using numerical integration
    distanceA = integral(velocityA, 0, t);
    distanceB = integral(velocityB, 0, t);
    
    % Calculate difference in distances
    distanceDifference = distanceA - distanceB;
end