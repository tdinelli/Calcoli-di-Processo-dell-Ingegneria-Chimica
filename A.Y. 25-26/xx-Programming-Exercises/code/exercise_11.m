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
% Clear workspace, figures, and command window for a fresh start
clear variables  % Removes all variables from workspace
clc              % Clears command window

% Test the function
A = [1 2 3; 4 5 6; 7 8 9];
angle = check_rotation_symmetry(A);
fprintf('Original matrix:\n');
disp(A);
fprintf('Rotation that produces symmetry: %d degrees\n', angle);
if angle == 0
    fprintf('(None produce a symmetric matrix)\n');
end

function rotation_angle = check_rotation_symmetry(A)
    % Returns 90, 180, 270 if that rotation produces symmetric matrix
    % Returns 0 if none produce a symmetric matrix
    
    % Rotate 90 degrees clockwise
    A_90 = rotate_90(A);
    if is_symmetric(A_90)
        rotation_angle = 90;
        return;
    end
    
    % Rotate 180 degrees
    A_180 = rotate_90(A_90);
    if is_symmetric(A_180)
        rotation_angle = 180;
        return;
    end
    
    % Rotate 270 degrees
    A_270 = rotate_90(A_180);
    if is_symmetric(A_270)
        rotation_angle = 270;
        return;
    end
    
    rotation_angle = 0;
end

function rotated = rotate_90(A)
    % Rotate matrix 90 degrees clockwise manually
    n = size(A, 1);
    rotated = zeros(n, n);
    
    for i = 1:n
        for j = 1:n
            rotated(j, n+1-i) = A(i, j);
        end
    end
end

function result = is_symmetric(A)
    % Check if matrix is symmetric (A == A')
    n = size(A, 1);
    result = true;
    
    for i = 1:n
        for j = 1:n
            if A(i, j) ~= A(j, i)
                result = false;
                return;
            end
        end
    end
end