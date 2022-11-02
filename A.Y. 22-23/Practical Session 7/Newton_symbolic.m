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
%                   Symbolic version the derivatives                      %
%                   here are computed a symbolic                          %
%                                                                         %
% ----------------------------------------------------------------------- %

function [solution, error] = Newton_symbolic(x0, f, tol, maxiter)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y0: first guess solution
% f: function to be zeroed
% tol: accepted relative tolerance for the solution
% maxiter: maximum number of iterations allowed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

syms x
y = f(x);
diffy = diff(y);
x0v = zeros(1, maxiter);
x0v(1) = x0;

fprintf("%-s\t\t %-s\t\t %-s\t\t %-s\t\t %-s\t\t \n","Iter","x0", ...
    "f(x0)", "x0+1", "error")
for i = 1:maxiter % here it is implemented the version with for cycle 
                  % however is completely equivalent the version with the
                  % while
    numerator = subs(y, x, x0v(i));
    denominator = subs(diffy, x, x0v(i));
    
    x0v(i+1) = x0v(i) - double(numerator) / double(denominator); 
    error(i) = x0v(i) - x0v(i+1);
    
    fprintf("%-i\t\t %-.3f\t\t %-.3f\t\t %-.3f\t\t %-.3f\n", ...
        i, x0v(i), double(numerator), x0v(i+1), error(i))
    if error(i) <= tol && error(i) >= 0
        fprintf("\nSolution reached!\n");
        break
    end
end
solution = x0v(1,1:i);
error = error(1,1:i);
end