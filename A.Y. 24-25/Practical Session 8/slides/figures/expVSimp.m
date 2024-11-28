% Demonstrate first iteration of Forward and Backward Euler methods
% Solving dy/dt = -2y with y(0) = 1

% Parameters
t0 = 0;          % Initial time
y0 = 1;          % Initial condition y(0) = 1
lambda = -2;     % In equation dy/dt = -2y
h = 0.5;         % Step size
t1 = t0 + h;     % Next time point

% Forward Euler first step
% y1 = y0 + h*f(y0)
y1_forward = y0 + h * (lambda * y0);

% Backward Euler first step
% y1 = y0/(1-h*lambda)
y1_backward = y0/(1 - h*lambda);

% Calculate exact solution
t_exact = linspace(t0, t1, 100);
y_exact = exp(lambda * t_exact);

% Create plot
figure('Position', [100, 100, 800, 600]);

% Plot exact solution
plot(t_exact, y_exact, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Exact Solution');
hold on;

% Plot Forward Euler
plot([t0, t1], [y0, y1_forward], 'b.-', 'LineWidth', 2, 'MarkerSize', 20, ...
    'DisplayName', 'Forward Euler');

% Plot Backward Euler
plot([t0, t1], [y0, y1_backward], 'r.-', 'LineWidth', 2, 'MarkerSize', 20, ...
    'DisplayName', 'Backward Euler');

% Plot slopes
% Forward Euler slope (at t0)
slope_forward = lambda * y0;
t_slope = [t0, t0+h];
y_slope_forward = y0 + slope_forward * (t_slope - t0);
plot(t_slope, y_slope_forward, 'b--', 'LineWidth', 1);

% Backward Euler slope (at t1)
slope_backward = lambda * y1_backward;
y_slope_backward = y1_backward + slope_backward * (t_slope - t1);
plot(t_slope, y_slope_backward, 'r--', 'LineWidth', 1);

% Formatting
grid on;
xlabel('Time');
ylabel('y(t)');
title({'dy/dt = -2y,  y(0) = 1, Exact: y(t) = e^{-2t}'}, ...
       'FontSize', 12);
legend('Location', 'northeast');
axis([t0-h/4 t1+h/4 min(y1_forward,y1_backward)-0.1 y0+0.1]);

% Display numerical results
fprintf('Differential equation: dy/dt = -2y, y(0) = 1\n');
fprintf('Step size h = %.4f\n\n', h);

fprintf('Forward Euler:\n');
fprintf('y1 = y0 + h*(-2*y0) = %.4f\n', y1_forward);

fprintf('\nBackward Euler:\n');
fprintf('y1 = y0/(1-h*lambda) = %.4f\n', y1_backward);

fprintf('\nExact solution at t = %.4f: %.4f\n', t1, exp(lambda*t1));