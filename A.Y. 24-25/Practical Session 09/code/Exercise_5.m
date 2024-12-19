%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl <marco.mehl@polimi.it>                             %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.chem.polimi.it>            %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
clear, close, clc

%% Data Section
% Global variables for reaction system parameters
global Q k1_300 k2_300 E1 E2 DH1 DH2 CpA CpB CpC CpD

% Reactor and reaction parameters
V = 10;         % Reactor volume [l]
DH1 = 20000;    % Enthalpy change for reaction 1 [cal/mol]
DH2 = -10000;   % Enthalpy change for reaction 2 [cal/mol]
k1_300 = 0.001; % Rate constant 1 at 300K [l²/mol²*s]
k2_300 = 0.001; % Rate constant 2 at 300K [l/mol*s]
E1 = 5000;      % Activation energy for reaction 1 [cal/mol]
E2 = 7500;      % Activation energy for reaction 2 [cal/mol]
CA0 = 2;        % Initial concentration of A [mol/l]
CB0 = 4;        % Initial concentration of B [mol/l]
Q = 10;         % Volumetric flow rate [l/s]
CpA = 20;       % Heat capacity of species A [cal/mol*K]
CpB = 20;       % Heat capacity of species B [cal/mol*K]
CpC = 60;       % Heat capacity of species C [cal/mol*K]
CpD = 80;       % Heat capacity of species D [cal/mol*K]

%% Numerical Solution
% ODE solver options
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

% Solve the system of ODEs
[t, y] = ode23s(@system, [0 10], [CA0*Q CB0*Q 0 0 650], opts);

%% Plotting
figure(1)
% Subplots for molar flows and temperature
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

%% Reaction System ODE Function
function df = system(t,y)
    global Q k1_300 k2_300 E1 E2 DH1 DH2 CpA CpB CpC CpD

    % Universal gas constant
    R = 1.987; % cal/mol*K
    
    % Extract current state variables
    Fa = y(1);   % Molar flow of A
    Fb = y(2);   % Molar flow of B
    Fc = y(3);   % Molar flow of C
    Fd = y(4);   % Molar flow of D
    T = y(5);    % Temperature
    
    % Calculate concentrations
    Ca = Fa/Q;
    Cb = Fb/Q;
    Cc = Fc/Q;

    % Temperature-dependent rate constants (Arrhenius equation)
    K1 = k1_300 * exp(-E1/R * (1/T - 1/300));
    K2 = k2_300 * exp(-E2/R * (1/T - 1/300));

    % Reaction rates
    r1 = K1 * Ca * Cb^2;  % Rate of first reaction
    r2 = K2 * Ca * Cc;    % Rate of second reaction

    % Molar flow rate changes
    dFa = -r1 -r2;
    dFb = -2 * r1;
    dFc = 2 * r1 - r2;
    dFd = 2 * r2;

    % Temperature change rate
    dT = (-r1*DH1 - r2*DH2)/(Fa*CpA + Fb*CpB + Fc*CpC + Fd * CpD);

    df = [dFa dFb dFc dFd dT]';
end