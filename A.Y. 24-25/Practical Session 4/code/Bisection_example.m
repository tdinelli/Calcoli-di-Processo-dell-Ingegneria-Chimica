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
[root, iterations] = BisectionWithVisualization(f, a, b, eps);
fprintf('Root found at x = %.6f after %d iterations\n', root, iterations);

%% Function definition
function [c, iter] = BisectionWithVisualization(funz, a, b, eps)
    % BISECTIONWITHVISUALIZATION Visualize Bisection method iterations
    %   [c, iter] = BisectionWithVisualization(funz, a, b, eps) finds and
    %   visualizes the root-finding process using the Bisection method
    %
    % Inputs:
    %   funz - Function handle
    %   a, b - Interval endpoints
    %   eps  - Tolerance for convergence
    
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
    
    % Store history for convergence plot
    history.x = [];
    history.y = [];
    
    % Check Bolzano's theorem condition
    if sign(fa)*sign(fb) < 0
        while abs(b-a) > eps && iter <= maxIter
            % Clear current plots
            clf;
            
            % Main function plot (top subplot)
            subplot(2,1,1);
            hold on;
            grid on;
            
            % Plot the function
            plot(x_plot, y_plot, 'b-', 'LineWidth', 1.5);
            plot(x_plot, zeros(size(x_plot)), 'k--'); % x-axis
            
            % Plot current interval points
            plot([a,b], [fa,fb], 'ro', 'MarkerSize', 8, 'LineWidth', 2);
            
            % Calculate and plot midpoint
            c = a + (b-a)/2;  % Numerically stable midpoint formula
            fc = funz(c);
            
            % Add point to history
            history.x(end+1) = c;
            history.y(end+1) = fc;
            
            % Plot the midpoint
            plot(c, fc, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
            
            % Plot vertical line to show bisection
            plot([c c], [min(y_plot) max(y_plot)], 'g--', 'LineWidth', 1);
            
            % Add labels and title
            xlabel('x');
            ylabel('f(x)');
            title(sprintf('Bisection Method - Iteration %d', iter+1));
            
            % Add legend
            legend('Function', 'Zero Line', 'Interval Endpoints', ...
                   'Midpoint', 'Bisection Line', ...
                   'Location', 'best');
            
            % Zoomed view (bottom subplot)
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
            plot(c, fc, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
            plot([c c], [min(y_plot) max(y_plot)], 'g--', 'LineWidth', 1);
            
            % Add labels
            xlabel('x');
            ylabel('f(x)');
            title('Zoomed View of Current Iteration');
            
            % Add text box with current values and interval information
            text_str = sprintf(['Iteration: %d\n' ...
                              'Current interval: [%.6f, %.6f]\n' ...
                              'Midpoint: %.6f\n' ...
                              'f(midpoint) = %.6f\n' ...
                              'Interval size: %.6f'], ...
                              iter+1, a, b, c, fc, abs(b-a));
            annotation('textbox', [0.15, 0.4, 0.2, 0.1], ...
                      'String', text_str, ...
                      'FitBoxToText', 'on', ...
                      'BackgroundColor', 'white', ...
                      'EdgeColor', 'black');
            
            % Update interval based on sign check
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
            
            % Optional: Add convergence subplot
            if iter > 1 && mod(iter, 5) == 0  % Show convergence every 5 iterations
                figure(2);
                semilogy(1:iter, abs(history.y), 'b.-', 'LineWidth', 1.5);
                grid on;
                xlabel('Iteration');
                ylabel('|f(x)|');
                title('Convergence Progress');
            end
        end
        
    else
        error('There is no solution in the selected interval!');
    end
end