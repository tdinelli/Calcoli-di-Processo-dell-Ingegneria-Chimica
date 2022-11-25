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

clear, close, clc,

%% Lotka-Volterra

global alpha beta gamma delta

alpha = .3;
beta = .15;
gamma = .1;
delta = .1;

[t, y] = ode45(@lotkavolterra, [0 200], [7 3]);

figure(1), hold on
plot(t, y(:,1), 'LineWidth', 2.2, 'LineStyle','--')
plot(t, y(:,2), 'LineWidth', 2.2, 'LineStyle','-.')
title('Lotka-Volterra', 'FontSize', 18)
legend('Predator', 'Prey', 'FontSize', 18)
xlabel('time', 'FontSize', 18)
ylabel('#Predator/Prey', 'FontSize', 18)

%% Lorenz

x0 = -15 + 30 * rand(100, 3);
for i = 1:length(x0)

    [tL, yL] = ode45(@lorentz3D, [0 8], x0(i,:));

    figure(2)
    hold on
    grid on
    plot3(yL(:,1), yL(:,2), yL(:,3))
    scatter3(x0(i,1), x0(i,2), x0(i,3))
end
