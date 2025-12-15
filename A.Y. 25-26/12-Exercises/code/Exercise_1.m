%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Global variables declaration for use across functions
global Qin Q13 Q42 Q12 Q23 Q34 Qout CAin kV 

%% INPUT DATA 

% Input flow rate [L/h]
Qin = 10;
% Recycle flow rate from reactor 1 to 3 [L/h]
Q13 = 5;
% Recycle flow rate from reactor 4 to 3 [L/h]
Q42 = 3;
% Input concentration of component A [mol/L]
CAin = 1;
% Input concentration of component B [mol/L]
CBin = 0;

% Reactor volumes [L]
V = [25 75 100 25];
% Kinetic constants [h^-1]
k = [0.05 0.1 0.5 0.1];

% Calculate k*V terms for reaction rate expressions
kV = k.*V;

% Calculate intermediate flow rates based on mass balances
Q12 = Qin - Q13;      % Flow from reactor 1 to 2
Q23 = Q12;            % Flow from reactor 2 to 3
Q34 = Q23 + Q13 + Q42;% Flow from reactor 3 to 4
Qout = Q34 - Q42;     % Output flow

% Initial guess for solver
% [CA1 CA2 CA3 CA4 CB1 CB2 CB3 CB4]
x0 = [0.89 0.8 0.5 0.3 0.01 0.34 0.66 0.8];

% Solve the system of equations using fsolve
concentrations = fsolve(@linSystem, x0);

% Function that defines the system of equations
function eq = linSystem(x)
    global Qin Q13 Q42 Q12 Q23 Q34 Qout CAin kV

    % Extract concentrations from solution vector
    % Concentrations of component A in reactors 1-4
    CA1 = x(1);
    CA2 = x(2);
    CA3 = x(3);
    CA4 = x(4);

    % Concentrations of component B in reactors 1-4
    CB1 = x(5);
    CB2 = x(6);
    CB3 = x(7);
    CB4 = x(8);

    % Mass balance equations for component A in each reactor
    % Format: Input flows - Output flows - Reaction term = 0
    eq(1) = Qin*CAin - Q13*CA1 - Q12*CA1 - kV(1)*CA1;      % Reactor 1
    eq(2) = Q12*CA1 - Q23*CA2 - kV(2)*CA2;                 % Reactor 2
    eq(3) = Q23*CA2 + Q13*CA1 + Q42*CA4 - Q34*CA3 - kV(3)*CA3; % Reactor 3
    eq(4) = Q34*CA3 - Q42*CA4 - Qout*CA4 - kV(4)*CA4;      % Reactor 4

    % Mass balance equations for component B in each reactor
    % Format: Input flows - Output flows + Reaction term = 0
    eq(5) = -Q13*CB1 - Q12*CB1 + kV(1)*CA1;                % Reactor 1
    eq(6) = Q12*CB1 - Q23*CB2 + kV(2)*CA2;                 % Reactor 2
    eq(7) = Q23*CB2 + Q13*CB1 + Q42*CB4 - Q34*CB3 + kV(3)*CA3; % Reactor 3
    eq(8) = Q34*CB3 - Q42*CB4 - Qout*CB4 + kV(4)*CA4;      % Reactor 4
end
