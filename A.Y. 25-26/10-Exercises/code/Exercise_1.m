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
% Exercise 1: Thermometer Heating System Start-up Dynamics
% This script models the temperature evolution of a spherical thermometer
% subjected to both radiative and convective heat transfer. The analysis
% includes:
% 1. Radiative heat transfer with walls using Stefan-Boltzmann law
% 2. Forced convective heat transfer with air using empirical correlations
% 3. Combined effects on temperature evolution
%
% Physical model assumptions:
% - Uniform temperature distribution in the thermometer
% - Constant material properties
% - Forced convection with laminar flow
% - Gray body radiation
% - Ideal gas behavior for air density
clear, close, clc

%% Data
global stefanBoltzmannConst surfaceArea wallTemp thermalConductivity ...
       diameter prandtlNumber pressure molarMass gasConstant ...
       airTemp thermometerMass specificHeat velocity viscosity

stefanBoltzmannConst = 5.67e-8;    % Stefan-Boltzmann constant [W/m2·K4]
gasConstant = 8.314;                % Universal gas constant [J/mol K]
molarMass = 0.028;                  % Molar mass of air [kg/mol]
pressure = 101325;                  % Atmospheric pressure [Pa]
thermalConductivity = 0.025;        % Thermal conductivity of air [W/m K]
viscosity = 1.81e-5;                % Dynamic viscosity of air [Pa s]
prandtlNumber = 0.7;                % Prandtl number for air
velocity = 1;                       % Air flow velocity [m/s]
diameter = 5e-3;                    % Thermometer diameter [m]
thermometerMass = 1e-2;             % Thermometer mass [kg]
specificHeat = 500;                 % Specific heat capacity [J/kg K]
surfaceArea = pi * diameter^2;      % Surface area of sphere: 4πr2 = πD2 [m2]

%% Temperature Conditions
% Convert all temperatures to Kelvin for calculations
wallTemp = 10 + 273.15;             % Wall temperature [K]
airTemp = 20 + 273.15;              % Air temperature [K]
initialTemp = 25 + 273.15;          % Initial thermometer temperature [K]

% Display initial conditions
fprintf('======================================================\n');
fprintf('Exercise 1: Thermometer Heating System Dynamics\n');
fprintf('======================================================\n\n');
fprintf('Initial Conditions:\n');
fprintf('Initial Temperature: %.2f °C\n', initialTemp - 273.15);
fprintf('Air Temperature: %.2f °C\n', airTemp - 273.15);
fprintf('Wall Temperature: %.2f °C\n', wallTemp - 273.15);
fprintf('Thermometer Diameter: %.1f mm\n', diameter * 1000);
fprintf('Thermometer Mass: %.1f g\n', thermometerMass * 1000);
fprintf('Air Velocity: %.1f m/s\n\n', velocity);

%% Solve Temperature Evolution
% Define simulation time span (1 hour = 3600 seconds)
timeSpan = [0, 3600];               % Time vector [seconds]

% Solve the ODE system
[timeVector, tempProfile] = ode45(@temperatureODE, timeSpan, initialTemp);

%% Results Analysis
% Calculate final temperature
finalTempCelsius = tempProfile(end) - 273.15;

% Display results
fprintf('Results after 1 hour:\n');
fprintf('Final Temperature: %.2f °C\n', finalTempCelsius);
fprintf('Temperature Change: %.2f °C\n', finalTempCelsius - (initialTemp - 273.15));
fprintf('\n======================================================\n');

%% Visualize Results
figure('Name', 'Thermometer Temperature Evolution', 'NumberTitle', 'off')

% Plot temperature profile in Celsius
plot(timeVector/60, tempProfile - 273.15, 'b-', 'LineWidth', 2)

% Add reference temperature lines
hold on
plot([0 max(timeVector)/60], [airTemp - 273.15, airTemp - 273.15], ...
     'g--', 'LineWidth', 1.5)
plot([0 max(timeVector)/60], [wallTemp - 273.15, wallTemp - 273.15], ...
     'r--', 'LineWidth', 1.5)
plot([0 max(timeVector)/60], [21.5, 21.5], ...
     'k:', 'LineWidth', 1.5)
hold off

