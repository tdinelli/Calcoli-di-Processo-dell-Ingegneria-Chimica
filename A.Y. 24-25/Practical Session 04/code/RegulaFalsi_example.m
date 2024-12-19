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
% Clear workspace, figures, and command window for a fresh start
clear all  % Removes all variables from workspace
close all  % Closes all figure windows
clc        % Clears command window
f = @(x) x.^2 - 2;  % Find sqrt(2)
a = 0;              % Left endpoint
b = 2;              % Right endpoint
eps = 1e-6;         % Tolerance

% Run visualization
[root, iterations] = RegulaFalsiWithVisualization(f, a, b, eps);
fprintf('Root found at x = %.6f after %d iterations\n', root, iterations);

%% Function definitions
function [c, iter] = RegulaFalsiWithVisualization(funz, a, b, eps)
    % REGULAFALSIWITHVISUALIZATION Visualize Regula Falsi method iterations
    %   [c, iter] = RegulaFalsiWithVisualization(funz, a, b, eps) finds and
    %   visualizes the root-finding process using the Regula Falsi method
    
    % Set up the figure
    figure('Color', 'white', 'Position', [100, 100, 1000, 600]);
    
    % Create dense x values for smooth function plotting
    x_plot = linspace(a-0.1*(b-a), b+0.1*(b-a), 1000);
    y_plot = arrayfun(funz, x_plot);
    
    % Initialize parameters
    maxIter = 120;
    fa = funz(a);
    fb = funz(b);
    iter = 0;
    
    % Check Bolzano's theorem condition
    if sign(fa)*sign(fb) < 0
        while abs(b-a) > eps && iter <= maxIter
            % Clear current plots and create new ones
            clf;
            subplot(2,1,1); % Top plot for full view
            hold on;
            grid on;
            
            % Plot the function
            plot(x_plot, y_plot, 'b-', 'LineWidth', 1.5);
            plot(x_plot, zeros(size(x_plot)), 'k--'); % x-axis
            
            % Plot current interval points
            plot([a,b], [fa,fb], 'ro', 'MarkerSize', 8, 'LineWidth', 2);
            
            % Calculate and plot Regula Falsi line
            c = b - fb*(b-a)/(fb-fa);
            fc = funz(c);
            
            % Plot the secant line
            plot([a,b], [fa,fb], 'r--', 'LineWidth', 1.5);
            
            % Plot the new point
            plot(c, fc, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
            
            % Add labels and title
            xlabel('x');
            ylabel('f(x)');
            title(sprintf('Regula Falsi Method - Iteration %d', iter+1));
            
            % Add legend
            legend('Function', 'Zero Line', 'Interval Endpoints', ...
                   'Secant Line', 'New Approximation', ...
                   'Location', 'best');
            
            % Create zoomed view in bottom subplot
            subplot(2,1,2);
            hold on;
            grid on;
            
            % Calculate zoom window
            zoom_width = abs(b-a)*1.5;
            zoom_center = (a+b)/2;
            xlim([zoom_center-zoom_width/2, zoom_center+zoom_width/2]);
            
            % Plot zoomed view
            plot(x_plot, y_plot, 'b-', 'LineWidth', 1.5);
            plot(x_plot, zeros(size(x_plot)), 'k--');
            plot([a,b], [fa,fb], 'ro', 'MarkerSize', 8, 'LineWidth', 2);
            plot([a,b], [fa,fb], 'r--', 'LineWidth', 1.5);
            plot(c, fc, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
            
            % Add labels
            xlabel('x');
            ylabel('f(x)');
            title('Zoomed View of Current Iteration');
            
            % Add text box with current values
            text_str = sprintf(['Iteration: %d\n' ...
                              'Current approx: %.6f\n' ...
                              'f(c) = %.6f\n' ...
                              'Interval size: %.6f'], ...
                              iter+1, c, fc, abs(b-a));
            annotation('textbox', [0.15, 0.4, 0.2, 0.1], ...
                      'String', text_str, ...
                      'FitBoxToText', 'on', ...
                      'BackgroundColor', 'white', ...
                      'EdgeColor', 'black');
            
            % Update interval
            if sign(fc)*sign(fb) <= 0
                a = c;
                fa = fc;
            else
                b = c;
                fb = fc;
            end
            
            iter = iter + 1;
            
            % Pause to show iteration
            pause(0.5);
        end
        
    else
        error('There is no solution in the selected interval!');
    end
end