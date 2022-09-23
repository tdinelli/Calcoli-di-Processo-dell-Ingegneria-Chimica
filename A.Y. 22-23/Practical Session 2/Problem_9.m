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

clear, clc

%% SUM forward single precision

sum = single(0);

for i = 1:1:1e6
    sum = sum + 1/i;
end

disp(['This the single precision sum of the first 1 mln inverse ' ...
    'numbers (forward): ', num2str(sum)])

%% SUM backword single precision

sum = single(0);

for i = 1e6:-1:1
    sum = sum + 1/i;
end

disp(['This the single precision sum of the first 1 mln inverse ' ...
    'numbers (backward): ', num2str(sum)])
%% SUM forward double precision

sum = 0;

for i = 1:1:1e6
    sum = sum + 1/i;
end

disp(['This the double precision sum of the first 1 mln inverse ' ...
    'numbers (forward): ', num2str(sum)])

%% SUM backword double precision

sum = 0;

for i = 1e6:-1:1
    sum = sum + 1/i;
end

disp(['This the double precision sum of the first 1 mln inverse ' ...
    'numbers (backward): ', num2str(sum)])