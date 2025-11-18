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
clear; close all; clc;

%% Data
% Flow rate with sinusoidal daily pattern [L/h]
q = @(t) 2 * (sin((t/24) * pi).^2) * 60; 

total_time = 48;                    % Simulation duration [h]
dt = 1;                             % Time step [h]
t = 0:dt:total_time;                % Time vector [h]

%% Calculate Volume Over Time
% Pre-allocate volume array
V = zeros(size(t));

% Integrate flow rate to get cumulative volume
for i = 2:length(t)
    % Add volume increment using trapezoidal rule
    V(i) = V(i-1) + trapezoidal(q, t(i-1), t(i), 10);
    
    % Reset volume every 24 hours (daily cycle)
    if mod(t(i), 24) == 0
        V(i) = 0;
    end
end

%% Display Results
fprintf('\n=== Integration Results ===\n')
fprintf('Volume after 24h: %.2f L\n', V(25))
fprintf('Trapezoidal method: %.2f L\n', trapezoidal(q, 0, 24, 30))
fprintf('MATLAB integral:    %.2f L\n', integral(q, 0, 24))

%% Performance Comparison (Optional)
fprintf('\n=== Performance Benchmarks ===\n')

tic; I1 = trapezoidal(q, 0, 24, 34); t1 = toc;
fprintf('Custom trapezoidal: %.6f s\n', t1)

tic; I2 = integral(q, 0, 24); t2 = toc;
fprintf('MATLAB integral:    %.6f s\n', t2)

fprintf('\nIntegration error: %.6f L\n', abs(I1 - I2))

%% Visualization
figure('Position', [100 100 900 500])
hold on; grid on; box on;

% Plot flow rate
yyaxis left
plot(t, q(t), 'b-', 'LineWidth', 2)
ylabel('Flow Rate [L/h]', 'FontSize', 14)
ylim([0 max(q(t))*1.1])

% Plot volume
yyaxis right
plot(t, V, 'r-', 'LineWidth', 2)
ylabel('Volume [L]', 'FontSize', 14)
ylim([0 max(V)*1.1])

% Formatting
xlabel('Time [h]', 'FontSize', 14)
title('Tank Volume Over Time with Daily Reset', 'FontSize', 16)
legend('Flow Rate', 'Volume', 'Location', 'northwest', 'FontSize', 12)
xlim([0 total_time])