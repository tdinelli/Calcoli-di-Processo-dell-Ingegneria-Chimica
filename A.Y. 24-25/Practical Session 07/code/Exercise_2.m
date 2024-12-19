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
clear, close, clc;

%% Data
A = 3.3375E+04;
B = 2.5864E+04;
C = 9.3280E+02;
D = 1.0880E+04;
E = 4.2370E+02;

% Heat capacity function [J/kmol*K]
cp = @(T) A + B.*(C./T./sinh(C./T)).^2 + D .* (E./T./cosh(E./T)).^2;

% Temperature range [K]
Tmin = 230 + 273.15;        % Convert from °C
Tmax = 480 + 273.15;
Tavg = (1500 + 100)/2;      % Average temperature
Trange = Tmin:0.01:Tmax;    % Temperature vector for calculations

ndot = 300/3600;            % Molar flow rate [mol/s]

% Heat capacity at key temperatures
cp1 = cp(Tmin);
cp2 = cp(Tmax);
cp3 = cp(Tavg);

%% Results
% Calculate cumulative integral of heat capacity
int(1) = cp(Tmin);
for i=1:length(Trange)-1
   int(i+1) = int(i) + trapezoidal(cp, Trange(i), Trange(i+1), 20);
end

% Calculate total integral with high precision
tic
int2 = trapezoidal(cp, Tmin, Tmax, 10000000);
toc

% Calculate power requirements [W]
Power = ndot * int2;                   % Using integrated cp
P1 = ndot * cp1 * (Tmax - Tmin);       % Using cp at Tmin
P2 = ndot * cp2 * (Tmax - Tmin);       % Using cp at Tmax
P3 = ndot * cp3 * (Tmax - Tmin);       % Using cp at Tavg

% Display results in MW
disp(['The necessary power is: ', num2str(Power/(1e6)), ' MW'])
disp(['The power for cp(100 K) is: ', num2str(P1/(1e6)), ' MW'])
disp(['The necessary cp(1500 K) is: ', num2str(P2/(1e6)), ' MW'])
disp(['The necessary cp(800 K) is: ', num2str(P3/(1e6)), ' MW'])

%% Plot heat capacity vs temperature
figure(1)
plot(Trange, cp(Trange), 'LineWidth', 2.2)
xlabel('Temperature [K]', 'FontSize', 18)
ylabel('Molar heat capacity [J/kmol*K]', 'FontSize', 18)