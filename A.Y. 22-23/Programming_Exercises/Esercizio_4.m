clear, close, clc

P1 = [4 -3];
P2 = [5 1];

m = (P2(2) - P1(2)) / (P2(1) - P1(1));
q = P1(2) - m * P1(1);

x = 3.5:0.001:5.5;
for i = 1:length(x)
    y(i) = m*x(i) + q;
end

figure(1)
hold on
plot(x, y, 'LineWidth', 2.2, 'Color', 'red')
scatter(P1(1), P1(2), 200,'filled', 'o')
scatter(P2(1), P2(2), 200,'filled', 'o')