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
% Clear workspace and prepare for fresh start
clear variables   % Remove all variables from workspace
clc         % Clear command window

% Test the function
A = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16];
spiral = spiral_traversal(A);
fprintf('Original matrix:\n');
disp(A);
fprintf('Spiral traversal: %s\n', mat2str(spiral));

function spiral_vec = spiral_traversal(A)
    n = size(A, 1);
    spiral_vec = [];
    
    top = 1;
    bottom = n;
    left = 1;
    right = n;
    
    while top <= bottom && left <= right
        % Traverse right along top row
        for col = left:right
            spiral_vec = [spiral_vec, A(top, col)];
        end
        top = top + 1;
        
        % Traverse down along right column
        for row = top:bottom
            spiral_vec = [spiral_vec, A(row, right)];
        end
        right = right - 1;
        
        % Traverse left along bottom row (if still valid)
        if top <= bottom
            for col = right:-1:left
                spiral_vec = [spiral_vec, A(bottom, col)];
            end
            bottom = bottom - 1;
        end
        
        % Traverse up along left column (if still valid)
        if left <= right
            for row = bottom:-1:top
                spiral_vec = [spiral_vec, A(row, left)];
            end
            left = left + 1;
        end
    end
end