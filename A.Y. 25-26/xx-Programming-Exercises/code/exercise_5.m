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
%% Mathematical Function Plotting
% This script demonstrates how to plot a mathematical function by:
% 1. Generating a sequence of x values
% 2. Computing corresponding y values using a custom function
% 3. Creating a professional-looking plot with customized appearance
%
% The function being plotted is: f(x) = sin(x)/(2 + x^4)

% Clear workspace and prepare for fresh plotting
clear all   % Remove all variables from workspace
close all   % Close all figure windows
clc         % Clear command window

%% Generate Input Values
% Create a vector of x values from -1 to 1 with steps of 0.1
% The colon operator (:) creates sequences: start:step:end
v = -1:0.1:1;

%% Calculate Function Values
% Pre-allocate arrays for better performance
x = zeros(size(v));  % Array for x coordinates
y = zeros(size(v));  % Array for y coordinates

% Calculate function values for each point
for i = 1:length(v)
    x(i) = v(i);               % Store x coordinate
    y(i) = plotting(v(i));     % Calculate and store y coordinate
end

% Note: This loop could be vectorized in MATLAB:
% x = v;
% y = plotting(v);

%% Create Plot
% Plot the function with customized appearance
figure;     % Create new figure window
plot(x, y, ...                 % Plot x vs y data
     'LineWidth', 2.2, ...     % Set line thickness
     'Color', 'blue')          % Set line color

% Add labels and title
xlabel('x');                   % x-axis label
ylabel('f(x) = sin(x)/(2+x^4)'); % y-axis label
title('Plot of f(x) = sin(x)/(2+x^4)'); % Plot title
grid on;                       % Add grid lines

% Optional: Enhance plot appearance
set(gca, 'FontSize', 12);     % Set axis font size
axis tight;                   % Adjust axis limits to data

%% Function Definition
function f = plotting(x)
    % PLOTTING Compute the value of sin(x)/(2 + x^4)
    %   f = plotting(x) returns the value of the function sin(x)/(2 + x^4)
    %   for the input x
    %
    % Input:
    %   x - Scalar or array of numbers
    %
    % Output:
    %   f - Function value(s) for the given input(s)
    %
    % Example:
    %   y = plotting(0)     % Returns value at x = 0
    %   y = plotting([0 1]) % Returns values for x = 0 and x = 1
    %
    % Note:
    %   - Function is vectorized and works with both scalar and array inputs
    %   - Domain includes all real numbers
    %   - Denominator is always ≥ 2, so no division by zero is possible
    
    % Calculate function value
    f = sin(x) ./ (2 + x.^4);    % Use element-wise operations (./ and .^)
end
