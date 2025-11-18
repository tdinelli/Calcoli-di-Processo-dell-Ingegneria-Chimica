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
% RISOLUZIONE PROBLEMA DI OTTIMIZZAZIONE CON MOLTIPLICATORI DI LAGRANGE
% 
% Problema: Minimizzare f(x,y,z) = x^2 + 2y^2 + 3z^2
% Soggetto ai vincoli:
%   g1: x + y + z - 2 = 0
%   g2: xy + yz - 1 = 0
%
% Utilizziamo il metodo dei moltiplicatori di Lagrange per trovare
% il punto di minimo e i valori dei moltiplicatori lambda1 e lambda2

clear all
close all
clc

%% DEFINIZIONE DEL PUNTO INIZIALE
% Scegliamo un punto di partenza per l'algoritmo iterativo
% Il vettore contiene: [x, y, z, lambda1, lambda2]
x0 = [1; 1; 0; 1; 1];

fprintf('=== RISOLUZIONE SISTEMA KKT ===\n\n')
fprintf('Punto iniziale:\n')
fprintf('x = %.4f, y = %.4f, z = %.4f\n', x0(1), x0(2), x0(3))
fprintf('lambda1 = %.4f, lambda2 = %.4f\n\n', x0(4), x0(5))

%% TEST DEL SISTEMA (opzionale)
% Verifichiamo quanto il punto iniziale è lontano dalla soluzione
F_test = kkt_system(x0);
fprintf('Residui nel punto iniziale:\n')
fprintf('F(1) = %.4f  (gradiente rispetto a x)\n', F_test(1))
fprintf('F(2) = %.4f  (gradiente rispetto a y)\n', F_test(2))
fprintf('F(3) = %.4f  (gradiente rispetto a z)\n', F_test(3))
fprintf('F(4) = %.4f  (vincolo g1)\n', F_test(4))
fprintf('F(5) = %.4f  (vincolo g2)\n\n', F_test(5))

%% CONFIGURAZIONE DEL SOLVER
% Impostiamo le opzioni per fsolve
% - MaxFunctionEvaluations: numero massimo di valutazioni della funzione
% - MaxIterations: numero massimo di iterazioni
options = optimoptions('fsolve', ...
    'Display', 'iter', ...               % Mostra il progresso delle iterazioni
    'MaxFunctionEvaluations', 10000, ... % Numero massimo di valutazioni della funzione
    'MaxIterations', 10000, ...          % Numero massimo di iterazioni dell' algoritmo
    'TolFun', 1e-6, ...                  % Tolleranza sulla funzione
    'TolX', 1e-6);                       % Tolleranza sulla soluzione

%% RISOLUZIONE DEL SISTEMA
% fsolve cerca le radici del sistema di equazioni non lineari
% - @kkt_system: funzione che definisce il sistema
% - x0: punto iniziale
% - options: opzioni del solver
[sol, fval, exitflag] = fsolve(@kkt_system, x0, options);

%% ESTRAZIONE DELLA SOLUZIONE
x_opt = sol(1);
y_opt = sol(2);
z_opt = sol(3);
lambda1_opt = sol(4);
lambda2_opt = sol(5);

%% CALCOLO DEL VALORE DELLA FUNZIONE OBIETTIVO
% Calcoliamo f(x,y,z) = x^2 + 2y^2 + 3z^2 nel punto ottimo
f_opt = x_opt^2 + 2*y_opt^2 + 3*z_opt^2;

%% VERIFICA DEI VINCOLI
% Verifichiamo che i vincoli siano soddisfatti
g1_check = x_opt + y_opt + z_opt - 2;
g2_check = x_opt*y_opt + y_opt*z_opt - 1;

%% STAMPA DEI RISULTATI
fprintf('\n=== RISULTATI FINALI ===\n\n')

% Stato di convergenza
if exitflag > 0
    fprintf('Convergenza raggiunta!\n\n')
else
    fprintf('Attenzione: il solver potrebbe non aver raggiunto la convergenza (exitflag = %d)\n\n', exitflag)
end

% Punto ottimo
fprintf('Punto di minimo:\n')
fprintf('x* = %.6f\n', x_opt)
fprintf('y* = %.6f\n', y_opt)
fprintf('z* = %.6f\n\n', z_opt)

% Moltiplicatori di Lagrange
fprintf('Moltiplicatori di Lagrange:\n')
fprintf('λ₁ = %.6f\n', lambda1_opt)
fprintf('λ₂ = %.6f\n\n', lambda2_opt)

% Valore della funzione obiettivo
fprintf('Valore minimo della funzione obiettivo:\n')
fprintf('f(x*, y*, z*) = %.6f\n\n', f_opt)

% Verifica vincoli
fprintf('Verifica vincoli (dovrebbero essere ≈ 0):\n')
fprintf('g₁ = x + y + z - 2 = %.2e\n', g1_check)
fprintf('g₂ = xy + yz - 1 = %.2e\n\n', g2_check)

% Norma del residuo
fprintf('Norma del residuo: %.2e\n', norm(fval))

%% FUNZIONE CHE DEFINISCE IL SISTEMA KKT
function F = kkt_system(vars)
    % Questa funzione definisce il sistema di equazioni delle condizioni
    % di Karush-Kuhn-Tucker (KKT) per il nostro problema di ottimizzazione
    %
    % Input:
    %   vars = vettore [x, y, z, lambda1, lambda2]
    %
    % Output:
    %   F = vettore delle 5 equazioni che devono essere uguali a zero
    
    % Estraiamo le variabili dal vettore
    x = vars(1);
    y = vars(2);
    z = vars(3);
    lambda1 = vars(4);
    lambda2 = vars(5);
    
    % Inizializziamo il vettore delle equazioni
    F = zeros(5, 1);
    
    % EQUAZIONI DEL GRADIENTE DELLA LAGRANGIANA
    % Queste derivano da ∇L = 0
    
    % ∂L/∂x = 2x - λ₁ - λ₂y = 0
    F(1) = 2*x - lambda1 - lambda2*y;
    
    % ∂L/∂y = 4y - λ₁ - λ₂(x + z) = 0
    F(2) = 4*y - lambda1 - lambda2*(x + z);
    
    % ∂L/∂z = 6z - λ₁ - λ₂y = 0
    F(3) = 6*z - lambda1 - lambda2*y;
    
    % EQUAZIONI DEI VINCOLI
    % Queste derivano da ∂L/∂λᵢ = 0
    
    % g₁(x,y,z) = x + y + z - 2 = 0
    F(4) = x + y + z - 2;
    
    % g₂(x,y,z) = xy + yz - 1 = 0
    F(5) = x*y + y*z - 1;
end