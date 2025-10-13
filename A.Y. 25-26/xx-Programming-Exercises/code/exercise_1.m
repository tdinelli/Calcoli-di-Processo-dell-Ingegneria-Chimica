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
clear variables  % Removes all variables from workspace
clc        % Clears command window

find_max_magic()

function [max_val, row, col] = find_max_magic()
    % Create magic matrix
    M = magic(234);
    
    % Manual approach - initialize variables
    max_val = M(1,1);
    row = 1;
    col = 1;
    
    % Loop through all elements
    [n_rows, n_cols] = size(M);
    for i = 1:n_rows
        for j = 1:n_cols
            if M(i,j) > max_val
                max_val = M(i,j);
                row = i;
                col = j;
            end
        end
    end
    
    fprintf('Manual approach:\n');
    fprintf('Maximum value: %d at position (%d, %d)\n', max_val, row, col);
    
    % Using MATLAB built-in functions
    [max_cols, row_indices] = max(M);
    [max_val_builtin, col_idx] = max(max_cols);
    row_builtin = row_indices(col_idx);
    col_builtin = col_idx;
    
    fprintf('\nBuilt-in approach (max):\n');
    fprintf('Maximum value: %d at position (%d, %d)\n', ...
            max_val_builtin, row_builtin, col_builtin);
    
    % Using find
    [r, c] = find(M == max_val_builtin);
    fprintf('\nUsing find:\n');
    fprintf('Maximum value: %d at position (%d, %d)\n', ...
            max_val_builtin, r(1), c(1));
end