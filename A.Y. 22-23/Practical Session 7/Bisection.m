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

function [c, iter] = Bisection(funz, a, b, eps)

maxIter = 120;  % max number of iterations
iter = 0.;      % initialize n iteration

fa = funz(a);   % calculate the function at the extremes of the interval
fb = funz(b);

if sign(fa)*sign(fb)<0 % test on the boundaries to check applicability 
                       % of the method (Bolzano's Hypothesys)
    
    while (b-a)>eps && iter<=maxIter   % we set 2 conditions: 
                                       % convergence and number of 
                                       % iteration to avoid infinite loops
        
        c = a+(b-a)/2;  % calculation of the midpoint in the interval using
                        % the more robust formulation
        % c=(a+b)/2;    % This is the less robust formulation
        
        fc=funz(c);       %value of the function in the mid point
        
        if sign(fc) * sign(fb)<0 % test on the sign 
            a = c;
        else
            b = c;
            fb = fc; % since the test it's done of fb and fc we update 
                     % fb too for the next iteration 
        end
        iter = iter+1; % the counter is incremented at each iteration
    end

    %%%%%%%%%%%%%%% This block manages the output %%%%%%%%%%%%%%%%%%%%
    if iter > maxIter
        disp('The maximum number of iteration is reached !')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    error('There is no solution in the selected interval!') 
    % if the Bolzano's Hypothesys is not verified return a error message
end
end