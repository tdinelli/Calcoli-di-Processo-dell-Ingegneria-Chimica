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
clear variables
clc

% Test the function
A = [1 2 3; 4 5 6; 7 8 9];
B = create_special_matrix(A);
fprintf('Original matrix A:\n');
disp(A);
fprintf('Modified matrix B:\n');
disp(B);

function B = create_special_matrix(A)
    n = size(A, 1);
    B = zeros(n, n);
    
    % Calculate sum of all elements
    total_sum = sum(A(:));
    
    % Fill the matrix
    for i = 1:n
        for j = 1:n
            if i == j
                % Diagonal: keep original elements
                B(i, j) = A(i, j);
            elseif i < j
                % Above diagonal: use total sum
                B(i, j) = total_sum;
            else
                % Below diagonal: zeros (already initialized)
                B(i, j) = 0;
            end
        end
    end
end