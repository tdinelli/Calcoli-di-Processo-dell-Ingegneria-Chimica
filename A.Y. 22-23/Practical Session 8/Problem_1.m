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

f = @(x) (1./(x-1))-2;
df = @(x) -(1/((x-1)^2));
line = @(x,m,q) m.*x + q;

x_0 = [0.8 3 1.2];

x_01 = [0.8 0.52 -0.4208 -5.8789];
mx01 = [-25 -4.34028 -0.49538];
qx01 = [-mx01(1)*x_01(2) -mx01(2)*x_01(3) -mx01(3)*x_01(4)];

x_02 = [3 -3 -39 -3279];
mx02 = [-0.25 -0.0625 -0.00063];
qx02 = [-mx02(1)*x_02(2) -mx02(2)*x_02(3) -mx02(3)*x_02(4)];

x_03 = [1.2 1.32 1.43520 1.49160];
mx03 = [-25 -9.7656 -5.27986];
qx03 = [-mx03(1)*x_03(2) -mx03(2)*x_03(3) -mx03(3)*x_03(4)];

x = -2:0.001:5;
x1 = [1 2];
y1 = [20 20]; 
y2 = [-20 -20];

f_x = f(x);

subplot(1,2,1)
hold on
plot([-1 5], [0 0], 'k'); % plot the horizontal line
plot([0 0], [-20 20], 'k'); % plot the vertical line
plot(x, f_x, 'LineWidth', 2.2, 'Color','blue')
scatter(0.8, 0, 100,'red', 'filled', 'o')
scatter(3, 0, 100,'green', 'filled', '^')

plot(x, line(x, mx01(1), qx01(1)), 'LineWidth', 2.2, 'LineStyle','--','Color','red')
plot(x, line(x, mx01(2), qx01(2)), 'LineWidth', 2.2, 'LineStyle','-.','Color','red')
plot(x, line(x, mx01(3), qx01(3)), 'LineWidth', 2.2, 'LineStyle',':','Color','red')

plot(x, line(x, mx02(1), qx02(1)), 'LineWidth', 2.2, 'LineStyle','--','Color','green')
plot(x, line(x, mx02(2), qx02(2)), 'LineWidth', 2.2, 'LineStyle','-.','Color','green')
plot(x, line(x, mx02(3), qx02(3)), 'LineWidth', 2.2, 'LineStyle',':','Color','green')
xlim([-1 5])
ylim([-20 20])

legend('', '', 'f(x)', 'x_{0} = 0.8', 'x_{0} = 3','#it = 1', ...
    '#it = 2', '#it = 3', '#it = 1', '#it = 2', '#it = 3', 'FontSize', 18)
grid on

subplot(1,2,2)
hold on
plot([-1 5], [0 0], 'k'); % plot the horizontal line
plot([0 0], [-20 20], 'k'); % plot the vertical line
plot(x, f_x, 'LineWidth', 2.2, 'Color','blue')
scatter(1.2, 0, 100,'magenta', 'filled', 'o')
plot(x, line(x, mx03(1), qx03(1)), 'LineWidth', 2.2, 'LineStyle','--','Color','magenta')
plot(x, line(x, mx03(2), qx03(2)), 'LineWidth', 2.2, 'LineStyle','-.','Color','magenta')
plot(x, line(x, mx03(3), qx03(3)), 'LineWidth', 2.2, 'LineStyle',':','Color','magenta')
xlim([-1 5])
ylim([-20 20])
% patch([x1 fliplr(x)], [y1 fliplr(y1)], 'g', 'FaceAlpha', 0.5)
harea = area(x1,y1);
harea2 = area(x1,y2);
set(harea, 'FaceColor', 'r')
set(harea2, 'FaceColor', 'r')
alpha(0.25)
legend('', '', 'f(x)', 'x_{0} = 1.2', '#it = 1', ...
    '#it = 2', '#it = 3', 'FontSize', 18)
grid on

