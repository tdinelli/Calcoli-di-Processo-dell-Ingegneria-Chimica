%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.chem.polimi.it>            %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %

clear, clc

D = 0.6; % m
h = 0.5; % m

% compute perimeter 

perimeter = pi * D;
Area = perimeter * h;

disp(Area);
%% Now we compute everything calling the function ...

D = 5; % m
h = 1; % m
D1 = 8;
Area1 = ComputeArea(D, h);
Area2 = ComputeArea(D1, h);

disp(Area1);
disp(Area2)


%% Functions definition

function area = ComputeArea2(diameter, height)
% ComputeArea is a supercool function that is needed by engineer to compute

% the area of a cylinder given the diameter and the height.

perimeter = pi * diameter;
area = perimeter * height;

end

