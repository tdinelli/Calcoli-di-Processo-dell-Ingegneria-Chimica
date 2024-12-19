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
clear all
close all
clc
%% Data
mu = 0.030;      % Pa s
gammma = 8445;   % m3
Y = 30;          % m
L = 4000;        % m
D = 0.25;        % m
V_dot_prime = 1; % m3/s
m_kutter = 0.5;  % m^0.5

%% Visualization
x_v = 0:.0001:1;
A1 = @(x) x; % y1
A2 = @(x) 0.837*((x/4).^(1/2) + 0.5).^(1/3);    % y2
A3 = @(x) 4*(sqrt((30 * x.^6)/10.36) - 0.5).^2; % y3

figure(1)
subplot(1,2,1)
hold on
plot(x_v, A1(x_v), 'LineStyle','--','Color','black','LineWidth',2.5)
plot(x_v, A2(x_v), 'LineStyle','-.','Color','black','LineWidth',2.5)
xlabel('X', 'FontSize', 18)
ylabel('Y', 'FontSize', 18)
legend('y = D', 'y = f(D)', 'FontSize', 18)

subplot(1,2,2)
hold on
plot(x_v, A1(x_v), 'LineStyle','--','Color','black','LineWidth',2.5)
plot(x_v, A3(x_v), 'LineStyle','-.','Color','black','LineWidth',2.5)
xlabel('X', 'FontSize', 18)
ylabel('Y', 'FontSize', 18)
legend('y = D', 'y = f(D)', 'FontSize', 18)

%% Solve using try and error method
firstguess = 10; % First guess solution
epsi = 1.e-5;    % Tolerance
max_iter = 150;  % Avoid infinite number of loops
iter_number = 1; % Iteration counter
D_sol = A2(firstguess);
error = abs(firstguess - D_sol);
while abs(firstguess - D_sol) > epsi && iter_number < max_iter 
    D_old = firstguess;
    firstguess = D_sol;
    D_sol = A2(firstguess);
    
    D_computed(iter_number) = D_sol; % Save results into an additional variable
    vector_FG(iter_number) = firstguess; % Save results into an additional variable
    computed_error(iter_number) = abs(firstguess - D_sol); % Save results into an additional variable

    iter_vector(iter_number) = iter_number; % Save results into an additional variable
    iter_number = iter_number + 1; % Increment iteration counter each cycle
end

%% Solve using fzero
options = optimset('Display','iter'); % show iterations
[sol, fval, exitFlag] = fzero(@bernoulli, 1.7, options);

%% Function Definition

function f = bernoulli(D)
    right = (10.37.*(sqrt(D/4) + 0.5).^2) / (D.^6);
    left = 30;
    f = left - right;
end