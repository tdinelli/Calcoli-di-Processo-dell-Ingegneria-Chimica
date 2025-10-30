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
% Clear workspace, figures, and command window
clear variables
close
clc

%% Problem Setup
% Define system conditions and composition

P = 1;                    % System pressure in atmospheres
names = ['NC6'; 'NC7'];  % Components in mixture (n-hexane and n-heptane)
mole_fractions = [0.7 0.3]; % Respective mole fractions of components

%% Solve for Bubble Point Temperature
% Calculate bubble point temperature using two different methods
% Both methods start with an initial guess of 300 K

% Method 1: Using fsolve
[Bubble_temperature_solve, val_solve, exit_solve] = Tbubble(P,...
    names, mole_fractions, 300, 'solve');

% Method 2: Using fzero
[Bubble_temperature_zero, val_zero, exit_zero] = Tbubble(P, ...
    names, mole_fractions, 300, 'fzero');

%% Function Definitions

function [T, fval, exitFlag] = Tbubble(P, speciesname, comp, FG, solver)
    % Calculate bubble point temperature for a mixture
    %
    % Inputs:
    %   P           - System pressure (atm)
    %   speciesname - Array of component names
    %   comp        - Array of component mole fractions
    %   FG          - First guess for temperature (K)
    %   solver      - Solver choice ('solve' for fsolve or 'fzero')
    %
    % Outputs:
    %   T        - Bubble point temperature (K)
    %   fval     - Function value at solution
    %   exitFlag - Solver exit flag

    % Set optimization options
    options = optimset('Display','iter','PlotFcns',...
        {@optimplotx,@optimplotfval}); % Show iteration progress and plots

    function sum = fbubble(T)
        % Objective function for bubble point calculation
        % Uses Raoult's law: sum(y_i) = sum(x_i * P_i^sat/P) = 1
        %
        % Input: T - Temperature (K)
        % Output: sum - Difference from unity for vapor phase mole
        % fractions
        
        sum = 0.;
        [nname, ~] = size(speciesname);
        
        % Calculate sum of vapor mole fractions
        for i = 1:nname
            % Apply Raoult's law for each component
            % y_i = x_i * P_i^sat/P
            sum = sum + PVap4Comp(T,speciesname(i,:)) / P * comp(i);
        end
        
        sum = sum - 1.; % Should equal zero at bubble point
    end 
   
    % Choose and execute appropriate solver
    if solver=='solve'
        [T, fval, exitFlag] = fsolve(@fbubble, FG, options);
    elseif solver=='fzero'
        [T, fval, exitFlag] = fzero(@fbubble, FG, options);
    end
end

function P = PVap4Comp(T,comp)
    % Calculate vapor pressure for various components
    %
    % Inputs:
    %   T    - Temperature (K)
    %   comp - Component name (3 characters)
    %
    % Output:
    %   P    - Vapor pressure (atm)
    %
    % Uses different vapor pressure equations depending on the component:
    % 1. Extended Antoine equation for H2O, NC6, NC7
    % P = exp(A + B/T + C*ln(T) + D*T^E)/101325
    %
    % 2. Modified Antoine equation for NC3, IC4, NC4, NC5
    % P = 10^(A + B/T + C*log10(T) + D*T + E*T^2)/760
    
    % Select appropriate coefficients and equation form based on component
    if comp=='H2O'
        % Water coefficients
        A =  7.3649E+01;
        B = -7.2582E+03;
        C = -7.3037E+00;
        D =  4.1653E-06;
        E =  2.0000E+00;
        P = exp(A + B/T + C*log(T) + D*T^E)/101325.;
    elseif comp=='NC6'
        % n-Hexane coefficients
        A = 10.465E+01;
        B = -6.9955E+03;
        C = -1.2702E+01;
        D =  1.2381E-05;
        E =  2.0000E+00;
        P = exp(A + B/T + C*log(T) + D*T^E)/101325.;
    elseif comp=='NC7'      
        A =  8.7829E+01;
        B = -6.9964E+03;
        C = -9.8802E+00;
        D =  7.2099E-06;
        E =  2.0000E+00;   
        P = exp(A + B/T + C*log(T) + D*T^E)/101325.;
    elseif comp=='NC3'
        A=21.447;
        B=-1462.7;
        C=-5.261;
        D=3.2820E-11;
        E=3.7349E-06;
        P=10^(A + B/T + C*log10(T) + D*T + E*T^2)/760;   
    elseif comp=='IC4'
        A=31.254;	
        B=-1953.2;	
        C=-8.806;
        D=8.9246E-11;
        E=5.7501E-06;
        P=10^(A + B/T + C*log10(T) + D*T + E*T^2)/760;
    elseif comp=='NC4'
        A=27.044;	
        B=-1904.9;
        C=-7.1805;
        D=-6.6845E-11;
        E=4.2190E-06;
        P=10^(A + B/T + C*log10(T) + D*T + E*T^2)/760;
    elseif comp=='NC5'
        A=33.324;
        B=-2422.7;
        C=-9.2354;
        D=9.0199E-11;
        E=4.1050E-06;
        P=10^(A + B/T + C*log10(T) + D*T + E*T^2)/760;
    end
end