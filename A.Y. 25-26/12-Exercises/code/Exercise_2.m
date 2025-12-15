%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Clear workspace and command window
clear all
clc

%% Input Data
% Temperature boundary conditions [°C]
T0 = 0;    % Initial temperature
T4 = 100;  % Final temperature

% Thermal conductivities [W/mK]
k = [3, 1.5, 5, 2];

% Position coordinates [m]
z = [0, 0.1, 0.2, 0.4, 0.45];

%% Setup System of Equations
% We need to solve for T1, T2, T3 and q
% The system can be written as Ax = b where x = [T1 T2 T3 q]'

% Initialize coefficient matrix A
A = zeros(4,4);

% Fill matrix A based on the heat flux equations
% First equation: q = k1(T1-T0)/(z1-z0)
A(1,1) = -k(1)/(z(2)-z(1));
A(1,4) = 1;

% Second equation: q = k2(T2-T1)/(z2-z1)
A(2,1) = k(2)/(z(3)-z(2));
A(2,2) = -k(2)/(z(3)-z(2));
A(2,4) = 1;

% Third equation: q = k3(T3-T2)/(z3-z2)
A(3,2) = k(3)/(z(4)-z(3));
A(3,3) = -k(3)/(z(4)-z(3));
A(3,4) = 1;

% Fourth equation: q = k4(T4-T3)/(z4-z3)
A(4,3) = k(4)/(z(5)-z(4));
A(4,4) = 1;

% Initialize and fill right-hand side vector b
b = zeros(4,1);
b(1) = k(1)*T0/(z(2)-z(1));
b(4) = k(4)*T4/(z(5)-z(4));

%% Solve the system
% x will contain [T1 T2 T3 q]
x = A\b;

% Extract solutions
T1 = x(1);
T2 = x(2);
T3 = x(3);
q = x(4);

% Create full temperature vector for plotting
T_full = [T0 T1 T2 T3 T4];

%% Plot results
figure
plot(z, T_full, 'b-o', 'LineWidth', 2)
grid on
xlabel('Position z [m]')
ylabel('Temperature [°C]')
title('Temperature Distribution Through Wall Layers')

% Add text annotations for heat flux
text(0.1, 80, sprintf('Heat Flux = %.2f W/m^2', q), 'FontSize', 12)

%% Display results
fprintf('Results:\n')
fprintf('T1 = %.2f °C\n', T1)
fprintf('T2 = %.2f °C\n', T2)
fprintf('T3 = %.2f °C\n', T3)
fprintf('Heat flux = %.2f W/m^2\n', q)
