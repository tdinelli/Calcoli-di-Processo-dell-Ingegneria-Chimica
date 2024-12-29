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
global total_distance max_acc human_speed

% Initialize parameters
total_distance = 170000;    % Total distance in meters (170 km)
max_acc = 1;               % Maximum acceleration (m/s²)
human_speed = 1.4;         % Walking speed (m/s ≈ 5 km/h)

% Test the time calculation function with 40 segments
Test_funzione = min_time(40);

% Find optimal number of segments using unconstrained optimization
nstop = round(fmincon(@min_time, 30, ...
    [], [], [], [], [], [], []));  % Start optimization at 30 segments

% Calculate distance between stops with optimal segments
distance = 170000 / nstop;

% Function to calculate total journey time
function time = min_time(n_segments)
    global total_distance max_acc human_speed
    
    % Calculate distance between stops
    distance = total_distance / n_segments;
    
    % Calculate components of total time:
    time_foot = distance/human_speed;  % Walking time between stops
    time_stop = n_segments*15;         % Total stopping time (15s per stop)
    time_run = (n_segments-1)*(distance/max_acc)^0.5;  % Time spent accelerating
    % Note: Formula valid only if distance between stations is less than 27.5 km
    
    % Calculate total journey time
    time = time_run + time_stop + time_foot;
end