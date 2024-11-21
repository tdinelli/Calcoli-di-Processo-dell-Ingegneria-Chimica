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
% Define flow rate function q(t) with sinusoidal daily pattern [L/h]
q = @(t) (2 .* (sin((t./24).*pi).^2)).*60; 

total_time = 24;                    % Simulation duration [h]
time = 0:0.0001:total_time*2;       % Time vector for plotting [h]
t = 1:1:49;                         % Time points for volume calculation
tt = 0:1:24;                        % Time points for trapz integration

%% Solution
% Calculate cumulative volume over time with daily reset
V(1) = 0;
for i = 1:1:48
   if i == 24
       % Reset volume at 24h mark
       V(i) = 0;
       V(i+1) = 0;
   else
       % Integrate flow rate to get volume change
       V(i+1) = V(i) + trapezoidal(q, i+1, i+2, 10);
   end
end

% Display results using different integration methods
disp(['The volume of the tank is: ', num2str(V(end)), ' L'])
disp(['Trapezoidal: ', num2str(trapezoidal(q,0,24,30))])
disp(['Matlab numerical integral built-in', num2str(integral(q,0,24))])

%% Benchmarks
% Compare performance of different integration methods
tic
I1 = trapezoidal(q,0,24,34);        % Custom trapezoidal
toc
tic
I2 = integral(q,0,24);              % MATLAB built-in
toc
tic
I3 = trapz(q(tt));                  % MATLAB trapz
toc
tic
I4 = trapezoidal_Ait(q,0,24,1000); % Aitken extrapolation
toc

% Display integration errors between methods
disp(['Error 1-2: ', num2str(I1 - I2)])
disp(['Error 1-3: ', num2str(I1 - I3)])
disp(['Error 2-3: ', num2str(I2 - I3)])

%% Plots
figure(1)
hold on
% Plot flow rate
plot(time, q(time), 'LineWidth', 2.2)
xlabel('time [h]', 'FontSize', 18)
ylabel('Q [L/h]', 'FontSize', 18)

% Plot volume on secondary y-axis
yyaxis right
plot(t, V, 'LineWidth', 2.2)
ylabel('V [L]', 'FontSize', 18)
xlim([0 48])

% Add legend
legend('Volumetric Rate [L/h]', 'Volume [L]', ...
   'FontSize', 18, 'location', 'northwest')