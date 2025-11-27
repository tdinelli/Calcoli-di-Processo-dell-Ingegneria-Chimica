%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%          Author: Marco Mehl <marco.mehl@polimi.it>                      %
%                  Timoteo Dinelli <timoteo.dinelli@polimi.it>            %
%          CRECK Modeling Lab <www.creckmodeling.polimi.it>               %
%          Department of Chemistry, Materials and Chemical Engineering    %
%          Politecnico di Milano                                          %
%          P.zza Leonardo da Vinci 32, 20133 Milano                       %
%                                                                         %
% ----------------------------------------------------------------------- %
% FORWARD_EULER - Implements the Forward Euler method for solving ODEs
%
% This function solves an ordinary differential equation (ODE) using the
% explicit Forward Euler method. The Forward Euler method is a first-order
% numerical method that is simple and computationally efficient, but has
% limited stability properties for stiff equations.
%
% Syntax:
%     [t_out, x_out] = forward_euler(f, t_span, x0, h)
%
% Input Arguments:
%     f      - Function handle representing the ODE dx/dt = f(t,x)
%     t_span - 2-element vector [t0, tend] specifying integration interval
%     x0     - Initial value of the dependent variable
%     h      - Time step size for integration
%
% Output Arguments:
%     t_out - Vector of time points where the solution is computed
%     x_out - Vector of solution values corresponding to time points in t_out
%
% Method Description:
%     The Forward Euler method uses the explicit formula:
%     x(n+1) = x(n) + h*f(t(n), x(n))
%     where h is the step size and n is the current step index.
%
function [t_out, x_out] = forward_euler(f, t_span, x0, h)

    % Generate time vector from t0 to tend with step size h
    t_out = t_span(1):h:t_span(2);
    
    % Initialize solution vector (preallocate for efficiency)
    x_out = zeros(size(t_out));
    
    % Set initial condition
    x_out(1) = x0;
    
    % Main integration loop
    for i = 1:length(t_out)-1
        % Apply Forward Euler formula: x(n+1) = x(n) + h*f(t(n), x(n))
        % This is an explicit method - the new value depends only on
        % the current state and does not require solving nonlinear equations
        x_out(i+1) = x_out(i) + h * f(t_out(i), x_out(i));
    end
end