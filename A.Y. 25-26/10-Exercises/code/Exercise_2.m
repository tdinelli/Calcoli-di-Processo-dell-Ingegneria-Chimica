%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _ ____     %
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
% Exercise 2: Cold Pack Temperature Evolution
% This script models the temperature evolution of a cold pack after
% activation of an endothermic dissolution reaction.
% The analysis includes:
% 1. Initial temperature calculation from endothermic reaction enthalpy
% 2. Temperature profile over time using Newton's law of cooling
% 3. Determination of effectiveness duration (time to reach 16°C)
%
% Physical model:
% - Assumes well-mixed solution
% - Instantaneous dissolution of NH4NO3
% - Newton's law of cooling for heat transfer with environment
clear, close, clc

%% Data
global heatTransferArea ambientTemp heatTransferCoeff totalMass specificHeat

% Environmental conditions
ambientTemp = 26;     % External ambient temperature [°C]

% Cold pack properties
totalMass = 200;      % Total mass of cold pack [g]
waterMass = 140;      % Mass of water [g]
saltMass = 60;        % Mass of NH4NO3 salt [g] (200 - 140)

% Thermal properties
specificHeat = 4.186; % Specific heat capacity of solution [J/g°C]

% Heat transfer parameters
packLength = 0.15;    % Pack length [m]
packWidth = 0.10;     % Pack width [m]
heatTransferArea = 2 * packLength * packWidth; % Surface area (both sides) [m2]
heatTransferCoeff = 40;  % Heat transfer coefficient [W/m2°C] = [J/s/m2°C]

% Dissolution reaction properties
solutionEnthalpy = 26.2;  % Solution enthalpy [kJ/mol] (endothermic, positive)
molarMass = 80;           % Molar mass of NH4NO3 [g/mol]

% Target temperature (effectiveness threshold)
thresholdTemp = 16;       % Cold pack loses effectiveness above this [°C]

%% Initial Temperature Calculation (T0)
% Energy balance for endothermic dissolution:
% Q_absorbed = n * ΔH_solution = m_total * Cp * ΔT
% ΔT = (n * ΔH_solution) / (m_total * Cp)
% T_final = T_initial + ΔT

% Calculate moles of salt
molesOfSalt = saltMass / molarMass;  % [mol]

% Calculate heat absorbed (endothermic reaction, cools the solution)
heatAbsorbed = molesOfSalt * solutionEnthalpy;  % [kJ]

% Convert to consistent units
heatAbsorbed = heatAbsorbed * 1000;  % [J]

% Calculate temperature drop
tempDrop = heatAbsorbed / (totalMass * specificHeat);  % [°C]

% Initial temperature after reaction
initialTemp = ambientTemp - tempDrop;  % [°C]

% Display initial conditions
fprintf('======================================================\n');
fprintf('Exercise 2: Cold Pack Temperature Evolution\n');
fprintf('======================================================\n\n');
fprintf('Cold Pack Properties:\n');
fprintf('Total mass: %.0f g\n', totalMass);
fprintf('Water mass: %.0f g\n', waterMass);
fprintf('NH4NO3 mass: %.0f g\n', saltMass);
fprintf('Moles of NH4NO3: %.3f mol\n', molesOfSalt);
fprintf('Surface area: %.4f m²\n', heatTransferArea);
fprintf('\nThermal Analysis:\n');
fprintf('Ambient temperature: %.2f °C\n', ambientTemp);
fprintf('Heat absorbed by dissolution: %.2f J\n', heatAbsorbed);
fprintf('Temperature drop: %.2f °C\n', tempDrop);
fprintf('Initial temperature (T0): %.2f °C\n', initialTemp);
fprintf('Effectiveness threshold: %.2f °C\n\n', thresholdTemp);

%% Solve Temperature Evolution
% Define time span for solution (0 to 120 minutes)
timeSpan = 0:1:120*60;  % Time vector [seconds], sampled every second

% Solve the ODE system
[timeVector, tempProfile] = ode45(@temperatureODE, timeSpan, initialTemp);

%% Find Time to Reach Threshold Temperature
% Find when temperature exceeds threshold
indexAboveThreshold = find(tempProfile >= thresholdTemp, 1);

