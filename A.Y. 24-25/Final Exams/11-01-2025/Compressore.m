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
% Global parameters for thermodynamic calculations
global R gamma Eff MW Qm Pin Pfin Tair UA Cpair QmSI
R = 8.31;         % Universal gas constant (J/mol/K)
Cpair = 1006;     % Specific heat of air at constant pressure (J/kg/K)
Cvair = 717.5;    % Specific heat of air at constant volume (J/kg/K)
gamma = Cpair/Cvair; % Heat capacity ratio
Eff = 0.72;       % Efficiency
Tnorm = 273.15;   % Normal temperature (K)
Pnorm = 101325;   % Normal pressure (Pa)
UA = 100;         % Heat transfer coefficient (W/s/K)
MW = 28.96;       % Molecular weight of air (g/mol)
Cost_Energy = 0.15; % Energy cost (Eur/kWh)
Pin = 1e5;        % Initial pressure
Pfin = 1e6;       % Final pressure
Tair = 298.15;    % Air temperature

% Mass flow rate calculation
Qm = 500*Pnorm/(R*Tnorm)*MW/1000; % kg/h
QmSI = Qm/3600;   % kg/s

% Generate pressure range for analysis
Pint = Pin:50000:Pfin;

% Iterate through pressure ranges
for i = 1:length(Pint)
    % Calculate power and outlet temperature for each pressure
    [Pwr_1st, Tout(i)] = PowerC(Pin, Pint(i), Tair);

    % Calculate successive temperature
    Tsuc2(i) = (Tout(i)-Tair)*exp(-UA/QmSI/Cpair) + Tair;

    % Calculate total power
    Power(i) = obj_fn(Pint(i));
end

% Plotting results
figure(1)
subplot(1,2,1)
plot(Pint, Power)
subplot(1,2,2)
plot(Pint, Tout, Pint, Tsuc2)

% Test calculations
[PwrComp, Tdis] = PowerC(1e5, 5e5, 300);
Pwr_tot = obj_fn(5.e5);

% Optimization settings
options = optimoptions("fmincon", "FunctionTolerance", 1e-20, "StepTolerance", 1e-30);
lb = 1e5;
ub = 1e6;

% Find optimal pressure
P_opt = fmincon(@obj_fn, 5e5, [], [], [], [], lb, ub, [], options);
P_sol = P_opt/1e5;

% Calculate savings
[Pwr_1st, Tout1] = PowerC(Pin, P_opt, Tair);
Tsuc2 = (Tout1-Tair)*exp(-UA/QmSI/Cpair) + Tair;
[Pwr_2nd, Tout2stage] = PowerC(P_opt, Pfin, Tsuc2);
Pwr2stage = Pwr_1st + Pwr_2nd;
[Pwr1stage, Tout1stage] = PowerC(Pin, Pfin, Tair);
Savings = (Pwr1stage-Pwr2stage)*6000*Cost_Energy;

% Objective function to minimize total power
function Pwr_tot = obj_fn(Pout_1st_stage)
    global Tair Pin Pfin UA QmSI Cpair

    % Calculate first stage power and temperature
    [Pwr_1st, Tout_1st] = PowerC(Pin, Pout_1st_stage, Tair);

    % Calculate exchange temperature
    Tout_excng = (Tout_1st-Tair)*exp(-UA/QmSI/Cpair) + Tair;

    % Calculate second stage power
    [Pwr_2nd, Tout_2nd] = PowerC(Pout_1st_stage, Pfin, Tout_excng);

    % Total power is sum of both stages
    Pwr_tot = Pwr_1st + Pwr_2nd;
end

% Power and discharge temperature calculation function
function [PwrComp, Tdis] = PowerC(Psuc, Pout, Tsuc)
    global R gamma Eff MW Qm

    % Calculate discharge temperature
    Tdis = Tsuc*(Pout/Psuc)^((gamma-1)/gamma);

    % Calculate compressor power
    PwrComp = 2.31*gamma/(gamma-1)*(Tdis-Tsuc)/MW*Qm/1000*Eff;
end
