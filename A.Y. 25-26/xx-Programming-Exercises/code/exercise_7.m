%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%                                                                         %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
clear variables
clc

% Test the function
v = [5, 4, 6, 8, 11];
sorted_v = bubble_sort(v);
fprintf('Original vector: %s\n', mat2str(v));
fprintf('Sorted vector: %s\n', mat2str(sorted_v));

function sorted_vec = bubble_sort(v)
    n = length(v);
    sorted_vec = v;
    change = true;
    
    while change
        change = false;
        for i = 1:(n-1)
            if sorted_vec(i) > sorted_vec(i+1)
                % Swap elements
                temp = sorted_vec(i);
                sorted_vec(i) = sorted_vec(i+1);
                sorted_vec(i+1) = temp;
                change = true;
            end
        end
    end
end