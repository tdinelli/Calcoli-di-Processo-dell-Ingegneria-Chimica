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
% Define global variables
global h D Bconc0 nx

%% Data
end_brine = 10;     % End time for simulation (days)
thickness = .05;    % Membrane thickness (meters)
nx = 10;            % Number of spatial points
h = thickness/2/nx; % Spatial step size
x = h:h:thickness;  % Create spatial grid
x = [0 x];          % Add point at x=0
Bconc0 = 200;       % Initial concentration at boundary
D = 2e-10*3600*24;  % Diffusion coefficient (converted from m²/s to m²/day)

%% Solution
% Solve system of ODEs using ode45
[t, C] = ode45(@ODEsys, 0:1:end_brine, [zeros(nx,1)]);

%% Plots
% Figure 1: Concentration profiles over time
figure(1)
% Plot concentration profile at each time step
for i = 1:length(t)
    % Create symmetric concentration profile and plot
    plot(x, ([Bconc0 C(i,1:nx) C(i,nx-1:-1:1) Bconc0]),'-o');
    hold on;
end
hold off;

% Figure 2: Concentration at center point over time
figure(2)
plot(t, C(:,nx));
hold off;

% Find time when concentration reaches 60 units
time = ceil(fzero(@tempAlg,10));

% Test the ODE system
x = 1:10;
Test = ODEsys(0, x);

%% Functions definition
% Function to find when concentration reaches 60
function err = tempAlg(t)
    global nx
    % Solve ODEs up to time t using stiff solver ode23s
    [t,C] = ode23s(@ODEsys, [0 t], [zeros(nx,1)]);
    % Return difference from target concentration (60)
    err = C(end,nx) - 60;
end

% Main ODE system representing diffusion equation
function dCdt = ODEsys(t,C)
    global h D Bconc0 nx

    % Boundary point (using symmetry)
    dCdt(1,1) = D*(Bconc0 - 2*C(1) + C(2))/h^2;

    % Interior points
    for i = 2:nx-1
        dCdt(i,1) = D*(C(i-1) - 2*C(i) + C(i+1))/h^2;
    end

    % Center point (using symmetry)
    dCdt(nx,1) = D*2*(C(nx-1) - C(nx))/h^2;
end
