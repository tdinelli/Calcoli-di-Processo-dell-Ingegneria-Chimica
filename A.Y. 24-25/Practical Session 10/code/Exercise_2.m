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
% Heat Transfer Analysis with Chemical Reaction
% This script models the temperature evolution of a reacting solution,
% considering both the heat of reaction and cooling to ambient conditions.
% The analysis includes:
% 1. Initial temperature calculation from reaction enthalpy
% 2. Temperature profile over time using Newton's law of cooling
% 3. Determination of time required to reach target temperature
%
% Physical model:
% - Assumes well-mixed solution
% - Considers instantaneous reaction
% - Uses Newton's law of cooling for heat transfer
clear all
close all
clc

%% Data
global heatTransferArea ambientTemp heatTransferCoeff totalMass specificHeat initialTemp finalTemp

ambientTemp = 26;     % Ambient temperature [°C]
specificHeat = 4.186; % Specific heat capacity of solution [kJ/kg/°C]
totalMass = 0.2;      % Total mass of solution [kg]
heatTransferArea = 0.15 * 0.1; % Surface area for heat transfer [m²]
heatTransferCoeff = 0.040;     % Heat transfer coefficient [kJ/m²s°C]

reactionEnthalpy = 26200; % Enthalpy change of reaction [kJ/kmol]
molarMass = 80;           % Molar mass of solute [kg/kmol]
soluteMass = 0.06;        % Mass of solute [kg]
finalTemp = 14;           % Target final temperature [°C]

%% Initial Temperature Calculation
% Calculate initial temperature after instantaneous reaction
% Energy balance: Q_reaction = m_total * Cp * ΔT
initialTemp = ambientTemp - ...
    (reactionEnthalpy * soluteMass / molarMass) / (specificHeat * totalMass);

% Display initial conditions
fprintf('Initial Conditions:\n');
fprintf('Initial Temperature: %.2f °C\n', initialTemp);
fprintf('Target Temperature: %.2f °C\n', finalTemp);

%% Solve Temperature Evolution
% Define time span for solution (0 to 26 hours, sampled every minute)
timeSpan = 0:60:26*60;  % Time vector [seconds]

% Solve the ODE system
[timeVector, tempProfile] = ode45(@temperatureODE, timeSpan, initialTemp);

%% Find Time to Reach Target Temperature
% First approximation using discrete solution
index = find(tempProfile > finalTemp, 1);  % Find first point above target
timeToReachFinalTemp = timeVector(index) / 60;  % Convert to minutes

% Refine solution using root finding
exactTime = fzero(@exactSolution, timeToReachFinalTemp);

% Display results
fprintf('\nResults:\n');
fprintf('Time to reach %.2f °C: %.2f minutes\n', finalTemp, exactTime);

%% Visualize Results
figure('Name', 'Temperature Profile', 'NumberTitle', 'off')

% Plot temperature profile
plot(timeVector/60, tempProfile, 'b-', 'LineWidth', 2)

% Add target temperature line
hold on
plot([0 max(timeVector)/60], [finalTemp finalTemp], 'r--', 'LineWidth', 1.5)
hold off

% Customize plot
xlabel('Time [min]', 'FontSize', 12)
ylabel('Temperature [°C]', 'FontSize', 12)
title('Temperature Evolution of Reacting Solution', 'FontSize', 14)
legend('Solution Temperature', 'Target Temperature', 'Location', 'best')
grid on

% Add annotations
text(exactTime, finalTemp, sprintf(' Target reached\n at %.1f min', exactTime), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left')

%% Helper Functions
function residual = exactSolution(time)
    % exactSolution - Calculates the difference between achieved and 
    % target temperature
    %
    % Parameters:
    %   time - Time point at which to evaluate temperature [minutes]
    %
    % Returns:
    %   residual - Difference between target and achieved temperature [°C]
    
    global initialTemp finalTemp
    
    % Solve ODE up to specified time (converting minutes to seconds)
    [~, tempProfile] = ode45(@temperatureODE, [0, time * 60], initialTemp);
    
    % Calculate difference from target
    residual = finalTemp - tempProfile(end);
end

function dTdt = temperatureODE(~, T)
    % temperatureODE - Defines the rate of temperature change
    %
    % Implementation of Newton's Law of Cooling:
    % dT/dt = h*A*(T_ambient - T)/(m*Cp)
    %
    % Parameters:
    %   ~   - Time (unused in autonomous ODE)
    %   T   - Current temperature [°C]
    %
    % Returns:
    %   dTdt - Rate of temperature change [°C/s]
    
    global heatTransferArea ambientTemp heatTransferCoeff totalMass specificHeat
    
    % Calculate temperature change rate
    dTdt = (ambientTemp - T) * (heatTransferCoeff * heatTransferArea) / ...
           (specificHeat * totalMass);
end