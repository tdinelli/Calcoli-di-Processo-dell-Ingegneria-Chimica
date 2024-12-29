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
% Define global variable for volume
global volume
volume = 0.0005;    % Volume in cubic meters (0.5 liters)

% Create array of diameters to test
D = 0.02:0.001:0.2;    % Diameters from 2cm to 20cm in 1mm steps

% Calculate surface area for each diameter
for i = 1:length(D)
    A(i) = objectF(D(i));
end

% Plot surface area vs diameter
plot(D, A);

% Find optimal diameter using constrained optimization
% Arguments: function, initial guess, minimum D, maximum D
D = fmincon(@objectF, 0.03, [], [], [], [], 0.0001, 0.1);

% Calculate base area and height for optimal diameter
Abase = D^2*pi/4;            % Area of circular base
h = volume/Abase;            % Height of cylinder

% Test the objective function
Test = objectF(0.2);

% Function to calculate total material surface area
function Amateriale = objectF(D)
    global volume

    % Calculate base area (circular)
    Abase = D^2*pi/4;

    % Calculate height based on volume constraint
    h = volume/Abase;

    % Calculate lateral surface area
    Alato = D*pi*h;

    % Calculate total material area with different costs
    % Side material costs 1.05 per unit area
    % Base material costs 1.15 per unit area
    Amateriale = Alato*1.05 + 2*Abase*1.15;
end
