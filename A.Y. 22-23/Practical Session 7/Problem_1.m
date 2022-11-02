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

options = optimset('Display','iter'); % show iterations

%% Newton method
fprintf("\nSolution with newton method of function 1\n")
[sol_newton_1, err_newton_1] = Newton_symbolic(1.7, @function_1, 1e-8, 50);

fprintf("\nSolution with newton method of function 2\n")
[sol_newton_2, err_newton_2] = Newton_symbolic(1.7, @function_2, 1e-8, 50);

fprintf("\nSolution with newton method of function 3\n")
[sol_newton_3, err_newton_3] = Newton_symbolic(1.7, @function_3, 1e-8, 50);

%% Fzero method
fprintf("\nSolution with fzero method of function 1\n")
[sol_fzero_1, fval_zero_1, exitFlag_zero_1] = fzero(@function_1, 1.8, options);
disp(['Solution with "fzero"  x = ',num2str(sol_fzero_1)...
    ,' f(x) = ',num2str(fval_zero_1)]);
disp(['ExitFlag of fzero: ',num2str(exitFlag_zero_1)]);

fprintf("\nSolution with fzero method of function 2\n")
[sol_fzero_2, fval_zero_2, exitFlag_zero_2] = fzero(@function_2, 1.7);
disp(['Solution with "fzero"  x = ',num2str(sol_fzero_2)...
    ,' f(x) = ',num2str(fval_zero_2)]);
disp(['ExitFlag of fzero: ',num2str(exitFlag_zero_2)]);

fprintf("\nSolution with fzero method of function 3\n")
[sol_fzero_3, fval_zero_3, exitFlag_zero_3] = fzero(@function_3, 1.7);
disp(['Solution with "fzero"  x = ',num2str(sol_fzero_3)...
    ,' f(x) = ',num2str(fval_zero_3)]);
disp(['ExitFlag of fzero: ',num2str(exitFlag_zero_3)]);

%% Fsolve method
fprintf("\nSolution with fsolve method of function 1\n")
[sol_fsolve_1, fval_solve_1, exitFlag_solve_1] = fsolve(@function_1, 1.8, options);
disp(['Solution with "fsolve"  x = ',num2str(sol_fsolve_1)...
    ,' f(x) = ',num2str(fval_solve_1)]);
disp(['ExitFlag of fsolve: ',num2str(exitFlag_solve_1)]);

fprintf("\nSolution with fsolve method of function 2\n")
[sol_fsolve_2, fval_solve_2, exitFlag_solve_2] = fsolve(@function_2, 1.7, options);
disp(['Solution with "fsolve"  x = ',num2str(sol_fsolve_2)...
    ,' f(x) = ',num2str(fval_solve_2)]);
disp(['ExitFlag of fsolve: ',num2str(exitFlag_solve_2)]);

fprintf("\nSolution with fsolve method of function 3\n")
[sol_fsolve_3, fval_solve_3, exitFlag_solve_3] = fsolve(@function_3, 1.7, options);
disp(['Solution with "fsolve"  x = ',num2str(sol_fsolve_3)...
    ,' f(x) = ',num2str(fval_solve_3)]);
disp(['ExitFlag of fsolve: ',num2str(exitFlag_solve_3)]);

%% Plotting results
x = 0:0.01:1;
x1 = -3:0.01:3;
figure(1)
hold on
plot(x, function_1(x),'LineWidth', 2, 'Color', 'green')
plot([0 1], [0 0], 'k--'); % plot the horizontal line
scatter(sol_newton_1(end), function_1(sol_newton_1(end)), 140, ...
    'MarkerFaceColor','red')
scatter(sol_fsolve_1, fval_solve_1, 140, ...
    'MarkerFaceColor','blue')
scatter(sol_fzero_1, fval_zero_1, 140, ...
    'MarkerFaceColor','yellow')
legend('Function', '','Newton method solution',...
    'fsolve solution', 'fzero solution', 'FontSize', 18)

figure(2)
hold on
plot(x, function_2(x),'LineWidth', 2, 'Color', 'green')
% plot([0 1], [0 0], 'k--'); % plot the horizontal line
scatter(sol_newton_2(end), function_2(sol_newton_2(end)), 140, ...
    'MarkerFaceColor','red')
scatter(sol_fsolve_2, fval_solve_2, 140, ...
    'MarkerFaceColor','blue')
scatter(sol_fzero_2, fval_zero_2, 140, ...
    'MarkerFaceColor','yellow')
legend('Function', '','Newton method solution',...
    'fsolve solution', 'fzero solution', 'FontSize', 18)

figure(3)
hold on
plot(x1, function_3(x1),'LineWidth', 2, 'Color', 'green')
plot([-3 3], [0 0], 'k--'); % plot the horizontal line
scatter(sol_newton_3(end), function_3(sol_newton_3(end)), 140, ...
    'MarkerFaceColor','red')
scatter(sol_fsolve_3, fval_solve_3, 140, ...
    'MarkerFaceColor','blue')
scatter(sol_fzero_3, fval_zero_3, 140, ...
    'MarkerFaceColor','yellow')
legend('Function', '','Newton method solution',...
    'fsolve solution (fail) N.B. this is not a solution'...
    , 'fzero solution', 'FontSize', 18)
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