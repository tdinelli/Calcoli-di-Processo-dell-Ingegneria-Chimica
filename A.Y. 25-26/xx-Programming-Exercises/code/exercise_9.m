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
%                                                                         %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
%% Bubble Sort Algorithm Implementation
% This script demonstrates the bubble sort algorithm by:
% 1. Creating a test vector
% 2. Implementing bubble sort
% 3. Visualizing the sorting process

% Clear workspace and prepare for fresh start
clear all   % Remove all variables from workspace
close all   % Close all figure windows
clc         % Clear command window

%% Test the Bubble Sort Function
% Create a random test vector
testVector = randi([1, 100], 1, 10);  % Random vector of 10 integers between 1 and 100

% Display original vector
fprintf('Original vector: ');
disp(testVector)

% Sort the vector using our bubble sort implementation
sortedVector = bubbleSort(testVector);

% Display sorted vector
fprintf('Sorted vector:   ');
disp(sortedVector)

% Verify with MATLAB's built-in sort (for comparison)
matlabSorted = sort(testVector);
fprintf('MATLAB sort:     ');
disp(matlabSorted)

%% Function Definition
function sortedVector = bubbleSort(inputVector)
    % BUBBLESORT Sort a vector in ascending order using bubble sort
    %   algorithm sortedVector = bubbleSort(inputVector) returns a sorted
    %   version of the input vector using the bubble sort algorithm.
    %
    % Input:
    %   inputVector - Vector of numbers to be sorted
    %
    % Output:
    %   sortedVector - Sorted vector in ascending order
    %
    % Example:
    %   v = [64, 34, 25, 12, 22, 11, 90];
    %   sorted = bubbleSort(v)
    %   % Returns: [11, 12, 22, 25, 34, 64, 90]

    % Make a copy of the input vector to avoid modifying the original
    sortedVector = inputVector;

    % Get the length of the vector
    n = length(sortedVector);

    % Bubble sort algorithm:
    % - Outer loop: number of passes through the vector
    % - We need at most n-1 passes (if the vector is in reverse order)
    for pass = 1:(n-1)
        % Flag to check if any swaps occurred in this pass
        hasSwapped = false;

        % Inner loop: compare adjacent elements
        % Note: We only need to go up to n-pass because:
        % - After each pass, the largest remaining element "bubbles up"
        %   to its final position
        % - So we don't need to check the last 'pass' elements
        for i = 1:(n-pass)
            % Compare adjacent elements
            if sortedVector(i) > sortedVector(i+1)
                % If they're in wrong order, swap them
                % Store first element temporarily
                temp = sortedVector(i);
                % Move second element to first position
                sortedVector(i) = sortedVector(i+1);
                % Move first element (from temp) to second position
                sortedVector(i+1) = temp;
                % Record that we made a swap
                hasSwapped = true;
            end

            % Optional: Uncomment to see the vector after each comparison
            % disp(sortedVector)
        end

        % If no swaps occurred in this pass, the vector is already sorted
        if ~hasSwapped
            fprintf('Early termination after %d passes (vector is sorted)\n', pass);
            break
        end
    end
end
