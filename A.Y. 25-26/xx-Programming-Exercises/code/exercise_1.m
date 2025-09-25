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
%% Finding Maximum Value in a Matrix
% This script demonstrates three different approaches to find the maximum
% value and its location in a matrix using MATLAB. Each method has its own
% advantages in terms of readability, performance, and educational value.

% Clear workspace, figures, and command window for a fresh start
clear all  % Removes all variables from workspace
close all  % Closes all figure windows
clc        % Clears command window

%% Create Test Matrix
% Create a magic square matrix of size 234x234
% A magic square is a square matrix where the sum of each row, column, and
% diagonal is the same, making it useful for testing
M = magic(234);

%% Method 1: Custom Implementation
% This method uses a manual search through the matrix using nested loops
% It's slower but demonstrates the fundamental concept clearly
[index_row, index_col, maximum_value] = findMaximum(M);

%% Method 2: Using find() and max()
% This method combines MATLAB's built-in find() and max() functions
% The '1' parameter limits the output to the first occurrence if there are
% multiple maxima
[row_1, col_1] = find(M == max(M(:)), 1);
matlab_max_1 = M(row_1, col_1);

%% Method 3: Using max() with 'all' parameter
% This is the most concise modern approach, available in newer MATLAB
% versions The 'all' parameter finds the maximum across all dimensions at
% once
[matlab_max_2, linearIndex] = max(M, [], 'all');
[row_2, col_2] = ind2sub(size(M), linearIndex);

%% Custom Function Definition
function [index_row, index_column, value] = findMaximum(A)
    % FINDMAXIMUM Find the maximum value and its location in a matrix
    %   [row, col, max_val] = findMaximum(A) returns:
    %   - row: row index of the maximum value
    %   - col: column index of the maximum value
    %   - max_val: the maximum value itself
    %
    % Input:
    %   A - Input matrix of any size
    %
    % Output:
    %   index_row - Row index of the maximum value
    %   index_column - Column index of the maximum value
    %   value - Maximum value found in the matrix
    %
    % Example:
    %   A = [1 2 3; 4 5 6; 7 8 9];
    %   [row, col, max_val] = findMaximum(A)
    %   % Returns: row = 3, col = 3, max_val = 9
    
    % Get matrix dimensions
    [nr, nc] = size(A);
    
    % Initialize with first element
    value = A(1, 1);
    index_row = 1;
    index_column = 1;
    
    % Iterate through each element
    for i = 1:nr
        for j = 1:nc
            % Update if current element is larger than stored maximum
            if A(i, j) > value
                value = A(i, j);
                index_row = i;
                index_column = j;
            end
        end
    end
end
