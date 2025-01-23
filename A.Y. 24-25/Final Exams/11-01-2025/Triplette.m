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

function [num_triplets, max_triplet] = findTriplets(v)
    % Initialize the number of triplets found to 0
    % This variable will count how many valid triplets exist in the input vector
    num_triplets = 0;

    % Initialize max_triplet as an empty array
    % This will store the triplet with the maximum sum
    max_triplet = [];

    % Set initial maximum sum to negative infinity
    % This ensures any valid triplet sum will be larger at first comparison
    max_sum = -inf;

    % Iterate through the vector, stopping 2 indices before the end
    % This allows us to always have three consecutive elements to check
    for i = 1:length(v)-2
        % Extract three consecutive numbers starting from index i
        current = v(i:i+2);

        % Check if the triplet follows an increasing pattern
        % Condition: second element > first element AND third element > second element
        if current(2) > current(1) && current(3) > current(2)
            % Increment the count of valid triplets
            num_triplets = num_triplets + 1;

            % Calculate the sum of the current triplet
            current_sum = sum(current);

            % Check if this triplet's sum is larger than the previous maximum
            if current_sum > max_sum
                % Update the maximum sum
                max_sum = current_sum;

                % Store this triplet as the maximum sum triplet
                max_triplet = current;
            end
        end
    end
end
