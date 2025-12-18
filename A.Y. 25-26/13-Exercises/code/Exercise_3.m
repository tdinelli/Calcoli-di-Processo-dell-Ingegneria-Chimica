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
% Solve system of differential equations from t=0 to t=4 with step size 0.1
[t,y] = ode45(@SysDiff, [0:.1:4], [1 0 0]);

% Plot results (all variables vs time)
plot(t,y)

% Analysis of results
Cc_end = y(end,3);            % Final value of third variable
Cc = y(:,3);                  % All values of third variable
Conc_Cmedia = trapz(t,Cc)/4;  % Average concentration over time period

% System of differential equations
function dydt = SysDiff(t,y)
    % First equation: dy₁/dt = -y₁
    dydt(1,1) = -y(1);
    
    % Second equation: dy₂/dt = 2y₁ - 2y₂
    dydt(2,1) = 2*y(1) - 2*y(2);
    
    % Third equation: dy₃/dt = 2y₂ - y₃
    dydt(3,1) = 2*y(2) - y(3);
end