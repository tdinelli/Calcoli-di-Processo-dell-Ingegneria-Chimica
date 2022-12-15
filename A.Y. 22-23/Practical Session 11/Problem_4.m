clear, close, clc

%% Data
global Fin0 r1 r2 A1 A2
A1 = 30;    % m2
r1 = 1.2;   % s/m2
A2 = 50;    % m2
r2 = 0.7;   % s /m2
Fin0 = 9.4; % m3/s
%% Solution

opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[tnonint, ynonint] = ode15s(@noninteractingtanks, [0 500], [11.28 6.58], opts);
[tint, yint] = ode15s(@interactingtanks, [0 500], [17.86 6.58], opts);
%% Plots
figure(1)
subplot(1,2,1)
hold on
plot(tnonint, ynonint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(tnonint, ynonint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Non Interacting Tanks', 'FontSize', 20)

subplot(1,2,2)
hold on
plot(tint, yint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(tint, yint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
title('Interacting Tanks', 'FontSize', 20)

figure(2)
hold on
plot(tnonint, ynonint(:,1), 'Color', 'red', 'LineWidth', 2.2)
plot(tnonint, ynonint(:,2), 'Color', 'blue', 'LineWidth', 2.2)
plot(tint, yint(:,1), 'Color', 'red', 'LineWidth', 2.2, 'LineStyle','--')
plot(tint, yint(:,2), 'Color', 'blue', 'LineWidth', 2.2, 'LineStyle','--')
xlabel('time [s]', 'FontSize', 18)
ylabel('Level [m]', 'FontSize', 18)
legend('Tank 1 non interacting', 'Tank 2 non interacting', ...
    'Tank 1 interacting', 'Tank 2 interacting')
%% Function
function df = noninteractingtanks(t, y)
    global Fin0 r1 r2 A1 A2
    h1 = y(1);
    h2 = y(2);

    if t <= 30
        Fi = Fin0 - ((Fin0/2)/30) * t;
    else
        Fi = Fin0 - ((Fin0/2)/30) * 30;
    end

    df(1) = (Fi - (h1/r1)) / A1; 
    df(2) = ((h1/r1) - (h2/r2)) / A2; 

    df = df';
end

function df = interactingtanks(t, y)
    global Fin0 r1 r2 A1 A2
    h1 = y(1);
    h2 = y(2);

    if t <= 30
        Fi = Fin0 - ((Fin0/2)/30) * t;
    else
        Fi = Fin0 - ((Fin0/2)/30) * 30;
    end

    df(1) = (Fi - ((h1-h2)/r1)) / A1; 
    df(2) = (((h1-h2)/r1) - (h2/r2)) / A2; 

    df = df';
end