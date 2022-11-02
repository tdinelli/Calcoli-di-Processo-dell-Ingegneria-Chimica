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

[sol_num_1, err_num_1] = Newton_numerical(1.7, @function_1,...
                                                @forward_diff,1e-8, 50);

[sol_num_2, err_num_2] = Newton_numerical(1.7, @function_2,...
                                                @forward_diff,1e-8, 50);

[sol_num_3, err_num_3] = Newton_numerical(1.7, @function_3,...
                                                @forward_diff,1e-8, 50);

[sol_sym_1, err_sym_1] = Newton_symbolic(1.7, @function_1, 1e-8, 50);

[sol_sym_2, err_sym_2] = Newton_symbolic(1.7, @function_2, 1e-8, 50);

[sol_sym_3, err_sym_3] = Newton_symbolic(1.7, @function_3, 1e-8, 50);

%% Errors

fprintf("Evaluation of the error!")
disp(sol_num_1(end)-sol_sym_1(end))
disp(sol_num_2(end)-sol_sym_2(end))
disp(sol_num_3(end)-sol_sym_3(end))

%% Plots

x = 0:0.01:1;
x1 = -3:0.01:3;

figure(1)
hold on
plot(x, function_1(x),'LineWidth', 2, 'Color', 'green')
plot([0 1], [0 0], 'k--'); % plot the horizontal line
scatter(sol_num_1(end), function_1(sol_num_1(end)), 140, ...
    'MarkerFaceColor','red')
scatter(sol_sym_1(end), function_1(sol_sym_1(end)), 140, ...
    'MarkerFaceColor','blue')
legend('Function', '','Newton numerical derivative',...
    'Newton analytical derivative', 'fzero solution', 'FontSize', 18)

figure(2)
hold on
plot(x, function_2(x),'LineWidth', 2, 'Color', 'green')
scatter(sol_num_2(end), function_2(sol_num_2(end)), 140, ...
    'MarkerFaceColor','red')
scatter(sol_sym_2(end), function_2(sol_sym_2(end)), 140, ...
    'MarkerFaceColor','blue')
legend('Function', 'Newton numerical derivative',...
    'Newton analytical derivative', 'fzero solution', 'FontSize', 18)

figure(3)
hold on
plot(x1, function_3(x1),'LineWidth', 2, 'Color', 'green')
plot([-3 3], [0 0], 'k--'); % plot the horizontal line
scatter(sol_num_3(end), function_3(sol_num_3(end)), 140, ...
    'MarkerFaceColor','red')
scatter(sol_sym_3(end), function_3(sol_sym_3(end)), 140, ...
    'MarkerFaceColor','blue')
legend('Function', '', 'Newton numerical derivative',...
    'Newton analytical derivative', 'fzero solution', 'FontSize', 18)
%% Functions definition
function y = function_1(x)
    y = 3 * exp(x) - 4 * cos(x);
end

function y = function_2(x)
    y = 25 * x.^2 - 10 * x + 1;
end

function y = function_3(x)
    y = x.^3 - x + 3;
end