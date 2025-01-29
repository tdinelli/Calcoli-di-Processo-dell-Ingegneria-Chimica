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
clear all, close all, clc

% Define coordinates of cities using latitude and longitude
paris = [48.8566, 2.3522]; % Paris [latitude, longitude]

% Matrix of coordinates for different cities
coordinates = [
    40.7128, -74.0060;    % New York    [row 1]
    -33.8688, 151.2093;   % Sydney      [row 2]
    51.5074, -0.1278;     % London      [row 3]
    -23.5505, -46.6333;   % San Paolo   [row 4]
    35.6762, 139.6503     % Tokyo       [row 5]
];

% Get dimensions of the coordinates matrix
[n_rows, n_cols] = size(coordinates);  % n_rows = 5 cities, n_cols = 2 (lat,lon)

% Find the city furthest from Paris
% Initialize variables to track maximum distance and its corresponding index
max_distance = 0;  % Store the maximum distance found
idx = 1;          % Store the index of the furthest city

% Loop through each city in the coordinates matrix
for i = 1:n_rows
    % Calculate distance between Paris and current city
    tmp_distance = calculate_distance(paris, coordinates(i,:));
    
    % Update max_distance and idx if current distance is larger
    if tmp_distance > max_distance
        max_distance = tmp_distance;
        idx = i;
    end
end

% Output results
furthest_location_from_paris = idx            % Index of furthest city
distance_from_paris = max_distance            % Distance to furthest city

% Function to calculate great-circle distance between two points on Earth
function distance = calculate_distance(coord1, coord2)
    % Convert latitude and longitude from degrees to radians
    % This is necessary because MATLAB's trigonometric functions use radians
    lat1 = deg2rad(coord1(1));   % First point's latitude
    lon1 = deg2rad(coord1(2));   % First point's longitude
    lat2 = deg2rad(coord2(1));   % Second point's latitude
    lon2 = deg2rad(coord2(2));   % Second point's longitude
    
    % Earth's mean radius in kilometers
    R = 6371;
    
    % Implementation of the Haversine formula
    % This formula determines the great-circle distance between two points
    % on a sphere given their latitudes and longitudes
    dlat = lat2 - lat1;          % Difference in latitudes
    dlon = lon2 - lon1;          % Difference in longitudes
    
    % Calculate the square of half the chord length between the points
    a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2;
    
    % Calculate final distance using the Haversine formula
    % 2R * arcsin(sqrt(a)) gives the great-circle distance
    distance = 2 * R * asin(sqrt(a));
end