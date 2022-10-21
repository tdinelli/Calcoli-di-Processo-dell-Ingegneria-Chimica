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

A = [67*1e6 0 0 0 0; ...
     0 36*1e6 0 0 0;...
     67*1e6 36*1e6 -161*1e6 0 0;...
     0 0 161*1e6 -182*1e6 0;...
     0 0 0 182*1e6 -212*1e12];

b = [180*1e3 710*1e3 -740*1e3 -3850*1e3 -4720*1e3]';


[L, U] = LUdecomposition(A);

y = linsolve(L, b);
x = linsolve(U, y);