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
%% Matrix Diagonal Modification
% This script demonstrates how to:
% 1. Calculate the average of each row in a matrix
% 2. Replace diagonal elements with row averages
% 3. Handle matrix size validation
% 4. Implement helper functions for matrix operations

% Clear workspace and prepare for fresh start
clear all   % Remove all variables from workspace
close all   % Close all figure windows
clc         % Clear command window

%% Create Test Matrix
% Define a 3x3 test matrix
A = [1 2 3; 
     4 5 6; 
     7 8 9];

% Display original matrix
disp('Original Matrix:')
disp(A)

%% Modify Matrix Diagonal
% Replace diagonal elements with row averages
A_star = subDiagonal(A);

% Display modified matrix
disp('Modified Matrix (diagonal elements replaced with row averages):')
disp(A_star)

%% Function Definitions

function finalMatrix = subDiagonal(A)
    % SUBDIAGONAL Replace diagonal elements of a square matrix with row
    %   averages finalMatrix = subDiagonal(A) returns a matrix where the
    %   diagonal elements have been replaced with the average value of
    %   their respective rows
    %
    % Input:
    %   A - Square matrix of size [n x n]
    %
    % Output:
    %   finalMatrix - Matrix of same size as A with modified diagonal elements
    %
    % Example:
    %   A = [1 2 3; 4 5 6; 7 8 9];
    %   result = subDiagonal(A)
    %   % Returns matrix with diagonal elements replaced by row averages
    %
    % Throws:
    %   Error if input matrix is not square
    
    % Get matrix dimensions
    [nr, nc] = size(A);
    
    % Initialize output matrix as copy of input
    finalMatrix = A;
    
    % Calculate row averages using helper function
    avg_row = computeRowAverage(A);
    
    % Check if matrix is square
    if nr == nc
        % Replace diagonal elements with row averages
        for i = 1:nr
            finalMatrix(i, i) = avg_row(i);
        end
    else
        error('This function works only for square matrices')
    end
    
    % Note: This could also be vectorized in MATLAB:
    % if nr == nc
    %     finalMatrix(1:nr+1:end) = avg_row;
    % else
    %     error('This function works only for square matrices')
    % end
end

function avg_row = computeRowAverage(A)
    % COMPUTEROWAVERAGE Calculate the average value of each row in a matrix
    %   avg_row = computeRowAverage(A) returns a row vector containing
    %   the average value of each row in the input matrix
    %
    % Input:
    %   A - Matrix of size [nr x nc]
    %
    % Output:
    %   avg_row - Row vector of length nr containing row averages
    %
    % Example:
    %   A = [1 2 3; 4 5 6];
    %   avgs = computeRowAverage(A)
    %   % Returns: avgs = [2 5]
    %
    % Note:
    %   This could be replaced with MATLAB's mean() function:
    %   avg_row = mean(A, 2)';
    
    % Get matrix dimensions
    [nr, nc] = size(A);
    
    % Pre-allocate output vector
    avg_row = zeros(1, nr);  % Note: length should be nr, not nc
    
    % Calculate average for each row
    for i = 1:nr
        avg = 0;
        % Sum elements in current row
        for j = 1:nc
            avg = avg + A(i, j);
        end
        % Calculate and store average
        avg_row(i) = avg / nc;
    end
end