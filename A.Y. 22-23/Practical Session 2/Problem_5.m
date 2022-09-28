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

M = magic(10);
sumRows = SumTheRowsOfMagic(M);
sumCols = SumTheColumnsOfMagic(M);

disp(['This is the computed sum of the rows: ', num2str(sumRows)])
disp(['This is the MATLAB sum of the rows:   ', num2str(sum(M, 2)')])

disp(['This is the computed sum of the columns: ', num2str(sumCols)])
disp(['This is the MATLAB sum of the columns:   ', num2str(sum(M))])

%% Function definition

function sum_row = SumTheRowsOfMagic(matrix)

    dimension = size(matrix);
    numberOfRows = dimension(1);
    numberOfColumns = dimension(2);

    for i=1:numberOfRows
        tmp = 0;
        for j=1:numberOfColumns
            tmp = tmp + matrix(i,j);
        end
        sum_row(i) = tmp; 
    end

end

function sum_col = SumTheColumnsOfMagic(matrix)

    dimension = size(matrix);
    numberOfRows = dimension(1);
    numberOfColumns = dimension(2);

    for i=1:numberOfColumns
        tmp = 0;
        for j=1:numberOfRows
            tmp = tmp + matrix(j,i);
        end
        sum_col(i) = tmp; 
    end
end


