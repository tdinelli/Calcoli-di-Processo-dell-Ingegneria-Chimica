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
f = @(x) x.^2 - 4;           % Example function: x^2 - 4
visualize_newton(f);

function visualize_newton(f)
    % Define the function and its derivative

    dfdx = @(f,x) (f(x+1e-6) - f(x))/1e-6;  % Numerical derivative
    
    % Parameters for Newton method
    x0 = 3;              % Initial guess
    tol = 1e-6;         % Tolerance
    maxiter = 120;       % Maximum iterations
    
    % Create figure with appropriate size
    figure('Position', [100, 100, 1000, 600]);
    
    % Generate points for plotting the function
    x = linspace(-1, 4, 1000);
    y = f(x);
    
    % Start Newton iteration
    x_current = x0;
    iterations = {};
    
    for i = 1:maxiter
        % Current point
        y_current = f(x_current);
        
        % Calculate derivative at current point
        derivative = dfdx(f, x_current);
        
        % Calculate next x using Newton's method
        x_next = x_current - y_current/derivative;
        
        % Store iteration data for animation
        iterations{i}.x_current = x_current;
        iterations{i}.y_current = y_current;
        iterations{i}.x_next = x_next;
        
        % Check for convergence
        if abs(x_next - x_current) < tol
            break;
        end
        
        x_current = x_next;
    end
    
    % Create animation
    for iter = 1:length(iterations)
        % Clear current plot
        clf;
        
        % Plot the function
        plot(x, y, 'b-', 'LineWidth', 2);
        hold on;
        plot(x, zeros(size(x)), 'k--');  % x-axis
        
        % Plot current point
        plot(iterations{iter}.x_current, iterations{iter}.y_current, 'ro', ...
            'MarkerSize', 10, 'MarkerFaceColor', 'r');
        
        % Plot tangent line
        x_tangent = iterations{iter}.x_current;
        y_tangent = iterations{iter}.y_current;
        derivative = dfdx(f, x_tangent);
        
        % Calculate points for tangent line
        x_line = [x_tangent-1, x_tangent+1];
        y_line = y_tangent + derivative * (x_line - x_tangent);
        plot(x_line, y_line, 'g-', 'LineWidth', 1.5);
        
        % Plot intersection with x-axis
        plot([iterations{iter}.x_next, iterations{iter}.x_next], ...
            [0, f(iterations{iter}.x_next)], 'r--');
        plot(iterations{iter}.x_next, 0, 'ko', ...
            'MarkerSize', 10, 'MarkerFaceColor', 'k');
        
        % Add title and labels
        title(sprintf('Newton Method Iteration %d', iter), 'FontSize', 14);
        xlabel('x', 'FontSize', 12);
        ylabel('f(x)', 'FontSize', 12);
        grid on;
        
        % Add legend
        legend('f(x) = x^2 - 4', 'x-axis', 'Current point', ...
            'Tangent line', 'Next iteration', ...
            'Location', 'best');
        
        % Set axis limits
        axis([-1 4 -5 10]);
        
        % Add iteration information
        text(0.02, 0.98, sprintf('x_%d = %.4f\nf(x_%d) = %.4f\nx_%d = %.4f', ...
            iter-1, iterations{iter}.x_current, ...
            iter-1, iterations{iter}.y_current, ...
            iter, iterations{iter}.x_next), ...
            'Units', 'normalized', ...
            'VerticalAlignment', 'top', ...
            'FontSize', 10);
        
        % Pause to create animation effect
        pause(1);
    end
    
    % Final message
    text(0.02, 0.85, sprintf('Method converged in %d iterations',...
        length(iterations)), ...
        'Units', 'normalized', ...
        'VerticalAlignment', 'top', ...
        'Color', 'green', ...
        'FontSize', 12);
end