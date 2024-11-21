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

options = optimset('Display','iter'); % Show optimization iterations

%% Data
global X
% Define concentration function X(t) [mol/l]
X = @(t) sin(sqrt(t)) .* exp(-2 .* t.^2);

C_X = 0.3;                 % Target concentration [mol/l]
t_range = 0:0.001:2;       % Time range [hours]

% Find time when average concentration equals target
[sol1, fval1, exit1] = fzero(@tank_dynamics, 1, options);
disp(['The solution of the problem is at t = ', num2str(sol1), ' hours'])

%% Plots
% Plot 1: Concentration vs time with target line
figure(1)
plot(t_range, X(t_range), 'LineWidth', 2.2);
yline(0.3,'LineWidth', 2.2, 'Color', 'red');
xlabel('time [hours]', 'FontSize', 18)
ylabel('X concentration [mol/l]', 'FontSize', 18)

% Plot 2: Concentration vs time with areas and intersections
figure(2)
hold on
plot(t_range, X(t_range), 'LineWidth', 2.2);
yline(0.3,'LineWidth', 2.2, 'Color', 'red', 'LineStyle','--');
xline(0.096, 'LineWidth', 2.2)             % First intersection
xline(0.664, 'LineWidth', 2.2)             % Second intersection
xline(1.0311, 'LineWidth', 2.2, 'Color', 'green', 'LineStyle','-.')

% Fill areas under curve for different regions
n1 = 0:0.00001:0.096;
x1 = X(n1);
area(n1,x1)

n2 = 0.096:0.00001:0.664;
x2 = X(n2);
area(n2,x2)

n3 = 0.664:0.00001:1.0311;
x3 = X(n3);
area(n3,x3)

n4 = 1.0311:0.00001:t_range(end);
x4 = X(n4);
area(n4,x4)

xlabel('time [hours]', 'FontSize', 18)
ylabel('X concentration [mol/l]', 'FontSize', 18)

%% Functions
function f = tank_dynamics(t)
% Calculate difference between average and target concentration
global X
   integral = trapezoidal(X, 0, t,20);
   f = (integral/t) - 0.3;     % Average concentration minus target
end