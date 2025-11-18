clear, close, clc
global X C_target

X = @(t) sin(sqrt(t)) .* exp(-2 * t.^2);
C_target = 0.3;

t_range = 0:0.001:2;

[t_solution, fval, exitflag] = fsolve(...
    @equazione, 1);

figure;
hold on
plot(t_range, X(t_range), 'b-')
yline(C_target, 'r-')
plot(t_solution, C_target, 'mo', 'MarkerSize', 12)

function f = equazione(t)
    global X C_target
    integral_x = integral(X, 0, t);

    avg = integral_x / t;

    f = avg - C_target;
end