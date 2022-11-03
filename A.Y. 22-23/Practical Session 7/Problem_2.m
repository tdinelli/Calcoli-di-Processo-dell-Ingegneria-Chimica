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

%% Data

Tinf = 273.16; % K
Tsup = 647.13; % K

T_vect = Tinf:0.001:Tsup;
P0vap = PVapH2O(T_vect);

options = optimset('Display','iter','PlotFcns', ...
    {@optimplotx,@optimplotfval}, 'TolX', 1e-20, ...
    'MaxFunEvals', 2e3, 'MaxIter', 2e3); % show iterations

%% Solve the problem

[sol_newton, error_newton] = Newton_numerical(310, @target,...
    @forward_diff, 1e-8, 50);

[sol_fsolve, fval_fsolve, exitFlag_fsolve] = fsolve(@target,...
                                                    310, options);

%% Plots

figure(2)
hold on
plot(T_vect, P0vap, 'LineWidth', 2.5)
plot([Tinf Tsup], [0 0], 'k--'); % plot the horizontal line
scatter(sol_fsolve, fval_fsolve, 140, 'MarkerFaceColor', 'red')
scatter(sol_newton(end), target(sol_newton(end)), 140,'MarkerFaceColor',...
    'blue', 'MarkerEdgeColor','blue')
ylabel('P^{0}_{vap} [Pa]', 'FontSize', 18)
xlabel('T [K]', 'FontSize', 18)
legend('P^{0}_{vap}', '', 'fsolve solution', 'Newton solution', ...
    'FontSize', 18)

%% Functions

function f = target(T)
    f = PVapH2O(T) - 5.0662e4;
end