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

%
% SOLUTION OF A LINEAR SYSTEM
%
%  x + 2y - z + 2t = 3
%  x + 2z + t = 1
%  2x + y - 2t = -1
%  -z + t = 2

clear, close, clc;

A = [1 2 -1 2; 1 0 2 1; 2 1 0 -2; 0 0 -1 1];

b = [3; 1; -1; 2];

MySolution = MyLinearSolver(A, b);
MatlabSolution = linsolve(A, b);

disp(['My solution:     ', num2str(MySolution')])
disp(['Matlab solution: ', num2str(MatlabSolution')])

