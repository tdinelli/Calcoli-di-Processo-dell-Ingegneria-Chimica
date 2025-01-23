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
% Global parameters for the predator-prey model

global a b c d e f g h K omega
a = 1;     % Base deer population growth rate
b = 0.3;   % Seasonal effect
c = 0.2;   % Predation rate
d = 0.3;   % Half-saturation constant
e = 0.16;  % Conversion efficiency
f = 0.5;   % Wolf mortality rate
g = 0.7;   % Wolf competition coefficient
h = 0.0;   % Initially no hunting
K = 700;   % Carrying capacity
omega = 2*pi;  % Seasonal frequency

% Test function (optional)
y_test = seasonal_predator_prey(5, [6, 2]);

% Initial population conditions
y0 = [250, 15]; % [deer, wolves]
tspan = [0 50]; % Simulation over 50 years

% First simulation without hunting
[t_no_hunt, y_no_hunt] = ode45(@seasonal_predator_prey, tspan, y0);
mean_no_hunt = mean(y_no_hunt(:, 1));

% Find optimal hunting rate
target_deer = 500; % Target deer population
h_values = 0:150;
mean_values = zeros(size(h_values));

% Systematic search for optimal hunting rate
fprintf('Analyzing hunting rates...\n')
for i = 1:length(h_values)
    h = h_values(i);
    [t, y] = ode45(@seasonal_predator_prey, tspan, y0);
    mean_values(i) = mean(y(:, 1));
end

% Find the hunting rate closest to target population
[~, idx] = min(abs(mean_values - target_deer));
best_h = h_values(idx);

% Simulate with optimal hunting rate
h = best_h;
[t_optimal, y_optimal] = ode45(@seasonal_predator_prey, tspan, y0);
mean_optimal = mean(y_optimal(:, 1));

% Visualization of results
figure('Position', [100 100 1200 800]);

% Subplot 1: Deer Population Comparison
subplot(2, 2, 1)
hold on
plot(t_no_hunt, y_no_hunt(:,1), 'g-', 'LineWidth', 1.5)
plot(t_optimal, y_optimal(:,1), 'b-', 'LineWidth', 1.5)
yline(target_deer, 'r--', 'Target', 'LineWidth', 1.5)
xlabel('Years')
ylabel('Deer Population')
legend('Without Hunting', sprintf('Hunting Rate %.0f', best_h), 'Target')
grid on
title('Deer Population')

% Subplot 2: Wolf Population Comparison
subplot(2, 2, 2)
hold on
plot(t_no_hunt, y_no_hunt(:,2), 'g-', 'LineWidth', 1.5)
plot(t_optimal, y_optimal(:,2), 'b-', 'LineWidth', 1.5)
xlabel('Years')
ylabel('Wolf Population')
legend('Without Hunting', sprintf('Hunting Rate %.0f', best_h))
grid on
title('Wolf Population')

% Subplot 3: Hunting Rate vs Mean Population
subplot(2, 2, 3)
plot(h_values, mean_values, 'b-', 'LineWidth', 1.5)
hold on
plot(best_h, mean_values(idx), 'ro', 'MarkerSize', 10)
xlabel('Hunted Individuals')
ylabel('Average Deer Population')
grid on
title('Effect of Hunting on Average Population')

% Subplot 4: Phase Portrait
subplot(2, 2, 4)
hold on
plot(y_no_hunt(:,1), y_no_hunt(:,2), 'g-', 'LineWidth', 1.5)
plot(y_optimal(:,1), y_optimal(:,2), 'b-', 'LineWidth', 1.5)
plot(target_deer, y_optimal(end,2), 'ro', 'MarkerSize', 10)
xlabel('Deer Population')
ylabel('Wolf Population')
legend('Without Hunting', sprintf('Hunting Rate %.0f', best_h), 'Target')
grid on
title('Phase Portrait')

% Final statistics
fprintf('\nMANAGEMENT ANALYSIS RESULTS:\n')
fprintf('Target deer population: %d individuals\n', target_deer)
fprintf('Optimal hunting rate: %.0f\n', best_h)
fprintf('Average deer population achieved: %.0f\n', mean_values(idx))

% Predator-prey system function
function dydt = seasonal_predator_prey(t, y)
    global a b c d e f g h K omega
    x = y(1);  % deer population
    y2 = y(2); % wolf population

    % Deer population variation
    dx = x*(a + b*sin(omega*t))*(1 - x/K) - ... % logistic growth with seasonal effect
          (c*x*y2)/(1 + d*x) - ...              % predation
          h;                                    % hunting

    % Wolf population variation
    dy = e*y2*(x/(1 + d*x)) - ...   % conversion of prey to new predators
          f*y2 - ...                % natural mortality
          g*y2^2/x;                 % intraspecific competition

    dydt = [dx; dy];
end
