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
% Define global constants for chemical equilibrium
global K1 KH K2 Kw Hplus0

% Define equilibrium constants (given in log form)
KH = 10^(-1.46);     % Henry's law constant
K1 = 10^(-6.3);      % First dissociation constant
K2 = 10^(-10.3);     % Second dissociation constant
Kw = 10^(-14);       % Water dissociation constant

% Calculate CO2 partial pressure for two years
pCO2_1958 = CO2ppm(1958);    % CO2 concentration in 1958 [ppm]
pCO2_2003 = CO2ppm(2003);    % CO2 concentration in 2003 [ppm]

% Initial conditions
pH0 = 6;                     % Initial pH
Hplus0 = 10.^-pH0;          % Initial H+ concentration

% Calculate H+ concentration and pH for both years
Hplus_1958 = ionConc_acidRain(1958);
Hplus_2003 = ionConc_acidRain(2003);

% Convert H+ concentration to pH
pH_1958 = -log10(Hplus_1958);
pH_2003 = -log10(Hplus_2003);

% Function to calculate CO2 concentration based on year
function p_co2 = CO2ppm(t)
    % Quadratic model for CO2 concentration
    % t is year, 1980.5 is reference year
    p_co2 = 0.011825 * (t - 1980.5)^2 + 1.356975 * (t - 1980.5) + 339;
end

% Function to calculate H+ concentration in acid rain
function Hplus = ionConc_acidRain(t)
    global K1 KH K2 Kw Hplus0
    
    % Get CO2 partial pressure for given year
    pCO2 = CO2ppm(t);
    
    % Nested function defining chemical equilibrium
    function eq = acidRainChemistry(Hplus)
        % Chemical equilibrium equation based on:
        % - Carbonic acid dissociation
        % - Water self-ionization
        eq = K1 * KH * pCO2 / (10^6 * Hplus) + ...            % HCO3- term
             2 * K2 * K1 * KH * pCO2 / (10^6 * Hplus^2) + ... % CO3^2- term
             Kw / Hplus - ...                                 % OH- term
             Hplus;                                           % H+ term
    end
    
    % Solve for H+ concentration using initial guess
    Hplus = fsolve(@acidRainChemistry, Hplus0);
end