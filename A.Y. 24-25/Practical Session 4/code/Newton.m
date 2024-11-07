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
function [solution, error] = Newton(x0, f, tol, maxiter)
    % NEWTON_NUMERICAL Implements the Newton-Raphson method to find
    % function zeros
    %
    % This function implements the Newton-Raphson method to find the root
    % (zero) of a nonlinear function using numerical derivatives. The
    % method uses the iterative
    % formula: x_(n+1) = x_n - f(x_n)/f'(x_n)
    %
    % Inputs:
    %   x0      - Initial guess for the root (scalar)
    %   f       - Function handle to the function whose root we want to find
    %   tol     - Convergence tolerance (relative error between iterations)
    %   maxiter - Maximum number of iterations allowed
    %
    % Outputs:
    %   solution - Vector containing the sequence of approximations to the root
    %   error    - Vector containing the error at each iteration
    %
    % Example:
    %   f = @(x) x^2 - 4;            % Function: x^2 - 4 = 0
    %   [sol, err] = Newton_numerical(1, f, 1e-6, 100);
    %
    % Notes:
    %   - The method may not converge if the initial guess is too far from
    %     the root
    %   - The method may fail if the derivative becomes zero during
    %     iterations
    %   - The error is computed as the difference between successive
    %     iterations

    % Forward difference function definition
    dfdx = @(f,x) (f(x+1e-6) - f(x))/1e-6;

    % Initialize variables
    y = f(x0);                   % Function value at initial guess
    diffy = dfdx(f, x0);         % Derivative at initial guess
    x0v = zeros(1, maxiter);     % Array to store all iterations
    error = zeros(1, maxiter);   % Array to store errors
    x0v(1) = x0;                 % Store initial guess
    error(1) = x0;               % Initialize error array
    iteration_number = 1;

    % Print header for iteration progress
    fprintf("%-s\t\t %-s\t\t %-s\t\t %-s\t\t %-s\t\t \n", ...
        "Iter", "x0", "f(x0)", "x0+1", "error");

    % Main iteration loop
    while abs(error(iteration_number)) > tol && iteration_number < maxiter
        % Compute next approximation using Newton's formula
        x0v(iteration_number+1) = x0v(iteration_number) - y / diffy;
    
        % Compute error as difference between successive iterations
        error(iteration_number+1) = x0v(iteration_number) - ...
            x0v(iteration_number+1);
    
        % Print iteration information
        fprintf("%-i\t\t %-.3f\t\t %-.3f\t\t %-.3f\t\t %-.3f\n", ...
            iteration_number, x0v(iteration_number), y, ...
            x0v(iteration_number+1), error(iteration_number+1));
    
        % Update function value and derivative for next iteration
        y = f(x0v(iteration_number+1));
        diffy = dfdx(f, x0v(iteration_number+1));
    
        % Increment iteration counter
        iteration_number = iteration_number + 1;
    end

    % Trim output arrays to actual number of iterations used
    solution = x0v(1,1:iteration_number);
    error = error(1,1:iteration_number);
end