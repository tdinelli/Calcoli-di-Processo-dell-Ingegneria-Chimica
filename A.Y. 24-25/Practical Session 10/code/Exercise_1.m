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
% Plate Cooling Analysis with Radiative and Convective Heat Transfer
% This script models the temperature evolution of a plate subjected to both
% radiative and convective heat transfer. The analysis includes:
% 1. Radiative heat transfer using Stefan-Boltzmann law
% 2. Forced convective heat transfer with empirical correlations
% 3. Combined effects on temperature evolution
%
% Physical model assumptions:
% - Uniform temperature distribution in the plate
% - Constant material properties
% - Forced convection with laminar flow
% - Gray body radiation
% - Ideal gas behavior for air density
clear all
close all
clc

%% Data
global stefanBoltzmannConst surfaceArea plateTemp thermalConductivity ...
       diameter prandtlNumber pressure molarMass gasConstant ...
       ambientTemp plateMass specificHeat velocity viscosity

stefanBoltzmannConst = 5.67e-8;    % Stefan-Boltzmann constant [W/m²·K⁴]
gasConstant = 8.314;               % Universal gas constant [J/mol·K]
molarMass = 0.028;                 % Molar mass of air [kg/mol]
pressure = 101325;                 % Atmospheric pressure [Pa]
thermalConductivity = 0.025;       % Thermal conductivity of air [W/m·K]
viscosity = 1.81e-5;               % Dynamic viscosity of air [Pa·s]
prandtlNumber = 0.7;               % Prandtl number for air
velocity = 1;                      % Air flow velocity [m/s]
diameter = 5e-3;                   % Plate diameter [m]
plateMass = 1e-2;                  % Plate mass [kg]
specificHeat = 500;                % Specific heat capacity [J/kg·K]
surfaceArea = pi * (diameter^2);   % Surface area [m²]

%% Temperature Conditions
% Convert all temperatures to Kelvin for calculations
plateTemp = 10 + 273.15;           % Target plate temperature [K]
ambientTemp = 20 + 273.15;         % Ambient temperature [K]
initialTemp = 25 + 273.15;         % Initial plate temperature [K]

% Display initial conditions
fprintf('Initial Conditions:\n');
fprintf('Initial Temperature: %.2f °C\n', initialTemp - 273.15);
fprintf('Ambient Temperature: %.2f °C\n', ambientTemp - 273.15);
fprintf('Target Temperature: %.2f °C\n', plateTemp - 273.15);

%% Solve Temperature Evolution
% Define simulation time span (30 minutes)
timeSpan = [0, 1800];              % Time vector [seconds]

% Solve the ODE system
[timeVector, tempProfile] = ode45(@temperatureODE, timeSpan, initialTemp);

%% Results Analysis
% Calculate final temperature
finalTempCelsius = tempProfile(end) - 273.15;

% Display results
fprintf('\nResults:\n');
fprintf('Final Temperature: %.2f °C\n', finalTempCelsius);
fprintf('Temperature Change: %.2f °C\n', finalTempCelsius - (initialTemp - 273.15));

%% Visualize Results
figure('Name', 'Plate Cooling Profile', 'NumberTitle', 'off')

% Plot temperature profile in Celsius
plot(timeVector, tempProfile - 273.15, 'b-', 'LineWidth', 2)

% Add target temperature line
hold on
plot([0 max(timeVector)], [plateTemp - 273.15, plateTemp - 273.15], ...
     'r--', 'LineWidth', 1.5)
hold off

% Customize plot
xlabel('Time [s]', 'FontSize', 12)
ylabel('Temperature [°C]', 'FontSize', 12)
title('Plate Temperature Evolution with Combined Heat Transfer', 'FontSize', 14)
legend('Plate Temperature', 'Target Temperature', 'Location', 'best')
grid on

%% ODE Function
function dTdt = temperatureODE(~, T)
    % temperatureODE - Calculates the rate of temperature change
    %
    % Combines radiative and convective heat transfer:
    % dT/dt = (Q_conv - Q_rad)/(m*cp)
    % where:
    % Q_rad = σ*A*(T⁴ - T_plate⁴)
    % Q_conv = h*A*(T_ambient - T)
    % h = (Nu*k)/D
    %
    % Parameters:
    %   ~   - Time (unused in autonomous ODE)
    %   T   - Current temperature [K]
    %
    % Returns:
    %   dTdt - Rate of temperature change [K/s]
    
    global stefanBoltzmannConst surfaceArea plateTemp thermalConductivity ...
           diameter prandtlNumber pressure molarMass gasConstant ...
           ambientTemp plateMass specificHeat velocity viscosity
    
    % Calculate air density using ideal gas law
    airDensity = pressure * molarMass / (gasConstant * T);    % [kg/m³]
    
    % Calculate Reynolds number for forced convection
    reynoldsNumber = airDensity * velocity * diameter / viscosity;
    
    % Calculate Nusselt number using empirical correlation
    % Valid for: Re^(1/2) * Pr^(1/3) > 0.2
    nusseltNumber = 0.4 * (reynoldsNumber^0.5) * (prandtlNumber^(1/3));
    
    % Calculate heat transfer components
    % Radiative heat transfer
    radiativeHeat = stefanBoltzmannConst * surfaceArea * ...
                    (T^4 - plateTemp^4);    % [W]
    
    % Convective heat transfer
    convectiveHeat = (nusseltNumber * thermalConductivity * surfaceArea / ...
                     diameter) * (ambientTemp - T);    % [W]
    
    % Calculate temperature change rate
    dTdt = (-radiativeHeat + convectiveHeat) / ...
           (plateMass * specificHeat);    % [K/s]
end