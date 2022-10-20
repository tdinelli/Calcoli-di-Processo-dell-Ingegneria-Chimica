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
%       Assemble the two function to get a single call                    %
%       to solve the system                                               %
%                                                                         %
% ----------------------------------------------------------------------- %

function x = MyLinearSolver(A,b)


[At, bt]=triangularizeU(A,b); % Take The matrix A and the vector b 
                             % and transform them in a upper triangular 
                             % matrix with its correspondent b
x = solveUTr(At,bt); % Solve the upper triangular system and 
                  % return the solution in the vector b

% It should be noted how we could save memory by writing the Upper
% Triangular matrix At and bt directly on A
end