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
x0 = 1;             % First initial point
x1 = 2;             % Second initial point
eps = 1e-6;         % Tolerance

% Run visualization
[root, iterations] = SecantWithVisualization(f, x0, x1, eps);
fprintf('Root found at x = %.6f after %d iterations\n', root, iterations);

%% Function definition
function [xn, iter] = SecantWithVisualization(funz, x0, x1, eps)
    % SECANTWITHVISUALIZATION Visualize Secant method iterations
    %   [xn, iter] = SecantWithVisualization(funz, x0, x1, eps) finds and
    %   visualizes the root-finding process using the Secant method
    
    % Set up the figure
    figure('Color', 'white', 'Position', [100, 100, 1000, 600]);
    
    % Create dense x values for smooth function plotting
    % Determine plotting range based on initial points
    plot_range = abs(x1 - x0);
    x_plot = linspace(min(x0,x1)-plot_range*0.5, ...
        max(x0,x1)+plot_range*0.5, 1000);
    y_plot = arrayfun(funz, x_plot);
    
    % Initialize parameters
    maxIter = 120;
    iter = 0;
    
    % Initialize points and function values
    xmin1 = x0;
    xn = x1;
    fmin1 = funz(xmin1);
    fn = funz(xn);
    
    % Store history for convergence plot
    history.x = [x0, x1];
    history.y = [fmin1, fn];
    
    while (abs(xn - xmin1) > eps) && (iter <= maxIter)
        % Clear current plots
        clf;
        
        % Main function plot (top subplot)
        subplot(2,1,1);
        hold on;
        grid on;
        
        % Plot the function
        plot(x_plot, y_plot, 'b-', 'LineWidth', 1.5);
        plot(x_plot, zeros(size(x_plot)), 'k--'); % x-axis
        
        % Plot current points
        plot([xmin1, xn], [fmin1, fn], 'ro', 'MarkerSize', 8,...
            'LineWidth', 2);
        
        % Calculate secant line points for plotting
        % Extend the line beyond the points for visualization
        line_extension = (xn - xmin1);
        x_line = [xmin1 - line_extension, xn + line_extension];
        slope = (fn - fmin1)/(xn - xmin1);
        y_line = fmin1 + slope*(x_line - xmin1);
        
        % Plot the secant line
        plot(x_line, y_line, 'r--', 'LineWidth', 1.5);
        
        % Calculate next point
        xplus1 = xn - fn/(fn - fmin1)*(xn - xmin1);
        fplus1 = funz(xplus1);
        
        % Plot the next point
        plot(xplus1, fplus1, 'go', 'MarkerSize', 10,...
            'MarkerFaceColor', 'g');
        
        % Plot vertical line to show intersection
        plot([xplus1 xplus1], [0 fplus1], 'g--', 'LineWidth', 1);
        
        % Add labels and title
        xlabel('x');
        ylabel('f(x)');
        title(sprintf('Secant Method - Iteration %d', iter+1));
        
        % Add legend
        legend('Function', 'Zero Line', 'Current Points', ...
               'Secant Line', 'Next Approximation', 'Intersection', ...
               'Location', 'best');
        
        % Zoomed view (bottom subplot)
        subplot(2,1,2);
        hold on;
        grid on;
        
        % Calculate zoom window
        zoom_width = abs(xn - xmin1)*2;
        zoom_center = (xn + xmin1)/2;
        xlim([zoom_center-zoom_width/2, zoom_center+zoom_width/2]);
        
        % Plot zoomed view
        plot(x_plot, y_plot, 'b-', 'LineWidth', 1.5);
        plot(x_plot, zeros(size(x_plot)), 'k--');
        plot([xmin1, xn], [fmin1, fn], 'ro', 'MarkerSize', 8,...
            'LineWidth', 2);
        plot(x_line, y_line, 'r--', 'LineWidth', 1.5);
        plot(xplus1, fplus1, 'go', 'MarkerSize', 10,...
            'MarkerFaceColor', 'g');
        plot([xplus1 xplus1], [0 fplus1], 'g--', 'LineWidth', 1);
        
        % Add labels
        xlabel('x');
        ylabel('f(x)');
        title('Zoomed View of Current Iteration');
        
        % Add text box with current values
        text_str = sprintf(['Iteration: %d\n' ...
                          'Previous x: %.6f\n' ...
                          'Current x: %.6f\n' ...
                          'Next x: %.6f\n' ...
                          'Current error: %.6f'], ...
                          iter+1, xmin1, xn, xplus1, abs(xn-xmin1));
        annotation('textbox', [0.15, 0.4, 0.2, 0.1], ...
                  'String', text_str, ...
                  'FitBoxToText', 'on', ...
                  'BackgroundColor', 'white', ...
                  'EdgeColor', 'black');
        
        % Update for next iteration
        xmin1 = xn;
        fmin1 = fn;
        xn = xplus1;
        fn = fplus1;
        
        % Store in history
        history.x(end+1) = xplus1;
        history.y(end+1) = fplus1;
        
        iter = iter + 1;
        
        % Pause to show iteration
        pause(0.8);
        
        % Show convergence plot in separate figure
        if iter > 1 && mod(iter, 2) == 0
            figure(2);
            clf;  % Clear the figure
            
            % Plot function value convergence
            subplot(2,1,1);
            semilogy(1:length(history.y), abs(history.y), 'b.-',...
                'LineWidth', 1.5);
            grid on;
            xlabel('Iteration');
            ylabel('|f(x)|');
            title('Convergence of Function Values');
            
            % Plot successive approximations convergence
            subplot(2,1,2);
            differences = abs(diff(history.x));
            semilogy(1:length(differences), differences, 'r.-',...
                'LineWidth', 1.5);
            grid on;
            xlabel('Iteration');
            ylabel('|x_{n+1} - x_n|');
            title('Convergence of Successive Approximations');
        end
    end
end