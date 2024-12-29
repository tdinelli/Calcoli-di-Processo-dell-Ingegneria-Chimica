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
function L = EvenOrOdd(A)
    % Function that creates a logical matrix marking even/odd numbers
    % Input:  A - input matrix
    % Output: L - logical matrix (1 for even numbers, 0 for odd numbers)
    
    % Get dimensions of input matrix
    [nr, nc] = size(A);
    
    % Initialize output matrix with zeros
    L = zeros(nr, nc);
    
    % Loop through each element in the matrix
    for i = 1:nr           % Loop through rows
        for j = 1:nc       % Loop through columns
            % Check if number is even
            if A(i, j)/2 == floor(A(i, j)/2)
                L(i, j) = 1;    % If even, set to 1
            else
                L(i, j) = 0;    % If odd, set to 0
            end
        end
    end
end