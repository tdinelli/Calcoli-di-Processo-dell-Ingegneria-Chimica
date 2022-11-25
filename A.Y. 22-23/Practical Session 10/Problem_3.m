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

clc, clear, close all;

%% Data

%
% Given the first order irreversible reaction A->B 
%   1. Compute the time needed to reach the 90 % of conversion of A
%   2. Now compute the time nedeed to reach 99.9 % of conversion of A
%

k = 0.01; % s^-1
CA0 = 2; % mol/l

%% Analitical solution

X_analitical_function = @(t) 1-exp(-k*t);
t_analitical = 1:1:1000;
for i=1:1000
    X_analitical(i) = X_analitical_function(i);
end
%% Soluzion numerica

X_numerical_function = @(t,x) k*(1-x);

[t45, y45] = ode45(X_numerical_function, [0,1000], 0);
%% Plots

figure(1)
subplot(2,2,[1 2])
hold on
ax = gca;
ax.FontSize = 15;
title('Analitical Solution VS Numerical Solution')
xlabel('time [s]')
ylabel('Conversion \chi [-]')
plot(t_analitical, X_analitical, 'LineWidth', 3, 'color', 'g')
plot(t45, y45, 'LineStyle', '--','LineWidth', 3, 'Color', 'r')
legend({'Analitical Solution','Numerical Solution'},'Location','northeast')

subplot(2,2,3)
hold on
ax = gca;
ax.FontSize = 15;
title('Analitical Solution')
xlabel('time [s]')
ylabel('Conversion \chi [-]')
plot(t_analitical, X_analitical,'LineWidth', 3, 'color', 'g')

subplot(2,2,4)
hold on
ax = gca;
ax.FontSize = 15;
title('Numerical Solution')
xlabel('time [s]')
ylabel('Conversion \chi [-]')
plot(t45, y45, 'LineStyle', '--','LineWidth', 3, 'Color', 'r')
