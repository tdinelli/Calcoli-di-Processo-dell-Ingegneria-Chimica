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
% Numerical Integration by means of                                       %
% trapezoidal rule                                                        %
%                                                                         %
%-------------------------------------------------------------------------%

function integral = trapezoidal(f,a,b,ninterval)
% Computes definite integral using trapezoidal rule
%
% Inputs:
%   f         - Function handle to integrate
%   a         - Lower integration limit
%   b         - Upper integration limit 
%   ninterval - Number of intervals for discretization
%
% Output:
%   integral  - Approximate value of definite integral
%
% The trapezoidal rule approximates the area under curve by dividing it into
% trapezoids. Accuracy increases with number of intervals.

    % Calculate width of each interval
    h = (b-a)/ninterval;
    
    % Initialize sum with endpoint contributions (weighted by 1/2)
    integral = (f(a)+f(b))/2;
    
    % Add contribution from internal points
    for i = 1:ninterval-1
        integral = integral+f(a+i*h);
    end
    
    % Multiply by interval width to get final result
    integral = integral * h;
end