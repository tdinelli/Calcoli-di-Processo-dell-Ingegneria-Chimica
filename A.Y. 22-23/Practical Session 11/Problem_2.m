clear, close, clc

%% Data
global Q m cp Fin

Q = 1e6;       % W
Fin = 8;       % kmol/s
m = 100;       % kmol
cp = 2.5*1000; % J/kmolK
Tin = 300;     % K

%% Solution

opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[t15, T15] = ode15s(@temperature_balance, [0 300], Tin);
[t45, T45] = ode45(@temperature_balance, [0 300], Tin);
%% Plot

hold on
grid on
plot(t15, T15, 'LineWidth', 2.2)
plot(t45, T45, 'LineWidth', 2.2)
xlabel('time [s]', 'FontSize', 18)
ylabel('Temperature [K]', 'FontSize', 18)
legend('Outlet temperature [K] -> ode 15s',...
    'Outlet temperature [K] -> ode 45', 'FontSize', 18, ...
    'location', 'northwest')
%% Function

function dTdt = temperature_balance(t, y)
    global Q m cp Fin
    T = y(1);
    if t < 150
        Tin = 300;
    else
        Tin = 330;
    end
    dTdt(1) = (Q/(m * cp)) - (Fin/m) * (T-Tin);
end