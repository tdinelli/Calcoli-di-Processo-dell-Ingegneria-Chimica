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
% This script demonstrates how to calculate the sum of rows and columns in
% a matrix using custom implementations. These implementations help
% understand the underlying concepts, though MATLAB has built-in functions
% that can perform these operations more efficiently.

% Clear the workspace and command window for a fresh start
clear variables  % Removes all variables from workspace
clc              % Clears command window

%% Create Test Matrix
% Create a 5x5 magic square for testing
% A magic square has the property that all rows, columns, and diagonals 
% sum to the same value, making it perfect for testing sum operations
% Script to verify magic matrix properties
n = 5;  % Size of magic matrix
M = magic(n);

fprintf('Testing magic matrix of size %dx%d\n\n', n, n);

% Calculate the magic constant
magic_constant = n * (n^2 + 1) / 2;
fprintf('Expected magic constant: %.0f\n\n', magic_constant);

% Check row sums
fprintf('Row sums:\n');
row_sums = sum(M, 2);
for i = 1:n
    fprintf('Row %d: %.0f\n', i, row_sums(i));
end

% Check column sums
fprintf('\nColumn sums:\n');
col_sums = sum(M, 1);
for i = 1:n
    fprintf('Column %d: %.0f\n', i, col_sums(i));
end

% Check diagonal sums
main_diag_sum = sum(diag(M));
anti_diag_sum = sum(diag(fliplr(M)));
fprintf('\nMain diagonal sum: %.0f\n', main_diag_sum);
fprintf('Anti-diagonal sum: %.0f\n', anti_diag_sum);

% Verify all sums are equal
is_magic = all(row_sums == magic_constant) && ...
           all(col_sums == magic_constant) && ...
           main_diag_sum == magic_constant && ...
           anti_diag_sum == magic_constant;

fprintf('\nIs magic matrix valid? %s\n\n', mat2str(is_magic));

% Compare with random matrix
R = randi([1, n^2], n, n);
fprintf('Random matrix row sums: %s\n', mat2str(sum(R, 2)'));
fprintf('Random matrix column sums: %s\n', mat2str(sum(R, 1)));
fprintf('Random matrix is NOT magic!\n');