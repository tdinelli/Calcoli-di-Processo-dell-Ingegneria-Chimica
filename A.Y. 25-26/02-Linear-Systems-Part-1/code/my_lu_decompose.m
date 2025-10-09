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
function [L, U] = my_lu_decompose(A)
    % Performs LU decomposition of matrix A
    % Input:  A - n×n matrix
    % Output: L - n×n lower triangular matrix (with 1's on diagonal)
    %         U - n×n upper triangular matrix
    % Note: A = L*U
    
    n = size(A, 1);
    L = eye(n);     % Initialize L as identity matrix
    U = A;          % Initialize U as copy of A
    
    % Elimination process
    for k = 1:n-1
        % For each row below the pivot
        for i = k+1:n
            % Compute and store multiplier in L
            L(i, k) = U(i, k) / U(k, k);
            
            % Eliminate in U using the multiplier
            U(i, :) = U(i, :) - L(i, k) * U(k, :);
        end
    end
end