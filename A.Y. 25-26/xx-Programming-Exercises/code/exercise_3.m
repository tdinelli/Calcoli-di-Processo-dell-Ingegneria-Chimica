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
%% Counting Positive Elements in Arrays
% This script demonstrates how to count positive elements (including zero)
% in arrays using both a custom implementation and MATLAB's built-in
% functions.

% Clear workspace and command window for a fresh start
clear variables  % Removes all variables from workspace
clc        % Clears command window

% Test the function
A = [1, 5, -3, -9];
result = count_positive(A);
fprintf('Number of positive elements: %d\n', result);

function count = count_positive(A)
    % Count positive elements without using built-in functions
    count = 0;
    n = length(A);
    
    for i = 1:n
        if A(i) > 0
            count = count + 1;
        end
    end
end