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
% trapezoidal aitken-rule                                                 %
%                                                                         %
%-------------------------------------------------------------------------%
function integral8=trapezoidal_Ait(f,a,b,n)
% Calculates integral using trapezoidal rule with Aitken extrapolation
%
% Inputs:
%   f - Function handle to integrate 
%   a - Lower integration limit
%   b - Upper integration limit
%   n - Initial number of intervals (adjusted to multiple of 8)
%
% Output:
%   integral8 - Improved integral approximation using Aitken extrapolation
%               on three trapezoidal approximations with n, 2n, 4n intervals

   % Ensure n is multiple of 8 for proper interval division
   if mod(n,8) ~= 0
       n = (floor(n/8)+1)*8;
       disp(['n must be a multiple of 8, it has been increased to ' num2str(n)])
   end
   
   h = (b-a)/n;  % Base interval width
   
   % Initialize three integral approximations with endpoint contributions
   integral2 = (f(a)+f(b))/2;  % For n/4 intervals
   integral4 = integral2;       % For n/2 intervals  
   integral8 = integral2;       % For n intervals
   
   % Calculate internal points contribution
   for i=1:n-1
       funct = f(a+i*h);
       
       % Add point to appropriate integral approximations based on index
       if round(i/4) == i/4     % Every 4th point for integral2
           integral2 = integral2+funct;
       end
       if floor(i/2) == i/2     % Every 2nd point for integral4 
           integral4 = integral4 + funct;
       end
       integral8 = integral8 + funct;  % All points for integral8
   end
   
   % Scale approximations by appropriate interval widths
   integral2 = integral2 * h * 4;  % Using n/4 intervals
   integral4 = integral4 * h * 2;  % Using n/2 intervals
   integral8 = integral8 * h;      % Using n intervals
   
   % Apply Aitken extrapolation to improve accuracy
   integral8 = integral8 - ((integral8-integral4)^2)/(integral8+integral2-2*integral4);
end