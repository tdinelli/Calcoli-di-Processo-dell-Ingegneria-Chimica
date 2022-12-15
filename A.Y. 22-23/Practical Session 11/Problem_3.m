clear, close, clc

%% Data
global Fin0 A r

A = 30; % m2
Fin0 = 7.5; % m3/s
r = 0.4; % s/m2
h0 = 3;
%% Solution

opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[t, y] = ode15s(@odesys, [0 100], 3, opts);
[t1, y1] = ode15s(@odesys2, [0 100], 3, opts);
%% Plot
figure(1)
plot(t, y, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)

figure(2)
subplot(2,1,1)
plot(t1, y1, 'LineWidth', 2.2, 'Color', 'red')
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Single tank: height dynamics', 'FontSize', 20)

subplot(2,1,2)

for i = 1:length(t1)
    if t1(i) <= 30
        F(i) = Fin0 - ((Fin0/2)/30) * t1(i);
    else
        F(i) = Fin0 - ((Fin0/2)/30) * 30;
    end
end
plot(t1, F, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Inlet Flow [m3/s]', 'FontSize', 18)
title('Inlet Flow', 'FontSize', 20)
%% Function

function df = odesys(t, y)
global Fin0 A r
    h = y(1);
    Fi = Fin0/2;
    df(1) = Fi/A - h/A/r; 
end

function df = odesys2(t, y)
global Fin0 A r 
    h = y(1);
    if t <= 30
        Fi = Fin0 - ((Fin0/2)/30) * t;
    else
        Fi = Fin0 - ((Fin0/2)/30) * 30;
    end

    df(1) = Fi/A - h/A/r; 
end