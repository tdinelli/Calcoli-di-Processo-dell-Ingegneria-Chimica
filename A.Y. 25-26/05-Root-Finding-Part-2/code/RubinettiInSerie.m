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
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
clear variables
close all
clc

%% Physical Data and System Parameters
global N P0 Patm rho g gamma dt dr L K epsi

N = 1;          % Initial number of taps
P0 = 1.5e5;     % Inlet pressure [Pa] = 1.5 bar
Patm = 1e5;     % Atmospheric pressure [Pa] = 1 bar
rho = 1000;     % Water density [kg/m³]
g = 9.81;       % Gravitational acceleration [m/s²]
gamma = rho*g;  % Specific weight [N/m³]
dt = 3e-2;      % Pipe diameter [m] = 3 cm
dr = 1e-2;      % Tap diameter [m] = 1 cm
L = 5;          % Distance between taps [m]
K = 4;          % Localized loss coefficient [-]
epsi = 1e-5;    % Pipe roughness [m]

options = optimset('Display','iter'); % Show fsolve iterations

%% Solution for N = 1 (Single Tap Case)
% This corresponds to objective 1: calculate outlet velocity with only
% one tap present. The system has 4 unknowns and 4 equations:
% 1) Bernoulli between inlet and tap outlet (with losses)
% 2) Continuity equation
% 3) Friction factor (Colebrook for turbulent or f=16/Re for laminar)
% 4) Boundary condition: v_a(1) = 0 (pipe closed after the tap)
fprintf('\n========================================\n');
fprintf('CASE 1: SINGLE TAP (N = 1)\n');
fprintf('========================================\n\n');

nUnknowns = 4*N;
x = zeros(1, nUnknowns);

% Initial guess for [v_b, f, v_out, v_a]
for i=1:N
    x(i) = 0.18;      % Initial guess for v_b [m/s]
    x(N+i) = 0.006;   % Initial guess for friction factor f [-]
    x(2*N+i) = 4;     % Initial guess for v_out [m/s]
    x(3*N+i) = 0.1;   % Initial guess for v_a [m/s]
end

[sol, fval, exitFlag] = fsolve(@rubinettiInSerie, x, options);

fprintf('\n--- Results for N = 1 ---\n');
fprintf('v_before = %.4f m/s\n', sol(1));
fprintf('v_after  = %.4f m/s\n', sol(4));
fprintf('v_out    = %.4f m/s\n', sol(3));
fprintf('f        = %.6f\n', sol(2));
fprintf('Exit flag: %d\n\n', exitFlag);

%% Solution for N = 5 (Five Taps)
% Test case with 5 taps to analyze pressure drop and flow distribution
fprintf('========================================\n');
fprintf('CASE 2: FIVE TAPS (N = 5)\n');
fprintf('========================================\n\n');

N = 5;

nUnknowns = 4*N;
x = zeros(1, nUnknowns);

% Initial guess for all taps
for i=1:N
    x(i) = 0.18;      % v_b(i)
    x(N + i) = 0.006; % f(i)
    x(2*N +i) = 4;    % v_out(i)
    x(3*N + i) = 0.1; % v_a(i)
end

[sol_5, fval_5, exitFlag_5] = fsolve(@rubinettiInSerie, x, options);

% Extract results for each tap
for i=1:N
    v_b_result(i) = sol_5(i);
    f_result(i) = sol_5(N+i);
    vout_result(i) = sol_5(2 * N + i);
    v_a_result(i) = sol_5(3 * N + i); 
    Re(i) = rho * v_b_result(i) * dt/1e-3;
    x(i) = i;
end

% Calculate pressure after each tap using Bernoulli equation
% P_a(i) accounts for cumulative distributed and localized losses
P_a = zeros(1, N);

for i=1:N    
    DH_distributed = 0;  % Cumulative distributed head loss
    DH_localized = 0;    % Cumulative localized head loss
    
    % Sum losses from tap 1 to tap i
    for j=1:i
        DH_distributed = DH_distributed + 4*f_result(j)*(L/dt)*v_b_result(j)^2/(2*g);
        DH_localized = DH_localized + K*(v_b_result(j)^2)/(2*g);
    end
    
    % Apply Bernoulli between inlet and position after tap i
    P_a(i) = P0+gamma*((v_b_result(1)^2-v_a_result(i)^2)/(2*g)-DH_distributed-DH_localized);
    P_a(i) = P_a(i)/1e5; % Convert to bar
