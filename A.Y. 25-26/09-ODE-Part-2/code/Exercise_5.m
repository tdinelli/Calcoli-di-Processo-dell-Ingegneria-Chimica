%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
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
V = 10;         % Reactor volume [L]
DH1 = 20000;    % Enthalpy change for reaction 1 [cal/mol]
DH2 = -10000;   % Enthalpy change for reaction 2 [cal/mol]
k1_300 = 0.001; % Rate constant 1 at 300K [L²/(mol²*s)]
k2_300 = 0.001; % Rate constant 2 at 300K [L/(mol*s)]
E1 = 5000;      % Activation energy for reaction 1 [cal/mol]
E2 = 7500;      % Activation energy for reaction 2 [cal/mol]
CA0 = 2;        % Initial concentration of A [mol/L]
CB0 = 4;        % Initial concentration of B [mol/L]
Q = 10;         % Volumetric flow rate [L/s]
CpA = 20;       % Heat capacity of species A [cal/(mol*K)]
CpB = 20;       % Heat capacity of species B [cal/(mol*K)]
CpC = 60;       % Heat capacity of species C [cal/(mol*K)]
CpD = 80;       % Heat capacity of species D [cal/(mol*K)]

% Initial conditions
FA0 = CA0 * Q;  % Initial molar flow of A [mol/s]
FB0 = CB0 * Q;  % Initial molar flow of B [mol/s]
FC0 = 0;        % Initial molar flow of C [mol/s]
FD0 = 0;        % Initial molar flow of D [mol/s]
T0 = 650;       % Initial temperature [K]

%% Numerical Solution
% ODE solver options
opts = odeset('RelTol',1e-9,'AbsTol',1e-12);

% Solve the system of ODEs
[V_array, y] = ode23s(@pfr_system, [0 V], [FA0 FB0 FC0 FD0 T0], opts);

%% Plotting
figure(1)
% Subplots for molar flows and temperature
subplot(2,3,1)
plot(V_array, y(:,1), 'LineWidth', 2.2, 'Color', 'red')
xlabel('Volume [L]', 'FontSize', 18)
ylabel('Molar flow [mol/s]', 'FontSize', 18)
title('F_A', 'FontSize', 20)
grid on

subplot(2,3,2)
plot(V_array, y(:,2), 'LineWidth', 2.2, 'Color', 'blue')
xlabel('Volume [L]', 'FontSize', 18)
ylabel('Molar flow [mol/s]', 'FontSize', 18)
title('F_B', 'FontSize', 20)
grid on

subplot(2,3,3)
plot(V_array, y(:,3), 'LineWidth', 2.2, 'Color', 'green')
xlabel('Volume [L]', 'FontSize', 18)
ylabel('Molar flow [mol/s]', 'FontSize', 18)
title('F_C', 'FontSize', 20)
grid on

subplot(2,3,4)
plot(V_array, y(:,4), 'LineWidth', 2.2, 'Color', 'magenta')
xlabel('Volume [L]', 'FontSize', 18)
ylabel('Molar flow [mol/s]', 'FontSize', 18)
title('F_D', 'FontSize', 20)
grid on

subplot(2,3,5)
plot(V_array, y(:,5), 'LineWidth', 2.2, 'Color', 'black')
xlabel('Volume [L]', 'FontSize', 18)
ylabel('Temperature [K]', 'FontSize', 18)
title('Temperature', 'FontSize', 20)
grid on

% Calculate and plot exit concentration of C
subplot(2,3,6)
CC_exit = y(:,3) / Q;  % Concentration of C along reactor
plot(V_array, CC_exit, 'LineWidth', 2.2, 'Color', 'cyan')
xlabel('Volume [L]', 'FontSize', 18)
ylabel('Concentration [mol/L]', 'FontSize', 18)
title('C_C', 'FontSize', 20)
grid on

% Display final concentration of C
fprintf('Final concentration of C at exit: %.4f mol/L\n', CC_exit(end));

%% Reaction System ODE Function
function dydV = pfr_system(V, y)
    global Q k1_300 k2_300 E1 E2 DH1 DH2 CpA CpB CpC CpD

    % Universal gas constant
    R = 1.987; % [cal/(mol*K)]
    
    % Extract current state variables
    FA = y(1);   % Molar flow of A [mol/s]
    FB = y(2);   % Molar flow of B [mol/s]
    FC = y(3);   % Molar flow of C [mol/s]
    FD = y(4);   % Molar flow of D [mol/s]
    T = y(5);    % Temperature [K]
    
    % Calculate concentrations [mol/L]
    CA = FA / Q;
    CB = FB / Q;
    CC = FC / Q;

    % Temperature-dependent rate constants (Arrhenius equation)
    k1 = k1_300 * exp(-E1/R * (1/T - 1/300));
    k2 = k2_300 * exp(-E2/R * (1/T - 1/300));

    % Reaction rates [mol/(L*s)]
    r1 = k1 * CA * CB^2;  % Rate of first reaction: A + 2B → 2C
    r2 = k2 * CA * CC;    % Rate of second reaction: A + C → 2D

    % Molar flow rate changes [mol/(s*L)]
    dFAdV = -r1 - r2;
    dFBdV = -2 * r1;
    dFCdV = 2 * r1 - r2;
    dFDdV = 2 * r2;

    % Temperature change rate [K/L]
    % Energy balance for adiabatic PFR
    dTdV = (-r1*DH1 - r2*DH2) / (FA*CpA + FB*CpB + FC*CpC + FD*CpD);

    dydV = [dFAdV; dFBdV; dFCdV; dFDdV; dTdV];
end