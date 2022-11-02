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
%                   Numerical version: the derivatives                    %
%                   here are computed numerically                         %
%                                                                         %
% ----------------------------------------------------------------------- %

function [solution, error] = Newton_numerical(x0, f, dfdx, tol, maxiter)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y0: first guess solution
% f: function to be zeroed
% tol: accepted relative tolerance for the solution
% maxiter: maximum number of iterations allowed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = f(x0);
diffy = dfdx(f, x0);

x0v = zeros(1, maxiter);
error = zeros(1,maxiter);
x0v(1) = x0;
error(1) = x0;

iteration_number = 1;

fprintf("%-s\t\t %-s\t\t %-s\t\t %-s\t\t %-s\t\t \n","Iter","x0", ...
    "f(x0)", "x0+1", "error")
while abs(error(iteration_number)) > tol && iteration_number < maxiter

    x0v(iteration_number+1) = x0v(iteration_number) - y / diffy; 
    error(iteration_number+1) = x0v(iteration_number) - x0v(iteration_number+1);
    
    fprintf("%-i\t\t %-.3f\t\t %-.3f\t\t %-.3f\t\t %-.3f\n", ...
        iteration_number, x0v(iteration_number), y,...
        x0v(iteration_number+1), error(iteration_number+1))

    y = f(x0v(iteration_number+1));
    diffy = dfdx(f, x0v(iteration_number+1));
    iteration_number = iteration_number + 1;
end

solution = x0v(1,1:iteration_number);
error = error(1,1:iteration_number);

end