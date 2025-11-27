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
% HEUN_ADAPTIVE - Implements Heun's method (RK2) with adaptive step size
%
% This function solves an ordinary differential equation (ODE) using the
% Heun method (also known as the explicit trapezoid rule or improved Euler
% method), which is a second-order Runge-Kutta method. The implementation
% includes adaptive step size control based on local truncation error
% estimation, providing efficient and accurate solutions.
%
% Syntax:
%     [t_out, x_out, h_history] = heun_adaptive(f, t_span, x0, h_init, tol)
%
% Input Arguments:
%     f       - Function handle representing the ODE dx/dt = f(t,x)
%     t_span  - 2-element vector [t0, tend] specifying integration interval
%     x0      - Initial value of the dependent variable
%     h_init  - Initial time step size
%     tol     - Error tolerance for adaptive step size control
%
% Output Arguments:
%     t_out     - Vector of time points where the solution is computed
%     x_out     - Vector of solution values corresponding to time points
%     h_history - Vector containing the step sizes used at each accepted step
%
% Method Description:
%     Heun's method is a predictor-corrector method with the formula:
%         k1 = f(t(n), x(n))                    (predictor slope)
%         x_pred = x(n) + h*k1                  (predicted value)
%         k2 = f(t(n) + h, x_pred)              (corrector slope)
%         x(n+1) = x(n) + h*(k1 + k2)/2         (corrected value)
%
%     Adaptive Step Size Control:
%         The local truncation error is estimated by comparing solutions
%         obtained with one full step (h) versus two half steps (h/2).
%         The step size is adjusted based on this error estimate:
%         - If error < tol: accept step, possibly increase h
%         - If error >= tol: reject step, decrease h
%
function [t_out, x_out, h_history] = heun_adaptive(f, t_span, x0, h_init, tol)

    % Initialize output arrays with initial conditions
    t_out = t_span(1);       % Time vector starts at t0
    x_out = x0;              % Solution vector starts at x0
    h_history = [];          % History of accepted step sizes
    
    % Initialize working variables
    t = t_span(1);           % Current time
    x = x0;                  % Current solution value
    h = h_init;              % Current step size
    
    % Main integration loop - continue until reaching final time
    while t < t_span(2)
        
        % Adjust step size to avoid overshooting the final time
        if t + h > t_span(2)
            h = t_span(2) - t;
        end
        
        % ================================================================
        % STEP 1: Compute solution with one full step of size h
        % ================================================================
        
        % Heun predictor step
        k1 = f(t, x);                    % Slope at beginning of interval
        x_pred = x + h * k1;             % Predicted value using Euler step
        
        % Heun corrector step
        k2 = f(t + h, x_pred);           % Slope at end of interval
        x_new_full = x + h * (k1 + k2) / 2;  % Average of slopes (trapezoid rule)
        
        % ================================================================
        % STEP 2: Compute solution with two half steps of size h/2
        % This provides a more accurate estimate for error calculation
        % ================================================================
        
        h_half = h / 2;                  % Half step size
        
        % First half step: from t to t + h/2
        k1_half = f(t, x);               % Slope at t
        x_half = x + h_half * k1_half;   % Predictor at t + h/2
        k2_half = f(t + h_half, x_half); % Slope at t + h/2
        x_mid = x + h_half * (k1_half + k2_half) / 2;  % Corrector at t + h/2
        
        % Second half step: from t + h/2 to t + h
        k1_half2 = f(t + h_half, x_mid);           % Slope at t + h/2
        x_pred2 = x_mid + h_half * k1_half2;       % Predictor at t + h
        k2_half2 = f(t + h, x_pred2);              % Slope at t + h
        x_new_half = x_mid + h_half * (k1_half2 + k2_half2) / 2;  % Corrector at t + h
        
        % ================================================================
        % STEP 3: Estimate local truncation error and adjust step size
        % ================================================================
        
        % Local truncation error estimate (difference between solutions)
        % The two-half-steps solution is O(h^3) accurate, while the full
        % step is O(h^2) accurate, so their difference estimates the error
        error = abs(x_new_half - x_new_full);
        
        % Decide whether to accept or reject the step based on tolerance
        if error < tol
            % Accept the step - error is within tolerance
            % Use the more accurate two-half-steps result
            t = t + h;
            x = x_new_half;
            
            % Store accepted values
            t_out = [t_out; t];
            x_out = [x_out; x];
            h_history = [h_history; h];
            
            % Increase step size if error is much smaller than tolerance
            % This improves efficiency without sacrificing accuracy
            if error < tol / 10
                h = h * 1.5;         % Increase step size by 50%
            end
        else
            % Reject the step - error exceeds tolerance
            % Reduce step size and retry (step will not be stored)
            h = h * 0.5;             % Decrease step size by 50%
        end
        
        % ================================================================
        % STEP 4: Safety check for minimum step size
        % ================================================================
        
        % If step size becomes too small, the integration may be stalling
        % due to numerical issues or extreme stiffness
        if h < 1e-10
            warning('Step size too small, stopping integration');
            break;
        end
    end
    
end