end

fprintf('\n--- Results for N = 5 ---\n');
for i=1:N
    fprintf('Tap %d: v_b=%.4f m/s, v_out=%.4f m/s, P_a=%.4f bar\n', ...
        i, v_b_result(i), vout_result(i), P_a(i));
end
fprintf('\n');

% Plot results for N = 5
figure(1)
subplot(2,2,1)
scatter(x(1,1:N), v_b_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Tap Number (i)', 'FontSize', 17)
ylabel('v_{b} [m/s]', 'FontSize', 17)
title('Velocity Before Each Tap (N=5)', 'FontSize', 15)
grid on

subplot(2,2,2)
scatter(x(1,1:N), vout_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Tap Number (i)', 'FontSize', 17)
ylabel('v_{out} [m/s]', 'FontSize', 17)
title('Outlet Velocity from Each Tap (N=5)', 'FontSize', 15)
grid on

subplot(2,2,3)
scatter(x(1,1:N), P_a, 100, 'blue', 'LineWidth', 2.2)
xlabel('Tap Number (i)', 'FontSize', 17)
ylabel('P [bar]', 'FontSize', 17)
title('Pressure After Each Tap (N=5)', 'FontSize', 15)
grid on

%% Solution for N = 20 (Maximum Number Test)
% Objective 2 & 3: Determine maximum number of taps and pressure profile
% A tap can deliver water only if P_a(i) > P_atm

fprintf('========================================\n');
fprintf('CASE 3: TWENTY TAPS (N = 20)\n');
fprintf('========================================\n\n');

N = 20;

nUnknowns = 4*N;
x = zeros(1, nUnknowns);

% Initial guess for all taps
for i=1:N
    x(i) = 0.18;
    x(N+i) = 0.006;
    x(2*N+i) = 4;
    x(3*N+i) = 0.1;
end

[sol_20, fval_20, exitFlag_20] = fsolve(@rubinettiInSerie, x, options);

% Extract results
for i=1:N
    v_b_result(i) = sol_20(i);
    f_result(i) = sol_20(N+i);
    vout_result(i) = sol_20(2 * N + i);
    v_a_result(i) = sol_20(3 * N + i); 
    Re(i) = rho * v_b_result(i) * dt/1e-3;
    x(i) = i;
end

% Calculate axial pressure profile
P_a = zeros(1, N);

for i=1:N
    DH_distributed = 0;
    DH_localized = 0;
    
    for j=1:i
        DH_distributed = DH_distributed + 4*f_result(j)*(L/dt)*v_b_result(j)^2/(2*g);
        DH_localized = DH_localized + K*(v_b_result(j)^2)/(2*g);
    end    
    
    P_a(i) = P0+gamma*((v_b_result(1)^2-v_a_result(i)^2)/(2*g)-DH_distributed-DH_localized);
    P_a(i) = P_a(i)/1e5; % Convert to bar
end

fprintf('\n--- Results for N = 20 ---\n');
fprintf('First 5 taps:\n');
for i=1:5
    fprintf('Tap %d: v_b=%.4f m/s, v_out=%.4f m/s, P_a=%.4f bar\n', ...
        i, v_b_result(i), vout_result(i), P_a(i));
end
fprintf('...\n');
fprintf('Last 5 taps:\n');
for i=16:20
    fprintf('Tap %d: v_b=%.4f m/s, v_out=%.4f m/s, P_a=%.4f bar\n', ...
        i, v_b_result(i), vout_result(i), P_a(i));
end
fprintf('\n');

% Check which taps can actually deliver water (P_a > P_atm)
active_taps = sum(P_a > 1.0); % P_atm = 1 bar
fprintf('Number of taps able to deliver water: %d out of %d\n\n', active_taps, N);

% Plot results for N = 20
figure(2)
subplot(2,2,1)
scatter(x(1,1:N), v_b_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Tap Number (i)', 'FontSize', 17)
ylabel('v_{b} [m/s]', 'FontSize', 17)
title('Velocity Before Each Tap (N=20)', 'FontSize', 15)
grid on

subplot(2,2,2)
scatter(x(1,1:N), vout_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Tap Number (i)', 'FontSize', 17)
ylabel('v_{out} [m/s]', 'FontSize', 17)
title('Outlet Velocity from Each Tap (N=20)', 'FontSize', 15)
grid on

subplot(2,2,3)
scatter(x(1,1:N), P_a, 100, 'blue', 'LineWidth', 2.2)
hold on
yline(1.0, 'r--', 'LineWidth', 2, 'Label', 'P_{atm}')
xlabel('Tap Number (i)', 'FontSize', 17)
ylabel('P [bar]', 'FontSize', 17)
title('Axial Pressure Profile (N=20)', 'FontSize', 15)
grid on

%% Function: System of Nonlinear Equations
% For N taps, this function defines the 4N equations:
%
% For each tap i (i = 1 to N):
%   1) Bernoulli equation between inlet and tap i outlet:
%      (P0-Patm)/γ + v_b(i)²/(2g) = v_out(i)²/(2g) +
%           ΣΔH_distributed + ΣΔH_localized
%
%   2) Continuity equation:
%      v_b(i)*D² = v_out(i)*d² + v_a(i)*D²
%
%   3) Friction factor (Colebrook correlation for turbulent flow):
%      1/√f = -4*log10(ε/(3.71*D) + 1.256/(Re*√f))  for Re > 2000
%      f = 16/Re                                    for Re < 2000
%
%   4) Boundary conditions:
%      v_a(i) = v_b(i+1)  for i < N  (continuity between taps)
%      v_a(N) = 0         for i = N  (pipe closed at the end)

