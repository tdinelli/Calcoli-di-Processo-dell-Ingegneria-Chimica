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
%% Counting Positive Elements in Arrays
% This script demonstrates how to count positive elements (including zero)
% in arrays using both a custom implementation and MATLAB's built-in
% functions.

% Clear workspace and command window for a fresh start
clear all  % Removes all variables from workspace
close all  % Closes all figure windows
clc        % Clears command window

%% Test Arrays
% Define two test arrays with different lengths and mixture of
% positive/negative numbers
A = [1, 5, -3, -9];                % 4-element array with 2 positive numbers
B = [-1, 2, 3, 4, 5, -5, -8, -22]; % 8-element array with 4 positive numbers

%% Count Positive Elements
% Use our custom function to count positive elements in each array
numberOfPositiveElementsInA = countPositive(A);
numberOfPositiveElementsInB = countPositive(B);

% Note: This could also be done using MATLAB's built-in functions:
% numberOfPositiveElementsInA = sum(A >= 0);
% numberOfPositiveElementsInB = sum(B >= 0);

%% Function Definition
function numberOfPositiveElements = countPositive(a)
    % COUNTPOSITIVE Count the number of non-negative elements in an array
    %   numberOfPositiveElements = countPositive(a) returns the count of
    %   elements that are greater than or equal to zero in the input array
    %
    % Input:
    %   a - Input array of any size
    %
    % Output:
    %   numberOfPositiveElements - Scalar value representing the count of
    %                             non-negative elements
    %
    % Example:
    %   arr = [1, -2, 0, 3, -4];
    %   count = countPositive(arr)
    %   % Returns: count = 3 (counting 1, 0, and 3)
    %
    % Notes:
    %   - Zero is considered a positive number in this implementation
    %   - The function works with arrays of any size or shape
    %   - For efficiency with large arrays, consider using MATLAB's
    %     built-in
    %     sum(a >= 0) instead
    
    % Get the length of the input array
    ne = length(a);
    
    % Initialize counter
    numberOfPositiveElements = 0;
    
    % Count positive elements (including zero)
    for i = 1:ne
        if a(i) >= 0
            numberOfPositiveElements = numberOfPositiveElements + 1;
        end
    end
end