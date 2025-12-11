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
% Complex Pressure Vessel Optimization
% This script determines the optimal dimensions of a cylindrical pressure 
% vessel with ellipsoidal ends, considering manufacturing costs and
% variable thickness
clear all
close all
clc

%% Data
V = 100;  % Example volume, can be changed

%% Part 1: Numerical Solution using fmincon
% Objective function: f = 0.0432V + 0.5(V/D) + 0.3041D^2 + 0.0263D^3
% Volume constraint: V = (π*D^2/4)*(L + D/2)
% Define objective function (using D as the optimization variable)
function_obj = @(D) 0.0432*V + 0.5*V./D + 0.3041*D.^2 + 0.0263*D.^3;

% Calculate L from volume constraint
% L = (4V/(πD^2)) - D/2
calc_L = @(D) (4*V/(pi*D^2)) - D/2;

% Set optimization options
options = optimoptions('fmincon', 'Display', 'iter', ...
                      'OptimalityTolerance', 1e-10, ...
                      'ConstraintTolerance', 1e-10);

% Initial guess for D
D0 = 5;  % Initial diameter guess

% Lower and upper bounds for D
lb = 0.1;  % Avoid zero dimension
ub = 20;   % Reasonable upper limit

% Additional constraint: L must be positive
nonlcon = @(D) deal([], []);  % No equality constraints, only bounds

% Run optimization
[D_opt, fval] = fmincon(function_obj, D0, [], [], [], [], ...
    lb, ub, nonlcon, options);

% Calculate optimal L
L_opt = calc_L(D_opt);

% Calculate objective function components for analysis
f1 = 0.0432*V;
f2 = 0.5*V/D_opt;
f3 = 0.3041*D_opt^2;
f4 = 0.0263*D_opt^3;

% Display results
fprintf('\nOptimal Solution:\n')
fprintf('Optimal diameter (D): %.2f m\n', D_opt)
fprintf('Optimal length (L): %.2f m\n', L_opt)
fprintf('L/D ratio: %.2f\n', L_opt/D_opt)
fprintf('Minimum objective value: %.2f\n', fval)

fprintf('\nObjective Function Components:\n')
fprintf('Volume term (0.0432V): %.2f\n', f1)
fprintf('V/D term (0.5V/D): %.2f\n', f2)
fprintf('D² term (0.3041D²): %.2f\n', f3)
fprintf('D³ term (0.0263D³): %.2f\n', f4)

% Verify volume constraint
actual_volume = (pi*D_opt^2/4)*(L_opt + D_opt/2);
fprintf('\nVolume Verification:\n')
fprintf('Target volume: %.2f m³\n', V)
fprintf('Actual volume: %.2f m³\n', actual_volume)
fprintf('Volume error: %.2e m³\n', abs(V - actual_volume))

% Plot objective function vs. diameter
D_range = linspace(lb, ub, 200);
f_values = zeros(size(D_range));
L_values = zeros(size(D_range));

for i = 1:length(D_range)
    D = D_range(i);
    L_values(i) = calc_L(D);
    if L_values(i) > 0  % Only calculate for valid L values
        f_values(i) = function_obj(D);
    else
        f_values(i) = NaN;
    end
end

figure;
subplot(2,1,1)
plot(D_range, f_values, 'b-', 'LineWidth', 2)
hold on
plot(D_opt, fval, 'ro', 'MarkerSize', 10)
xlabel('Diameter (m)')
ylabel('Objective Function Value')
title('Objective Function vs. Diameter')
grid on
legend('Objective Function', 'Optimal Point')

subplot(2,1,2)
plot(D_range, L_values, 'b-', 'LineWidth', 2)
hold on
plot(D_opt, L_opt, 'ro', 'MarkerSize', 10)
xlabel('Diameter (m)')
ylabel('Length (m)')
title('Length vs. Diameter (from Volume Constraint)')
grid on
legend('Length', 'Optimal Point')