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
% Define global variable for total distance
global totalDistance
totalDistance = 30000; % Total distance in meters (30 km)

% Test calculations
time = TotalTime(10);          % Calculate total time at 10 m/s
rentCost = Rent(10000);        % Calculate rental cost for 10000 seconds
gasCost = FuelConsumption(10); % Calculate fuel cost at 10 m/s

% Find optimal velocity that minimizes total cost
vOpt = fmincon(@TotalCost, 17, ...
    [], [], [], [], [], [], []); % Start optimization from 17 m/s
finalCost = TotalCost(vOpt);    % Calculate final cost at optimal velocity

%% Functions definition
% Function to calculate rental cost based on time
function cost = Rent(time)
    fixedCost = 80;   % Fixed base cost

    % If rental time is less than 2 hours (7200 seconds)
    if time <= 2*3600
        cost = fixedCost;
    else
        % Additional cost of 0.5 per minute after 2 hours
        cost = fixedCost + (time-7200)/60 * 0.5;
    end
end

% Function to calculate total trip time based on velocity
function time = TotalTime(v)
    global totalDistance
    % Total time = 2 hours fixed time + round trip travel time
    time = 2*3600 + 2*totalDistance/v;
end

% Function to calculate fuel consumption based on velocity
function fuelConsumption = FuelConsumption(v)
    global totalDistance
    % Fuel consumption model: quadratic relationship with velocity
    % 6.8e-3 is consumption coefficient, multiply by 2 for round trip
    fuelConsumption = 6.8e-3 * v^2 * totalDistance/1000 * 2;
end

% Function to calculate total cost based on velocity
function cost = TotalCost(v)
    % Get total time at this velocity
    time = TotalTime(v);

    % Calculate rental cost
    rentCost = Rent(time);

    % Calculate fuel cost (multiply by 1.8 for price per unit)
    gasCost = FuelConsumption(v) * 1.8;

    % Total cost is sum of rental and fuel costs
    cost = rentCost + gasCost;
end
