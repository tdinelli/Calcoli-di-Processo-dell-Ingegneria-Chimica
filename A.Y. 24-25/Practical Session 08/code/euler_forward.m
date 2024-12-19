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
% EULER_FORWARD - Implements the Forward Euler method for solving ODEs
% 
% This function solves an ordinary differential equation (ODE) using the
% explicit Forward Euler method. The Forward Euler method is the simplest
% numerical integration method for ODEs, using a first-order approximation
% of the derivative.
% 
% Syntax:
%     [t, y] = euler_forward(funz, range, y0, nint)
% 
% Input Arguments:
%     funz  - Function handle representing the ODE dy/dt = f(t,y)
%     range - 2-element vector [t0, tend] specifying integration interval
%     y0    - Initial value of the dependent variable
%     nint  - Number of intervals for discretization
% 
% Output Arguments:
%     t - Vector of time points where the solution is computed
%     y - Vector of solution values corresponding to time points in t
% 
% Method Description:
%     The Forward Euler method uses the explicit formula:
%     y(n+1) = y(n) + h*f(t(n), y(n))
%     where h is the step size and n is the current step index.
% 
% Note:
%     This method is explicit (meaning it directly computes the next value)
%     but has limited stability. It works well for non-stiff equations with
%     small step sizes but may become unstable for stiff equations or
%     large step sizes.
function [t, y] = euler_forward(funz, range, y0, nint)
    % Calculate the step size using the difference between interval
    % endpoints. diff(range) is equivalent to range(2) - range(1)
    h = diff(range)/nint;  % Time step size
    
    % Initialize solution vectors
    t(1) = range(1);  % First time point is the start of the interval
    y(1) = y0;        % First solution value is the initial condition
    
    % Main integration loop
    for i = 1:nint
        % Update time vector by adding step size to previous time
        t(1+i) = t(i) + h;
        
        % Compute next solution value using Forward Euler formula:
        % y(i+1) = y(i) + h * f(t(i), y(i))
        % where funz(t(i), y(i)) evaluates the derivative at current point
        y(1+i) = y(i) + funz(t(i), y(i))*h;
    end 
end