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
%                                                                         %
%       Assemble the two function to get a single call                    %
%       to solve the system                                               %
%                                                                         %
% ----------------------------------------------------------------------- %

clear, close, clc;

options = optimset('Display','iter','PlotFcns', ...
    {@optimplotx,@optimplotfval},'TolFun',1e-10); % show iterations

%% Fsolve

[sol_fsolve_1, fval_solve_1, exitFlag_solve_1] = fsolve(@function_1,...
    1, options);

[sol_fsolve_2, fval_solve_2, exitFlag_solve_2] = fsolve(@function_2,...
    1, options);
%% Fzero
[sol_fzero_1, fval_zero_1, exitFlag_zero_1] = fzero(@function_1,...
    1, options);

[sol_fzero_2, fval_zero_2, exitFlag_zero_2] = fzero(@function_2,...
    1, options);
%% Plots

x = -1:0.01:1;
hold on
plot([-1 1], [0 0], 'k--'); % plot the horizontal line
plot(x, function_1(x),'LineWidth',2.5,'Color', 'red')
plot(x, function_2(x), 'LineWidth',2.5, 'Color', 'blue')
legend('', 'x^{2}', 'x^{3}', 'FontSize', 18)
%% Functions

function f1 = function_1(x)
    f1 = x.^2;
end

function f2 = function_2(x)
    f2 = x.^3;
end