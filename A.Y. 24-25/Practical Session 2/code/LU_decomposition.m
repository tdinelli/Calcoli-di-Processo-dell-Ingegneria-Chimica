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
%                                                                         %
%       Function to perform the LU decomposition                          %
%       of a square matrix  with gaussian elimination                     %
%       and no pivoting                                                   %
%                                                                         %
% ----------------------------------------------------------------------- %

function [L, U]=LU_decomposition(A)
    [n_rows, n_cols] = size(A);
    C = A; % Let's copy A into C
    L = eye(n_rows); % eye function return an Identity square matrix given the size 

    if n_rows == n_cols
        for i = 1:n_rows
            if C(i, i) == 0
                error('This algorithm does not perform pivoting')
            end
            for k = i+1:n_rows
                coeff = C(k,i)/C(i,i);
                C(k,:) = C(k,:) - C(i,:)*coeff;
                L(k,i) = coeff;
            end
        end
        U = C(1:n_rows, 1:n_cols);
    else
        error('The matrix must be square!')
    end
end
