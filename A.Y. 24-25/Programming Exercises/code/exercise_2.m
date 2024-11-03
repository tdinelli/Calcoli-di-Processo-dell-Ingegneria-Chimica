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
% This script demonstrates how to calculate the sum of rows and columns in
% a matrix using custom implementations. These implementations help
% understand the underlying concepts, though MATLAB has built-in functions
% that can perform these operations more efficiently.

% Clear the workspace and command window for a fresh start
clear all  % Removes all variables from workspace
close all  % Closes all figure windows
clc        % Clears command window

%% Create Test Matrix
% Create a 5x5 magic square for testing
% A magic square has the property that all rows, columns, and diagonals 
% sum to the same value, making it perfect for testing sum operations
M = magic(5);

%% Calculate Sums
% Calculate the sum of each column and row using our custom functions
columns_sum = sumColumns(M);
rows_sum = sumRows(M);

% Note: These operations could also be performed using MATLAB's
% built-in sum():
% columns_sum = sum(M);  % Sum of each column
% rows_sum = sum(M, 2)'; % Sum of each row (transposed to match our implementation)

%% Function Definitions

function columnsSum = sumColumns(M)
    % SUMCOLUMNS Calculate the sum of each column in a matrix
    %   columnsSum = sumColumns(M) returns a row vector where each element
    %   is the sum of the corresponding column in matrix M
    %
    % Input:
    %   M - Input matrix of size [nr x nc]
    %
    % Output:
    %   columnsSum - Row vector of length nc containing column sums
    %
    % Example:
    %   M = [1 2 3; 4 5 6];
    %   sums = sumColumns(M)
    %   % Returns: sums = [5 7 9]
    
    % Get matrix dimensions
    [nr, nc] = size(M);
    
    % Pre-allocate output vector for efficiency
    columnsSum = zeros(1, nc);
    
    % Calculate sum for each column
    for i = 1:nc            % Loop through each column
        tmp_sum = 0;        % Initialize sum for current column
        for j = 1:nr        % Loop through each row in current column
            tmp_sum = tmp_sum + M(j, i);
        end
        columnsSum(i) = tmp_sum;
    end
end

function rowsSum = sumRows(M)
    % SUMROWS Calculate the sum of each row in a matrix
    %   rowsSum = sumRows(M) returns a row vector where each element
    %   is the sum of the corresponding row in matrix M
    %
    % Input:
    %   M - Input matrix of size [nr x nc]
    %
    % Output:
    %   rowsSum - Row vector of length nr containing row sums
    %
    % Example:
    %   M = [1 2 3; 4 5 6];
    %   sums = sumRows(M)
    %   % Returns: sums = [6 15]
    
    % Get matrix dimensions
    [nr, nc] = size(M);
    
    % Pre-allocate output vector for efficiency
    rowsSum = zeros(1, nr);  % Note: Length should be nr, not nc
    
    % Calculate sum for each row
    for i = 1:nr            % Loop through each row
        tmp_sum = 0;        % Initialize sum for current row
        for j = 1:nc        % Loop through each column in current row
            tmp_sum = tmp_sum + M(i, j);
        end
        rowsSum(i) = tmp_sum;
    end
end