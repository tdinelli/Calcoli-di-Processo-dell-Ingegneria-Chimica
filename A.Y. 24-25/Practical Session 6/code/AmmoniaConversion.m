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
% This code analyzes the equilibrium conversion of nitrogen and hydrogen
% to ammonia: N2 + 3H2 ⇌ 2NH3
%
% The code calculates:
% 1. Equilibrium conversion at different temperatures and pressures
% 2. Creates a contour plot of conversion
% 3. Calculates specific equilibrium point at T=700K and P=500atm
%
% The equilibrium is based on:
% - Gibbs free energy calculation
% - Mass balance
% - Equilibrium constant relationship

%% Initialize Global Variables
global T P   % Temperature [K] and Pressure [atm]

%% Generate Conversion Map
% Create temperature and pressure grid for contour plot
% T range: 600-900K in 50K steps
% P range: 50-600atm in 50atm steps
for i = 1:7
    for j = 1:12
        % Calculate conditions for each point
        T = 600 + 50*(i-1);    % Temperature [K]
        P = 50 + 50*(j-1);     % Pressure [atm]
        
        % Solve for equilibrium conversion
        lambda = fzero(@equilibrium, 0.5);  % Initial guess = 0.5
        
        % Store results for plotting
        Tplot(i,j) = T;
        Pplot(i,j) = P;
        conv(i,j) = lambda;
    end
end

% Create contour plot of conversion
contourf(Tplot, Pplot, conv)
colorbar
xlabel('Temperature [K]')
ylabel('Pressure [atm]')
title('NH_3 Synthesis Conversion')

%% Calculate Specific Solution at T=700K, P=500atm
Kp700 = eqconst(700);          % Equilibrium constant at 700K
T = 700;                       % Temperature [K]
P = 500;                       % Pressure [atm]
soluzione = fzero(@equilibrium, 0.5);  % Equilibrium conversion

%% Function Definitions

function Kp = eqconst(T)
    % Calculate equilibrium constant from thermodynamic data
    %
    % Input:
    %   T - Temperature [K]
    % Output:
    %   Kp - Equilibrium constant
    
    R = 1.987;        % Gas constant [cal/mol/K]
    dH = -22000;      % Standard enthalpy of reaction [cal/mol]
    dS = -47.35;      % Standard entropy of reaction [cal/mol/K]
    
    % Calculate standard Gibbs free energy
    dG0 = dH - T*dS;
    
    % Calculate equilibrium constant
    Kp = exp(-dG0/(R*T));
end

function y = equilibrium(lambda)
    % Equilibrium function to solve for conversion
    %
    % Input:
    %   lambda - Conversion of N2
    % Output:
    %   y - Residual of equilibrium equation
    
    global T P
    
    % Calculate moles of each species at equilibrium
    nNH3 = 2*lambda;      % Moles of NH3 produced
    nN2 = 1-lambda;       % Moles of N2 remaining
    nH2 = 3-3*lambda;     % Moles of H2 remaining
    ntot = 4-2*lambda;    % Total moles in system
    
    % Calculate mole fractions
    yNH3 = nNH3/ntot;     % NH3 mole fraction
    yN2 = nN2/ntot;       % N2 mole fraction
    yH2 = nH2/ntot;       % H2 mole fraction
    
    % Calculate equilibrium expression residual
    % Kp = (yNH3^2)/(yN2 * yH2^3 * P^2)
    y = yNH3^2/((yH2)^3*yN2)/P^2 - eqconst(T);
end