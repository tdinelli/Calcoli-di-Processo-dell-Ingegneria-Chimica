%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%          Author: Marco Mehl <marco.mehl@polimi.it>                      %
%                  Timoteo Dinelli <timoteo.dinelli@polimi.it>            %
%          CRECK Modeling Lab <www.creckmodeling.polimi.it>               %
%          Department of Chemistry, Materials and Chemical Engineering    %
%          Politecnico di Milano                                          %
%          P.zza Leonardo da Vinci 32, 20133 Milano                       %
%                                                                         %
% ----------------------------------------------------------------------- %
clear, close, clc

% Initial stock value
initial_value = 1000;
n_iterations = 10000;

% Initialize values for different rounding methods
value_full_precision = initial_value;
value_floor = initial_value;
value_ceil = initial_value;
value_round = initial_value;

% Set random seed for reproducibility (optional)
rng(42);

% Iterate 10000 times with random ±1% variation
for i = 1:n_iterations
    % Generate random variation: ±1%
    % rand() gives [0,1], so 2*rand()-1 gives [-1,1]
    variation = (2 * rand() - 1) * 0.01;
    
    % Full precision (no rounding)
    value_full_precision = value_full_precision * (1 + variation);
    
    % Floor (round down to 2 decimal places)
    temp = value_floor * (1 + variation);
    value_floor = floor(temp * 100) / 100;
    
    % Ceil (round up to 2 decimal places)
    temp = value_ceil * (1 + variation);
    value_ceil = ceil(temp * 100) / 100;
    
    % Round (round to nearest 2 decimal places)
    temp = value_round * (1 + variation);
    value_round = round(temp * 100) / 100;
end

% Display results
fprintf('Results after %d iterations:\n', n_iterations);
fprintf('=========================================\n');
fprintf('Initial value:        %.2f\n', initial_value);
fprintf('Full precision:       %.6f\n', value_full_precision);
fprintf('Floor (round down):   %.2f\n', value_floor);
fprintf('Ceil (round up):      %.2f\n', value_ceil);
fprintf('Round (to nearest):   %.2f\n', value_round);
fprintf('=========================================\n');

% Calculate differences from full precision
fprintf('\nDifferences from full precision:\n');
fprintf('Floor:  %.6f (%.2f%%)\n', ...
    value_full_precision - value_floor, ...
    100*(value_full_precision - value_floor)/value_full_precision);
fprintf('Ceil:   %.6f (%.2f%%)\n', ...
    value_full_precision - value_ceil, ...
    100*(value_full_precision - value_ceil)/value_full_precision);
fprintf('Round:  %.6f (%.2f%%)\n', ...
    value_full_precision - value_round, ...
    100*(value_full_precision - value_round)/value_full_precision);