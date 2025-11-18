clear, close, clc

q = @(t) 2 * (sin((t/24) * pi).^2) * 60;

total_time = 48;
dt = 1;
time = 0:dt:total_time;

V = zeros(length(time));
for i=2:length(time)
    V(i) = V(i-1) + trapezi(q,...
        time(i-1), time(i),...
        10);
    if mod(time(i), 24) == 0
        V(i) = 0;
    end
end

figure;
hold on
yyaxis left;
plot(time, q(time), 'b-')
yyaxis right;
plot(time, V, 'r-')