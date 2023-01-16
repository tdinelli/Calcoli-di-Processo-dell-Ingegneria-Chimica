clear, close, clc

v = -1:0.1:1;

for i = 1:length(v)
    x(i) = v(i);
    y(i) = plotting(v(i));
end

plot(x, y, 'LineWidth', 2.2, 'Color', 'blue')

function f = plotting(x)
    f = sin(x) / (2 + x^4);
end