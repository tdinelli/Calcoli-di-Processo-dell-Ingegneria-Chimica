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
clear all, close all, clc;

%% Part 1: Basic Comparison of Methods
% Define the analytical solution for the ODE dy/dt = -y
analitical_solution = @(t) 10 * exp(-t);

% Create fine time grid for analytical solution
t = 0:.001:5;
y = analitical_solution(t);

% Solve using Forward and Backward Euler with 50 intervals
[tf_50, yf_50] = euler_forward(@reactions, [0 5], 10, 50);
[tb_50, yb_50] = euler_backward(@reactions, [0 5], 10, 50);

% Solve using Forward and Backward Euler with 1000 intervals
[tf_100, yf_100] = euler_forward(@reactions, [0 5], 10, 1000);
[tb_100, yb_100] = euler_backward(@reactions, [0 5], 10, 1000);

% Solve using MATLAB's ODE45 (adaptive Runge-Kutta)
[t45, y45] = ode45(@reactions, [0 5], 10);

%% Part 2: Plotting Results
figure(1)

% Plot comparison with 50 intervals
subplot(3,1,1)
hold on
plot(t, y, 'LineWidth', 2.2)
plot(tf_50, yf_50(1,:), 'LineWidth', 2.2)
plot(tb_50, yb_50(1,:), 'LineWidth', 2.2)
legend('Analytical Solution', 'Euler Forward', 'Euler Backward',...
    'FontSize', 18)
title('Comparison with 50 intervals')

% Plot comparison with 1000 intervals
subplot(3,1,2)
hold on
plot(t, y, 'LineWidth', 2.2)
plot(tf_100, yf_100(1,:), 'LineWidth', 2.2)
plot(tb_100, yb_100(1,:), 'LineWidth', 2.2)
legend('Analytical Solution', 'Euler Forward', 'Euler Backward',...
    'FontSize', 18)
title('Comparison with 1000 intervals')

% Plot comparison with ODE45
subplot(3,1,3)
hold on
plot(t, y, 'LineWidth', 2.2)
plot(t45, y45, 'LineWidth', 2.2)
legend('Analytical Solution', 'ODE-45', 'FontSize', 18)
title('Comparison with ODE45')

%% Part 3: Stiffness Analysis
% Investigate the effect of different reaction rates (stiffness)
global k
kval = [1 5 20];  % Different rate constants

% Loop through different k values
for i=1:length(kval)
    k = kval(i);
    [tf_1, yf_1] = euler_forward(@reactions2, [0 5], 10, 50);
    [tb_1, yb_1] = euler_backward(@reactions2, [0 5], 10, 50);
    
    figure(2)
    subplot(3,1,i)
    hold on
    plot(t, y, 'LineWidth', 2.2)
    plot(tf_1, yf_1(1,:), 'LineWidth', 2.2)
    plot(tb_1, yb_1(1,:), 'LineWidth', 2.2)
    legend('Analytical', 'Forward Euler', 'Backward Euler')
    title('k = ' + string(kval(i)), 'FontSize', 18)
end

%% Functions
function dydt = reactions(t, y)
    % Basic first-order decay: dy/dt = -y
    dydt(1) = -y(1);
    dydt = dydt';
end

function dydt = reactions2(t, y)
    % Parameterized first-order decay: dy/dt = -k*y
    global k 
    dydt(1) = -k * y(1);
end