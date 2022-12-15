clear, close, clc

%% Data
global k1 k2 k3
k1 = 0.5; % 1/h
k2 = 1e-7; % kmol/m3
k3 = 0.6;

tfinal = 15; % h

B0 = 0.03; % kmol/m3
S0 = 4.5;  % kmol/m3

%% ODE solution
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

[tbase, ybase] = ode15s(@biomass, [0 tfinal], [B0 S0]);
[topt, yopt] = ode15s(@biomass, [0 tfinal], [B0 S0], opts);

%% Plot

subplot(1,2,1)
hold on
plot(tbase, ybase(:,1), 'LineWidth', 2.2)
plot(tbase, ybase(:,2), 'LineWidth', 2.2)
xlabel('time [h]', 'FontSize', 18)
ylabel('Concetration [kmol/m3]', 'FontSize', 18)
legend('Biomass','Substrate', 'FontSize', 22)

subplot(1,2,2)
hold on
plot(topt, yopt(:,1), 'LineWidth', 2.2)
plot(topt, yopt(:,2), 'LineWidth', 2.2)
xlabel('time [h]', 'FontSize', 18)
ylabel('Concetration [kmol/m3]', 'FontSize', 18)
legend('Biomass','Substrate', 'FontSize', 22, 'location','northwest')

%% Function

function dCdt = biomass(t, x)

    global k1 k2 k3
    B = x(1);
    S = x(2);
    
    eq1 = (k1 * B * S) / (k2 + S);
    eq2 = -k3 * (k1 * B * S) / (k2 + S);

    dCdt = [eq1 eq2]';
end