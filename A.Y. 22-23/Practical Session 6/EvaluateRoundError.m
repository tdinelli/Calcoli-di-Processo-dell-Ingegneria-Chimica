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

exactsolution = [0.0036; -1.9071; 1.6036];
solution_no_pivoting = [-0.1000;-1.7000; 1.5000];
solution_with_pivoting = [0.0063;-1.9000;1.6000];

diff_no_pivoting = exactsolution - solution_no_pivoting;
diff_with_pivoting = exactsolution - solution_with_pivoting;

error_no_pivoting = norm(diff_no_pivoting);
error_with_pivoting = norm(diff_with_pivoting);

disp(error_no_pivoting - error_with_pivoting)
disp(error_with_pivoting - error_no_pivoting)

