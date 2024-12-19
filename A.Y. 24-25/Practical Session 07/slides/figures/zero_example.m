%% Enhanced Function Visualization using fzero
% Visualize f(x) = 3*sin(x) + x/5 with precise zero crossings

clear all, close all, clc

% Define the function
f = @(x) 3*sin(x) + x/5;

% Generate x and y values for plotting
x = -10:0.1:10;
y = f(x);

% Create figure with white background
figure('Color', 'white');
hold on

% Plot the function
plot(x, y, 'LineWidth', 2, 'Color', 'blue')

% Add horizontal line at y=0
plot(x, zeros(size(x)), 'k--', 'LineWidth', 1)

% Find approximate zero crossings for initial guesses
zero_crossings_idx = find(diff(sign(y)) ~= 0);
initial_guesses = x(zero_crossings_idx);

% Use fzero to find precise zero crossings
precise_zeros = zeros(size(initial_guesses));
for i = 1:length(initial_guesses)
    precise_zeros(i) = fzero(f, initial_guesses(i));
end

% Plot zero crossings
scatter(precise_zeros, zeros(size(precise_zeros)), 100, 'red', 'filled', ...
    'MarkerEdgeColor', 'black', ...
    'LineWidth', 1)

% Add labels
xlabel('x', 'FontSize', 12)
ylabel('y', 'FontSize', 12)

% Add grid
grid on

% Create text box with function expression
text_str = '$f(x) = 3\sin(x) + \frac{x}{5}$';
annotation('textbox', [0.15, 0.8, 0.3, 0.1], ...
    'String', text_str, ...
    'Interpreter', 'latex', ...
    'FitBoxToText', 'on', ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'none', ...
    'FontSize', 14)

% Add legend
legend('Function', 'y = 0', 'Zero Crossings', ...
    'Location', 'best', ...
    'FontSize', 10)

% Adjust plot appearance
box on
axis tight
set(gca, 'FontSize', 12)

% Display precise zero crossings
fprintf('Zero crossings occur at x = \n')
fprintf('%.6f\n', sort(precise_zeros))