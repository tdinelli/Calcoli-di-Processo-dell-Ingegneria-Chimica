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
%                                                                         %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
%% Line Plotting Between Two Points
% This script demonstrates how to:
% 1. Calculate the equation of a line passing through two points
% 2. Plot the line with a specified range
% 3. Visualize the points using scatter plot
%
% The line equation is y = mx + q, where:
% - m is the slope
% - q is the y-intercept

% Clear workspace and prepare for fresh plotting
clear all   % Remove all variables from workspace
close all   % Close all figure windows
clc         % Clear command window

%% Define Points
% Define two points in 2D space: P1(x1,y1) and P2(x2,y2)
P1 = [4 -3];    % Point 1: (4, -3)
P2 = [5 1];     % Point 2: (5, 1)

%% Calculate Line Equation
% Calculate slope (m) using the point-slope formula: m = (y2-y1)/(x2-x1)
m = (P2(2) - P1(2)) / (P2(1) - P1(1));

% Calculate y-intercept (q) using point-slope form: y1 = mx1 + q
% Rearranging to solve for q: q = y1 - mx1
q = P1(2) - m * P1(1);

%% Generate Points for Line Plot
% Create x-coordinates with small steps for smooth line
% Range is extended slightly beyond the points for better visualization
x = 3.5:0.001:5.5;  % x values from 3.5 to 5.5 with 0.001 step size

% Calculate corresponding y-coordinates using y = mx + q
% Pre-allocate array for better performance
y = zeros(size(x));
for i = 1:length(x)
    y(i) = m*x(i) + q;
end

% Note: This loop could be vectorized in MATLAB:
% y = m*x + q;

%% Create Visualization
% Create new figure and hold on to add multiple plots
figure;
hold on

% Plot the line
plot(x, y, ...
    'LineWidth', 2.2, ...     % Set line thickness
    'Color', 'red')           % Set line color

% Plot the points using scatter
scatter(P1(1), P1(2), 200, 'filled', 'o')  % Plot Point 1
scatter(P2(1), P2(2), 200, 'filled', 'o')  % Plot Point 2

% Enhance plot appearance
grid on                       % Add grid lines
xlabel('x')                   % Add x-axis label
ylabel('y')                   % Add y-axis label
title('Line Through Two Points')  % Add title

% Add legend
legend('Line', 'Point 1', 'Point 2', 'Location', 'best')

% Optional: Add text labels for points
text(P1(1)-0.2, P1(2)-0.5, sprintf('P1(%.1f, %.1f)', P1(1), P1(2)))
text(P2(1)-0.2, P2(2)+0.5, sprintf('P2(%.1f, %.1f)', P2(1), P2(2)))

% Add text showing line equation
equation = sprintf('y = %.2fx + %.2f', m, q);
text(4, 2, equation, 'FontSize', 12)

% Adjust axis for better visualization
axis([3.5 5.5 -4 2])         % Set axis limits
set(gca, 'FontSize', 12)     % Set font size
box on                       % Add box around plot

% Display line parameters in command window
fprintf('Line equation: y = %.2fx + %.2f\n', m, q)
fprintf('Slope (m): %.2f\n', m)
fprintf('Y-intercept (q): %.2f\n', q)