if ~isempty(indexAboveThreshold)
    % Refine solution using interpolation
    if indexAboveThreshold > 1
        % Linear interpolation for more accurate time
        t1 = timeVector(indexAboveThreshold - 1);
        t2 = timeVector(indexAboveThreshold);
        T1 = tempProfile(indexAboveThreshold - 1);
        T2 = tempProfile(indexAboveThreshold);
        
        % Interpolate to find exact crossing time
        effectiveDuration = t1 + (thresholdTemp - T1) * (t2 - t1) / (T2 - T1);
    else
        effectiveDuration = timeVector(indexAboveThreshold);
    end
    
    effectiveDurationMinutes = effectiveDuration / 60;
    
    fprintf('Results:\n');
    fprintf('Time to reach %.2f °C: %.2f minutes\n', thresholdTemp, effectiveDurationMinutes);
    fprintf('Cold pack effectiveness duration: %.2f minutes\n', effectiveDurationMinutes);
else
    fprintf('Results:\n');
    fprintf('Temperature never reaches %.2f °C within simulation time.\n', thresholdTemp);
    effectiveDurationMinutes = NaN;
end

fprintf('\n======================================================\n');

%% Visualize Results
figure('Name', 'Cold Pack Temperature Profile', 'NumberTitle', 'off')

% Plot temperature profile
plot(timeVector/60, tempProfile, 'b-', 'LineWidth', 2)

% Add reference lines
hold on
plot([0 max(timeVector)/60], [thresholdTemp thresholdTemp], 'r--', 'LineWidth', 1.5)
plot([0 max(timeVector)/60], [ambientTemp ambientTemp], 'k:', 'LineWidth', 1.5)

% Add effectiveness duration marker
if ~isnan(effectiveDurationMinutes)
    plot(effectiveDurationMinutes, thresholdTemp, 'ro', 'MarkerSize', 10, 'LineWidth', 2)
    xline(effectiveDurationMinutes, 'r:', 'LineWidth', 1);
end
hold off

% Customize plot
xlabel('Time [minutes]', 'FontSize', 12)
ylabel('Temperature [°C]', 'FontSize', 12)
title('Cold Pack Temperature Evolution', 'FontSize', 14)
legend('Cold Pack Temperature', 'Effectiveness Threshold (16°C)', ...
       'Ambient Temperature (26°C)', 'Location', 'southeast')
grid on
xlim([0 120])

% Add annotation
if ~isnan(effectiveDurationMinutes)
    text(effectiveDurationMinutes + 2, thresholdTemp - 1, ...
         sprintf('Effectiveness lost\nat %.1f min', effectiveDurationMinutes), ...
         'FontSize', 10, 'Color', 'r')
end

%% Additional Analysis - Cooling Rate
figure('Name', 'Cooling Rate Analysis', 'NumberTitle', 'off')

% Calculate cooling rate
coolingRate = zeros(length(timeVector), 1);
for i = 1:length(timeVector)
    coolingRate(i) = (ambientTemp - tempProfile(i)) * ...
                     (heatTransferCoeff * heatTransferArea) / ...
                     (specificHeat * totalMass);
end

subplot(2,1,1)
plot(timeVector/60, coolingRate, 'r-', 'LineWidth', 2)
xlabel('Time [minutes]', 'FontSize', 12)
ylabel('dT/dt [°C/s]', 'FontSize', 12)
title('Heating Rate (due to heat transfer from environment)', 'FontSize', 12)
grid on
xlim([0 120])

subplot(2,1,2)
plot(timeVector/60, tempProfile, 'b-', 'LineWidth', 2)
hold on
plot([0 max(timeVector)/60], [thresholdTemp thresholdTemp], 'r--', 'LineWidth', 1.5)
hold off
xlabel('Time [minutes]', 'FontSize', 12)
ylabel('Temperature [°C]', 'FontSize', 12)
title('Cold Pack Temperature', 'FontSize', 12)
grid on
xlim([0 120])

%% ODE Function
function dTdt = temperatureODE(~, T)
    % temperatureODE - Defines the rate of temperature change
    %
    % Implementation of Newton's Law of Cooling:
    % dT/dt = (T_ambient - T) * (U * A) / (m * Cp)
    %
    % where:
    % - U: heat transfer coefficient [W/m2°C]
    % - A: surface area [m2]
    % - m: mass [g]
    % - Cp: specific heat capacity [J/g°C]
    %
    % Parameters:
    %   ~   - Time (unused in autonomous ODE)
    %   T   - Current temperature [°C]
    %
    % Returns:
    %   dTdt - Rate of temperature change [°C/s] 
    global heatTransferArea ambientTemp heatTransferCoeff totalMass specificHeat
    
    % Calculate temperature change rate
    % Positive when T < T_ambient (heating up)
    dTdt = (ambientTemp - T) * (heatTransferCoeff * heatTransferArea) / ...
           (specificHeat * totalMass);
end