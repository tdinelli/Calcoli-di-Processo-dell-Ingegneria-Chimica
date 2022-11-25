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

function fdot = lotkavolterra(t, y)
    global alpha beta gamma delta

    % Here are reported two different ways of writing the ODE-system of 
    % equations
    
    % eq1 = alpha * y(1) - beta * y(2) * y(1);
    % eq2 = delta * y(1) * y(2) - gamma * y(2);

    % fdot = [eq1; eq2];

    fdot(1) = alpha * y(1) - beta * y(2) * y(1);
    fdot(2) = delta * y(1) * y(2) - gamma * y(2);

    fdot = fdot';
end