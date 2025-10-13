%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%                                                                         %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Clear workspace, figures, and command window for a fresh start
clear variables  % Removes all variables from workspace
clc              % Clears command window

% Test the function
v = [1, 2, 3, 4, 5, 6, 7];
k = 3;
filtered = running_average(v, k);
fprintf('Original vector: %s\n', mat2str(v));
fprintf('Window size: %d\n', k);
fprintf('Filtered vector: %s\n', mat2str(filtered));

function result = running_average(v, k)
    n = length(v);
    result = zeros(1, n);
    half_window = floor(k / 2);
    
    for i = 1:n
        % Determine the valid window range
        start_idx = max(1, i - half_window);
        end_idx = min(n, i + half_window);
        
        % Calculate average of elements in window
        window_elements = v(start_idx:end_idx);
        result(i) = sum(window_elements) / length(window_elements);
    end
end