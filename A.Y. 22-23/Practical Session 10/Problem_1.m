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

%% Solutions

analitical_solution = @(t) 10 * exp(-t);
t = 0:.001:5;
y = analitical_solution(t);

[tf_50, yf_50] = euler_forward(@reactions, [0 5], 10, 50);
[tb_50, yb_50] = euler_backward(@reactions, [0 5], 10, 50);

[tf_100, yf_100] = euler_forward(@reactions, [0 5], 10, 1000);
[tb_100, yb_100] = euler_backward(@reactions, [0 5], 10, 1000);

[t45, y45] = ode45(@reactions, [0 5], 10);

%% Plots

figure(1)
subplot(3,1,1)
hold on
plot(t, y, 'LineWidth', 2.2)
plot(tf_50, yf_50(1,:), 'LineWidth', 2.2)
plot(tb_50, yb_50(1,:), 'LineWidth', 2.2)
legend('Analytical Solution', 'Euler Forward', 'Euler Backward',...
    'FontSize', 18)

subplot(3,1,2)
hold on
plot(t, y, 'LineWidth', 2.2)
plot(tf_100, yf_100(1,:), 'LineWidth', 2.2)
plot(tb_100, yb_100(1,:), 'LineWidth', 2.2)
legend('Analytical Solution', 'Euler Forward', 'Euler Backward',...
    'FontSize', 18)

subplot(3,1,3)
hold on
plot(t, y, 'LineWidth', 2.2)
plot(t45, y45, 'LineWidth', 2.2)
legend('Analytical Solution', 'ODE-45', 'FontSize', 18)

%% What if?
global k
kval = [1 5 20];
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
    
    title('k = ' + string(kval(i)), 'FontSize', 18)
end
%% Functions

function dydt = reactions(t, y)

    dydt(1) = -y(1);
    dydt = dydt';
end

function dydt = reactions2(t, y)
    global k 
    dydt(1) = - k * y(1);

end