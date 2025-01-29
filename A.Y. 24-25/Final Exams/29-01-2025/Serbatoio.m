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
clear all, close all, clc

% Define physical parameters of the tank system
R = 1;        % Tank radius [meters]
r = 0.05;     % Outlet radius [meters]
h0 = 2;       % Initial water height [meters]
C = 0.65;     % Discharge coefficient [-] (accounts for flow losses)
g = 9.81;     % Acceleration due to gravity [m/s²]

% Calculate relevant areas
A_cilindro = pi * R^2;    % Tank cross-sectional area [m²]
a_foro = pi * r^2;        % Outlet hole area [m²]

% Define integrand function for Torricelli's law
% This function represents dt/dh = -A/(a*C*sqrt(2gh))
% Negative sign because height decreases with time
f = @(h) -A_cilindro./(a_foro*C*sqrt(2*g*h));

% Calculate emptying time using numerical integration
% integral() uses adaptive quadrature to compute definite integral
% from h0 to 0
t_svuotamento_num = integral(f, h0, 0);

% Calculate emptying time using analytical solution
% This comes from integrating Torricelli's law directly
% t = (2A/(aC*sqrt(2g))) * sqrt(h0)
t_svuotamento_analytical = (2*A_cilindro/(a_foro*C*sqrt(2*g))) * sqrt(h0);

% Calculate difference between numerical and analytical solutions
t_diff = t_svuotamento_num - t_svuotamento_analytical;

% Display results
fprintf('Numerical emptying time: %.2f seconds\n', t_svuotamento_num);
fprintf('Analytical emptying time: %.2f seconds\n', t_svuotamento_analytical);