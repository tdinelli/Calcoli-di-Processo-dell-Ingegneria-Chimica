clear, close, clc

%% Data
global Q k1_300 k2_300 E1 E2 DH1 DH2 CpA CpB CpC CpD
V = 10;         % l
DH1 = 20000;    % cal/mol
DH2 = -10000;   % cal/mol
k1_300 = 0.001; % l^2/mol^2*s
k2_300 = 0.001; % l/mol*s
E1 = 5000;      % cal/mol
E2 = 7500;      % cal/mol
CA0 = 2;        % mol/l
CB0 = 4;        % mol/l
Q = 10;         % l/s
CpA = 20; % cal/mol
CpB = 20; % cal/mol
CpC = 60; % cal/mol
CpD = 80; % cal/mol

% Assuming you could vary the entering temperature between 600 K  
% and 700 K, what entering temperature would you recommend to maximize the 
% concentration of species C exiting the reactor (±10 K accuracy)?

%% Solution
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);
[t, y] = ode23s(@system, [0 10], [CA0*Q CB0*Q 0 0 650], opts);

%% Plot

figure(1)
subplot(2,3,1)
plot(t, y(:,1), 'LineWidth', 2.2, 'Color', 'red')
xlabel('Volume [l]', 'FontSize', 18)
ylabel('Molar flow [mol]', 'FontSize', 18)
title('FA', 'FontSize', 20)

subplot(2,3,2)
plot(t, y(:,2), 'LineWidth', 2.2, 'Color', 'blue')
xlabel('Volume [l]', 'FontSize', 18)
ylabel('Molar flow [mol]', 'FontSize', 18)
title('FB', 'FontSize', 20)

subplot(2,3,3)
plot(t, y(:,3), 'LineWidth', 2.2, 'Color', 'green')
xlabel('Volume [l]', 'FontSize', 18)
ylabel('Molar flow [mol]', 'FontSize', 18)
title('FC', 'FontSize', 20)

subplot(2,3,4)
plot(t, y(:,4), 'LineWidth', 2.2, 'Color', 'magenta')
xlabel('Volume [l]', 'FontSize', 18)
ylabel('Molar flow [mol]', 'FontSize', 18)
title('FD', 'FontSize', 20)

subplot(2,3,5)
plot(t, y(:,5), 'LineWidth', 2.2, 'Color', 'black')
xlabel('Volume [l]', 'FontSize', 18)
ylabel('Temperature [K]', 'FontSize', 18)
title('Temperature', 'FontSize', 20)
%% Function

function df = system(t,y)
    global Q k1_300 k2_300 E1 E2 DH1 DH2 CpA CpB CpC CpD

    R = 1.987; % cal/molK
    
    Fa = y(1);
    Fb = y(2);
    Fc = y(3);
    Fd = y(4);
    T = y(5);
    
    Ca = Fa/Q;
    Cb = Fb/Q;
    Cc = Fc/Q;

    K1 = k1_300 * exp(-E1/R * (1/T - 1/300));
    K2 = k2_300 * exp(-E2/R * (1/T - 1/300));

    r1 = K1 * Ca * Cb^2;
    r2 = K2 * Ca * Cc;

    dFa = -r1 -r2;
    dFb = -2 * r1;
    dFc = 2 * r1 - r2;
    dFd = 2 * r2;

    dT = (-r1*DH1 - r2*DH2)/(Fa*CpA + Fb*CpB + Fc*CpC + Fd * CpD);

    df = [dFa dFb dFc dFd dT]';

end