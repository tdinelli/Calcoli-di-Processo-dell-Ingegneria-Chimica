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
global Re epsD

Re = 100000;
epsD = 0.01;

%% Solution

options = optimset('Display','iter'); % show iterations
% Does fzero converge ????
[sol, fval, exitFlag] = fsolve(@Colebrook, 1.7, options);

x = 0:0.0001:0.1;
T1 = @(x) 1 ./ sqrt(x);
T2 = @(x) -2 .* log10((2.51./(Re .* sqrt(x))) + ((1/3.71) .* epsD));

figure(1)
hold on
plot(x, T1(x), 'LineWidth',2.2,'Color','blue','LineStyle','--')
plot(x, T2(x), 'LineWidth', 2.2,'Color','red','LineStyle','--')

figure(2)
hold on
plot([0 0.1], [0 0], 'k'); % plot the horizontal line
plot(x, T1(x)-T2(x), 'LineWidth',2.2,'Color','blue','LineStyle','--')
grid on
%% Function

function F = Colebrook(x)
global Re epsD

T1 = 1 / sqrt(x);
T2 = -2 * log10((2.51/(Re * sqrt(x))) + ((1/3.71) * epsD));

F = T1 - T2;
end

