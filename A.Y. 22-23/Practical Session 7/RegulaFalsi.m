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

function [c, iter] = RegulaFalsi(funz,a,b,eps)

maxIter = 120;
fa = funz(a);
fb = funz(b);
iter = 0;

if sign(fa)*sign(fb)<0
    while abs(b-a)>eps && iter<=maxIter

    c = b - fb / (fb-fa) * (b-a);
    fc=funz(c);
    if sign(fc) * sign(fb) <= 0
        a = c;
        fa = fc;
    else
        b = c;
        fb = fc; 
    end
        iter = iter+1;
    end
    
else
    error('There is no solution in the selected interval!')
end
end


