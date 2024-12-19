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
function [c, iter] = Bisection(funz, a, b, eps)
    % BISECTION Find the root of a continuous function using the bisection
    % method
    %   [c, iter] = Bisection(funz, a, b, eps) finds a root of the function 
    %   'funz' in the interval [a,b] within tolerance 'eps'
    %
    % Inputs:
    %   funz - Function handle of the continuous function
    %   a    - Left endpoint of the interval
    %   b    - Right endpoint of the interval
    %   eps  - Desired tolerance for the solution
    %
    % Outputs:
    %   c    - Approximate root of the function
    %   iter - Number of iterations performed
    %
    % Example:
    %   f = @(x) x^2 - 2;            % Find sqrt(2)
    %   [root, iterations] = Bisection(f, 1, 2, 1e-6)
    %
    % The bisection method is based on the Intermediate Value Theorem:
    % If a continuous function has values of opposite signs at the
    % endpoints of an interval, then it must have at least one root within
    % that interval.
    
    % Set maximum number of iterations to prevent infinite loops
    maxIter = 120;
    
    % Initialize iteration counter
    iter = 0;
    
    % Calculate function values at interval endpoints
    fa = funz(a);
    fb = funz(b);
    
    % Check Bolzano's theorem (Intermediate Value Theorem) condition
    if sign(fa) * sign(fb) < 0
        % Main iteration loop
        % Continue until either:
        % 1. Interval width is less than tolerance (convergence)
        % 2. Maximum iterations reached (prevent infinite loop)
        while (b - a) > eps && iter <= maxIter
            % Calculate midpoint using numerically stable formula
            % We use a + (b-a)/2 instead of (a+b)/2 to avoid potential
            % overflow for large values of a and b
            c = a + (b-a)/2;
            
            % Calculate function value at midpoint
            fc = funz(c);
            
            % Update interval based on where the root lies
            % If sign(fc) * sign(fb) < 0, root is in [c,b]
            % Otherwise, root is in [a,c]
            if sign(fc) * sign(fb) < 0
                a = c;         % Move left endpoint to midpoint
            else
                b = c;         % Move right endpoint to midpoint
                fb = fc;       % Update fb for next iteration's sign check
            end
            
            % Increment iteration counter
            iter = iter + 1;
        end
        
        % Check if method failed to converge within maxIter
        if iter > maxIter
            disp('Warning: Maximum number of iterations reached!')
            disp('The solution may not have achieved desired accuracy.')
        end
        
    else
        % If Bolzano's condition is not met, throw error
        error(['Bisection method cannot be applied: ', ...
               'Function must have opposite signs at interval endpoints.'])
    end
end