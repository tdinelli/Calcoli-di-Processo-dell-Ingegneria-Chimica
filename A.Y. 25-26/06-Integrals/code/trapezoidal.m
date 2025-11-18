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
%                                                                         %
% Numerical Integration using the Trapezoidal Rule                        %
%                                                                         %
% The trapezoidal rule approximates the area under a curve by dividing    %
% it into trapezoids. More intervals = better accuracy.                   %
%                                                                         %
%-------------------------------------------------------------------------%

function integral = trapezoidal(f, a, b, ninterval)
% TRAPEZOIDAL Compute definite integral using trapezoidal rule
%
% Syntax:
%   integral = trapezoidal(f, a, b, ninterval)
%
% Inputs:
%   f         - Function handle to integrate
%   a         - Lower integration limit
%   b         - Upper integration limit
%   ninterval - Number of intervals (more = more accurate)
%
% Output:
%   integral  - Approximate value of the definite integral
%
% Example:
%   f = @(x) x.^2;
%   result = trapezoidal(f, 0, 1, 100);  % Integrates x^2 from 0 to 1
%
% Formula:
%   Integral ≈ h * [f(a)/2 + f(x1) + f(x2) + ... + f(xn-1) + f(b)/2]
%   where h = (b-a)/n is the width of each interval

    % Step 1: Calculate the width of each interval
    h = (b - a) / ninterval;
    
    % Step 2: Start with the endpoints (weighted by 1/2 each)
    integral = (f(a) + f(b)) / 2;
    
    % Step 3: Add contributions from all interior points
    for i = 1:ninterval-1
        x_i = a + i * h;              % Calculate position of interior point
        integral = integral + f(x_i); % Add full weight for interior points
    end
    
    % Step 4: Multiply by interval width to get final result
    integral = integral * h;
    
end