function F = rubinettiInSerie(x)
    global N P0 Patm rho g gamma dt dr L K epsi
    
    % Extract variables from solution vector x
    % x = [v_b(1:N), f(1:N), v_out(1:N), v_a(1:N)]
    v_b  = zeros(1, N);  % Velocity before each tap [m/s]
    f    = zeros(1, N);  % Friction factor at each tap [-]
    vout = zeros(1, N);  % Outlet velocity from each tap [m/s]
    v_a  = zeros(1, N);  % Velocity after each tap [m/s]

    for i = 1:N
        v_b(i)  = x(i);
        f(i)    = x(N+i);
        vout(i) = x(2*N+i);
        v_a(i)  = x(3*N+i); 
    end

    % Calculate Reynolds number for each tap
    Re = zeros(1, N);
    for i = 1:N
        Re(i) = (rho * v_b(i) * dt) / 1e-3;  % μ = 1e-3 Pa·s for water
    end

    % Build the system of equations
    for i = 1:N
        % Cumulative head losses from inlet to tap i
        DH_distributed = 0;
        DH_localized = 0;
        
        for j = 1:i
            % Distributed losses (Darcy-Weisbach): ΔH = 4*f*(L/D)*v²/(2g)
            DH_distributed = DH_distributed + 4*f(j)*(L/dt)*(v_b(j)^2)/(2*g);
            
            % Localized losses at tap: ΔH = K*v²/(2g)
            DH_localized = DH_localized + K*(v_b(j)^2)/(2*g);
        end
        
        % Equation 1: Bernoulli between inlet and tap i outlet
        F(i) = (P0-Patm)/gamma + (v_b(i)^2)/(2*g) - (vout(i)^2)/(2*g) ...
            - DH_distributed - DH_localized;
        
        % Equation 2: Continuity at tap i
        F(N+i) = v_b(i)*dt^2 - vout(i)*dr^2 - v_a(i)*dt^2;
    
        % Equation 3: Friction factor (Colebrook or laminar)
        if(Re(i) > 2000)
            % Turbulent flow: implicit Colebrook equation
            F(2*N+i) = 1/sqrt(f(i)) + 4*log10(epsi/(3.71*dt) + ...
                1.256/(Re(i)*sqrt(f(i))));
        else
            % Laminar flow: Hagen-Poiseuille
            F(2*N+i) = f(i) - 16/Re(i);
        end
        
        % Equation 4: Boundary conditions
        if(i < N)
            % Interior taps: continuity with next tap
            F(3*N+i) = v_a(i) - v_b(i+1);
        elseif (i == N)
            % Last tap: pipe is closed (v_a = 0)
            F(3*N+i) = v_a(i);
        end
    end
end