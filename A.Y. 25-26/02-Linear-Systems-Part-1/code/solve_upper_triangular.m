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
function x = solve_upper_triangular(A, b)
    % Solves an upper triangular system Ax = b using back-substitution
    % Input:  U - n×n upper triangular matrix
    %         b - n×1 vector
    % Output: x - n×1 solution vector
    
    n = length(b);
    x = zeros(n, 1);  % Initialize solution vector
    
    % Start from the last equation: x_n = b_n / U(n,n)
    x(n) = b(n) / A(n, n);
    
    % Work backwards from row n-1 to 1
    for i = n-1:-1:1
        % Compute sum of known terms: A(i,j)*x(j) for j > i
        sum_terms = 0;
        for j = i+1:n
            sum_terms = sum_terms + A(i, j) * x(j);
        end
        
        % Solve for x(i)
        x(i) = (b(i) - sum_terms) / A(i, i);
    end
end