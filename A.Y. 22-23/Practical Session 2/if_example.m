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

dimension = 10;
v = magic(dimension);
found = 0;

for i=1:dimension
    for j=1:dimension
        if(v(i,j) == 560)
            disp('Whoa 560 found in a magic square') 
            disp(['row: ',num2str(i)])
            disp(['column: ', num2str(j)])
            found = 1;
            break
        elseif(v(i,j) == 789)
            disp('Whoa 789 found in a magic square') 
            disp(['row: ',num2str(i)])
            disp(['column: ', num2str(j)])
            found = 1;
            break
        else
            v(i,j+1) = 560;
        end
    end
    break
end
if found == 0
    disp('I am sorry your square was a bit unlucky')
end