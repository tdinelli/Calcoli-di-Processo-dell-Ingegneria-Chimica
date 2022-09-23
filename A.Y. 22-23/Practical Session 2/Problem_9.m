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

%
% Cp(T) = A + B(C/T/sinh(C/T))^2 + D(E/T/cosh(E/T))^2
%
clear, clc, close all
%% DATA

A = 3.3375E+04;
B = 2.5864E+04;
C = 9.3280E+02;
D = 1.0880E+04;
E = 4.2370E+02;

T = 0:1:1000; % K
computedCp= zeros(1,length(T));

for i = 1:length(T)
    computedCp(i) = ComputeCp(T(i), A, B, C, D, E);
end

%% Plot stuff

plot(T, computedCp, 'LineWidth', 4, 'LineStyle',':', 'Color','green')
xlabel('Temperature [K]')
ylabel('Cp [J/kmol/K]')
title('Cp of SO_{2}')
legend('dotted line Cp SO_{2}', 'Location','southeast')

%% Functions definition

function Cp = ComputeCp(T, A, B, C, D, E)
    Cp = A + B * (C/T/sinh(C/T))^2 + D * (E/T/cosh(E/T))^2;
end
