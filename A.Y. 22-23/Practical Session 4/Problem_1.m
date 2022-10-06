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

clear, close, clc;

Matrix1 = [1 2 3 78; 2 3 4 7; 5 7 6 5];
Matrix2 = [55 89 57 1; 3 5 6 2; 76 847 1283 56];

ResultingMatrix = SumMatrix(Matrix1, Matrix2);
ResultingMatlab = Matrix1 + Matrix2;

disp('My Sum Function')
disp(ResultingMatrix)

disp('MATLAB Sum Function')
disp(ResultingMatlab)

%% Function definition

function SM = SumMatrix(A, B)

[nr1, nc1] = size(A); % Get the size of the first matrix
[nr2, nc2] = size(B); % Get the size of the second matrix

SM = ones(nr1, nc1); % Create a matrix of one where we PRE-allocate
                     % dimensions to save results

if nr1 == nr2 && nc1 == nc2 % Condition to check if the operation can be performed
    for i = 1:nr1 % i scan the rows
        for j = 1:nc1 % j scan the columns
            SM(i,j) = A(i,j) + B(i,j); % sum the elements of each matrix
        end
    end
else
    error('The dimensions of the two matrices are not coherent!')
end

end
