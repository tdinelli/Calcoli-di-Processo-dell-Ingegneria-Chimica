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
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% EULER_BACKWARD - Implements the Backward Euler method for solving ODEs
% 
% This function solves an ordinary differential equation (ODE) using the
% implicit Backward Euler method. The Backward Euler method is an A-stable,
% first-order numerical method particularly suitable for stiff equations.
% 
% Syntax:
%     [t, y] = euler_backward(funz, interval, y0, ninterval)
% 
% Input Arguments:
%     funz      - Function handle representing the ODE dy/dt = f(t,y)
%     interval  - 2-element vector [t0, tend] specifying integration interval
%     y0        - Initial value of the dependent variable
%     ninterval - Number of intervals for discretization
% 
% Output Arguments:
%     t - Vector of time points where the solution is computed
%     y - Vector of solution values corresponding to time points in t
% 
% Method Description:
%     The Backward Euler method uses the implicit formula:
%     y(n+1) = y(n) + h*f(t(n+1), y(n+1))
%     where h is the step size and n is the current step index.
function [t, y] = backward_euler(funz, interval, y0, ninterval)
    % Extract integration limits
    t0 = interval(1);    % Initial time of integration
    tend = interval(2);  % Final time of integration
    
    % Calculate step size
    h = (tend-t0)/ninterval;  % Time step size
    
    % Initialize solution vectors
    t = t0;  % Time vector, starting with initial time
    y = y0;  % Solution vector, starting with initial condition
    
    % Main integration loop
    for i = 1:ninterval
        % Update time vector for next step
        t(i+1) = t(i) + h;
        
        % Define the nonlinear equation to be solved at each step
        % The equation is: y(i+1) - y(i) - h*f(t(i+1), y(i+1)) = 0
        funz_to_0 = @(ypiu1) ypiu1 - (y(i) + h*funz(t(i+1), ypiu1));
        
        % Solve the nonlinear equation using fzero
        % Using y(i) as initial guess for the iterative solver
        y(i+1) = fzero(funz_to_0, y(i));
    end
end