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

clear, close, clc;
%% Solution

[t, y] = ode45(@reactions, [0 5], [10 0 0]);

%% Plot

figure(1)
hold on
plot(t, y(:,1), 'LineWidth', 2.2)
plot(t, y(:,2), 'LineWidth', 2.2)
plot(t, y(:,3), 'LineWidth', 2.2)
legend('CA', 'CB', 'CC', 'FontSize', 18)

%% Functions

function dydt = reactions(t, y)

    dydt(1) = -y(1);
    dydt(2) = y(1) - y(2);
    dydt(3) = y(2);
    dydt = dydt';

end