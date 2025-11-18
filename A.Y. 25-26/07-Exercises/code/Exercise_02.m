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
%% CALCOLO DEL TEMPO DI SVUOTAMENTO DI UN SERBATOIO CILINDRICO
%
% Questo script calcola il tempo necessario per svuotare completamente
% un serbatoio cilindrico attraverso un foro circolare sul fondo.
%
% MODELLO FISICO:
% Il problema è governato dall'equazione di Torricelli che descrive
% la velocità di uscita del fluido: v = C*sqrt(2*g*h)
% dove h è l'altezza del liquido nel serbatoio
%
% EQUAZIONE DIFFERENZIALE:
% A_cilindro * dh/dt = -a_foro * C * sqrt(2*g*h)
% 
% Riorganizzando:
% dt = -A_cilindro / (a_foro * C * sqrt(2*g*h)) * dh
%
% Integrando da h0 (altezza iniziale) a 0 (serbatoio vuoto):
% t_svuotamento = ∫[h0→0] -A_cilindro / (a_foro * C * sqrt(2*g*h)) dh

clear all
close all
clc

%% PARAMETRI FISICI E GEOMETRICI

% Geometria del serbatoio
R = 1;          % Raggio del serbatoio cilindrico (m)
h0 = 2;         % Altezza iniziale del liquido (m)

% Geometria del foro di uscita
r = 0.05;       % Raggio del foro di uscita (m)

% Parametri fisici
C = 0.65;       % Coefficiente di efflusso (adimensionale)
                % Tiene conto delle perdite di carico e della 
                % contrazione della vena fluida (tipicamente 0.6-0.65)
                
g = 9.81;       % Accelerazione di gravità (m/s²)

%% CALCOLO DELLE AREE

% Area della sezione trasversale del serbatoio
A_cilindro = pi * R^2;

% Area del foro di uscita
a_foro = pi * r^2;

%% DEFINIZIONE DELLA FUNZIONE INTEGRANDA

% La funzione da integrare deriva dall'equazione differenziale:
% dt/dh = -A_cilindro / (a_foro * C * sqrt(2*g*h))
%
% Nota: il segno negativo è dovuto al fatto che h diminuisce nel tempo
f = @(h) -A_cilindro ./ (a_foro * C * sqrt(2*g*h));

%% SOLUZIONE NUMERICA

% Integrazione numerica usando la funzione 'integral' di MATLAB
% Integriamo da h0 (altezza iniziale) a 0 (serbatoio vuoto)
% NOTA: Il segno negativo in f garantisce un risultato positivo
%       perché stiamo integrando da h0 verso 0 (h decresce)
t_svuotamento_num = integral(f, h0, 0);

%% SOLUZIONE ANALITICA
% La soluzione analitica si ottiene risolvendo l'integrale:
% t = ∫[h0→0] -A/(a*C*sqrt(2*g)) * h^(-1/2) dh
%   = -A/(a*C*sqrt(2*g)) * [2*sqrt(h)]|[h0→0]
%   = -A/(a*C*sqrt(2*g)) * (0 - 2*sqrt(h0))
%   = 2*A/(a*C*sqrt(2*g)) * sqrt(h0)

t_svuotamento_analytical = (2 * A_cilindro / (a_foro * C * sqrt(2*g))) * sqrt(h0);

%% CONFRONTO TRA I METODI
% Calcolo della differenza assoluta tra i due metodi
t_diff = abs(t_svuotamento_num - t_svuotamento_analytical);

% Calcolo dell'errore relativo percentuale
errore_relativo = (t_diff / t_svuotamento_analytical) * 100;

%% STAMPA DEI RISULTATI

fprintf('RISULTATI:\n')
fprintf('------------------------\n')
fprintf('Tempo di svuotamento (numerico):   %.4f secondi = %.2f minuti\n', ...
    t_svuotamento_num, t_svuotamento_num/60)
fprintf('Tempo di svuotamento (analitico):  %.4f secondi = %.2f minuti\n', ...
    t_svuotamento_analytical, t_svuotamento_analytical/60)
fprintf('\n')
fprintf('VERIFICA:\n')
fprintf('------------------------\n')
fprintf('Differenza assoluta:     %.6f secondi\n', t_diff)
fprintf('Errore relativo:         %.6f %%\n', errore_relativo)