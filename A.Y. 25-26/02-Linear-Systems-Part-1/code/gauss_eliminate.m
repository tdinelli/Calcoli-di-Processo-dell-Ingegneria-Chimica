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
function [U, b_new] = gauss_eliminate(A, b)
    % Transforms matrix A into upper triangular form using Gauss elimination
    % Input:  A - n×n matrix
    %         b - n×1 vector
    % Output: U - n×n upper triangular matrix
    %         b_new - n×1 modified vector
    % Note: This version does NOT include pivoting
    
    n = size(A, 1);
    U = A;          % Copy A to U (we'll modify U)
    b_new = b;      % Copy b to b_new
    
    % Forward elimination: eliminate column by column
    for k = 1:n-1
        % For each row below the pivot
        for i = k+1:n
            % Compute multiplier
            m = U(i, k) / U(k, k);
            
            % Eliminate element U(i,k) by subtracting m times row k
            U(i, :) = U(i, :) - m * U(k, :);
            
            % Apply same operation to b
            b_new(i) = b_new(i) - m * b_new(k);
        end
    end
end