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
%% EQUILIBRIO CHIMICO NELLA SINTESI DELL'AMMONIACA
%
% Calcola il grado di conversione (lambda) per la reazione:
% N₂ + 3H₂ ⇌ 2NH₃

clear all; close all; clc

%% PARAMETRI
% Termodinamica
Delta_H = -22000;  % cal/mol (esotermica)
Delta_S = -47.35;  % cal/(mol·K)
R = 1.987;         % cal/(mol·K)

% Range di T e P
T_vec = linspace(600, 900, 50);  % K
P_vec = linspace(50, 600, 50);   % atm

%% CALCOLO
[T_grid, P_grid] = meshgrid(T_vec, P_vec);
lambda_grid = zeros(size(T_grid));

% Loop su tutti i punti (T,P)
for i = 1:length(P_vec)
    for j = 1:length(T_vec)
        Kp = calcola_Kp(T_grid(i,j), Delta_H, Delta_S, R);
        lambda_grid(i,j) = risolvi_equilibrio(Kp, P_grid(i,j));
    end
end

%% VISUALIZZAZIONE
figure('Name', 'Equilibrio Ammoniaca', 'Position', [100, 100, 1200, 450])

% Contour plot
subplot(1,2,1)
contourf(T_grid, P_grid, lambda_grid, 20, 'LineColor', 'none')
colorbar; colormap(jet); caxis([0 1])
xlabel('Temperatura (K)'); ylabel('Pressione (atm)')
title('Grado di Conversione \lambda')
grid on; hold on
[C, h] = contour(T_grid, P_grid, lambda_grid, 10, 'k', 'LineWidth', 0.5);
clabel(C, h, 'FontSize', 8, 'Color', 'k')

% 3D surface
subplot(1,2,2)
surf(T_grid, P_grid, lambda_grid, 'EdgeColor', 'none')
xlabel('Temperatura (K)'); ylabel('Pressione (atm)'); zlabel('\lambda')
title('Superficie di Equilibrio')
colorbar; colormap(jet); view(45, 30)
lighting gouraud; shading interp

%% ANALISI
fprintf('Conversione massima: λ = %.4f a T=%.0fK, P=%.0fatm\n', ...
    max(lambda_grid(:)), T_vec(1), P_vec(end))
fprintf('Conversione minima:  λ = %.4f a T=%.0fK, P=%.0fatm\n', ...
    min(lambda_grid(:)), T_vec(end), P_vec(1))

%% FUNZIONI

function Kp = calcola_Kp(T, Delta_H, Delta_S, R)
    % Calcola Kp = exp(-ΔG⁰/RT) dove ΔG⁰ = ΔH - TΔS
    Delta_G0 = Delta_H - T * Delta_S;
    Kp = exp(-Delta_G0 / (R * T));
end

function lambda = risolvi_equilibrio(Kp, P)
    % Risolve: 4λ²(4-2λ)² / [27(1-λ)⁴P²] = Kp
    eq = @(lam) (4*lam^2*(4-2*lam)^2) / (27*(1-lam)^4*P^2) - Kp;
    
    try
        lambda = fzero(eq, [0.001, 0.999], optimset('Display', 'off'));
        lambda = max(0, min(1, lambda));  % Limita a [0,1]
    catch
        lambda = NaN;
        warning('Soluzione non trovata per Kp=%.4e, P=%.2f', Kp, P);
    end
end