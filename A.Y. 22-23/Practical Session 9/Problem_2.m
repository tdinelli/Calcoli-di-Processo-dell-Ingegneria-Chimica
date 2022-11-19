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

cp = @(T) A + B.*(C./T./sinh(C./T)).^2 + D .* (E./T./cosh(E./T)).^2; % J/kmol*K

Tmin = 230 + 273.15; % K
Tmax = 480 + 273.15; % K
Tavg = (1500 + 100)/2;
Trange = Tmin:0.01:Tmax;
ndot = 300/3600; % mol/s

cp1 = cp(Tmin);
cp2 = cp(Tmax);
cp3 = cp(Tavg);
%% Results

int(1) = cp(Tmin);
for i=1:length(Trange)-1
    int(i+1) = int(i) + trapezoidal(cp, Trange(i), Trange(i+1), 20);
end

tic
int2 = trapezoidal(cp, Tmin, Tmax, 10000000);
toc

Power = ndot * int2; % J/s or W
P1 = ndot * cp1 * (Tmax - Tmin);
P2 = ndot * cp2 * (Tmax - Tmin);
P3 = ndot * cp3 * (Tmax - Tmin);

disp(['The necessary power is: ', num2str(Power/(1e6)), ' MW'])

disp(['The power for cp(100 K)  is: ', num2str(P1/(1e6)), ' MW'])
disp(['The necessary cp(1500 K) is: ', num2str(P2/(1e6)), ' MW'])
disp(['The necessary cp(800 K)  is: ', num2str(P3/(1e6)), ' MW'])

%% Plot

figure(1)
plot(Trange, cp(Trange), 'LineWidth', 2.2)
xlabel('Temperature [K]', 'FontSize', 18)
ylabel('Molar heat capacity [J/kmol*K]', 'FontSize', 18)