% Customize plot
xlabel('Time [minutes]', 'FontSize', 12)
ylabel('Temperature [°C]', 'FontSize', 12)
title('Thermometer Temperature Evolution with Radiative and Convective Heat Transfer', 'FontSize', 14)
legend('Thermometer Temperature', 'Air Temperature', 'Wall Temperature', ...
       'Thermostat Threshold (21.5°C)', 'Location', 'best')
grid on
xlim([0 60])

%% Additional Analysis - Heat Transfer Components
figure('Name', 'Heat Transfer Analysis', 'NumberTitle', 'off')

% Calculate heat transfer components over time
radiativeHeat = zeros(length(timeVector), 1);
convectiveHeat = zeros(length(timeVector), 1);

for i = 1:length(timeVector)
    T = tempProfile(i);
    
    % Air density
    airDensity = pressure * molarMass / (gasConstant * T);
    
    % Reynolds number
    reynoldsNumber = airDensity * velocity * diameter / viscosity;
    
    % Nusselt number
    nusseltNumber = 0.4 * (reynoldsNumber^0.5) * (prandtlNumber^(1/3));
    
    % Heat transfer rates
    radiativeHeat(i) = stefanBoltzmannConst * surfaceArea * (T^4 - wallTemp^4);
    convectiveHeat(i) = (nusseltNumber * thermalConductivity * surfaceArea / ...
                         diameter) * (T - airTemp);
end

% Plot heat transfer components
subplot(2,1,1)
plot(timeVector/60, radiativeHeat, 'r-', 'LineWidth', 2)
hold on
plot(timeVector/60, convectiveHeat, 'b-', 'LineWidth', 2)
plot(timeVector/60, radiativeHeat + convectiveHeat, 'k-', 'LineWidth', 2)
hold off
xlabel('Time [minutes]', 'FontSize', 12)
ylabel('Heat Transfer Rate [W]', 'FontSize', 12)
title('Heat Transfer Components', 'FontSize', 12)
legend('Radiative (to walls)', 'Convective (to air)', 'Total', 'Location', 'best')
grid on
xlim([0 60])

subplot(2,1,2)
plot(timeVector/60, tempProfile - 273.15, 'b-', 'LineWidth', 2)
xlabel('Time [minutes]', 'FontSize', 12)
ylabel('Temperature [°C]', 'FontSize', 12)
title('Thermometer Temperature', 'FontSize', 12)
grid on
xlim([0 60])

%% ODE Function
function dTdt = temperatureODE(~, T)
    % temperatureODE - Calculates the rate of temperature change
    %
    % Energy balance: m*cp*dT/dt = -Q_rad - Q_conv
    % where:
    % Q_rad = σ*A*(T⁴ - T_wall⁴)  [heat loss to walls via radiation]
    % Q_conv = h*A*(T - T_air)     [heat loss to air via convection]
    % h = (Nu*k)/D                 [convective heat transfer coefficient]
    %
    % Parameters:
    %   ~   - Time (unused in autonomous ODE)
    %   T   - Current temperature [K]
    %
    % Returns:
    %   dTdt - Rate of temperature change [K/s]
    
    global stefanBoltzmannConst surfaceArea wallTemp thermalConductivity ...
           diameter prandtlNumber pressure molarMass gasConstant ...
           airTemp thermometerMass specificHeat velocity viscosity
    
    % Calculate air density using ideal gas law
    airDensity = pressure * molarMass / (gasConstant * T);    % [kg/m3]
    
    % Calculate Reynolds number for forced convection
    reynoldsNumber = airDensity * velocity * diameter / viscosity;
    
    % Calculate Nusselt number using empirical correlation
    % Nu_D = 0.4 * Re^0.5 * Pr^(1/3)
    nusseltNumber = 0.4 * (reynoldsNumber^0.5) * (prandtlNumber^(1/3));
    
    % Calculate heat transfer components
    % Radiative heat transfer (loss to cold walls)
    radiativeHeat = stefanBoltzmannConst * surfaceArea * ...
                    (T^4 - wallTemp^4);    % [W]
    
    % Convective heat transfer (loss to cooler air)
    convectiveHeat = (nusseltNumber * thermalConductivity * surfaceArea / ...
                     diameter) * (T - airTemp);    % [W]
    
    % Calculate temperature change rate
    % Both terms are positive when T > T_wall and T > T_air (heat loss)
    % Energy balance: m*cp*dT/dt = -Q_rad - Q_conv
    dTdt = -(radiativeHeat + convectiveHeat) / ...
           (thermometerMass * specificHeat);    % [K/s]
end