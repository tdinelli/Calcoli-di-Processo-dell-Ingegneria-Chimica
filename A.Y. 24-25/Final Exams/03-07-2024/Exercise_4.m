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
% Define global variables for heat transfer parameters
global T0 s k sigma U eps Text F

% Create temperature range to analyze (400K to 1000K in 100K steps)
T = 400:100:1000;

% Define system parameters
s = 0.03;            % Distance/thickness (m)
k = 2.5;             % Thermal conductivity (W/m·K)
Text = 298;          % External/ambient temperature (K)
U = 5;               % Heat transfer coefficient (W/m²·K)
sigma = 5.67e-8;     % Stefan-Boltzmann constant (W/m²·K⁴)
eps = 0.9;           % Emissivity
F = 0.5;             % View factor

% Calculate equilibrium temperatures for each initial temperature
for i = 1:length(T)
    T0 = T(i);                    % Set initial temperature
    T1(i) = fzero(@alg_sys, T0);  % Find equilibrium temperature
end

% Calculate ratios of radiation to convection heat transfer
ratios = (T1.^4-Text^4)*sigma*eps*F./(U*(T1-Text));

% Test the heat balance function
test = alg_sys(800);

% Function to calculate heat balance
function y = alg_sys(x)
    global T0 s k sigma U eps Text F
    T1 = x;      % Current temperature
    
    % Calculate different heat transfer components:
    Cond = (T0-T1)*k/s;              % Conduction (Fourier's law)
    Irr = (T1^4-Text^4)*sigma*eps*F; % Radiation (Stefan-Boltzmann law)
    Conv = U*(T1-Text);              % Convection (Newton's law of cooling)
    
    % Heat balance equation (conduction = radiation + convection)
    y = Cond - Irr - Conv;
end