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
clear all
close all
clc

%% Data
global N P0 Patm rho g gamma dt dr L K epsi
N = 1; 
P0 = 1.5e5; % Pa
Patm = 1e5; % Pa
rho = 1000; % kg/m3
g = 9.81;   % m/s2
gamma = rho*g;
dt = 3e-2; % m tubo
dr = 1e-2; % m rubinetto
L = 5;     % m
K = 4;
epsi = 1e-5; % m
options = optimset('Display','iter'); % show iterations

%% Solution N = 1
nUnknowns = 4*N;
x= zeros(1, nUnknowns);

for i=1:N
    x(i) = 0.18;
    x(N+i) = 0.006;
    x(2*N+i) = 4;
    x(3*N+i) = 0.1;
end

[sol, fval, exitFlag] = fsolve(@rubinettiInSerie, x, options);
%% Solution for N = 5

N = 5;

nUnknowns = 4*N;
x= zeros(1, nUnknowns);

for i=1:N
    x(i) = 0.18;
    x(N + i) = 0.006;
    x(2*N +i) = 4;
    x(3*N + i) = 0.1;
end

[sol_5, fval_5, exitFlag_5] = fsolve(@rubinettiInSerie, x, options);

for i=1:N
    v_b_result(i) = sol_5(i);
    f_result(i) = sol_5(N+i);
    vout_result(i) = sol_5(2 * N + i);
    v_a_result(i) = sol_5(3 * N + i); 
    Re(i) = rho * v_b_result(i) * dt/1e-3;
    x(i) = i;
end

P_a = zeros(1, N);

for i=1:N    
    DH_distributed = 0;
    DH_localized = 0;
    for j=1:i
        DH_distributed = DH_distributed + 4*f_result(j)*(L/dt)*v_b_result(j)^2/(2*g);
        DH_localized = DH_localized + K*(v_b_result(j)^2)/(2*g);
    end
    P_a(i) = P0+gamma*((v_b_result(1)^2-v_a_result(i)^2)/(2*g)-DH_distributed-DH_localized);
    P_a(i) = P_a(i)/1e5;
end

figure(1)
subplot(2,2,1)
scatter(x(1,1:N), v_b_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Rubinetto (i)', 'FontSize', 17)
ylabel('v_{b} [m/s]', 'FontSize', 17)
grid on

subplot(2,2,2)
scatter(x(1,1:N), vout_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Rubinetto (i)', 'FontSize', 17)
ylabel('v_{out} [m/s]', 'FontSize', 17)
grid on

subplot(2,2,3)
scatter(x(1,1:N), P_a, 100, 'blue', 'LineWidth', 2.2)
xlabel('Rubinetto (i)', 'FontSize', 17)
ylabel('P [bar]', 'FontSize', 17)
grid on

%% Solution for N = 20

N = 20;

nUnknowns = 4*N;
x= zeros(1, nUnknowns);

for i=1:N
    x(i) = 0.18;
    x(N+i) = 0.006;
    x(2*N+i) = 4;
    x(3*N+i) = 0.1;
end
[sol_20, fval_20, exitFlag_20] = fsolve(@rubinettiInSerie, x, options);

for i=1:N
    v_b_result(i) = sol_20(i);
    f_result(i) = sol_20(N+i);
    vout_result(i) = sol_20(2 * N + i);
    v_a_result(i) = sol_20(3 * N + i); 
    Re(i) = rho * v_b_result(i) * dt/1e-3;
    x(i) = i;
end

P_a = zeros(1, N);

for i=1:N
    DH_distributed = 0;
    DH_localized = 0;
    for j=1:i
        DH_distributed = DH_distributed + 4*f_result(j)*(L/dt)*v_b_result(j)^2/(2*g);
        DH_localized = DH_localized + K*(v_b_result(j)^2)/(2*g);
    end    
    P_a(i) = P0+gamma*((v_b_result(1)^2-v_a_result(i)^2)/(2*g)-DH_distributed-DH_localized);
    P_a(i) = P_a(i)/1e5;
end

figure(2)
subplot(2,2,1)
scatter(x(1,1:N), v_b_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Rubinetto (i)', 'FontSize', 17)
ylabel('v_{b} [m/s]', 'FontSize', 17)
grid on

subplot(2,2,2)
scatter(x(1,1:N), vout_result, 100, 'blue', 'LineWidth', 2.2)
xlabel('Rubinetto (i)', 'FontSize', 17)
ylabel('v_{out} [m/s]', 'FontSize', 17)
grid on

subplot(2,2,3)
scatter(x(1,1:N), P_a, 100, 'blue', 'LineWidth', 2.2)
xlabel('Rubinetto (i)', 'FontSize', 17)
ylabel('P [bar]', 'FontSize', 17)
grid on

%% Function
function F = rubinettiInSerie(x)
    global N P0 Patm rho g gamma dt dr L K epsi
    % Declaration of the vector storing the values
    v_b  = zeros(1, N);
    f    = zeros(1, N);
    vout = zeros(1, N);
    v_a  = zeros(1,N);

    % Preallocation
    for i = 1:N
        v_b(i)  = x(i);
        f(i)    = x(N+i);
        vout(i) = x(2*N+i);
        v_a(i)  = x(3*N+i); 
    end

    Re = zeros(1, N);
    for i = 1:N
        Re(i) = (rho * v_b(i) * dt) / 1e-3; 
    end

    for i = 1:N
        DH_distributed = 0;
        DH_localized = 0;
        for j = 1:i
            DH_distributed = DH_distributed + 4*f(j)*(L/dt)*(v_b(j)^2)/(2*g);
            DH_localized = DH_localized + K*(v_b(j)^2)/(2*g);
        end
        F(i) = (P0-Patm)/gamma + (v_b(i)^2)/(2*g) - (vout(i)^2)/(2*g) ...
            - DH_distributed - DH_localized;
        F(N+i) = v_b(i)*dt^2 - vout(i)*dr^2 - v_a(i)*dt^2;
    
        if(Re(i)>2000)
            F(2*N+i) = 1/sqrt(f(i))+4*log10(epsi/(3.71*dt)+1.256/(Re(i)*sqrt(f(i))));
        else
            F(2*N+i) = f(i)-16/Re(i);
        end
        
        if(i<N)
            F(3*N+i) = v_a(i) - v_b(i+1);
        elseif (i == N)
            F(3*N+i) = v_a(i);
        end
    end
end