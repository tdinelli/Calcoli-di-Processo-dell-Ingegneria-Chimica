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
function [xn, iter] = Secant(funz, x0, x1, eps)
    % SECANT Find root of a function using the Secant Method
    %   [xn, iter] = Secant(funz, x0, x1, eps) finds a root of the function 
    %   using the Secant method starting from initial points x0 and x1
    %
    % Inputs:
    %   funz - Function handle of the target function
    %   x0   - First initial point
    %   x1   - Second initial point
    %   eps  - Convergence tolerance (for |x_{n+1} - x_n|)
    %
    % Outputs:
    %   xn   - Approximate root of the function
    %   iter - Number of iterations performed
    %
    % Example:
    %   f = @(x) x^2 - 2;                  % Find sqrt(2)
    %   [root, iters] = Secant(f, 1, 2, 1e-6)
    %
    % The Secant method is similar to Newton's method but approximates the
    % derivative using two points instead of requiring an analytical
    % derivative.
    % Formula: x_{n+1} = x_n - f(x_n) * (x_n - x_{n-1})/(f(x_n) - f(x_{n-1}))
    
    % Set maximum number of iterations to prevent infinite loops
    maxIter = 120;
    
    % Initialize iteration counter
    iter = 0;
    
    % Initialize points and function values
    % x_{n-1} is the previous point
    % x_n is the current point
    xmin1 = x0;         % x_{n-1} (previous point)
    xn = x1;            % x_n (current point)
    
    % Calculate function values at initial points
    fmin1 = funz(xmin1);    % f(x_{n-1})
    fn = funz(xn);          % f(x_n)
    
    % Main iteration loop
    % Continue until either:
    % 1. Consecutive points are within tolerance
    % 2. Maximum iterations reached
    while (abs(xn - xmin1) > eps) && (iter <= maxIter)
        % Calculate next approximation using Secant formula
        % x_{n+1} = x_n - f(x_n) * (x_n - x_{n-1})/(f(x_n) - f(x_{n-1}))
        xplus1 = xn - fn/(fn - fmin1)*(xn - xmin1);
        
        % Update points and function values for next iteration
        % Move current point to previous point
        xmin1 = xn;
        fmin1 = fn;
        
        % Move next point to current point
        xn = xplus1;
        fn = funz(xn);
        
        % Increment iteration counter
        iter = iter + 1;
    end
    
    % Check for convergence
    if iter > maxIter
        warning(['Maximum number of iterations (%d) reached. ', ...
                'Solution may not have achieved desired accuracy.'], maxIter)
    end
end