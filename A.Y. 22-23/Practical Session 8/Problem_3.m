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

x = 0:.0001:1;
A1 = @(x) x;
A2 = @(x) 0.837 .* ((x/4).^(1/2) + 0.5).^(1/3);
A3 = @(x) 4 .* (sqrt((30 * x.^6)./(10.36)) - 0.5).^2;

%% Starting Plots

figure(1)
subplot(1,2,1)
hold on
plot(x, A1(x), 'LineStyle','--','Color','black','LineWidth',2.5)
plot(x, A2(x), 'LineStyle','-.','Color','black','LineWidth',2.5)
xlabel('X', 'FontSize', 18)
ylabel('Y', 'FontSize', 18)
legend('y = D', 'y = f(D)', 'FontSize', 18)

subplot(1,2,2)
hold on
plot(x, A1(x), 'LineStyle','--','Color','black','LineWidth',2.5)
plot(x, A3(x), 'LineStyle','-.','Color','black','LineWidth',2.5)
xlabel('X', 'FontSize', 18)
ylabel('Y', 'FontSize', 18)
legend('y = D', 'y = f(D)', 'FontSize', 18)

%% Solve

options = optimset('Display','iter'); % show iterations
[sol, fval, exitFlag] = fzero(@bernoulli, 1.7, options);
%% Function Definition

function f = bernoulli(x)

right = (10.37.*(sqrt(x/4) + 0.5).^2) / (x.^6);
left = 30;

f = left - right;
end
