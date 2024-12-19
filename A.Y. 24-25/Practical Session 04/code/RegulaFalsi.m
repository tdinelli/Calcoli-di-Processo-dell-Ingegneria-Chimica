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
function [c, iter] = RegulaFalsi(funz, a, b, eps)
    % REGULAFALSI Find root of a function using the Regula Falsi (False
    % Position) method
    %   [c, iter] = RegulaFalsi(funz, a, b, eps) finds a root of the function 
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
    %   [root, iterations] = RegulaFalsi(f, 1, 2, 1e-6)
    %
    % The Regula Falsi method combines:
    % 1. The bracketing property of the bisection method (guaranteed
    %    convergence)
    % 2. The rapid convergence of the secant method
    % It uses linear interpolation between interval endpoints to estimate
    % the root
    
    % Set maximum number of iterations to prevent infinite loops
    maxIter = 120;
    
    % Calculate function values at interval endpoints
    fa = funz(a);
    fb = funz(b);
    
    % Initialize iteration counter
    iter = 0;
    
    % Check Bolzano's theorem condition (opposite signs at endpoints)
    if sign(fa) * sign(fb) < 0
        % Main iteration loop
        % Continue until either:
        % 1. Interval width is less than tolerance (convergence)
        % 2. Maximum iterations reached (prevent infinite loop)
        while abs(b-a) > eps && iter <= maxIter
            % Calculate next approximation using Regula Falsi formula
            % This is a weighted average of the endpoints, where the
            % weights are based on the function values (linear
            % interpolation)
            c = b - fb * (b-a) / (fb-fa);
            
            % Calculate function value at new approximation
            fc = funz(c);
            
            % Update interval based on where the root lies
            % If sign(fc) * sign(fb) <= 0, root is in [c,b]
            % Otherwise, root is in [a,c]
            if sign(fc) * sign(fb) <= 0
                % Root is in [c,b]
                a = c;    % Move left endpoint to new approximation
                fa = fc;  % Update function value at left endpoint
            else
                % Root is in [a,c]
                b = c;    % Move right endpoint to new approximation
                fb = fc;  % Update function value at right endpoint
            end
            
            % Increment iteration counter
            iter = iter + 1;
        end
        
        % Check if method failed to converge within maxIter
        if iter > maxIter
            warning(['Maximum number of iterations (%d) reached. ', ...
                    'Solution may not have achieved desired accuracy.'], maxIter)
        end
        
    else
        % If Bolzano's condition is not met, throw error
        error(['Regula Falsi method cannot be applied: ', ...
               'Function must have opposite signs at interval endpoints.'])
    end
end