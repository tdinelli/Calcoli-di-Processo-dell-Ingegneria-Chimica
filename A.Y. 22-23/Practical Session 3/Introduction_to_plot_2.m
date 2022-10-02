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

close, clear, clc;

x = 1:1:20;

for i = 1:length(x)
    y(i) = 3 * x(i) + 2;
    y2(i) = -3 * x(i) + 4;
    y3(i) = x(i)^2 - 26 * x(i) - 44;
end

subplot(3,1,1)
plot(x, y, 'LineStyle',':', 'LineWidth',2, 'Color','red')
xlabel('Asse x grafico 1', 'FontSize', 22)
ylabel('Asse y grafico 1', 'FontSize', 22)
legend('y(x) = 3x + 2', 'FontSize', 18, 'Location', 'northwest')

subplot(3,1,2)
plot(x, y2, 'LineStyle', '-.', 'LineWidth', 2, 'Color', 'green')
xlabel('Asse x grafico 2', 'FontSize', 22)
ylabel('Asse y grafico 2', 'FontSize', 22)
legend('y(x) = -3x + 2', 'FontSize', 18, 'Location', 'southwest')

subplot(3,1,3)
plot(x, y3, 'LineStyle','--', 'LineWidth', 2, 'Color', 'blue')
xlabel('Asse x grafico 3', 'FontSize', 22)
ylabel('Asse y grafico 3', 'FontSize', 22)
legend('non so cosa esca', 'FontSize', 18, 'Location', 'southwest')
